---
layout: post
title: "Coding to interfaces"
comments: true
date: 2006-06-19 09:00
categories:
- .net 2.0
- c sharp
- patterns
---

I had an interesting comment to a [previous post](http://blog.developwithpassion.com/HandlingDynamicRulesAPrecursor.aspx) I made about validation rules:

<em>I'm actually leaning toward limiting the use of interfaces... and here's why. 

If your interface defines every aspect of the concrete class, then what's the benefit? I'm guessing you'll say mocking, which is a valid concern. While mocking is a useful testing technique, you can still effectively test the behaviour of your classes. 

Interfaces aren't objects, so they do not get the benefits of System.object overrides, such as Equals() or ToString(). I'm all in favor of using interfaces where they are defined well and WILL be reused, but I'd stick with a base class until refactoring proves otherwise. 

A colleague of mine suggests to use interfaces for behavior only. He further suggests that defining properties inside of interfaces is a full-on Code Smell. 

I'm not 100% sure I agree with him on that, but I do believe that interfaces should focus on behavior, not on non-functional aspects like Name or Id.</em>

All an interface is, is a contract that defines the expected behaviours/attributes an object is supposed to implement (remember, implementing may not necessarily mean defining a body for the method/property itself. I definitely disagree with the statement that interfaces should contain only methods. Although lots of the framework classes leave a lot of room to the imagination, I could name a handful of clean interfaces in the framework that make use of a interfaces ability to contain properties,methods, and events.

I want to stress a point here, in the .Net world we have gotten hung up on the term interface. Remember that this term is overloaded. There is the concept of an interface, but there is also a concept in C# of an interface language construct. You can program to an interface without needing to actually use an interface. This is what people often achieve using a supertype. The fact that you can program to an interface using both an "interface" construct and a "class" construct is irrelevant. The benefit of either approach is to make use of polymorphism by programming to an interface/supertype so that code in the system is not (as much as possible) tied to concrete implementations. Coding to an interface/supertype allows the client code consuming the objects to not care about the object that it is working with, only that it supports a certain 'interface'.

I personally err to the side of using interface constructs to drive out the initial implementations, and then will refactor to a supertype in the event that it is necessary. And even then, I think people often jump to the use of inheritance way to quickly.

Rich interfaces are almost a necessity when you are creating component based systems utilizing the separated interface pattern. In these scenarios you may not want you client to have any knowledge whatsoever of the implementation code you are putting in place. Interface constructs are a great clean way to separate the client code from the actual server implementations (think remoting).

This whole question about interfaces vs abstract classes leads me to leave you with 2 OO/design thoughts to ponder:
<ul>
<li>Favour object composition over concrete inheritance</li>
<li>Code to interfaces (interface construct/abstract classes) not implementations </li></ul>




