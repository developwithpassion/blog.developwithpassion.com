---
layout: post
title: "(Automated Build Script + ReSharper Solution Wide Error Analysis) == The Bomb"
comments: true
date: 2007-04-30 09:00
categories:
- tools
---

Using ReSharper 3.0 for the last week and a bit has been an awesome experience. It is currently in the EAP phase, but so far it is proving to be the most solid eap of the product they have released to date (in my opinion).

Of all of the features that have been brought into the mix, I am particularly pleased with:
<ul>
<li>Solution wide error analysis</li>
<li>TODO Explorer</li>
<li>Member reordering</li></ul>

I asked for solution wide error analysis as a feature several months ago, I am pleased that other people must have also asked to ensure that it got brought into the mix.

The title of the post has to deal with the fact that coupled with the solution wide error analysis, I can now truly not need to do my compiles using studio at all. During this last week, I held another iteration of my Nothin But .Net coding bootcamp (1 10 hour day, 4 14 hour days!!). Aside from 2 times that I accidentally built in studio, the app evolved over the course of the week, and there was no need for me to use studio once to do a build.

The nice thing about the solution wide error analysis, is that I can deal with my error quicker than doing a NAnt compile, looking for the error, fixing, and repeating. I can just hit ATL-F12 to take me to the next error in the solution, fix the code, ensure that I am good to go solution wide, then I can do my build in NAant.

Cheers to the Jetbrains team for continuing to evolve a stellar product for .Net developers.

 




