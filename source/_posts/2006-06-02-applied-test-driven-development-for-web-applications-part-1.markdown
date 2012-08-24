---
layout: post
title: "Applied Test Driven Development For Web Applications - Part 1"
comments: true
date: 2006-06-02 09:00
categories:
- .net 2.0
- agile
- c sharp
- patterns
- vs2005
---

I have been promising for a long time to start a series that details the creation of a project similar to the one that I presented on my first set of DNRTv episodes. Here is the beginning of that promise!! The goals of this series is to develop a highly testable web application that demonstrates a lot of the principles that can be utilised when developing a web (or any) application using Test Driven Development. I have chosen to base the examples around the new AdventureWorks database. Why AdventureWorks you may ask? Since it is the successor to Northwind, you are going to see (or already have) many examples/demos that utilise it as a DB. It stands to reason that a lot of the techniques and approaches that I am going to show you, will be counter to what is in the mainstream MS world right now. This is not a bad thing, it is always good to open your eyes to new ways to accomplish tasks!!

In this episode, I am just going to start by discussing solution structure for the project as well as the building of the database. This is by no means meant to be an introduction to NAnt, if you want to see how NAnt can be utilised as build tool for your projects then read my [NAnt Start Series](http://blog.developwithpassion.com/NAntStarterSeries.aspx). Download [this zip file]({{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/adventureworks.zip) and you will be able to start off at the same point that I am starting at. Drop the zip file in a folder you typically do your development and unzip it to that location:

<a href="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/Unzipping.jpg" rel="lightbox[appliedTestDrivenDevelopmentForWebApplicationsPart1]"><img alt="Unzipping" src="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/Unzipping_thumb1.jpg" border="0" / /></a>

 

Once you have extracted the contents of the build file there should now be a directory named adventureworks.

<a href="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/UnzippedFolder.jpg" rel="lightbox[appliedTestDrivenDevelopmentForWebApplicationsPart1]"><img alt="UnzippedFolder" src="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/UnzippedFolder_small.jpg" border="0" / /></a>

The first thing you will need to do is go into the adventureworks directory (from this point referred to as the trunk) and copy the local.properties.xml.template file to a file named local.properties.xml (don't delete the local.properties.xml.template file):

<a href="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/LocalProperties.jpg" rel="lightbox[appliedTestDrivenDevelopmentForWebApplicationsPart1]"><img alt="LocalProperties" src="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/LocalProperties_small.jpg" border="0" / /></a>

With that taken care of, you will need to go in and edit the local.properties.xml file (not the template) and change any settings that may be specific to your machine:

<?xml version="1.0"?>
<properties>
 <property name="sqlToolsFolder" value="C:\Program Files\Microsoft SQL Server\90\Tools\Binn"/>
 <property name="osql.ConnectionString" value="-E"/>
 <property name="initial.catalog" value="AdventureWorks"/>
 <property name="config.ConnectionString" value="data source=(local);Integrated Security=SSPI;Initial Catalog=${initial.catalog}"/> 
 <strong><property name="database.path" value="C:\root\development\databases" />
</strong> <property name="osql.exe"  value="${sqlToolsFolder}\osql.exe" />
</properties>

Pay special attention to the database.path property. You can change the value to point to a different directory on your machine. Make sure that the folder exists, as the build process does not create this folder for you (it could, but I chose not to). Another setting that might vary on your machine is the osql.ConnectionString property. This is basically the connection parameters that you would need to specify if you used OSQL from the command line. For me, I use integrated windows authentication so I can just use the -E switch. You will have to experiment with your settings (you might even need to specify a server name etc).

Once you have changed the properties you can open up a command prompt pointing to your trunk directory. From the command line run the command 'build run'. If all of your settings are configured properly (and you have a local instance of IIS), you should see a blank web page pop up in your browser:

<a href="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/DefaultASPX.jpg" rel="lightbox[appliedTestDrivenDevelopmentForWebApplicationsPart1]"><img alt="DefaultASPX" src="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/DefaultASPX_small.jpg" border="0" / /></a>

Last but not least, once you have closed down the browser, you can run the following command from the command line 'build builddb'. This will copy the adventureworks database files located in the [trunk]\sql\original directory and place them in the directory that you specified in the 'database.path' property of your local configuration file. It will also run a sp_attach_db command and it will name the database using the name you provided in the 'initial.catalog' property of your local configuration file. 

I have explicitly chosen not to build the DB from scripts, why? I had a hard time finding any original SQL scripts for the AVWorks. If anyone feels like taking the time to create script files that we can use (as well as the accompanying seed data) please let me know.

The main build targets that we will be using during the course of these walkthroughs are 'build test' and 'build run'. 

Let's take a quick look at the initial solution structure (double click on the AdventureWorks.sln file, this is a VS2005 projects):

<a href="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/InitialSolution.jpg" rel="lightbox[appliedTestDrivenDevelopmentForWebApplicationsPart1]"><img alt="InitialSolution" src="{{ site.cdn_root }}binary/appliedTestDrivenDevelopmentForWebApplicationsPart1/InitialSolution_thumb.jpg" border="0" / /></a>

So far we have a Web project, a Presentation project, and a Presentation.Test project. Pretty standard fare. Right now the 2 classes that are in each of the Presentation, and Presentation.Test project are just there so the 'build test' target in the build file will execute properly. We will replace both of those classes with meaningful classes next week.

Ok, we are ready to start. Take a look around (there's nothing much to see right now), read my [NAnt Starter Series](http://blog.developwithpassion.com/NAntStarterSeries.aspx) if you have'nt already. And <strong>most important, </strong>submit requests for what you would like to see in this project. Keep in mind that I am going to try and use it as a vehicle to teach both TDD and good development practices (design patterns, refactoring etc, OO). Next week I will start by building a screen similar to the one that I created for DNRTv, once I have gotten completely through that example we will have a fairly good ground from which to branch out from. I have already talked to a handful of people and have a good idea of what they would like to see demonstrated. If you have'nt got your request in, now is the time to do it. If you can't comment on this blog post email me directly at [bitwisejp@gmail.com](mailto:bitwisejp@gmail.com). 

Here are some ideas to get you thinking:
<ul>
<li>Manageable Databinding</li>
<li>Passing information between pages</li>
<li>Master/Detail pages</li>
<li>Managing master pages better</li>
<li>Ajax</li>
<li>Layered Architecture</li>
<li>Validation</li></ul>

 

Let the coding begin (almost!!).






