---
layout: post
title: "Closing an anonymous method to a known delegate type"
comments: true
date: 2009-07-28 09:00
categories:
- c sharp
---

If you are using extension methods as a way to achieve more language oriented programming, there are lots of times you will want to be able to run extension methods against an anonymous method, but you will first have to close it to a well known delegate type before it is allowed. Here is a useful method if you want the starting point to be an anonymous method created on the fly:  <div style="font-family: consolas; background: black; color: white; font-size: 14pt">   <p style="margin: 0px"> <span style="color: #ff8000">public</span> <span style="color: #ff8000">class</span> <span style="color: yellow">CreateDelegate</span>    <p style="margin: 0px"> {    <p style="margin: 0px"> <span style="color: #ff8000">public</span> <span style="color: #ff8000">static</span> DelegateType of<DelegateType>(DelegateType body) {    <p style="margin: 0px"> <span style="color: #ff8000">return</span> body;    <p style="margin: 0px"> }     <p style="margin: 0px"> } </div>  
  
[Develop With Passion](http://www.developwithpassion.com)!




