---
layout: post
title: "Build A Solid Core"
comments: true
date: 2007-04-05 09:00
categories:
- general
---

From the title I am sure that most people think that I am continuing on from the [post that Raymond gave a couple of weeks ago](http://codebetter.com/blogs/raymond.lewallen/archive/2007/03/20/Don_2700_t-just-CodeBetter_2C00_-LiveBetter-too_2100_.aspx)!!

In the realm of exercise and fitness you often hear trainers and athletes alike stressing the importance of Building A Strong Core. The benefits from working inside out are not immediately apparent, but the long term benefits quickly outweigh the rush for the 'visible' differences that can often be gained quickly by targeting satellite muscles!!

This concept of building a solid core has just as much applicability in our respective careers. For us as software developers I believe the strength of your 'core' development muscles is the single most factor that will determine how long it takes for you to GROK new techniques and concepts that come down the pipe.

As well as being a consultant, I have had the opportunity over the last couple of months to deliver an intense week of training focused around the practical application of BDD, DDD, patterns and OO. One of the points that hits most strongly home for me is the fact that many developers need to spend more time focusing on their core skill-set, as opposed to chasing after the current 'hot technology of the month'. With a solid grounding and understanding of the principles, patterns and techniques that under-pin these 'new' frameworks, you are in a better place as a developer to question the practicality and applicability of a certain technology with respect to your current development project.

So what does it mean for me to 'Build A Solid Core'? Here are some pointers that I would like to share for things that people can start doing right now to hone in on a set of skills that will serve them today, and quite possibly 10-20 years down the road in software development:

<strong><u>Get Infected about testability</u></strong>

Everyone knows that I am a big proponent of test driven development. As a design tool it is the bomb for helping me keep on track with the evolution of a software system. Channeling my efforts to take one piece of functionality at a time and develop it from the perspective of a client who wants to consume the functionality that I am building. As a design tools TDD is awesome, <strong>but it is not a testing tool. </strong>You get tests as a side effect of doing code driven design, but the tests are not complete. For people who are writing any kind of application, there is some assurance in knowing that if you have a formal test suite in place (be it Unit Tests, Acceptance Tests, Integrations tests etc) that you can make changes to the code and get quick feedback as to whether a change you made actually broke anything. This point is the first point that I am going to make that will help people 'build the solid core'. Don't be satisfied with having to manually run your application to verify that it works after every change that you make. Get into the habit of leverage a variety of automated testing frameworks that test the application from different perspectives (unit, acceptance etc). When you have automated tests in place, even something as 'harmless' as a 'trivial' refactoring becomes a non-issue, as you know things are not good until all of the test are passing again. This is a practice that people do not have to be doing TDD to realize. If more people took it upon themselves to leverage the value of automated testing for their applications, they would inevitably release software that is of much higher quality (not necessarily from a design perspective, but from the client delivery perspective).

<u><strong>Get back to basics</strong> <strong>(OO Basics That Is)</strong></u>

Develop your skills as an object oriented developer. This is often a topic that becomes a sore point for most people. When asked the question 'Do you know how to program in Objects?', the answer is almost always a resounding yes. After a bit of careful examination it often becomes evident that lots of people (not just in the MS world) are writing procedural code masquerading as objects. Just because you understand what PIE, composition, delegation etc are, does not necessarily mean you understand how to utilize these principles to build rich, clear object models. Question strongly how much you think you know about object oriented programming and set out to correct any deficiencies you may be able to identify. Pick up [Head First Design Patterns](http://www.amazon.com/Head-First-Design-Patterns/dp/0596007124) as a good refresher about what OO programming is supposed to be about.

<strong><u>Learn the GOF patterns</u></strong>

The way I see it, most good developers will often stumble onto the use of patterns without actually knowing they are named entities. The strength in patterns comes from the expressiveness that can be conveyed between team members as to ways they may think about implementing a solution. Like any new tool in a developers toolkit, it will often be abused in the beginning. This is where you will learn (over time) when and where the use of the pattern is overkill. I see greater benefit is learning how to Refactor to the pattern when necessary, as opposed to designing to use a pattern from the outset. Most people do not have the luxury of working with greenfield code-bases. They have to learn these new techniques and try to find ways to implement them pragmatically on their current projects. Being able to identity refactoring candidates, and knowing where a design pattern may benefit the health of the codebase is a far more important skill than trying to use patterns to design the 'perfect' system from the beginning!! A couple of books to pick up when you are thinking about learning design patterns are:
<ul>
<li>[Head First Design Patterns](http://www.amazon.com/Head-First-Design-Patterns/dp/0596007124)</li>
<li>[Design Patterns](http://www.amazon.com/Design-Patterns-Object-Oriented-Addison-Wesley-Professional/dp/0201633612)</li>
<li>[Applying UML and Patterns](http://www.amazon.com/Applying-UML-Patterns-Introduction-Object-Oriented/dp/0131489062/ref=pd_lpo_k2_dp_k2a_3_txt/103-5653998-1688625)</li>
<li>[Java Enterprise Design Patterns](http://www.amazon.com/Java-Enterprise-Design-Patterns-CD-ROM/dp/0471333158)</li></ul>

<strong><u>Sharpen Your Sword</u></strong>

This is the last an most important point. Don't be satisfied with building apps the way you have always done it. Force yourself to stretch your mind and look at problems in new ways. If you have built a piece of functionality the same way for the past 2 applications, sit yourself down and see if you can come up with a different solution to the same problem (just for fun). Like any skill, programming is something that gets better with a solid foundation that is continually built upon. Most of us got into software for the fun of problem solving. Once we lose the 'fun', that is when most of us settle into ruts that can be hard to get out of. A great set of exercises that developers can use to 'sharpen the sword' are the CodeKata exercises provided by Dave Thomas. What, you mean I'm going to write code that I throw away, just for fun? That is how you improve your dev mind. Doing the same thing over and over again does not make you better at that task, it just makes you more efficient. The real skill in development is being able to look at a problem, realize and identify several ways to solve the problem, and pick the one that works best in the current context.

By building upon the 3 main points above, developers will have the core they need to understand and assimilate new concepts in the development realm. As well as tackle new and emerging technologies with a lot more grounded understanding in how the technologies may actually be working under the hood.<div class="bjtags">Tags:  <a rel="tag" href="http://technorati.com/tag/Programming">Programming</a></div>




