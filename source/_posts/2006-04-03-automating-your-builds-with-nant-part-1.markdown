---
layout: post
title: "Automating Your Builds With NAnt - Part 1"
comments: true
date: 2006-04-03 09:00
categories:
- .net 2.0
- tools
---

After a couple of discussions with [Ben Scheirman](http://www.flux88.com/) . I decided that I should post some information about automating your build process using NAnt. This is the first in a 3 part post that describes my recommendations for all things related to automating your build process. I should note that this is a process that I use even if I am working on a project for myself, where no other developers are involved. Having an automated build process can streamline your development efforts dramatically. I am making the assumption that you already have a source control repository in place. Let’s take a look at a common directory structure that I use for projects:

 

<img alt="FolderStructure" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNantPart1/folderStructure.jpg" border="0">

 

This may or may not be a structure that you are familiar with. The first thing to notice is the location of the solution file (DotNetRocks.sln) with respect to all of the projects under the solution. The solution file lives right in the root of the (trunk) directory. I’ll explain as necessary the purpose of each of the folders. The first and most important thing I want to stress about this proposed build structure is this: <strong>After a fresh checkout a developer should be able to do all project related tasks with solely the contents of the combined folders.</strong>

This means, that a new developer coming onto to the team should be able to boot up their computer, do a fresh checkout, and be able to build the project without any problems. We’ll dive further into how this can be accomplished by talking about some of the core directories that are crucial to the build process.

<strong><u>The lib Folder</u></strong>

Take a look at the following screenshot that shows the contents of this particular lib folder:

<img alt="LibFolder" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNantPart1/libFolder.jpg" border="0">

Each subdirectory in the lib folder will be named after a third party library that also needs to go along with the deployed application. This could be things like a logging library (log4Net), Infragistics etc. The point is, without the files contained in these folders, the application could not be compiled or deployed. Typically, the majority of files that live in these folders are dll’s or exe’s. One key point about this folder. All project references to third party software from within the solution are made to point into folders in this directory.

<strong><u>The tools Folder</u></strong>

Take a look at a screenshot for the tools folder:

<img alt="ToolsFolder" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNantPart1/toolsFolder.jpg" border="0">

Each subdirectory in the tools folder contains utilities, libraries etc, that are essential to the building and testing of the application. A key distinction between this and the lib folder is that files in the tools folder do not get deployed with the production application. They are only necessary to facilitate the build process itself. The NAnt folder contains all of the NAnt assemblies including the NAntContrib assemblies. I will talk more about NAnt later, as it is a great tool to facilitate automating your build process. A common folder that is seen in tools directories everywhere is the nunit folder. This folder, obviously, contains all of the dll’s and exe for NUnit, which is used to write and run automated unit tests for the application.

<strong><u>The src Folder</u></strong>

The source folder obviously holds the most important artifacts for the application (the source code files). There is a slight twist to this source directory as you will see from the following screenshot:

<img alt="SrcFolder" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNantPart1/srcFolder.jpg" border="0">

All projects for the solution are stored under the respective directory. Any project that is part of the build for distribution will live under the app directory. All projects related to testing live under the test folder.

 

This would be a good place to actually talk about the solution and project hierarchy itself.

 

<strong><u>VS Solution Setup</u></strong>

The following screenshot shows what a typical solution would look like mapped to the above directory structure:

<img alt="SolutionLayout" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNantPart1/solutionLayout.jpg" border="0">

As you can see, studio flattens out the actual physical structure that the projects are mapped to. Any project with a .Test extension would live under the src\test directory. Other projects would live under the src\app directory. All references to third party libraries would point to either folders under the tools/lib folder, depending on the type of reference. Notice that almost every “app” project in this solution has an accompanying “Test” project. This is an optimal setup to allow for quick building/segragation of the test and app portions of the application. In this scenario, the only project that does not have a Test project is the Web.UI project. This is the project where all of the .aspx,.ascx files etc live. As such, and this is a topic for a later discussion, code that lives in that layer is kept to a minimum as it is difficult to test without running the application or using WATIR or alternatives.

Next up we’ll talk about building this application using NAnt.

