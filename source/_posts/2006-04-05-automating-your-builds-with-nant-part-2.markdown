---
title: "Automating Your Builds With NAnt - Part 2"
comments: true
date: 2006-04-05 09:00
categories:
- .net 2.0
- tools
---
In the [previous post](http://blog.developwithpassion.com/AutomatingYourBuildsWithNAntPart1.aspx) we covered off solution structure and physical directory structure. It’s time to move on to talk about the actual build process. What does it mean to build? A “build” means different things to different people. For me building consists of the following crucial steps:<o:p></o:p>
<ul type="disc">
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Cleaning up the results of a previous (if any) build process.<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Creating a build area (folder)<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Rebuilding databases (optional)<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Compiling all project/solution related files<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Compiling all test related projects<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Running unit tests<o:p></o:p></li></ul>

Of course there are other activities that can occur in a build process, but the ones listed above are key. Notice that the “Rebuilding databases” step is optional, as there are lots of applications that do not require the use of database engines. I’ll break the process down step by step, so you can follow along if you desire. Before we can begin putting the steps in motion we are going to make use of a tool that will allow us to automate this process. Having some form of an automated build process is the key to enhancing your productivity as a developer. Getting back to a point I keep stressing, “A Developer should be able to do a fresh checkout and be able to hit the ground running.”.  As a developer, I would much rather do a fresh checkout and run some command at the command prompt to assert that my world is set up ok. As opposed to:<o:p></o:p>
<ul type="disc">
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Checking Out<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Opening the Solution file<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Waiting for studio to load up<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">Building the solution<o:p></o:p></li>
<li class="MsoNormal" style="margin: 0in 0in 0pt;">etc,etc,etc<o:p></o:p></li></ul>

In order to automate your build process you can take advantage of [NAnt](http://nant.sourceforge.net/). NAnt is the open source, more mature, equivalent to MSBuild. Let me say that I think it is great that MS has introduced an automated build tool into the mix, and I am sure that eventually I will be able to retire NAnt and utilize it. In its current implementation, I definitely feel that NAnt is more feature rich out of the box, and a little easier to work with.<o:p></o:p>

<strong><u>Setting Up The Build File</u></strong><o:p></o:p>

A NAnt build file, just like an MSBuild file, is nothing more than an xmldocument that is interpreted and executed by the NAnt runtime. Most of my build files start with the following basic skeleton:<o:p></o:p>

<?xml version="1.0"?>
<project name="DotNetRocks" default="all"><o:p></o:p>

    <property name="debug" value="true" /><o:p></o:p>

    <target name=”all”/><o:p></o:p>

</project><o:p></o:p>

That’s it. This is the start of your build file. All these couple of lines of XML are telling NAnt is that this build file represents the project named “DotNetRocks” and that there is a global property called “debug” that has its value set to true. Most important is the “default” attribute. This attribute tells NAnt that the default target to execute is the “all” target. What is a target? More on that later. Think of properties defined at the top of the build file as variables that can be accessed (using the ${propertyName} syntax) during the build process.<o:p></o:p>

So far this build file does not do much of anything, let’s take care of the first item on the build to-do list.<o:p></o:p>

<strong><u>Cleaning up the results of a previous (if any) build process</u></strong>

Now of course, there are currently no unwanted artifacts to clean up, as I have not even completed a successful build yet. Don’t worry about that. The first thing you need to decide is where you want all of your build artifacts to go. When I say build artifacts, I am talking about dll’s, exe’s etc that result from compiling your projects. The following screenshot shows how I will augment my directory structure to support the build process:<o:p></o:p>

<v:shapetype id="_x0000_t75" stroked="f" filled="f" path="m@4@5l@4@11@9@11@9@5xe" o:preferrelative="t" o:spt="75" coordsize="21600,21600"><v:stroke joinstyle="miter"></v:stroke><v:formulas><v:f eqn="if lineDrawn pixelLineWidth 0"></v:f><v:f eqn="sum @0 1 0"></v:f><v:f eqn="sum 0 0 @1"></v:f><v:f eqn="prod @2 1 2"></v:f><v:f eqn="prod @3 21600 pixelWidth"></v:f><v:f eqn="prod @3 21600 pixelHeight"></v:f><v:f eqn="sum @0 0 1"></v:f><v:f eqn="prod @6 1 2"></v:f><v:f eqn="prod @7 21600 pixelWidth"></v:f><v:f eqn="sum @8 21600 0"></v:f><v:f eqn="prod @7 21600 pixelHeight"></v:f><v:f eqn="sum @10 21600 0"></v:f></v:formulas><v:path o:connecttype="rect" gradientshapeok="t" o:extrusionok="f"></v:path><o:lock aspectratio="t" v:ext="edit"></o:lock></v:shapetype><o:p><img alt="BuildDirectory" src="http://www.developwithpassion.com/buildDirectory.jpg" border="0"></o:p>

There is one important thing you should realize about the “build” directory. It is <strong>created</strong> by the build process and is a completely transient directory. It exists solely for facilitating the placement of files and artifacts related to building and testing the project. As a side note, this directory would also not be under source control. Which means you would have to make sure that it is “ignored” from checkins/commits. The main executable unit for NAnt files is the <target> element. You can think of <targets> as subroutines that can be invoked to perform a series of tasks. Let’s change our build file to clean/recreate the build directory:<o:p></o:p>

<?xml version="1.0"?>
<project name="DotNetRocks" default="all"><o:p></o:p>

    <property name="debug" value="true" /><o:p></o:p>

    <target name=”all”/>    <o:p></o:p>

<strong>   <target name="clean" description="remove all build products"></strong><b>
<strong>        <delete dir="build"  if="${directory::exists('build')}" /></strong>
<strong>    </target></strong></b><o:p></o:p>

</project><o:p></o:p>

Notice that the target element has attributes such as “description” that can be used to provide descriptive information about the targets contained in the build file. What about the nested element? The <delete> element is one of many NAnt [tasks ](http://nant.sourceforge.net/release/latest/help/tasks/) that can be composed within targets to provide the functionality contained within a target. Here I am using a conditional to tell NAnt to delete the build directory if it already exists. Within a NAnt build file, unless explicitly stated, all directory references are relative to the location of the build file itself. Which means when I tell NAnt to delete the ‘build’ directory, it will attempt to delete a subfolder named build in the folder where the build file itself is contained. I am not going to dive in depth into the ins and outs of each of the NAnt tasks, as the task [documentation](http://nant.sourceforge.net/release/latest/help/tasks/) provides lots of good information that you can use. As long as you can read/write xml, you should be set!!<o:p></o:p>

<strong><u>Creating a build area</u></strong><o:p></o:p>

Ok, I’ve ensured that a build directory does not exist, so now I want to create one that will be used in the build process. I do this by adding the following to the build file:<o:p></o:p>

<?xml version="1.0"?>
<project name="DotNetRocks" default="all"><o:p></o:p>

    <property name="debug" value="true" /><o:p></o:p>

   <target name=”all”/> <o:p></o:p>

   <strong><target name="clean" description="remove all build products"></strong><b>
<strong>        <delete dir="build"  if="${directory::exists('build')}" /></strong>
<strong>    </target></strong></b><o:p></o:p>

    <strong><target name="init"></strong><b>
<strong>        <mkdir dir="build" /></strong>
<strong>    </target></strong></b><o:p></o:p>

</project><o:p></o:p>

Again, here I am making use of the mkdir task provided by NAnt to create a subdirectory named build in the directory where the build file is located. Ok, I now have a NAnt file with three targets that know nothing about each other. Of course, all this XML means nothing if I can’t actually run something that will make use of it. Let me take a quick time-out to talk about utilizing NAnt to execute targets in the build file.<o:p></o:p>

<strong><u>Running NAnt</u></strong><o:p></o:p>

The advantage of having everything related to your build process in one directory (the trunk) means that performing build tasks becomes much simpler. Remember back to where NAnt would actually live in my proposed directory layout:<o:p></o:p>

<o:p><img alt="ToolsDirectory" src="http://www.developwithpassion.com/toolsDirectory.jpg" border="0"></o:p>

Remember, NAnt is just an executable with a bunch of supporting dll’s. To run it I have to run the exe file. Because I typically run NAnt from the command line on my local machine, it would be a bit of a pain to have to open up the command prompt and execute NAnt for my build file using the following command line:<o:p></o:p>

<strong>Tools\nant\bin\NAnt.exe -buildfile:dotnetrocks.build all</strong><o:p></o:p>

The arguments tell NAnt that the build file to run is the dotnetrocks.build file and that the <strong>all </strong>target should be executed. Again, this would be a pain to have to type every time, so let’s make use of a good old trusted pal. The bat file!! Create a file called build.bat that will live in the same directory as your build file. The contents of the bat file are as follows:<o:p></o:p>

@echo off
cls
Tools\nant\bin\NAnt.exe -buildfile:dotnetrocks.build %*<o:p></o:p>

The most important aspect of this bat file is that it allows us to execute it and pass in extra arguments to be interpreted by the build file (using the %*). So, if I wanted to execute the <strong>clean</strong> target that exists in my build file, I would just have to open up a command prompt and navigate to the directory my build file is located (use [Command Prompt Here](http://download.microsoft.com/download/whistler/Install/2/WXP/EN-US/CmdHerePowertoySetup.exe) for convenience) and run the command – <strong>build clean, </strong>which would result in the following console output:<o:p></o:p>

<span style="font-family: 'Lucida Console';">NAnt 0.85 (Build 0.85.2139.0; nightly; 11/9/2005)
Copyright (C) 2001-2005 Gerry Shaw
</span><a href="http://nant.sourceforge.net/"><span style="font-family: 'Lucida Console';">http://nant.sourceforge.net</span></a><o:p></o:p>

<span style="font-family: 'Lucida Console';">Buildfile: </span><a href="http://www.developwithpassion.com/dotnetrocks.build"><span style="font-family: 'Lucida Console';">http://www.developwithpassion.com/dotnetrocks.build</span></a>
<span style="font-family: 'Lucida Console';">Target framework: Microsoft .NET Framework 2.0
Target(s) specified: clean</span><o:p></o:p>

<span style="font-family: 'Lucida Console';">     [echo] Loading local.properties.xml</span><o:p></o:p>

<span style="font-family: 'Lucida Console';">clean:</span><o:p></o:p>


<span style="font-family: 'Lucida Console';">BUILD SUCCEEDED</span><o:p></o:p>

<span style="font-family: 'Lucida Console';">Total time: 0.2 seconds.</span><o:p></o:p>


<span style="font-family: 'Lucida Console';">D:\Development\dotnetrocks\2006\testDrivenDevelopment></span><o:p></o:p>

With this setup in place I can quickly execute any of the targets in my build file with ease. Ok, I am quickly seeing that all of this information is probably going to be too much for this one blog post, so I will span this over a couple of more entries. Tomorrow we’ll pick up the process by compiling the application and linking targets!!<o:p></o:p>
<p class="MsoNormal" style="margin: 0in 0in 0pt;"><o:p> </o:p>
