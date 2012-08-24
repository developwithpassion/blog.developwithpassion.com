---
layout: post
title: "Who Said Being Passive Was A Bad Thing?"
comments: true
date: 2006-10-08 09:00
categories:
- .net 2.0
- patterns
---

I have had a couple of questions over the last couple of weeks as to which flavour of Model-View-Presenter I am partial to. In regards to the recent split of the pattern that Martin Fowler has established, I am a big proponent of the Passive View variant of the pattern. The Passive View approach allows me to push even more code down into the presenter, as it is now directly responsible for responding to events on the view. In the example that I have given in the past, I show how the view is responsible for invoking a method on the presenter whenever something needs to be done. In practice, I expose events on the interface for the view, that the view is responsible for raising. For example, when the a save button is clicked on the view, I can have the view raise a save event. The Save event is handled by an event handler on the presenter, which can then invoke the appropriate functionality within itself. This frees the view from needing to know which method to call on the presenter when something needs to be done. 
With regards to the different flavours of MVP, they all have pros and cons. You will also find that many people were already using the Passive View approach, before it even received its own name!!




