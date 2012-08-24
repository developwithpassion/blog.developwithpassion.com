---
layout: post
title: "Solution Reorganizing (Again!!)"
comments: true
date: 2008-05-12 09:00
categories:
- programming
---

I just completed a reorganizing of the solution that I am currently working on. I now have only 2 projects in the solution. I use to have 3 project:  <ul>   <li>{ApplicationName} - This contained the project for the application itself, all of the logical layers lived in this project.</li>    <li>{ApplicationName}.Test - The unit tests for the Application (integration and unit)</li>    <li>{ApplicationName.Build - All of the artifacts related to managing the build process</li> </ul>  
After the reorg that just took place over the last 1 hour it is now:  <ul>   <li>{ApplicationName} - Same as before, except now each spec/specs live beside the code it is testing. </li>    <li>{ApplicationName}.Build - Same as before</li> </ul>  
Thanks to the power of ReSharper and an existing [NAnt](http://nant.sourceforge.net/) build file that I was already using to manage the project build/compilation/test ... It took me 40 minutes to do the file shuffling. ReSharper helped out with the namespace changes. 3 lines of xml added to the build script (no other changes required) and I am back in business!!  
I love [ReSharper](http://www.jetbrains.com/resharper/)!! And yes, I am running the latest nightly build (797) and it has been running amazingly. I currently have Solution Wide Error Analysis turned off, as it seems to slow things down a little.




