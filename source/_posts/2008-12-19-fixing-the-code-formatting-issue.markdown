---
layout: post
title: "Fixing the Code Formatting Issue"
comments: true
date: 2008-12-19 09:00
categories:
- general
---

After the many emails about the code formatting issues with feed readers. Here is my attempt to get it resolved.  
Please get back to me with comments, if this fixes it (or if it doesn’t):  <div style="font-size: 14pt; background: white; color: black; font-family: consolas">   <p style="margin: 0px"> <span style="color: blue">static</span> <span style="color: blue">public</span> <span style="color: blue">void</span> should_not_contain<T>(<span style="color: blue">this</span> <span style="color: #2b91af">IEnumerable</span><T> items, <span style="color: blue">params</span> T[] items_that_should_not_be_found)    <p style="margin: 0px"> {    <p style="margin: 0px"> <span style="color: blue">var</span> list = <span style="color: blue">new</span> <span style="color: #2b91af">List</span><T>(items);    <p style="margin: 0px"> <span style="color: blue">foreach</span> (<span style="color: blue">var</span> item <span style="color: blue">in</span> items_that_should_not_be_found) <span style="color: #2b91af">Assert</span>.IsFalse(list.Contains(item));    <p style="margin: 0px"> } </div>




