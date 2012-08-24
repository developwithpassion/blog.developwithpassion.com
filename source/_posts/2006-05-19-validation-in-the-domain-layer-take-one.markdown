---
layout: post
title: "Validation In The Domain Layer - Take One"
comments: true
date: 2006-05-19 09:00
categories:
- .net 2.0
- c sharp
---

I have been receiving a lot of email's centered around the topic of validation in the domain layer. If you are a developer who is trying to utilize a rich domain layer in your applications, then you might have struggled with the whole issue of validation. Conceptually, most of us know how to perform validation using some predefined set of business rules. Unfortunately, the way the validation is implemented often leaves us with a solution where validation is scattered haphazardly throughout multiple layers in the application. Worse yet, is the case where validation is duplicated in multiple layers in the application, and changing a rule entails changing the code in multiple places. To demonstrate one solution to this issue I am going to focus on building a simple voting application. Some of the business rules are as follows:
<ul>
<li>Must be between the age of 18 – 75 to vote (yes there is an upper limit!!)</li>
<li>Must live in the country the candidate is running for</li></ul>

Ok, so my rules about the voting process are a little weird to say the least, but hey, it’s just an example. As well as the rules for voting, upon submitting a vote the person voting has to supply all of the required voter information:
<ul>
<li>FirstName</li>
<li>LastName</li>
<li>Age</li>
<li>Address</li>
<li>Gender</li>
<li>CountryOfResidence</li></ul>

Take a look at the class diagram for the initial domain model:

<img alt="InitialClassDiagram" src="{{ site.cdn_root }}binary/validationTake1/initialClassDiagram.jpg" border="0">

As you can see. This is a pretty simple domain. Let’s switch back to validating the simple properties for now. Let’s start with the strings (firstname,lastname,address). Remember, I am going to be performing all of my validation in the domain layer, so the buck stops here. I am not trusting anything that may have come from the UI. I am going to write a test to capture the validation I want to perform against the first name of a person:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldValidateUsingRule()
{
  IBusinessRule<Person> firstNameRule = new BusinessRule<Person>(delegate(Person person)
      {
      return string.IsNullOrEmpty(person.FirstName);
      });

  Person personWithInvalidFirstName = new Person("", "", "", 0, null, null);
  Person personWithValidFirstName = new Person("JP", "", "", 0, null, null);

  Assert.IsTrue(firstNameRule.IsBrokenBy(personWithInvalidFirstName));   
  Assert.IsFalse(firstNameRule.IsBrokenBy(personWithValidFirstName));


}
{% endcodeblock %}


As you can see from this test. I am trying to encapsulate the simple business rule “A person must have a non-null firstname” into a full fledged BusinessRule object instance. You will notice the use of the Predicate delegate that I plan on passing into the constructor of the BusinessRule class. This is the method that will perform the validation against the person. The implementation of this class should prove to be fairly simplistic:

 

{% codeblock lang:csharp %}
public class BusinessRule<T> : IBusinessRule<T>  { Predicate<T> brokenPredicate;

  public BusinessRule(Predicate<T> brokenPredicate)
  {
    this.brokenPredicate = brokenPredicate;
  }

  public bool IsBrokenBy(T item)
  {
    return brokenPredicate(item);
  }
}
{% endcodeblock %}



Notice how I am making use of generics so that I can use the BusinessRule to work with any type. When I instantiate the BusinessRule for a certain type it will also constrain the type for the Predicate. If you take a look at the IBusinessRule<T> interface. You will notice that there is not much to it:

 


{% codeblock lang:csharp %}

public interface IBusinessRule<T>  { bool IsBrokenBy(T item);
}

{% endcodeblock %}



I now want a way to encapsulate a set of rules that need to be checked against an entity. Let’s take a look at another test:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldRetrieveAllRulesBrokenByItem()
{
    IBusinessRule<Person> mockRule1 = mockery.CreateMock<IBusinessRule<Person>>();
    IBusinessRule<Person> mockRule2 = mockery.CreateMock<IBusinessRule<Person>>();
    IBusinessRule<Person> mockRule3 = mockery.CreateMock<IBusinessRule<Person>>();

    Person person = new Person("", "", "", 0, null, null);
    Expect.Call(mockRule1.IsBrokenBy(person)).Return(true);
    Expect.Call(mockRule2.IsBrokenBy(person)).Return(true);
    Expect.Call(mockRule3.IsBrokenBy(person)).Return(false);
    
    
    mockery.ReplayAll();
    
    IBusinessRuleSet<Person> ruleSet = new BusinessRuleSet<Person>(mockRule1, mockRule2, mockRule3);
    IBusinessRuleSet<Person> brokenRules = ruleSet.BrokenBy(person);
    Assert.AreEqual(2,brokenRules.Count);
}
{% endcodeblock %}



 

