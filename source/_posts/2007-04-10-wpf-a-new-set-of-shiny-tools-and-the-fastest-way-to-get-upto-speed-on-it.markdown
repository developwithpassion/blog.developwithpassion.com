---
layout: post
title: "WPF - A New Set Of Shiny Tools (and the fastest way to get upto speed on it!!)"
comments: true
date: 2007-04-10 09:00
categories:
- .net 3.0
---

For those of you who have not started looking into WPF, time to start!! Even if you don't care about the flash and jazz of the UI bits, there are pieces in there that you might want to think about leveraging in your own applications right now. One of the things that is immediately apparent to me is the evident design work that went into the development of WPF. Some of the things I have had a chance to play with that have stuck me are:
<ul>
<li>Logical and Visual Trees</li>
<li>Dependency Properties</li>
<li>Routed Events</li>
<li>ICommand interface (finally I can stop rolling my own!!)</li>
<li>First class command pattern support for common UI widgets</li>
<li>Even though I am not a fan of databinding, some of the enhancements that have been brought to the table are pretty impressive:</li>
<ul>
<li>CompositeCollections</li>
<li>MultiBindings</li>
<li>PriorityBindings (again, finally I can stop rolling my own!!)</li></ul>
<li>ValidationRules and ValidationResults (again,.. you get the point)!!</li>
<li>Retained-mode graphics system!!</li>
<li>Animation</li></ul>

I could carry on, but I think you get the point. As a developer who errs to the side of writing custom explicit code to make the UI more maintainable, WPF brings to the table a host of features that I can leverage to mix the declarative nature of XAML, with the explicitness of writing clean well-factored code that leverages proper separation of responsibilities while also taking advantage of not needing to hand roll so much stuff that I had to do with prior versions of .Net.

If you want to get upto speed quickly on what WPF can do for you, I recommend rushing to pick up a copy of the book [Windows Presentation Foundation Unleashed](http://www.amazon.com/gp/product/0672328917/) by [Adam Nathan](http://blogs.msdn.com/adam_nathan/). The book is an awesome read, and it gives you a solid grounding in all of the root concepts that you need to GROK to utilize WPF in a practical fashion.

 




