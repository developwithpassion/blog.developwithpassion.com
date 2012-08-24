---
layout: post
title: "One Of The Reasons TDD Can Be A Hard Sell"
comments: true
date: 2006-06-01 09:00
categories:
- agile
---

For readers of this blog you are no doubt aware that I am a practitioner of TDD and I have a passion for at least demonstrating its benefits to other developers. I had a great conversation with Kyle Baley and Wade Grandoni the other day, and I stressed the fact that although I believe heavily in the value of TDD, I also realize that it is just another tool that developers can 'choose' to add to their arsenal. Would I personally develop not using TDD, probably not. Do I know that before TDD came along that there were many successful projects delivered on-time and on-budget, absolutely! 

That being said, there is a reason why many developers have a hard time believing the benefits of TDD. One of the biggest issues which is often a stumbling block for many developers new/attempting TDD is the fact that it does represent a significant paradigm shift into the software development process. 'You want me to write a test for a method that doesn't exist yet on a class that doesn't exist yet??' In my opinion, this statement alone represents the reason why I believe that the shift is an even bigger one than the one many of us faced years ago - The shift from procedural coding to OO programming.

I am sure that there are few of us today who could argue against practical reasons for utilizing OO as a vehicle to compose applications. The same holds true for TDD. At first it can be something that looks so different from what you are used to that you do one of two things:
<ul>
<li>Shrug it off completely as a waste of time</li>
<li>Look into the questions popping up in your mind</li></ul>

It is the second group that can still continue to have a hard time with the process. Why? Again, remember back to when you were learning to code/think in objects? Chances are you had the help of a few good books, and mentors who had run the Object race, whom you gleaned a lot of good information/best practices from. Because TDD is still a relatively new practice for the .Net community, there is a definite shortage of experts who people can turn to for personal coaching. Now I say shortage, there are a lot of TDD practitioners and gurus out there, but not nearly as many as plain old OO gurus. Why am I mentioning this? Often in the first couple of weeks of attempting TDD on anything but a trivial project, people who are trying to do it on their own get frustrated, and sometimes it is at this point that they dismiss TDD as a waste of time and 'impractical for enterprise development'. Unfortunately, this frustration can often be a result of the fact that correctly applying TDD means having a handle on some plain old fashioned clean object thinking. A seasoned TDD developer can help walk you down the path of interface based programming. They can extol the values of dependency injection and layered architecture. All the while tying these principles back to how they relate to the TDD software development process.

Lastly, the biggest reason I think people have a hard time buying into TDD is the only time they get to see it in action is by the 'experts' who can only use it to demonstrate a 'small' piece of a larger application. I admit, I definitely fall into this category. Unfortunately what they can't see is how TDD can literally be applied to build out the functionality of enormous large scale enterprise applications. Why? They can't join you on your project on a daily basis. They can't see how just because you are using TDD that the SDLC hasn't disappeared. They can't see that in an agile environment a large part of the test code that you write is a direct result of hourly interaction with the business users, who are there helping the developers carve out the functionality. They can't see the fact that even though you are using TDD that other types of testing are not forgotten.

I am not a purist. I believe TDD is a great vehicle for delivering apps into the hands of users quicker. Do I think that a developer who doesn't use TDD is a less skilled developer. Absolutely not. One thing you can't be in this industry is dogmatic. Everyone is entitled to their own opinion. My personal opinion - I would not develop software without using a TDD approach.




