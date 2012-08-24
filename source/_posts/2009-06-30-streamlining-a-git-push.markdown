---
layout: post
title: "Streamlining a GIT Push"
comments: true
date: 2009-06-30 09:00
categories:
- git
- tools
---

So you are using git you've done some work on your branch, everything is committed and you want to do a push to a remote repository. If you have used simple defaults to configure your repository then it is very possible that you will receive this message when you attempt to do a git push without any arguments:   
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/StreamliningaGITPush_11C39/image_2.png" rel="lightbox"><img style="border-right-width: 0px; display: inline; border-top-width: 0px; border-bottom-width: 0px; border-left-width: 0px" title="image" border="0" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/StreamliningaGITPush_11C39/image_thumb.png" width="634" height="290" /></a>   
The reason for this is because by default git tries to push all matching refspecs which is not usually what you want to do. There are a couple of places you can configure this if you do not want to receive this message. You can configure this at a repository level by running the following command from the shell (in the repository folder):   
git config push.default [setting]   
Where [setting] is one of the following values:   
- nothing    
- matching     
- tracking     
- current   
Currently the setting that I find myself using the most is current. By setting this setting it allows me to do a push by simply running git push without any arguments.   
Of course, if this is your default then you can create a fallback setting in your .gitconfig file that will be used in the event that a repository you are working in has not got a push.default configured. To do this just add the following entry into your .gitconfig file:   
[push]    
 default = current   
This ensures that if you happen to be working in a repository that does not explicitly have push.default set, then when you do a push without any arguments it will not attempt to push all matching branches, only the current branch you are working on.   
[Develop With Passion](http://www.developwithpassion.com)!!




