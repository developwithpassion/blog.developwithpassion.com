---
layout: post
title: "Running Things between multiple machines while maintaining the database"
comments: true
date: 2009-06-29 09:00
categories:
- tools
---

Since I use virtual machines very extensively (thanks [Terry](http://www.connicus.com)) it is pretty important for me to be able to drop onto a new machine and be able to launch my main VM's and be able to carry on working. I have recently moved my vm's onto an external hard drive, so I can literally jump onto a new machine install VMWare Fusion / Workstation and I'm good to go.   
Unfortunately some of the other programs that I like to install on the host os (Mac) are:   
-QuickSilver   
-Things    
-ITunes   
Up until now I had not taken the time to figure out how to get Things running between different machines. If you go to the following URL you can see how to make Things work between multiple computers:   
[Syncing Things on multiple computers](http://culturedcode.com/things/wiki/index.php?title=Syncing_Things_on_multiple_Macs_%28FAQ%29)   
Armed with this information I just copy the entire Things database onto the external drive that I place my virtual machines on:   
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/RunningThingsbetweenmultiplemachineswhil_C353/Picture%201_2.png" rel="lightbox"><img style="border-bottom: 0px; border-left: 0px; display: inline; border-top: 0px; border-right: 0px" title="Picture 1" border="0" alt="Picture 1" src="{{ site.cdn_root }}binary/WindowsLiveWriter/RunningThingsbetweenmultiplemachineswhil_C353/Picture%201_thumb.png" width="432" height="191" /></a>   
I also make sure to copy the things app onto the external hard drive so that I can quickly copy it into the applications folder on the target machine. With this configuration I can flip between my Mac Pro and MacBook Pro, having both of them using the same Things database without any issue.  
[Develop With Passion](http://www.developwithpassion.com)




