---
layout: post
title: "Becoming Extreme - From the inside out"
comments: true
date: 2007-05-23 09:00
categories:
- agile
---

This is a hot topic for me right now, as I talk with lots of people who are working through trying to make their teams more 'Agile'. That word is a little overloaded and overused lately, so I am going to focus on how you can make your team more Extreme through use of practices and strategies that live in the world of the development team.

I am going to point everyone to James Carrs great post today about [A Tale of Two Teams](http://blog.james-carr.org/?p=78). It is a great post that helps me start of by making a big bold statement (reiterating what James said).
<ul>
<li>Stop blaming other people for your inability to introduce practices and strategies that <strong>will </strong>make your team more effective.</li></ul>

As a consultant, I get the great joy of being 'that guy'. The one who comes in to shake things up and challenge peoples assumptions about the way they build software and the software development process in general. Having a deep love for the practices associated with Extreme programming, I have crafted a set of strategies that I feel have helped infect every team/developer I have interacted with on the benefits of this 'new' style of development. I want to share these strategies in the hope that they will inspire other developers who are in positions of influence (that is all of us) to encourage their development team to strive for something better.

<strong><u>Develop With Passion</u></strong>

This title is not a joke. My companies tagline is 'Develop With Passion'. This is a crucial, but often overlooked element of introducing a team to a set of new practices. Whether people share the same values or not, people respect people who stand up with conviction for their beliefs. If you love what you do, other people will notice and (most) will want to share that passion you have for your work. If I come in completely fired up about the benefits of agile, yet am lukewarm in my delivery, the message will get lost.

<strong><u>Invest In Building Solid Team Relationships</u></strong>

Before you can hope to reach people at a technical level, and try to encourage them to improve their development practices, they have to know you are authentic. This is especially important for consultants, who are often viewed as the ninja paratroopers of the software development world. We swoop in, do a bunch of 'magic', then we leave!! This view has to be dispelled as quickly as possible. If a team that I engage does not believe that I truly care about them on a personal and professional level, they are not going to be able to listen to ideas that I bring to the table. My first couple of weeks on a new contract are spent building a level of trust between myself and the other developers that I am going to be working with. What does this investment look like:
<ul>
<li>Lunches/Coffee breaks getting to know developers outside of the workspace</li>
<li>Pair Programming Sessions where I can get an idea for each individuals skill level, providing me information I can use to focus future mentoring sessions</li>
<li>Encouraging open communication within the workspace, which helps identify each developers comfort levels, boundaries etc.</li></ul>

<strong><u>Focus On Small Victories</u></strong>

After that first couple of weeks of building relationships, I should have a great idea of how much work needs to be done to get the developers thinking and practicing in a more agile fashion. For the majority of teams out in the wild, the practices that are second nature to most agile developers are almost completely alien. There is a limit to how much an individual can assimilate at one time. This means that if I come in and throw TDD,BDD, DDD, Interface Based Programming, Automated Builds, Continuous Integration etc.. at them all at once, it will be too much information. Based on the level of the team I have to focus on individuals and practices in a piecemeal fashion. Think of running it like you own mini agile project, with the end result being having your development team completely immersed in an agile environment. My set of small wins is usually introduced incrementally using the following steps:
<ol>
<li>Introduce the concept of an automated deployment script. If nothing else, to decrease the amount of manual time that is probably being spent on deploying applications that are going out to production. Some good tools for this are [NAnt](http://nant.sourceforge.net/), [MSBuild](http://msdn2.microsoft.com/en-us/library/0k6kkbsd.aspx), or (my fave for deployments) [FinalBuilder](http://www.finalbuilder.com/). The amount of individual time saved on decreasing the amount of human intervention required for deployment will allow your development team to focus on other tasks to ramp themselves up.</li>
<li>Start leveraging an automated build script to compile your application. This will inevitably lead to some codebase structure refactoring that will make it more malleable to an automated build script.</li>
<li>Introduce the concepts and practices of automated unit testing using an framework such as [MBUnit](http://www.mbunit.com/).</li>
<li>Bring a continuous integration server into the mix. My current fave for this is [CruiseControl .Net](http://confluence.public.thoughtworks.org/display/CCNET/Welcome+to+CruiseControl.NET).</li>
<li>With the foundations in place, switch into a mode of pair programming with the client developers.</li></ol>

Once in a place where I can pair with developers that is where I choose to introduce the following concepts:
<ol>
<li>The benefits of trying to achieve mouseless computing</li>
<li>Real Object Oriented Programming</li>
<li>Interface based programming</li>
<li>Test Driven Development</li>
<li>Domain Driven Design</li>
<li>Object Relational mapping and all the other great tools that exist out there to facilitate rapid,testable development.</li></ol>

As you can imagine. It takes a bit of time to have this knowledge flow and be completely understood by each developer on a team. When it happens, amazing things start happening. Other teams start to notice, management starts to notice. Teams will be coming to your team asking you the secret to your success. And then the cycle starts again.

This is a way that teams, independent of management can start to achieve some gains associated with becoming more agile. I might be a little bit cavalier about my approach to team engagement/improvement, but I have always tried to follow this simple principle:
<ul>
<li>It is easier to ask for forgiveness than permission.</li></ul>

More people need to start taking chances. Every single developer on a team , regardless of years of experience or title, is in a position to initiate change. Do you see room for improvement, introduce it. Be the catalyst for change that inspires other people. Don't hide behind excuses that shield the fact that, more often than not, the problem lies with developers who are content to whine and do nothing, vs doing something and 'maybe' receiving some heat.

Wanna be more extreme? Do what it takes to make it happen. It's that simple.




