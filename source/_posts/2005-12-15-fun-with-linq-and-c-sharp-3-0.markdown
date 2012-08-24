---
layout: post
title: "Fun With Linq and C# 3.0"
comments: true
date: 2005-12-15 09:00
categories:
- .net 3.0
- c sharp
---
As you already may know, Microsoft released the preview of Linq a while ago, to give developers a chance to play with some of the language features that are going to be in C# 3.0. Some of the new features that will be introduced are:

* Extension Classes
* Lambda Expressions
* Language Integrated Query(LINQ)


So what does all this mean to you as a developer? Here is an example of what can be accomplished with extension classes. How many times have you found yourself writing some sort of StringUtility class in your applications? Would'nt it be nice if you could just add methods that all instances of string would be able to call? Well with C# 3.0 it looks like this:

{% codeblock lang:csharp %}
 using System;
 using System.Collections.Generic;
 using System.Text;
 using System.Query;
 using System.Xml.XLinq;
 using System.Data.DLinq;
 using NUnit.Framework;
 using LinqMadness.Core;
 using System.Query;
 namespace LinqMadness.Test
 {
     [TestFixture]
     public class StringExtensionTest
     {
         [Test]
         public void ShouldBeAbleToReverseString()
         {                        
             Assert.AreEqual("tsaoT","Toast".Reverse());
         }
 
         [Test]
         public void ShouldBeAbleToTestForPalindrome()
         {
             Assert.IsTrue("pop".IsPalindrome());
             Assert.IsTrue("barcrab".IsPalindrome());
             Assert.IsTrue("elbertandednatreble".IsPalindrome());
             Assert.IsFalse("nonPalindrome".IsPalindrome());
         }
         
         
     }
 }
{% endcodeblock %}
 
As you can see from the above test class, using extension classes I have been able to dynamically add methods to any instance of a string object. How did he do that?? Look at the following code that shows how this is accomplished:



{% codeblock lang:csharp %}
 using System;
 using System.Collections.Generic;
 using System.Text;
 using System.Query;
 using System.Xml.XLinq;
 using System.Data.DLinq;
 
 namespace LinqMadness.Core
 {
     public static class StringExtensions
     {        
         public static string Reverse(this string stringToReverse)
         {
             StringBuilder builder = new StringBuilder(stringToReverse.Length);
             for(int i = stringToReverse.Length-1;i>=0;i--)
                {
                 builder.Append(stringToReverse[i]);
             }
             return builder.ToString();
         }
     
         public static bool IsPalindrome(this string toCheck)
         {
 
             for(int i = 0;i < toCheck.Length/2;i++)
             {
                     if (toCheck[i] != toCheck[toCheck.Length -1 -i])
                     {
                             return false;
                     }
             }
             return true;
         }
 
     }
 }
{% endcodeblock %}


A couple of key points to note here. Notice the use of a static class. More importantly look at the signature of one of the methods that extends string with new functionality:

public static string Reverse(<b>this</b> string stringToReverse)

The use of the this keyword coupled with the type argument to the method indicates that this method is a behaviour that now will belong to all string instances.

Ok, so as cool as that is, take a look at the following code that demonstrates some of the new LINQ features in C# 3.0.

