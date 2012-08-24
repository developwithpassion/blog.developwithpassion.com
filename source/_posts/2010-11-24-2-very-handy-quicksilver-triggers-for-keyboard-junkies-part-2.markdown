---
layout: post
title: "2 Very Handy Quicksilver Triggers For Keyboard Junkies - Part 2"
comments: true
date: 2010-11-24 08:00
categories: [tools]
---
In the last [post](/2010/11/2-very-handy-quicksilver-triggers-for-keyboard-junkies.html) I mentioned a quicksilver trick that could give you access to menu items and windows (these are actually one of a large set of features that you can take advantage of once you have enabled proxy objects).

Some people were having trouble getting this feature working. One thing that will ensure that it works is to download the latest version of the UIAccess plugin from [here](https://github.com/neurolepsy/blacktree-elements/downloads). Once you have downloaded it, you can install it into quicksilver. I use a simple shell script to copy all of my plugin configuration from my "devtools" repository, back into the location where quicksilver expects to find it:

> ~/Library/Application Support/Quicksilver/PlugIns

This makes it simple when I am reimaging a new machine, or when I add plugins on my laptop and want to switch back to my desktop and have the exact same setup.

Here is the directory listing for my plugins directory:

{% codeblock bash %}

Calculator Module.qsplugin
Chat Support.qsplugin
Clipboard Module.qsplugin
Command Line Tool.qsplugin
Cube Interface.qsplugin
Developer Module.qsplugin
Dictionary Module.qsplugin
Disk Image Support.qsplugin
Displays Module.qsplugin
Extra Scripts.qsplugin
File Attribute Actions.qsplugin
File Compression Module.qsplugin
File Tagging Module.qsplugin
Flashlight Interface.qsplugin
Gmail Module.qsplugin
Growl Module.qsplugin
Image Manipulation Actions.qsplugin
Menu Interface.qsplugin
Mini Interface.qsplugin
Mini-Bezel.qsplugin
Music Support.qsplugin
Path Finder Module.qsplugin
Process Manipulation Actions.qsplugin
Remote Desktop Module.qsplugin
Screen Capture Actions.qsplugin
Shelf Module.qsplugin
Slideshow Action.qsplugin
System HotKey Commands.qsplugin
Terminal Module.qsplugin
Text Manipulation Actions.qsplugin
UI Access.qsplugin
Unit Conversion Module.qsplugin
Window Interface.qsplugin
iChat Module.qsplugin
iTunes Module.qsplugin

{% endcodeblock %}

Hopefully this will help get the menu and window triggers going for you!!

[Develop With Passion®](http://www.developwithpassion.com)