Once again, I am making use of RhinoMocks to mock out the business rules. As you can see, you can ask a BusinessRuleSet for all of the rules that are broken by an item. With the test in place, the implementation becomes a breeze:

 

{% codeblock lang:csharp %}
public class BusinessRuleSet<T> : IBusinessRuleSet<T>
{
    private IList<IBusinessRule<T>> rules;

    public BusinessRuleSet(params IBusinessRule<T>[] rules) : this(new List<IBusinessRule<T>>(rules))
    {
    }

    public BusinessRuleSet(IList<IBusinessRule<T>> rules)
    {
        this.rules = rules;
    }

    public IBusinessRuleSet<T> BrokenBy(T item)
    {
        IList<IBusinessRule<T>> brokenRules = new List<IBusinessRule<T>>();

        foreach (IBusinessRule<T> rule in rules)
        {
            if (rule.IsBrokenBy(item))
            {
                brokenRules.Add(rule);
            }
        }
        return new BusinessRuleSet<T>(brokenRules);
    }

    public int Count
    {
        get { return rules.Count; }
    }
}
{% endcodeblock %}



With the business rule set in place let’s turn our attention to how we could go about asking domain objects to validate themselves:

 

 

{% codeblock lang:csharp %}
[Test]
public void ShouldValidateUsingBusinessRuleSet()
{
  IBusinessRuleSet<Person> mockRuleSet = mockery.CreateMock<IBusinessRuleSet<Person>>();
  IBusinessRuleSet<Person> mockBrokenRules = mockery.CreateMock<IBusinessRuleSet<Person>>();

  Person person = new Person("", "", "", 0, null, null,mockRuleSet);

  Expect.Call(mockRuleSet.BrokenBy(person)).Return(mockBrokenRules);
  mockery.ReplayAll();

  IBusinessRuleSet<Person> brokenRules = person.Validate();
  Assert.AreEqual(mockBrokenRules,brokenRules);
}
{% endcodeblock %}




Being a big fan of dependency injection, I am making the decision that domain objects will be constructed with the rules they can use to validate themselves. This is especially handy in situations where the validation is context sensitive ie. In migration you often relax validation rules. I have decided that I will be able to ask a domain object to validate itself, and the result of this call will be a IBusinessRuleSet<T> containing all of the broken rules. With what we already have in place this should be fairly trivial:

 

{% codeblock lang:csharp %}
public Person(string firstName, string lastName, string address, int age, Country countryOfResidence, Gender gender, IBusinessRuleSet<Person> ruleSet)
{
    this.firstName = firstName;
    this.lastName = lastName;
    this.address = address;
    this.age = age;
    this.countryOfResidence = countryOfResidence;
    this.gender = gender;
    this.ruleSet = ruleSet;
}

public IBusinessRuleSet<Person> Validate()
{
    return ruleSet.BrokenBy(this);
}
{% endcodeblock %}



 

That’s it. In the constructor for the Person class I pass in the rule set that it can use for validation, and the Validate method becomes a simple one line delegation. The solution I have used to encapsulate the business rules can easily allow me to utilize the flyweight pattern to share RuleSet’s between multiple instances of the same type. More on that later. Let’s look at the completed code required to validate a person class:

 

{% codeblock lang:csharp %}
public class Person
{
  private string firstName;
  private string lastName;
  private string address;
  private int age;
  private Country countryOfResidence;
  private Gender gender;
  private readonly IBusinessRuleSet<Person> ruleSet;

  public Person(string firstName, string lastName, string address, int age, Country countryOfResidence, Gender gender):this(firstName,lastName,address,age,countryOfResidence,gender,Rules.Default)
  {

  }

  public Person(string firstName, string lastName, string address, int age, Country countryOfResidence, Gender gender, IBusinessRuleSet<Person> ruleSet)
  {
    this.firstName = firstName;
    this.lastName = lastName;
    this.address = address;
    this.age = age;
    this.countryOfResidence = countryOfResidence;
    this.gender = gender;
    this.ruleSet = ruleSet;
  }

