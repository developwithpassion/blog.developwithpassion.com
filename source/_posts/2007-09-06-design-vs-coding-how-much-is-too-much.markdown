---
layout: post
title: "Design vs. Coding - How Much Is Too Much?"
comments: true
date: 2007-09-06 09:00
categories:
- agile
---

A while ago I got asked the following question:

<em><font color="#ff00ff">I've been wondering something about
OOD that perhaps many developers think about, and that is the
relationship between the amount of time used for design (eg. drawing
UML) and actual coding.
 
What's your take on this? Do you like to design everything from the
high-level till the ground-level with UML? What UML diagrams you find
most usefull? Or do you think that using pure TDD makes UML somewhat
obsolete?</font></em>

Since I got introduced to agile methods, I was also introduced very early to the concept of 'code' as a design tool. To be more specific, this is the concept that everyone has come to know formally as Test Driven Development. When practicing TDD/BDD the goal is to write the test before the code that you are wanting to create actually exists. Don't forget what we are doing here, we are writing 'code' for 'code' that does not yet exist. This gives us a completely blank slate to work with. <strong>This allows us to code the object with the exact 'behaviors' that we would want it to exhibit and the API through which we interact with it</strong>. After you have been doing TDD for a while the 'explicit thought' of 'I should write a test' becomes a habit, so you write the test first without even thinking about it. This is great. When you have been doing TDD for a while.

The problem lies for the people who are fresh into TDD and they are still in that uncomfortable period where it does not yet feel natural to write the test first. As much as TDD is about design it is also about 'moving ahead'. When you find yourself staring at a screen and lost for which direction to drive out a test the answer is simple <strong>'Get Up In Front Of A WhiteBoard and Draw!!!</strong>' (I am making the assumption here that you have already tried talking with your team and you are all collectively at a loss for where to begin). If you are feeling stuck and unable to move ahead one of the following diagrams :
<ul>
<li>UML Class Diagram</li>
<li>UML Sequence Diagram</li></ul>

may help to generate some ideas in your head that can serve as a starting point for helping you to drive out the test. Of all of the UML diagrams, the only ones I find myself using anymore are:
<ul>
<li>UML Class Diagram</li>
<li>UML Sequence Diagram</li>
<li>UML State Diagram</li></ul>

Even on teams of experienced agile practitioners, it can often be beneficial to whiteboard an high level idea that you are having to quickly share information with the team and solicit feedback. These should be quick sanity check sessions where you are just brainstorming. It is not a 2 hour session where you are drawing out a complicated class/sequence diagram that will almost definitely not correlate to the resulting code that is produced. 

One of the most effective tools that a developer has in their arsenal to convey design ideas quickly (aside from unit tests) is a whiteboard and marker. So even though you may currently feel stuck with respects to which direction to take test; the act of getting up and trying to draw down a quick UML sketch can get the creative juices flowing and provide you with the ammo and direction with which to get back to the computer and start writing the test. Which is ultimately the design exercise you want to move to, as it is a 'specification' that is able to adapt to the code that it is targeting (unlike a static UML diagram).

People starting out in TDD get very uncomfortable when they are often faced with the realization that the design skills they thought they had are actually not really that proficient. TDD brings this to the forefront because design is something that is being done constantly. Most developers that I know who are familiar with UML are able get in front of a whiteboard and come up with a quick sketch of a proposed object model they are thinking about. Put the majority of those developers in front of studio with an test fixture and they often flounder.

It is time that people started developing a different set of design skills. The skill of designing an application by 'coding in reverse'. One of the best ways I try to describe TDD when I am pairing with someone is to <strong>'code it like it's there and it has the exact API that you want to use'</strong>. Once people can take that phrase and literally apply it to a test they are writing for an object; they have crossed , IMHO , the largest learning gap on the road to effective TDD.

Do I think that design is dead? Absolutely not. TDD is first and foremost about design, not testing. It is a practice that requires discipline on the part of all the members of a development team. One of the startling revelations that people who are skeptical about TDD encounter when introduced into a team practicing it, is that the emphasis on solid design is actually much higher than other teams they have been a part of. Why? Because design is something that is happening almost every minute of every iteration. Developers working on stories are driving out the design of components one test at a time. They are driving out the communication between disparate layers in the system one test at a time. All of these 'design' artifacts brought together with the accompanying implementation code, over the course of (x) iterations result in a piece of software that has been actively designed and developed over the entire lifecycle.

At the end of the day, I no longer see any value in BDUF. Let me stress this point, '<strong>this does not mean you turn a blind eye to changes that are coming in future iteration that may (most likely will) require change</strong>'. More importantly you build the system with tests as a design tool that enable you to keep your objects following:
<ul>
<li>Single Responsibility Principle</li>
<li>HollyWood Principle</li>
<li>Dependency Inversion principle</li>
<li>.......</li></ul>

This will ensure that when change comes (<strong>and it will</strong>) the effort required to  accomodate the change will not be a negative one. And will you be able to drive out the 'design' and implementation of the change by following a set of repeatable practices that eventually will become second nature for you, if you stick with it.




