---
layout: post
title: "Wow, the difference a single line can make!!"
comments: true
date: 2009-03-16 09:00
categories:
- c sharp
---

  
I have not changed my build script for my current project for a little while. As the project started to get bigger I started to notice a significant slowdown in building from my build script. I stopped to take a look at my script this morning and smacked my head when I saw what was going on. It read like the following:   
$result = MSBuild.exe "$base_dir\solution.sln" /t:Rebuild /p:Configuration=Debug   
A quick change to the following and it was all good:   
$result = MSBuild.exe "$base_dir\solution.sln" /t:Clean /t:Build /p:Configuration=Debug   
Micro optimization is where its at!!   
Develop With Passion!! 




