---
layout: post
title: "All Old Links Restored"
comments: true
date: 2008-07-10 09:00
categories:
- general
---

When I published the site I forgot about all of the links that I would be breaking to the blog that pointed at [http://www.developwithpassion.com/blog](http://www.developwithpassion.com/blog). After a comment from someone who had done a lot of linking I thought about the quickest thing I could do to fix the problem. Even though the site is built on System.Web.MVC, I thought that since all of the links would point at [www.developwithpassion.com/blog](http://www.developwithpassion.com/blog). I just tweaked IIS instead of adding in a new route (KISS).  
I created a blog folder under the main directory for the web site. The folder itself was empty. Then in IIS I went to the properties for the blog folder and set it up as follows:  
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/AllOldLinksRestored_14084/image_4.png"><img style="border-right: 0px; border-top: 0px; border-left: 0px; border-bottom: 0px" height="460" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/AllOldLinksRestored_14084/image_thumb_1.png" width="485" border="0" /></a>   
This is just a simple redirection, that ensures (using the simplest way possible) that all old requests, trackbacks, links etc will get pointed at the new resources that are now rooted at:  
[http://blog.developwithpassion.com](http://blog.developwithpassion.com)  
  
Develop With Passion




