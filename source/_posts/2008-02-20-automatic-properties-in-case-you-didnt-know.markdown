---
layout: post
title: "Automatic Properties - In case you didn't know"
comments: true
date: 2008-02-20 09:00
categories:
- c sharp
---

The following snippet of code (C# 3.5) is allowable, and gives you the benefit of unnecessary extra verbosity with the benefits of encapsulation. Of course, if you need to implement logic in your property, then you don't want to think about automatic properties:  
public T Item { get; private set; } 