  public IBusinessRuleSet<Person> Validate()
  {
    return ruleSet.BrokenBy(this);
  }


  public string FirstName
  {
    get { return firstName; }
  }

  public string LastName
  {
    get { return lastName; }
  }

  public string Address
  {
    get { return address; }
  }

  public int Age
  {
    get { return age; }
  }

  public Country CountryOfResidence
  {
    get { return countryOfResidence; }
  }

  public Gender Gender
  {
    get { return gender; }
  }

  public sealed class Rules
  {
    private Rules()
    {

    }

    public static IBusinessRule<Person> FirstName
    {
      get { return new BusinessRule<Person>(delegate(Person person)
          {
          return ! string.IsNullOrEmpty(person.FirstName);
          });
      }
    }

    public static IBusinessRule<Person> LastName
    {
      get { return new BusinessRule<Person>(delegate(Person person)
          {
          return ! string.IsNullOrEmpty(person.LastName);
          });
      }
    }

    public static IBusinessRule<Person> Address
    {
      get { return new BusinessRule<Person>(delegate(Person person)
          {
          return ! string.IsNullOrEmpty(person.Address);
          });
      }
    }

    public static IBusinessRule<Person> Age
    {
      get { return new BusinessRule<Person>(delegate(Person person)
          {
          return person.Age > 0;
          });
      }
    }

    public static IBusinessRule<Person> Country
    {
      get { 
            return new BusinessRule<Person>(delegate(Person person)
                                            {
                                              return person.CountryOfResidence != null;
                                            });
      }
    }


    public static IBusinessRule<Person> Gender
    {
      get { return new BusinessRule<Person>(delegate(Person person)
          {
          return person.Gender != null;
          });
      }
    }


    public static IBusinessRuleSet<Person> Default
    {
      get { return new BusinessRuleSet<Person>(FirstName, LastName, Age, Address, Country, Gender);
      }
    }
  }
}

{% endcodeblock %}





Notice how I am making use of the nested rules class inside of Person to place all of the distinct business rules for a person inside of the Person class itself. This is for demonstration, and to not go to the full blown effort of creating a RuleRegistry or the like. Notice how the constructor for the Person class that does not take a rule set, calls into the greedy constructor passing in the Default rule set, which is composed of each of the individual business rules. Let’s write some quick tests to verify that the default validation actually works:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldValidateFirstNameUsingDefaultRules()
{
  Person person = new Person("", "JP", "Address", 1, Country.CANADA, Gender.MALE);
  IBusinessRuleSet<Person> broken = person.Validate();
  Assert.AreEqual(1,broken.Count);
  Assert.IsTrue(broken.Contains(Person.Rules.FirstName));
}
{% endcodeblock %}





Currently the test will not compile because the IBusinessRuleSet interface does not provide the contains method. I need to implement the method (which I won’t bother showing) and then I can run the test. Once I have added the necessary code I will still get a failure because the object references for the 2 rules are not the same, even though in reality the rules are identical. To circumvent this issue we can add a custom equals implementation for the BusinessRule class. To make it simpler, I am going to add a new field to the business rule class to store the name of the business rule:

 

 

{% codeblock lang:csharp %}
[Test]
public void BusinessRulesForATypeWithTheSameNameShouldBeEqual()
{
  IBusinessRule<Person> firstNameRule = new BusinessRule<Person>("FirstName",delegate(Person person)
      {
      return false;
      });

  IBusinessRule<Person> firstNameRule2 = new BusinessRule<Person>("FirstName",delegate(Person person)
      {
      return false;
      });

  Assert.IsTrue(firstNameRule.Equals(firstNameRule2));
}
{% endcodeblock %}



Initially this test will fail, this is because I need to add a custom equals implementation for the BusinessRule class:

 

{% codeblock lang:csharp %}
public override bool Equals(object obj)
{
    IBusinessRule<T> other = obj as IBusinessRule<T>;
    return (other == null ? true : this.Name.Equals(other.Name));                        
}

public override int GetHashCode()
{
    return brokenPredicate.GetHashCode() + 29*name.GetHashCode();
}
{% endcodeblock %}






