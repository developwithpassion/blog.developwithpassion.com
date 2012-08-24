---
layout: post
title: "Update To BDDDoc"
comments: true
date: 2008-11-25 09:00
categories:
- tools
---

In the Las Vegas edition of [Nothin But .Net](http://www.developwithpassion.com/training.oo) my TA [Scott Cowan](http://sleepoverrated.com/) made some updates to [BDDDoc](http://www.assembla.com/spaces/bdddoc/trac_subversion_tool). BDDDoc is a tool I wrote that you can use to quickly generate a simple HTML report based on your test classes. Scott added an update to integrate with the test results of MbUnit (currently the tool can report against any codebase regardless of the testing framework being used). Now the report also shows coloring red/green depending on whether a given observation is passing or not. Here is a screenshot of a portion of what the new report looks like:  
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/UpdateToBDDDoc_F2B0/image_2.png" rel="lightbox"><img title="image" style="border-right: 0px; border-top: 0px; display: inline; border-left: 0px; border-bottom: 0px" height="615" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/UpdateToBDDDoc_F2B0/image_thumb.png" width="492" border="0" /></a>   
The tool currently takes advantage of my current naming style to generate natural sentences from the names of the concerns and observations.  
Develop With Passion!!




