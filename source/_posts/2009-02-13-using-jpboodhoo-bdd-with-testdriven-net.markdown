---
layout: post
title: "Using jpboodhoo.bdd with TestDriven.Net"
comments: true
date: 2009-02-13 09:00
categories:
- general
---

When I announced the [slight addition](http://blog.developwithpassion.com/SlightAdditionToJpboodhoobdd.aspx) to [jpboodhoo.bdd](http://www.assembla.com/spaces/jpboodhoo_bdd) I mentioned that it worked with [TestDriven.Net](http://testdriven.net/). I just recently converted the current project I am on to use the new "it" style blocks everywhere. All of a sudden my tests were no longer being recognized by TestDriven.Net. I went to the tests for jpboodhoo.bdd and realized that I could still run them from TestDriven. I quickly realized the fix that I needed!! In my test project (for my current project) I have a folder called helpers (don't let the name scare you, this is a pure test utility folder) which contains the following class:   <div style="font-size: 14pt; background: black; color: white; font-family: consolas">   <p style="margin: 0px">[<span style="color: yellow">TestFixture</span>]    <p style="margin: 0px"><span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">emtpy_fixture_to_allow_testdriven_dot_net_to_pickup_tests</span>    <p style="margin: 0px">{    <p style="margin: 0px">} </div>  
As you can see, by having that in my test project, TD.Net can do the appropriate reflection to pick up the test. If you don't use TD.Net and were just using the MBUnit Console, or MBUnit GUI, there would not have been a problem. Instead of diving in to come up with a complicated solution, the pragmatist in me is ok having this as a file in my test projects!!   
Develop With Passion!! 




