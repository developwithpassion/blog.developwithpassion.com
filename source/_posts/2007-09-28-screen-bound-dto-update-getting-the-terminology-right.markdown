---
layout: post
title: "Screen Bound DTO Update (Getting the terminology right)"
comments: true
date: 2007-09-28 09:00
categories:
- patterns
- programming
---

I am going to be posting a small sample that demonstrates what I was talking about in my post describing using <strike>Screen Bound DTO's</strike> Presentation Model.

In chatting with a couple of people, they correctly fixed my terminology to use lingo that most people have already got a cursory knowledge of. So with that said, the technique that I described with regards to objects that are designed specific to the screens that they are servicing is the concept of a [Presentation Model](http://martinfowler.com/eaaDev/PresentationModel.html" target="_blank). DTO's are still in the picture with respect to the messaging that can occur between presenter and service (and vice versa). The presentation model is their to satisfy the needs of the UI, be if for databinding or other UI needs (such as coloring for rows in a grid, highlighting customers with bad credit etc).

Ok, now we are all on the same page.

 




