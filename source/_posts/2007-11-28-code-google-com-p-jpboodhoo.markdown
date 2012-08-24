---
layout: post
title: "code.google.com/p/jpboodhoo!!!"
comments: true
date: 2007-11-28 09:00
categories:
- .net 2.0
- .net 3.0
- agile
- c sharp
- continuous integration
- patterns
- programming
- tools
---

I finally set up a [googlecode project ](http://code.google.com/p/jpboodhoo/)to host source code for the various things I have been doing over the last year. The first major significant contribution is of course the code drop that I promised a week ago now!!

The application is the start of what I hope will evolve to be a great learning resource for lots of things related to .Net development. The application does not currently cover any of the 'extra' topics that I did not have time to get covered in the course. This is perfect because as request come in from people (including past students) asking how to tackle a certain problem, I will use this application as the demonstration area where I can tackle the problem, and update the code base, and you will be able to update your local copy and carry on.

I am currently in the midst of a large Smart Client application that I am hoping to be able to harvest pieces of code out and do the exact same thing except for the smart client realm. I have much more experience developing in the smart client realm and that is where I feel most comfortable, so I am looking forward to be able to do another code drop (for a different application) in a couple of months.

I am going to write up another post about the Web Application as it is built very differently from traditional .Net based web applications. In following with the theme for my courses, there are currently no 3<sup>rd</sup> party frameworks (other than log4net) that have come into play. My goal with this web app is to demonstrate to people how far we can push raw .Net. The goal being that expanding their knowledge of how to creatively leverage .Net, they will be better prepared to jump into frameworks that they may currently feel daunted by. As time goes by, I will swap pieces of the application out with components that people are asking to see meaningful samples on:
<ul>
<li>NHibernate</li>
<li>Castle</li>
<li>Prototype</li>
<li>JQuery</li>
<li>..*</li></ul>

As the app stands right now I see it as the beginning of what will shape up to be a pretty mean machine!!

I am going to post a screencast that will show people how to get started working with the web application. For people who are eager to get going right now, here are the quick and simple steps without a lot of explanation (that will come in the next post):
<ul>
<li>Anonymously checkout the trunk from the google code repository using the following svn command line:
svn checkout [http://jpboodhoo.googlecode.com/svn/trunk/](http://jpboodhoo.googlecode.com/svn/trunk/) jpboodhoo-read-only
</li>
<li>Navigate to the checkout folder</li>
<li>Go into the build folder</li>
<li>Copy local.properties.xml.template and paste it into the same directory, then rename the copied file to local.properties.xml</li>
<li>Open up the local.properties.xml file with your favourite text editor.</li>
<li>Modify any of the settings in the file that are different on your machine.</li>
<li>Open up a command prompt and navigate to the build directory of the code.</li>
<li>type: build load.data and hit enter.</li>
<li>type: build test.all.woc</li>
<li>type: build run</li>
<li>The last task should fail (I haven't automated everything yet)</li>
<li>Create a virtual directory called nothinbutdotnetstore that points at the following location (this location is created after you attempt to run the build run task) : ${checkoutfolder)\build\deploy\web\app</li>
<li>After successfully creating the virtual directory try the build run task again.</li>
<li>If the web browser pops up pointed at a web page (for the app) you are in business. Feel free to click through the first set of pages that are implemented (only 3 pages are currently implemented).</li></ul>

As far as what I have planned to implement in the web app (that is currently not implemented):
<ul>
<li>Build out a more extensive domain model that encompasses some more advanced scenarios of the application (especially around order processing).</li>
<li>Unit Of Work for the service layer</li>
<li>Implement a lightweight OR/M layer</li>
<li>Integrate some UI frameworks like prototype</li>
<li>Eliminate Master Pages completely and switch to a much more elegant template view pattern.</li>
<li>Introduce a more robust container (as the current one is a simple dictionary wired up in a simple procedural fashion).</li>
<li>Introduce the concepts of lifecycles for the items in the container. Right now, everything wired into the container is essentially a singleton.</li>
<li>Introduce CSS based layout for the web pages (working with a designer on this one).</li>
<li>Bring security concerns into play</li>
<li>Demonstrate how to effectively manage sessions</li>
<li>......lots,lots,lots more!!!</li></ul>

Obviously I will be leaning on people checking out the code and playing around with it and submitting requests for things they would like to see.

There are a couple of things that you will immediately notice about the application:
<ul>
<li>Clean front controller implementation with ASPX pages as the template views. There are no code behind pages in this web application. All web requests are handled by command objects that interact with the service layer, push the details into a 'ViewBag' and then choose which view to render.</li>
<li>Logical layers in the project are separated using simple folders and namespaces (not full blown projects)</li>
<li>Build automation is its own project in the solution (props to Jay Flowers for this inspiration)</li>
<li>The current container implements (CustomDependencyContainer) is very simple and is handled by a big procedural application startup task.</li>
<li>Compile time support for the database layer. A couple of classes ago I introduced the concept of a generic TableColumn<T> type. In England after introducing this concept [Scott Cowan](http://www.sleepoverrated.com/) leveraged his knowledge of MyGeneration to automatically generate strongly typed table definitions that we could leverage to do mapping (trust me when I say, this is nothing like datasets). Until moving into OR/M concepts deeper this gives a good place to start as the generation of the TableDefinitions is linked to whenever the SQL files change, so you will get compile errors if column types are now mismatched etc...</li></ul>

There are lots of other things I could talk about, but this code really is the start of what I see being a long running conversation between myself and other people wanting to learn. In all honesty for all of the emails I have not paid attention to this year, hosting code through google will allow me to answer peoples questions in a much more meaningful way as I can point them at this site to see the implementation of the code they had questions about.

I am going to be placing all of the code for presentations that I have done for the last year as well as continue to update it with the source code that comes out of new courses that will be coming out in the new year, and the DNRTv episodes.

Once again, the application is currently in its infancy, but as people start sending in the requests I now will have a venue and example to add upon to answer questions in a much more timely fashion!!!

 

Develop With Passion!!!

 

 




