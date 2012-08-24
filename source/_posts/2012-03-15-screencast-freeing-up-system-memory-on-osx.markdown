---
layout: post
title: "Screencast: Freeing Up System Memory on OSX"
date: 2012-03-15 09:01
comments: true
categories: [screencasts, osx]
---

In this quick video I show you how to use the purge command to quickly free up virtual memory on your machine.

Because I run a fair amount of vms on my machine, at any point in the day I can look at my memory usage and realize that I have almost no memory availabe.

For those that don't want to watch the video (it's only 2 minutes), I start the video having almost 6.81GB inactive and only 284.7GB available (and this is a 16GB machine.)

The long and short is I run the following command:

{% codeblock Free Up Your Memory - purge_memory.sh  %}
purge
{% endcodeblock %}

After the command finished running, I had only 138.6MB of inactive memory and 9.56GB of free memory!!

Here is the video:

{% vimeo 38572779 %}

[Develop With Passion®](http://www.developwithpassion.com)
