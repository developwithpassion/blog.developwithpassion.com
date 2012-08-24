---
layout: post
title: "How can I convince my management/other developers of the value of unit testing?"
comments: true
date: 2007-05-23 09:00
categories:
- agile
---

The amount of times I am asked this question is fairly astounding. It seems that lots of people are struggling with getting their management (at this level I will talk about the Project Management level) to believe in the value of automated unit testing.

I am not even talking about Test/Behavior Driven Development, I am talking about simple state based unit testing. There seems to be a great misconception floating around out there that the act of unit testing is going to negatively impact individual/team velocity. Let me ask all of the developers out there another question. How can I convince a developer that refactoring is a good practice? This seems like a ridiculous question, but it actually points to the same principle. The reason that most developers will laugh at the statement about refactoring is that most good developers naturally learn to evolve their basic refactoring skills even with the absence of fancy design patterns etc. Going through a series of steps such as:
<ul>
<li>This method is too long... I'll break it up</li>
<li>This class is too big.... I'll separate responsibilities</li>
<li>This behavior does not belong on this object.... I'll move it</li>
<li>This functionality does not belong in this layer of the application.... I'll move it</li></ul>

That is a dramatic simplification of refactoring. Nonetheless, a good developer who has not been exposed to a refactoring catalog will inherently develop a habit of 'natural' refactoring, for nothing less than to keep the quality of the code at a certain level.

One more question. When you are sitting there making estimates on how long a particular unit of work will take, do you estimate in time for how long it will take you to refactor code that you are writing? Ridiculous, if we are talking about a developer who has developed a natural habit of refactoring, it is just that 'A Natural Habit'. This developer no longer needs to think about factoring in time for refactoring, because it has been factored into their very core as a development practice.

In my opinion, unit testing is the exact same problem. Not enough developers have developed a natural habit of unit testing their codebases. Content to jump into debuggers at the first sign of an issue, most developers spend an order of magnitude time greater manual fixing and verifying their codebases, when they could bit the bullet, write some automated tests, and have a computer do as much grunt work for them as possible.

Here is a question I would like to throw at developers (and management alike). Where do you want to spend the time? Would you prefer to spend the time flying through delivering untested features that are potentially going to come back with bug items that need to be manually debugged and fixed piecemeal. Or, write unit tests around as much code as you can, so that in the event a bug comes in you can:
<ul>
<li>Write a failing unit test that captures the bug</li>
<li>Update the code to make the failing unit test pass</li>
<li>Keep the test in place to serve as a way to prevent the bug from reintroducing itself</li></ul>

Developers and managers alike are kidding themselves if they think that they are going to save themselves time by not having some form of automated testing in place. A very simple way to convince people of the value of unit testing is to record actual metrics that document the amount of time it takes to fix a bug in a system that has a suite of automated unit tests in place vs. a system that has no automated unit tests in place. Once you can convert that figure to a dollar amount in developer time wasted on bug fixing; it becomes very apparent to developers and management that there is an actual real cost saving that can be realized.

Above and beyond convincing management is the fact that, at a developer level, it is time for more developers to form some new natural habits in their development process. I am a personal fan of test driven development because while you are simultaneously flushing out the design for your system, you are left with a safety net of tests.

If you are not practicing TDD, you need to get yourself into a habit of at least unit testing critical objects/behaviors in your system. For projects that are well underway/deployed and have no unit tests in place, it is unrealistic to revisit them and retrofit the entire codebase with unit tests. A better strategy for these projects is to identify pain points in the application (areas with the highest level of bug activity/ areas with the most volatility) and get some unit tests around these 'points of high visibility'. Going forward you can encourage developers to get unit tests around new methods/classes etc, and start to integrate some new habits into your developers.