With this code in place the equals method will now work. Of course, with this refactoring I need to go back to the Rules class inside of person, and change all of the rules so a name is passed in also. An example of one such rule change is as follows:

 

{% codeblock lang:csharp %}

public static IBusinessRule<Person> Country
{
  get { return new BusinessRule<Person>(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
      {
      return person.CountryOfResidence != null;
      });
  }
}
{% endcodeblock %}




Notice, in this initial incarnation I am using the Name of the property itself to determine the rule name!! Ok, this post is quickly turning into an essay, so I am going to cover one more point and then carry on another day. Take a look at the following rules in the Person class:

 

 

{% codeblock lang:csharp %}
public static IBusinessRule FirstName
{
  get
  {
    return new BusinessRule(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
        {
        return ! string.IsNullOrEmpty(person.FirstName);
        });
  }
}

public static IBusinessRule LastName
{
  get
  {
    return new BusinessRule(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
        {
        return ! string.IsNullOrEmpty(person.LastName);
        });
  }
}

public static IBusinessRule Address
{
  get
  {
    return new BusinessRule(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
        {
        return ! string.IsNullOrEmpty(person.Address);
        });
  }
}
{% endcodeblock %}




You will notice that I am making use of the same method call in each argument string.IsNullOrEmpty. Unfortunately, what happens for any one of those checks when the string for any one of them is " ". The IsNullOrEmpty method will not catch this scenario. I need to fix the string checks so that they all behave the same. So now I have three pieces of code to change. Let me show you a way to encapsulate the checks: 



{% codeblock lang:csharp %}
public interface ISpecification<T>
{
  bool IsSatisfiedBy(T item);
}

public class NonEmptyStringSpecification : ISpecification<string> { public bool IsSatisfiedBy(string item)
  {
    return (! string.IsNullOrEmpty(item)) && item.Trim().Length > 0;
  }
}
{% endcodeblock %}






{% codeblock lang:csharp %}
public static IBusinessRule<Person> FirstName
{
    get
    {
        return new BusinessRule<Person>(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
                                            {
                                                return new NonEmptyStringSpecification().IsSatisfiedBy(person.FirstName);
                                            });
    }
}

public static IBusinessRule<Person> LastName
{
    get
    {
        return new BusinessRule<Person>(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
                                            {
                                                return new NonEmptyStringSpecification().IsSatisfiedBy(person.LastName);
                                            });
    }
}
{% endcodeblock %}





I am making use of a toned down Specification pattern. If you are not familiar with that pattern, go ahead and pick up a copy of Eric Evans Domain Driven Design book. I promise I will devote a separate post to the Specification pattern (if people remind me!!). With the NonEmptyStringSpecificaton in place I can change the code in the Person rules class to the following: 

 

{% codeblock lang:csharp %}
public static IBusinessRule<Person> FirstName
{
    get
    {
        return new BusinessRule<Person>(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
                                            {
                                                return new NonEmptyStringSpecification().IsSatisfiedBy(person.FirstName);
                                            });
    }
}

public static IBusinessRule<Person> LastName
{
    get
    {
        return new BusinessRule<Person>(MethodInfo.GetCurrentMethod().Name,delegate(Person person)
                                            {
                                                return new NonEmptyStringSpecification().IsSatisfiedBy(person.LastName);
                                            });
    }
}
{% endcodeblock %}




Notice that because the check for a Non-Empty string is now encapsulated in “another object”, if the rules for a non empty string change, I now only need to change one place!! I could carry on and add a NonNullObject specification that would encapsulate the null checks, this would be added solely for consistency and readability.

Ok, so we now have a faily flexible validation engine in place, we have one problem. I can perform validation, but how am I going to get validation errors back to the client? Let’s write a quick test to prove out how I can go about this. In my head I think that it is going to take another change to the business rule class as well as the rule set:

 

{% codeblock lang:csharp %}
[Test]
public void ShouldRetrieveMessagesForAllRules()
{
    IBusinessRule<Person> mockRule1 = mockery.CreateMock<IBusinessRule<Person>>();
    IBusinessRule<Person> mockRule2 = mockery.CreateMock<IBusinessRule<Person>>();

    Expect.Call(mockRule1.Description).Return(FIRST_NAME_MESSAGE);
    Expect.Call(mockRule2.Description).Return(LAST_NAME_MESSAGE);

    mockery.ReplayAll();
    
    IBusinessRuleSet<Person> rules = new BusinessRuleSet<Person>(mockRule1, mockRule2);
    IList<string> ruleMessages = rules.Messages;
    
    Assert.AreEqual(2,rules.Count);
    Assert.Contains(FIRST_NAME_MESSAGE,(IList)ruleMessages);
    Assert.Contains(LAST_NAME_MESSAGE,(IList)ruleMessages);
}
{% endcodeblock %}



