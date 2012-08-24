---
layout: post
title: "Directory Structure For Projects"
comments: true
date: 2007-10-01 09:00
categories:
- agile
- general
---

That last part in the title is to indicate that for me, this is something that has changed several times over the past year with a change happening even within the last month.

Let me stress the fact that I am a big automated build junkie, and am not really even a fan of compiling from within studio. To that end I do the majority of my work using studio + ReSharper as the editor, and NAnt (currently) as the compile/test tool coupled with FinalBuilder as my deployment tool.

Here is a snapshot of a root directory of one of my current projects:


<img alt="" src="{{ site.cdn_root }}binary/2007/september/27/directoryStructureForProjects/directoryStructure.png" border="0" />

Let's break each of these items down so that there is a bit of explanation behind each one. Don't worry about the .svn folder or the folders with underscores in front of them.

<u>The <strong>config</strong> dir</u>

This directory contains all of the files related to the configuration of the application. Things that I typically put in this directory are:
<ul>
<li>app.config file template (if you are not sure of the concept of file templates check out my NAnt starter [series](http://blog.developwithpassion.com/NAntStarterSeries.aspx" target="_blank)).</li>
<li>NHibernate mapping files (typically placed in a folder called mapping)</li>
<li>Log4Net config file template</li>
<li>Boo file template to configure Windsor</li></ul>

<u>The <strong>docs </strong>dir</u>

This directory should be fairly self explanatory, as it contains documentation artifacts related to the project. These can be things like stories, diagrams etc.

<u>The <strong>lib </strong>dir</u>

This directory contains all of the third party libraries that <strong>will need to be deployed to the client/server machine.</strong> Keep in mind that 3rd party libraries could also be app specific versions of in house libraries that you share between projects.

<u>The <strong>src </strong>dir</u>

This directory contains all of the code related artifacts that belong to the project. This application usually consists of the following 2 root directories:
<ul>
<li>app - Contains all of the code that will be compilable units that get deployed to production.</li></ul>

 
<ul>
<li>test - Contains all of the code that is related to testing the code that will get deployed.</li></ul>

I often break the test directory down into different subdirectories to clearly identify the types of tests that are contained:
<ul>
<li>unit</li>
<li>integration</li>
<li>ui</li></ul>

The src directory is organized in this structure so that I can quickly choose to ignore/include files that I want when I am compiling for either test or deployment.

<u>The <strong>tools </strong>dir</u>

This directory contains all of the supporting third party libraries that are there to serve the purposes of build automation, testing etc. Libraries that you might expect to find in here are:
<ul>
<li>NAnt</li>
<li>MBUnit/NUnit</li>
<li>NCover</li>
<li>NCoverExplorer</li>
<li>RhinoMocks</li></ul>

These libraries are essential during the build process, but they do not need to be present on the deployment machine as they are there to support the needs of automating and testing the application.

<u>The <strong>local.properties.xml </strong>file</u>

This file is there to account for the differences in individual machine configurations without cluttering the build file with knowledge of each specific developers machine in a team environment. Machine specific settings are kept in this file that each developer maintains their own copy of, and the settings in the file get leveraged during the build process to carry out the build automation tasks on each developers machine.

You will also note, that in the above diagram, I place my solution file right at the root so that it is quickly accessible and can be opened right from the checkout unit.

As you can imagine this physical folder structure does not correlate to what you would see in studio, as unfortunately, studio comes up with its own way to view your world.

In a latter post I'll talk about how I have abandoned the notion of multiple projects inside of studio, in place of trusting developers to follow correct layer separation. This can be done, because once you stop using Studio as your build engine, a world of possibilities open up to how you go about laying out the physical code in your code base.

<strong><u>Why</u></strong>

The purpose for having this structure that I have outlined above is to have a completely atomic unit for your project. The goal being that someone new to the team, with a fresh install of the .Net framework (not even studio), should be able to check out the above project, make the appropriate machine specific changes to the local.properties.xml file, and run build.bat to compile and test the application. One of the directories that you don't see in the image above, that is usually present on other apps that I write is the <strong>sql </strong>directory. As you can imagine, this directory contains all of the sql artifacts related to the project. Again, if a new developer checks out for the first time and tries to build/test, if there are databases to be created, they will be created, and then the code will compile and test.

Again, once you introduce the concept of build automation whether it be with NAnt, Rake etc, it opens the door and your mind to different possibilities with regards to how you go about laying out your project. No longer is your deployment model constrained to how you build your x number of projects in studio. You could have one physical project with 15 different folders that convey different namespaces/layers of the application (which you would originally have been using separate projects for) and you could choose in your build script to compile folders 1 - 5 into one assembly 6 -8 into another assembly etc. It is completely up to you.

There are so many other things that you can do when you start using this type of structure.