{% codeblock lang:csharp %}
 using System;
 using System.Collections.Generic;
 using System.Text;
 using NUnit.Framework;
 using System.Query;

 namespace LinqMadness.Test
 {
   [TestFixture]
   public class CollectionTest
   {
     [Test]
     public void ShouldBeAbleToFindAllOddNumbersInList()
     {
       List<int> numbers = new List<int>();
       numbers.Add(1);
       numbers.Add(2);
       numbers.Add(3);
       numbers.Add(4);
       numbers.Add(5);

       Assert.AreEqual(3,numbers.FindAll(i => (i % 2) != 0).Count);
       Assert.AreEqual(1,numbers.Min());
     }

     [Test]
     public void ShouldBeAbleToCreateCustomType()
     {
       IList<Customer> customers = new List<Customer>(){newCustomer("JP","555-4444",23,"SomeAddress","Canada"),
       new Customer("Aaron","555-4444",23,"SomeAddress","Canada")};

       foreach (Customer customer in customers)
       {
         var customerDTO = new{customer.CustomerName, customer.Phone};
         Assert.AreEqual(customer.CustomerName,customerDTO.CustomerName);
         Assert.AreEqual(customer.Phone,customerDTO.Phone);
       }
     }

     [Test]
     public void ShouldBeAbleToUseQuerySyntax()
     {
       IList<Customer> customers = new List<Customer>(){new Customer("JP","555-4444",27,"SomeAddress","Canada"),
       new Customer("APerson1","555-4444",27,"SomeAddress","Canada"),
       new Customer("APerson2","555-4444",8,"SomeAddress","Canada"),
       new Customer("APerson3","555-4444",6,"SomeAddress","Canada"),
       new Customer("APerson4","555-4444",3,"SomeAddress","Canada"),
       new Customer("APerson5","555-4444",1,"SomeAddress","Canada")};


       IEnumerable<Customer> customersOver8 = from c in customers
       where c.Age > 8
       select c;

       IEnumerable<Customer> customersBeginningWithA = from c in customers
       where c.CustomerName.StartsWith("A")
       select c;


       IEnumerable<Customer> customersWithOddNameLength = from c in customers
       where c.CustomerName.Length % 2 != 0
       select c;

       Assert.AreEqual(2,new List<Customer>(customersOver8).Count);
       Assert.AreEqual(2,new List<Customer>(customersBeginningWithA).Count);
       Assert.AreEqual(1,new List<Customer>(customersWithOddNameLength).Count);

     }

     [Test]
     public void ShouldBeAbleToMultiplyUsingFold()
     {
       List<int> numbers = new List<int>{1,2,3,4,5,6,7};
       int product = numbers.Fold((start,current)=> start * current);
       Assert.AreEqual(5040,product);
     }

     [Test]
     public void ShouldBeAbleToSum()
     {
       List<int> numbers = new List<int>{1,2,3,4,5,6,7};
       int sum = numbers.Sum();
       Assert.AreEqual(28,sum);
     }

     [Test]
     public void ShouldBeAbleToSeeIfListsAreEqual()
     {
       Assert.IsTrue(new List<int>(){1,2,3}.EqualAll(new List<int>(){1,2,3}));
       Assert.IsFalse(new List<int>(){1,2,3}.EqualAll(new List<int>(){1,2,4}));
     }

     [Test]
     public void ShouldBeAbleToGetDistinct()
     {
       Assert.AreEqual(4,new List<int>(new int[]{1,2,2,3,3,4}.Distinct()).Count);
     }


 [Test]
 public void ShouldBeAbleToUnionTwoSets()
 {
 List<int> firstSet = new List<int>(){1, 2, 3, 2, 2, 2, 4, 5};
 List<int> secondSet = new List<int>(){4, 5, 2, 2, 3, 4, 6, 7};

 Assert.AreEqual(7,new List<int>(firstSet.Union(secondSet)).Count);
 }


 [Test]
 public void ShouldBeAbleToIntersectTwoSets()
 {
 List<int> firstSet = new List<int>(){1,2,3,3,4,5,6,7};
 List<int> secondSet = new List<int>(){4,8,9};

 Assert.AreEqual(1,new List<int>(firstSet.Intersect(secondSet)).Count);
 }

 [Test]
 public void ShouldBeAbleToOutputSquares()
 {
 int numberToSquare = 0;
 foreach (int square in Sequence.Range(1,30).Select(i => i * i))
 {
 numberToSquare++;
 Assert.AreEqual(numberToSquare * numberToSquare,square);
 }
 }

 private class Customer
 {
   private string customerName;
   private string phone;
   private int age;
   private string address;
   private string country;


   public Customer(string customerName, string phone, int age, string address,string country)
   {
     this.customerName = customerName;
     this.phone = phone;
     this.age = age;
     this.address = address;
     this.country = country;
   }


   public string CustomerName
   {
     get { return customerName; }
   }

   public string Phone
   {
     get { return phone; }
   }

   public int Age
   {
     get { return age; }
   }

   public string Address
   {
     get { return address; }
   }


   public string Country
   {
     get { return country; }
   }
 }
 }
 }
{% endcodeblock %}
 
I'll let you wrap your head around that one over the weekend and will dive more into the details of how it all works in a later post. If you want to be able to run the code, you will need to download and install the [Linq](http://download.microsoft.com/download/4/7/0/4703eba2-78c4-4b09-8912-69f6c38d3a56/LINQ%20Preview.msi) technical preview.