The addition of a description for the rule requires me to add a new field and constructor to the BusinessRule class (the Description property gets added to the IBusinessRule interface):

 

{% codeblock lang:csharp %}
public class BusinessRule<T> : IBusinessRule<T>  { Predicate<T> brokenPredicate;
  private string name;
  private string description;

  public BusinessRule(string name,string description,Predicate<T> brokenPredicate)
  {
    this.name = name;
    this.description = description;
    this.brokenPredicate = brokenPredicate;
  }

  public bool IsSatisfiedBy(T item)
  {
    return brokenPredicate(item);
  }

  public string Name
  {
    get { return name; }
  }

  public string Description
  {
    get { return description; }
  }

  public override bool Equals(object obj)
  {
    IBusinessRule<T> other = obj as IBusinessRule<T>;
    return (other == null ? true : this.Name.Equals(other.Name));
  }

  public override int GetHashCode()
  {
    return brokenPredicate.GetHashCode() + 29*name.GetHashCode();
  }


}
{% endcodeblock %}






With that change in place. I need to update the rules that I create in the person class to add a description (you can check that out in the actual code). The code needed to implement the Messages property on the BusinessRuleSet class becomes a snap (with the aid of another anonymous delegate):

 

{% codeblock lang:csharp %}
public IList<string> Messages
{
    get 
    {
        return new List<IBusinessRule<T>>(rules).ConvertAll<string>(delegate(IBusinessRule<T> rule)
                                                                        {
                                                                            return rule.Description;
                                                                        });
    }
}
{% endcodeblock %}






I make use of the ConvertAll method on the List<t> class, to convert each of the rules into a plain old string, by passing in a delegate that just retrieves the Description from the rule!! Great. Everything is in place, let’s put all of this stuff through its paces. Take a look at the following WinForm:</t>

 

<img alt="PersonWinForm" src="{{ site.cdn_root }}binary/validationTake1/personWinForm.jpg" border="0">

This form will allow the user to enter in all of the basic information (minus Country and Gender). An accompanying presenter that can be consumed from this view is as follows:

 

{% codeblock lang:csharp %}
public class PersonPresenter
{
    private IPersonView view;

    private IBusinessRuleSet<Person> rulesInContext = new BusinessRuleSet<Person>(Person.Rules.FirstName, Person.Rules.LastName, Person.Rules.Address, Person.Rules.Age);

    public PersonPresenter(IPersonView view)
    {
        this.view = view;
    }

    public void Submit()
    {
        IBusinessRuleSet<Person> broken = CreateFromView().Validate();
        if (broken.Count > 0)
        {
            view.DisplayErrors(broken.Messages);
        }
        else
        {
            view.DisplaySuccess();
        }
    }

    private Person CreateFromView()
    {
        int age = 0;
        int.TryParse(view.Age, out age);

        return new Person(view.FirstName, view.LastName, view.Address, age, Country.CANADA, Gender.MALE);
    }
}
{% endcodeblock %}





With that code in place (plus an accompanying view interface), if you run the app you will notice that the rules (for the context of the presenter) are being utilized to perform validation. I think I have probably given you a bit to think about. And keep in mind, this is one of several ways that validation in the domain layer can be performed. There are more refactorings that can be performed, and I still have not even looked at how we are going to perform the validation for the real voting scenario. I'll leave that for another day, unless one of my readers feels like submitting an extension to this piece to support the extended scenario.

Please take the time to provide feedback if you have any. One of the main reasons that I try to post quality content is knowing that people out there are getting something from it. For the many who take the time to respond, it is greatly appreciated. I had to re- enable the captcha image, as I got spammed hard the other day. If you cannot place comments on the blog feel free to email me at [bitwisejp@gmail.com](mailto:bitwisejp@gmail.com)

The complete code (so far) for this entry is [here.]({{ site.cdn_root }}binary/validationTake1/Validation.zip)






  
