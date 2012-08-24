---
layout: post
title: "Behaviour Driven Development"
comments: true
date: 2006-06-29 09:00
categories:
- agile
---

With the recent buzz (in the .Net world) around behaviour driven development (mostly due to the release of NSpec). I thought I would take the time to make a quick point. BDD is nothing new to people who have already been doing TDD properly. One of the interesting side effects of even just changing the first word in the *DD term is the switch that the mind makes to realizing that TDD done properly or BDD is not about testing. TDD was never meant to be about testing the system, Test Driven Development or the lesser used term Test Driven Design is a pure exercise is designing your production code. Instead of UML class/sequence diagrams you are writing code that <strong>'specifies' </strong>how your components <strong>'behave'.</strong>  Notice the emphasis I have placed on the words specifies and behave. The whole test nomenclature can actually be quite a stumbling block for people who are wanting to do TDD effectively. 

If you have taken a look at [NSpec](http://nspec.tigris.org/) you will see that they are completely shedding the testing nomenclature. This subtle change alone can have a dramatic effect on people new to the whole 'design by code approach'. Why? It enforces the concept that you are not 'testing', you are designing. If you take a look at a quick piece of code demonstrating NSpec in action:
{% codeblock lang:csharp %}
[Context]
public class Example
{
    [Specification]
    public void NewMoneyShouldHaveZeroAmount()
    {
        Specify.That(new Money().Amount).Equals(0.00m);
    }
}
{% endcodeblock %}

Contrast this with a 'classic' NUnit approach 
{% codeblock lang:csharp %}
[TestFixture]
public class Example2
{
    [Test]
    public void TestNewMoney()
    {
        Assert.Equals(0.00m, new Money().Amount);
    }
}
{% endcodeblock %}




Functionally these two pieces of code are equivalent. Notice , however, that the use of the specification friendly terminology provided by NSpec does make intent of the code a bit easier to read (in my opinion).

NSpec as a framework looks promising, I'm not sure if it is ready for prime time yet, but again it is just a framework to aid in the 'practice' of BDD.  I think that BDD is the next natural step to enable people who may be struggling with TDD to finally realize that it is not about testing at all, it is about design.




