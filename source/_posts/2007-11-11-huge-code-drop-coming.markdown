---
layout: post
title: "Huge Code Drop Coming!!!!!!!"
comments: true
date: 2007-11-11 09:00
categories:
- .net 2.0
- .net 3.0
- agile
- c sharp
- programming
- training
---

A lot of people will probably say it is about time!! I am taking the source code that just got driven out from this last week of Nothin But .Net and I am going to make it publicly available from my blog. I am hoping to release it by the end of the week. The reason that I can't release it yet, is that there are lots of concepts that I wanted to cover in class that I did not have time too, so I am going to spend a bit of time fleshing out the code base to include all of the concepts that were missed (by student request)

Keep in mind that Nothin But .Net is a course about fundamental software development practices with a bit of a .Net slant. Here are some of the things you will be able to see in the code base:
<ul>
<li>How Test Driven Development was used to drive out the functionality of screens in the application in a top down fashion</li>
<li>The benefit of using Data Transfer objects not as a marshaling tool, but as a tool to let the needs of the UI not influence unecessary changes to the domain model</li>
<li>The benefits of leveraging layered architecture</li>
<li>Why you don't need lots of projects in your enterprise solutions if you are using an automated build (take  a look at the following screenshot to get an idea for the solution structure</li>
<li>Clean Front Controller implementation so that you can eliminate the need for messy Passive View/Supervising Controller implementations just for testability of the web form world</li>
<li>Good practices around mixing both interaction and state based testing</li>
<li>Test partitioning (integration, unit, acceptance)</li>
<li>My current project build structure</li>
<li>How to avoid the overspecification problem with interaction based testing</li>
<li>Rhino Mocks and leveraging the automocking container (thanks [James](http://www.jameskovacs.com/) for getting me hooked on this thing)</li>
<li>Fluent Interfaces</li>
<li>Build Automation</li>
<ul>
<li>NAnt compilation as an effective tool for pruning dead code that studio does not show</li>
<li>NAnt as a build tool</li>
<li>NAnt as your compiler and test runner</li>
<li>Build file partitioning</li>
<ul>
<li>Use of filesets</li></ul>
<li>Machine agnostic build files through use of local property files</li></ul>
<li>Unit Testing</li>
<ul>
<li>Focusing on one thing at a time</li>
<li>Incremental testing</li>
<li>Breaking reliance on setup methods</li></ul>
<li>MBUnit</li>
<ul>
<li>Decorators used effectively</li></ul>
<li>Design Patterns</li>
<ul>
<li>Visitor</li>
<li>Factory</li>
<li>Data Transfer Object</li>
<li>Adapter</li>
<li>Proxy</li>
<li>Mapper</li>
<li>Unit Of Work (lots of people have been bugging me about this for a while)</li>
<li>Lazy Loading</li>
<li>IOC</li>
<li>Gateway (and Static Gateway)</li>
<li>Service Layer</li>
<li>Identity Map</li>
<li>Data Mapper</li>
<li>Database Gateway</li>
<li>Money</li>
<li>Null Object</li>
<li>Strategy</li>
<li>Composite</li>
<li>Command</li>
<li>Template View</li>
<li>Query Object</li>
<li>Specification</li>
<li>Domain Model</li>
<li>Separated Interface</li></ul>
<li>Design Principles</li>
<ul>
<li>Single Responsibility</li>
<li>Open Closed principle</li>
<li>Dependency Inversion Principle</li>
<li>Hollywood principle</li>
<li>Tell Don't Ask</li></ul></ul>

I am sure I am missing lots in the description above, but you get the general idea. The important thing to note, is that all of the code (except for the changes I am making this week) was driven out through the course of the one week bootcamp!!

I am going to spend a couple of days ensuring that it contains as much code as possible for an initial drop, with full end to end functionality in place. 

<strong>Going forward, this code will serve as a good place for me to be able to demonstrate in a public arena, concepts that people email me and ask me questions about. This way, I won't have to spend as much time blogging, people can send me a question about something they are having problems with, I can implement the solution in the codebase and they can see how I attacked the problem from a test first perspective.</strong>

I envision this as being a very organic application. I am going to use it as a public tool to share whatever knowledge I have with as many people as possible.

When I post the code I will make sure I post a little about the application and why I feel that it will serve as a good tool to both teach and practice.




