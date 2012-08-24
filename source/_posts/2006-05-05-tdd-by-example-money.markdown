---
layout: post
title: "TDD By Example - Money"
comments: true
date: 2006-05-05 09:00
categories:
- .net 2.0
- c sharp
---

I thought I would take the time to post a simple example of TDD that people can use to build a class that could potentially add value to their current project. I am going to build a Money class test first. Lots of us work on projects that have to manipulate money in one form or another. For me, when I work on e-commerce apps I typically have to perform many different operations that deal and manipulate with monetary values. Traditionally people would use decimal or double types to represent the monetary amount. Unfortunately, this also meant that logic to perform rounding related issues was usually placed in some utility class or worse yet, in multiple places in the code where money was being manipulated. I don’t want to delve to far into discussion, as I feel that code speaks louder than words. Let’s start with the first test:



{% codeblock lang:csharp %}
 [TestFixture]
 public class MoneyTest
 {
     [Test]
     public void ShouldBeAbleToCreateMoney()
     {
         Money money = new Money(20.00);            
         Assert.AreEqual(20.00,money.Amount);
         Assert.AreEqual(2000,money.Cents);
         
         money = new Money(10.25);
         Assert.AreEqual(10.25,money.Amount);
         Assert.AreEqual(1025,money.Cents);
     }
 }
{% endcodeblock %}



As you can see. This test is pretty simple. It is just asserting that I can construct a new money instance that can be used to represent some monetary amount. Currently I am not in a build state, so I need to write enough code to make the test compile, and then pass. The following snippets show the progression of the Money class to make the test compile

 

{% codeblock lang:csharp %}
public class Money
{
  public Money(double amount)
  {
    throw new NotImplementedException();
  }
}
{% endcodeblock %}
 

 

{% codeblock lang:csharp %}
 public class Money
 {
   public Money(double amount)
   {
     throw new NotImplementedException();
   }
   public double Amount
   {
     get { throw new NotImplementedException(); }
   }
 }


{% endcodeblock %}

{% codeblock lang:csharp %}
public class Money
{
   public Money(double amount)
   {
       throw new NotImplementedException();
   }

   public double Amount
   {
       get { throw new NotImplementedException(); }
   }

   public int Cents
   {
       get { throw new NotImplementedException(); }
   }
}
 
{% endcodeblock %}




Ok, so we can easily see that there is no hope for these tests passing (from this point on I will skip showing the class generation step using ReSharper). Let’s write enough code to make the tests pass. 

 

{% codeblock lang:csharp %}
public class Money
{
  private readonly double amount;
  public Money(double amount)
  {
    this.amount = amount;
  }
  public double Amount
  {
    get { return this.amount; }
  }
  public int Cents
  {
    get { return Convert.ToInt32(amount * 100); }
  }
}
{% endcodeblock %}




Hopefully we are all in agreement that at the outset, this is currently the simplest way to implement the functionality described by the test. Which is exactly the point. Solve problems in small increments. Don’t future proof your designs. If a requirement changes or gets added, account for that fact by adding a new test and implementing the change/ new functionality. Ok, let’s write a test that is definitely going to cause us to rethink the design:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldRoundOnCreation()
{
   Money money = new Money(20.678);
   Assert.AreEqual(20.68,money.Amount);
   Assert.AreEqual(2068,money.Cents);
}
{% endcodeblock %}



If you add this new “requirement” you will quickly see that the current scheme I have come up with for storing the internal amount of the money as double is going to cause grief. The following ReSharper dialog shows the failure that occurs when this test is run:

 

<a href="{{ site.cdn_root }}binary/tddByExampleMoney/exception1.jpg" rel="lightbox[tddByExampleMoney"><img alt="Exception1" src="{{ site.cdn_root }}binary/tddByExampleMoney/exception1.jpg" align="middle" border="0"></a>

I am fairly confident that most of us are aware of some of the rounding issues that can arise from using double as a storage type for money. For that reason I am going to refactor the money class to use an int to store the number of pennies that the money consists of :

 

{% codeblock lang:csharp %}
public class Money
{
   private readonly int cents;
   private double roundedAmount;

   public Money(double amount)
   {
       roundedAmount = Math.Round(amount, 2);            
       cents = Convert.ToInt32(roundedAmount * 100);
   }
   
   public double Amount
   {
       get { return roundedAmount; }
   }

   public int Cents
   {
       get { return cents; }
   }
}
{% endcodeblock %}




As you can see the implementation of the class has not changed all that much. With the addition of the call to round and a field to now store the amount of the money object in pennies. You may ask why I bother to keep the field “roundedAmount” which stores the double value of the money as opposed to just calculating it every time the Amount property is accessed. Because Money is a classic “value object” once constructed it is completely immutable (read-only). For that reason, I don’t really care to recalculate every time the Amount property is accessed, as it will never change for a particular instance of Money. I perform the rounding right off the bat, and then continue to use it from that point on. 

