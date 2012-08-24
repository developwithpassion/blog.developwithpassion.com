---
layout: post
title: "Just For Clarification re The Latest DotNetRocks Episode"
comments: true
date: 2008-05-11 09:00
categories:
- agile
---

First and foremost I have to stress my great amount of respect for Carl and what he does for the development community.  
In the current DNR episode in which [Carl and Richard interview Phil Haack](http://www.dotnetrocks.com/default.aspx?showNum=339) there is a portion in the show where Carl makes some statements about Test Driven Development.  
The two statements that he makes are:  
"Test first is just one extreme of test driven development"  
"according to JP Boodhoo the whole test driven development ranges from wrapping NUnit tests around existing functions on one end of the spectrum and then test first on the other end of the spectrum but most people fall somewhere in between"  
These are not my thoughts/practices with regards to Test Driven Development. I feel that test driven development is first and foremost a design activity that is used to flesh out the design of a component by creating a test that first describes the API it is going to expose and how you are going to consume it's functionality. The test will help shape and mold the System Under Test until you have been able to encapsulate enough functionality to satisfy whatever tasks you happen to be working on.  
IMHO TDD as an activity requires the creation of the test code before you write any production code for the component itself. This is the way I personally develop as well as the way I teach and mentor people with respect to practicing TDD.  
When you go into an existing code base and start wrapping tests around existing production code that is already there, that is Unit Testing, not TDD.  
Develop With Passion!!




