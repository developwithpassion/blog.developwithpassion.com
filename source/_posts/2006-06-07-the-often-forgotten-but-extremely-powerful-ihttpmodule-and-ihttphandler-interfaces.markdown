---
layout: post
title: "The often forgotten, but extremely powerful IHttpModule and IHttpHandler interfaces"
comments: true
date: 2006-06-07 09:00
categories:
- .net 2.0
- c sharp
---

As cool as some of the new features in ASP.Net are, there are some simple interfaces that can open a door to a boatload of functionality for your web applications. I am talking specifically about the IHttpModule and IHttpHandler interfaces. Lots of developers are aware of the interesting problems that you can solve (cleanly) by taking advantage of these interfaces. Lots, however, are still in the mindset that to add new pieces of functionality that an .aspx / .ascx file has to be involved in the picture somewhere. This is just not the case. I am not going to rehash information that is already out there for consumption. Instead I will direct you to the site of [James Kovacs](http://www.jameskovacs.com/blog/), who has just published a great writeup on using an [IHttpModule implementation for dealing with Site Availability issues](http://www.jameskovacs.com/blog/InDepthLookAtTheSiteAvailabilityModule.aspx). 

If you are not familiar with these interfaces, read the [article](http://www.jameskovacs.com/blog/InDepthLookAtTheSiteAvailabilityModule.aspx) (along with his article on the [ImpostorHttpModule](http://www.jameskovacs.com/blog/PullingBackTheCoversOnImpostorHttpModule.aspx)), and start thinking of ways you can use these interfaces in your application. Some examples that I have used in the past are:
<ul>
<li>IHttpHandler implementation that watermarks all images in the application with a company logo</li>
<li>IHttpHandler implementation for doing 2 step transform/view implementation without the need for an aspx page</li>
<li>Pre 2.0, IHttpHandler for securing non asp.net releated web resources</li>
<li>IHttpModule implementation for creating strongly typed payload objects and attaching them to the executing request</li>
<li>IHttpModule implementation for custom authorization</li>
<li>IHttpHandler implementation for retrieving images from a database</li></ul>

Just think of the things you could do!!

 