If I run the tests, everything will now be passing. Unfortunately I am not done yet. Due to the way that the .Net framework implements rounding, I am going to run into a problem when I add the following new lines to the existing test for rounding:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldRoundOnCreation()
{
   Money money = new Money(20.678);
   Assert.AreEqual(20.68,money.Amount);
   Assert.AreEqual(2068,money.Cents);            
   
   money = new Money(37.535);
   Assert.AreEqual(37.54,money.Amount);
}
{% endcodeblock %}




The assertion on line 9 will fail. I could try using overloads of the Math.Round method, but they will all produce the same result. So once again, I am going to have to refactor the Money class to perform the rounding itself.

 

{% codeblock lang:csharp %}
public class Money
{
  private readonly int cents;
  private double roundedAmount;
  public Money(double amount)
  {
    double quotient = amount / 0.01;
    int wholePart = (int)quotient;
    decimal mantissa = ((decimal)quotient) - wholePart;

    roundedAmount = mantissa >= .5m ? .01 * (wholePart + 1) : .01 * wholePart;
    cents = Convert.ToInt32(roundedAmount * 100);
  }

  public double Amount
  {
    get { return roundedAmount; }
  }
  public int Cents
  {
    get { return cents; }
  }
}

{% endcodeblock %}




Ok, all of the tests are now passing and I am taking care of rounding myself. Unfortunately, the constructor has gotten a little hairy. Remember the mantra “Red – Green – Refactor”. I think we are sorely in need of a refactoring at this point. Let’s try and extract some methods out of the constructor. First off, let’s get the rounding calculation out of there:

 

{% codeblock lang:csharp %}
public class Money
{
   private readonly int cents;
   private double roundedAmount;

   public Money(double amount)
   {
       roundedAmount = RoundToNearestPenny(amount);
       cents = Convert.ToInt32(roundedAmount * 100);
   }
   
   private double RoundToNearestPenny(double amount)
   {
       double quotient = amount / 0.01;
       int wholePart = (int)quotient;
       decimal mantissa = ((decimal)quotient) - wholePart;

       return mantissa >= .5m ? .01 * (wholePart + 1) : .01 * wholePart;
   }
   
   public double Amount
   {
       get { return roundedAmount; }
   }

   public int Cents
   {
       get { return cents; }
   }
}
{% endcodeblock %}


Things are looking a little better. One more thing that I want to do, even though it is a one liner, is extract out the conversion to pennies: 



{% codeblock lang:csharp %}
public class Money
{
  private readonly int cents;
  private double roundedAmount;
  public Money(double amount)
  {
    roundedAmount = RoundToNearestPenny(amount);
    cents = ToPennies(roundedAmount);
  }
  private int ToPennies(double amount)
  {
    return Convert.ToInt32(amount * 100);
  }

  private double RoundToNearestPenny(double amount)
  {
    double quotient = amount / .01;
    int wholePart = (int)quotient;
    decimal mantissa = ((decimal)quotient) - wholePart;
    return mantissa >= .5m ? .01 * (wholePart + 1) : .01 * wholePart;
  }

  public double Amount
  {
    get { return roundedAmount; }
  }

  public int Cents
  {
    get { return cents; }
  }
}

{% endcodeblock %}




Ok, things are looking good. The 2 new methods we introduced as part of the refactoring are getting tested by the tests that already exist. Of course, there is no problem with increasing the visibility of these new methods if you wanted to directly exercise them. We can be assured that they are being exercised as the constructor makes direct use of them. So with rounding taken care of we can now move on to add new functionality to the money class. 

Remember the Money class is completely immutable, so once constructed there is no way to change the value that the Money object represents. That being said, we should be able to treat our Money class like any of the intrinsic value types in the framework (note that currently the Money type is a class not a struct), meaning we should be able to add two Monies together, subtract, multiply etc. Let’s first write a test to ensure that two different instance of the same value of money evaluate to be equal to one another:

 

{% codeblock lang:csharp %}
[Test]
public void IdenticalMonetaryValuesShouldBeEqual()
{
  Money tenDollars = new Money(10.00);
  Money anotherTenDollars = new Money(10.00);

  Assert.AreEqual(tenDollars,anotherTenDollars);
}
{% endcodeblock %}




Initially this test will fail because by default, all reference types use ReferenceEquals to determine object equality. I can quickly get the test passing by changing the Money class to be a struct (value type). To make that possible I will need to make the ToPennies and RoundToNearestPenny methods static:

 

