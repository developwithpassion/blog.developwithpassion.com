---
layout: post
title: "Credit where credit is due"
comments: true
date: 2009-03-12 09:00
categories:
- tools
---

A couple of people have been contacting telling me about how much they are enjoying using the [developwithpassion.bdd](https://www.assembla.com/wiki/show/developwithpassion_bdd) library. I just wanted to point out that the syntax for the library was completely inspired by the work I saw done in [Machine.Specifications (MSpec)](http://github.com/machine/machine.specifications/tree/master).  
My main reason for developing [developwithpassion.bdd](https://www.assembla.com/wiki/show/developwithpassion_bdd) was to have something that had the same syntax, that I could drop into my existing MbUnit projects and have them work side by side. This allowed me to take advantage of the existing unit runners (MbUnit Gui, MbUnit Console, Icarus, as well as TestDriven.Net), more importantly, it allowed me to slowly evolve my test writing style without having to revisit all of the tests that I already had in place. Of course, the library (being something that I use personally) has adopted a lot of things such as my naming conventions, as well as a fairly significant set of base classes that allow me to significantly cut down the noise in the tests/specs.  
The [Eleutian](http://blog.eleutian.com) boys did a great job with MSpec, and I just wanted to make it very publicly clear as to where this project got its inspiration!!  
Develop With Passion




