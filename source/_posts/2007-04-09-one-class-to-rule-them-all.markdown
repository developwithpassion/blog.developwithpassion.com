---
layout: post
title: "One Class To Rule Them All"
comments: true
date: 2007-04-09 09:00
categories:
- programming
---

One of the things that has really been hitting me in the face lately is the importance of adhering as closely as possible to the Single Responsibility Principle.

SRP simply states that:

 'A class should have only one reason to change'.

On the surface this can be a very simple principle to grok, the reality is that ensuring that a class is doing only one thing can be a skill that developers will continue to evolve over the course of their career.

Most people have come across the term cohesion, which describes how well the different behaviors of an object work together to accomplish a common task. Cohesion and SRP are one in the same. When looking at any arbitrary class in your codebase, it can often be very easy to determine whether a class is breaking SRP:
<ul>
<li>A UI that performs direct DB manipulation as well as validation of data entry.</li>
<li>'Bucket' utility classes that do everything from sending email to performing string manipulation.</li></ul>

Each extra responsibility you add to a class gives it another reason to change. Instead of composing highly cohesive objects each with a discrete responsibility that can be orchestrated together to accomplish a common task, many people opt for the behavior bloat that often can result when the time to factor out discrete behaviors has been skipped.

In my experience over the last couple of years, when you have someone sitting beside you, making you question strongly as to whether a particular piece of behavior is being placed correctly, it will almost always help drive out more cohesive objects that are focused around a single responsibility. Not only does this make them more testable. It also shields the rest of the system from any changes that may come along in that component, as its set of behaviors are fixed around one particular piece of functionality.

Single Responsibility is what drives us to create object oriented systems, that also leverage layering schemes, to ensure that ,even at the logical layering level, a 'layer' as a whole is adhering to SRP. This means that when I create a 'Presentation' layer, the layer and any of its accompanying components are focused around presentation related behavior. A DAL will be focused solely around providing data access services to the rest of the application. The domain model will be focused around encapsulating the business rules, and the heart of the system.

When you look at your codebases, ask yourself some hard questions and see whether or not you are placing too much responsibility on one object, component, or layer. By striving to follow this principle more diligently you will foster and encourage practices that lead to more loosely coupled, highly cohesive systems. Ultimately, all of the principles and practices of good OO software design come back in one way or another to trying to follow this principle as closely as possible!!




