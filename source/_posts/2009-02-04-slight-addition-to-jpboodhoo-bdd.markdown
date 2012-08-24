---
layout: post
title: "Slight addition to jpboodhoo.bdd"
comments: true
date: 2009-02-04 09:00
categories:
- c sharp
---

If you recall from the [last post on this topic](http://blog.developwithpassion.com/TestExamplesWithMBUnitAndJpboodhoobdd.aspx) one of the ways you can record an observation is by simply doing this:  <div style="font-size: 14pt; background: black; color: white; font-family: consolas">   <p style="margin: 0px"> [<span style="color: yellow">Observation</span>]    <p style="margin: 0px"> <span style="color: #ff8000">public</span> <span style="color: #ff8000">void</span> should_dispose_the_appropriate_items()    <p style="margin: 0px"> {    <p style="margin: 0px"> connection.was_told_to(x => x.Dispose());    <p style="margin: 0px"> } </div>  
  
In addition to be able to define observations using traditional attributes. You can now also define observations by using blocks (like the rest of the code uses). So the following observation is identical to the one above:  <div style="font-size: 14pt; background: black; color: white; font-family: consolas">   <p style="margin: 0px"> <span style="color: #2b91af">it</span> should_dispose_the_appropriate_items = () =>    <p style="margin: 0px"> connection.was_told_to(x => x.Dispose()); </div>  
Because all of this is backed by MBUnit. You can start integrating this into your existing MbUnit test suites with no change required. MBUnit GUI, and Console pick them up with no problem. TestDriven.Net can even run them. You can mix and match traditional attribute based observations and block style observations in the same test:   <div style="font-size: 14pt; background: black; color: white; font-family: consolas">   <p style="margin: 0px"><span style="color: #2b91af">it</span> should_leverage_db_infrastructure_to_return_a_set_of_rows_from_the_db = () =>     <p style="margin: 0px"> result.should_not_be_null();    <p style="margin: 0px">    <p style="margin: 0px">[<span style="color: yellow">Observation</span>]    <p style="margin: 0px"><span style="color: #ff8000">public</span> <span style="color: #ff8000">void</span> should_dispose_the_appropriate_items()    <p style="margin: 0px">{    <p style="margin: 0px"> connection.was_told_to(x => x.Dispose());    <p style="margin: 0px">} </div>  
The only issue with TD.Net right now, is that you can’t pick a single “it” block to run in a fixture. If you put the cursor on an “it” block and tell TD.Net to run test, it will run all of the “it” blocks in that fixture. If you are using a traditional attribute based Observation block this is not a problem.  
If people are interested in how I rolled out this feature, please respond with comments and I will get another post out!!  
Develop With Passion!!




