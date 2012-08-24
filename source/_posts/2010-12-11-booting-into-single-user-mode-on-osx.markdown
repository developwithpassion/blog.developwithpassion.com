---
layout: post
title: "Booting into Single-user mode on OSX"
comments: true
date: 2010-12-11 07:00
categories: [tools, osx]
---
The other day , at the beginning of a class day, my machine decided that it was about time to remove my user account from the main login screen. Which meant that I could not log in successfully using the GUI!

I was hunting around to find a good way to launch into the shell at startup and bypass the GUI entirely. Here are the steps:

1. Restart the machine and hold down the Command and "s" keys as the system is booting up.

2. When the shell starts you will be running in an extremely minimalist environment that does not even have the book disk fully mounted.

3. Mount the root disk as follows:

  * fsck -y - Perform checking on the boot volume file system, and also attempt to correct errors.
  * mount -uw / - Mount the root volume with write access enabled.

[Develop With Passion®](http://www.developwithpassion.com)
