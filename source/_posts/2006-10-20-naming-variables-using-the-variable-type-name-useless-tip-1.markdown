---
layout: post
title: "Naming variables using the variable type name (useless tip #1)"
comments: true
date: 2006-10-20 09:00
categories:
- c sharp
---

 
I'm not sure why you would want to do this (and I may be the last person in the world who actually figured this out), in C# if you try to do something like this it will be completely invalid: 
 <pre class="code">            <span style="color: rgb(0,0,255)">public</span> <span style="color: rgb(0,0,255)">void</span> SomeMethod()
            {
                <span style="color: rgb(0,0,255)">object</span> <span style="color: rgb(0,0,255)">object</span> = <span style="color: rgb(0,0,255)">new</span> <span style="color: rgb(0,0,255)">object</span>();
            }</pre><pre class="code"> </pre><pre class="code">You can ,however, do this:</pre><pre class="code"> </pre><pre class="code">            <span style="color: rgb(0,0,255)">public</span> <span style="color: rgb(0,0,255)">void</span> SomeMethod()
            {
                <span style="color: rgb(0,0,255)">object</span> @object = <span style="color: rgb(0,0,255)">new</span> <span style="color: rgb(0,0,255)">object</span>();
                }</pre><pre class="code"> </pre><pre class="code">Notice the use of the @ symbol.</pre><pre class="code"> </pre><pre class="code">Again, I can't see any value in taking advantage of this, take care with using this feature!!!</pre>
              
              
              
              
