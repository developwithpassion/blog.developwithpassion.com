---
layout: post
title: "RubyMine on Windows 7"
comments: true
date: 2009-07-01 09:00
categories:
- ruby
- tools
---

Since I moved everything over to Windows 7 the last program that I had not yet installed was [RubyMine](http://www.jetbrains.com/ruby/index.html) ([JetBrains](http://www.jetbrains.com) awesome IDE for Ruby coders). After I completed my installation I fired up the program and was presented with a great exception dialog:  
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/RubyMineonWindows7_D3EA/image_2.png" rel="lightbox"><img style="border-right-width: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" title="image" border="0" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/RubyMineonWindows7_D3EA/image_thumb.png" width="702" height="129" /></a>  
A quick search proved that the issue is with some settings in the idea properties file:   
# path to IDEA config folder. Make sure you're using forward slashes    
idea.config.path=${user.home}/.RubyMine10/config   
# path to IDEA system folder. Make sure you're using forward slashes    
idea.system.path=${user.home}/.RubyMine10/system   
# path to user installed plugins folder. Make sure you're using forward slashes    
idea.plugins.path=${user.home}/.RubyMine10/config/plugins     
(on my system in : C:\Users\Jean-Paul Boodhoo\.RubyMine10   
More specifically, RubyMine was not able to write to those folders as they were marked as readonly after install. I quickly changed the folder permissions and RubyMine was able to start up with no problems.   
[Develop With Passion](http://www.developwithpassion.com)!!