{% codeblock lang:csharp %}
public struct Money
{
  private readonly int cents;
  private double roundedAmount;
  public Money(double amount)
  {
    roundedAmount = RoundToNearestPenny(amount);
    cents = ToPennies(roundedAmount);
  }
  private static int ToPennies(double amount)
  {
    return Convert.ToInt32(amount * 100);
  }

  private static double RoundToNearestPenny(double amount)
  {
    double quotient = amount / .01;
    int wholePart = (int)quotient;
    decimal mantissa = ((decimal)quotient) - wholePart;
    return mantissa >= .5m ? .01 * (wholePart + 1) : .01 * wholePart;
  }

  public double Amount
  {
    get { return roundedAmount; }
  }
  public int Cents
  {
    get { return cents; }
  }

{% endcodeblock %}


Again, with that “small” change, I can run the test for equality and it will now pass. Let’s now write a test to add two money objects together:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldBeAbleToAddMoney()
{
   Money tenDollars = new Money(10.00);
   Money tenFifty = new Money(10.50);
   
   Assert.AreEqual(new Money(20.50),tenDollars.Add(tenFifty));
}
{% endcodeblock %}




You may be asking why I am not using operator overloading. No particular reason! With that failing test in place, we can carry on to add what proves to be a very simple method (thanks to all of the work we already did with the Rounding and Conversion)  (from this point I will only include new code fragments as opposed to the entire class):

 

{% codeblock lang:csharp %}
public Money Add(Money other)
{
  return new Money(this.Amount + other.Amount);
}
{% endcodeblock %}


As you can see. This does not break the immutabilty rule of the Money class, as the Add method returns a brand spanking new instance of Money that reflects that new value. Finishing off for today (there are other pieces of functionality that could be added, but I will leave that to you) let’s deal with one more piece of functionality – Multiplication. Multiplication is a good one as we are often wanting to calculate the GST for a certain amount of money when performing order totalling for E-comm sites. Let’s write a test to ensure that we can use Money to calculate GST correctly:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldCalculateGSTCorrectly()
{
  Money tenDollars = new Money(10.00);
  Assert.AreEqual(new Money(.70),tenDollars.MultiplyBy(.07));
}
{% endcodeblock %}


Once again, implementing this new piece of functionality proves to be very simple: 



{% codeblock lang:csharp %}
public Money MultiplyBy(double multiplicationFactor)
{
  return new Money(this.Amount * multiplicationFactor);
}
{% endcodeblock %}




Although there are other operations that could be added onto this money class (as well as the ability to have a Money class that can be used for multiple currencies), because we have Money encapsulated as an object in the domain we can now perform complex operations that previously would have been messily placed in utility classes and the like. This last "large" segment of code shows a family of classes taking advantage of the Money class for an Order scenario: 

{% codeblock lang:csharp %}
[Test]
public void ShouldTotalOrderCorrectly()
{
  Item chocolate = new Item(new Money(20.00),"Specialty Chocolate" );
  Item pop = new Item(new Money(10.00),"Pop" );
  Item chips = new Item(new Money(25.00),"Chips" );

  Order order = new Order();
  order.Add(chocolate);
  order.Add(pop);
  order.Add(chips);

  Assert.AreEqual(new Money(3.85),order.TotalGST);
  Assert.AreEqual(new Money(55.00),order.SubTotal);
  Assert.AreEqual(new Money(58.85),order.Total);

}

private class Order
{
  private IList<Item> items;
  private delegate Money Summarize(Item item);

  public Order():this(new List<Item>())
  {

  }

  public Order(IList<Item> itemsInOrder)
  {
    items = itemsInOrder;
  }

  public void Add(Item item)
  {
    items.Add(item);
  }

  public Money TotalGST
  {
    get {
      return TotalUsing(delegate(Item item)
          {
          return item.GST;
          });
    }
  }

  public Money SubTotal
  {
    get {
      return TotalUsing(delegate(Item item)
          {
          return item.Price;
          });
    }
  }

  private Money TotalUsing(Summarize summarizer)
  {
    Money result = new Money();
    foreach (Item item in items)
    {
      result = result.Add(summarizer(item));
    }
    return result;
  }



  public Money Total
  {
    get {
      return SubTotal.Add(TotalGST);
    }
  }
}

private class Item
{
  private const double TAX_RATE = .07;
  private Money price;
  private string name;
  public Item(Money price,string name)
  {
    this.price = price;
    this.name = name;
  }
  public Money GST
  {
    get {
      return price.MultiplyBy(TAX_RATE);
    }
  }

  public Money Price
  {
    get {
      return price;
    }
  }

  public string Name
  {
    get {
      return name;
    }
  }
}
}

{% endcodeblock %}


Enjoy.








