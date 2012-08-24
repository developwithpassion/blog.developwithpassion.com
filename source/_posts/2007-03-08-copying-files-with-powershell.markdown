---
layout: post
title: "Copying files with Powershell"
comments: true
date: 2007-03-08 09:00
categories:
- tools
---

For those of you getting started with powershell here is a simple example for you to cut your teeth on, file copying. 
I had to quickly copy some assemblies out of the gac to another location, specifically I had to copy all of the Assemblies for ActiveReports into a single directory. If you take a look at the GAC from the command line, you will notice there is a bit of a tree there. To make it simple I wrote this quick powershell script to do the heavy lifting for me : 
<strong>get-childitem C:\windows\assembly\gac * -Recurse -Include act*.dll | foreach-object -process{copy-item $_FullName - destination O:\efc}</strong> 
Notice how I am piping the results of the get-childitem cmdlet into the foreach-object cmdlet, the most powerful thing is that I am piping around objects, not simple strings, I love it!! 
I know there are ways to do this using the plain old command promtp, but it gives me another reason to sharpen my Powershell skills. If you have not started playing with Powershell, I encourage you to give it a try.




