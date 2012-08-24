---
layout: post
title: "WPF UI Automation Testing With MbUnit"
comments: true
date: 2008-01-17 09:00
categories:
- c sharp
---

I'll blog about the details of what I'm working on at a later date (if I can disclose). Needless to say. Make sure you use the TestFixture attribute as follows:<font size="4">

[</font><font color="#2b91af" size="4">TestFixture</font><font size="4">(ApartmentState = </font><font color="#2b91af" size="4">ApartmentState</font><font size="4">.STA)]</font>

<font size="4">public class When_the_tree_item_is_expanded</font>

<font size="4">{</font>

<font size="4">}</font>

This ensures that all of the tests in the fixture will run in a Single Threaded Apartment. And no putting the STAThread attribute on top of the test method won't do it!!

 

Develop with passion!!<font size="4"></font>




