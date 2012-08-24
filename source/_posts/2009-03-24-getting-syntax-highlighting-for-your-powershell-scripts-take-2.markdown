---
layout: post
title: "Getting syntax highlighting for your powershell scripts (take 2)"
comments: true
date: 2009-03-24 09:00
categories:
- tools
---

  
<font face="Arial" size="2">Since I just had to recently get my machine scaffolded again, I had a chance to revisit this item. I think this time I got it figured out a little better!!</font>  
<font face="Arial" size="2">For reference this is what my vim folder looks like:</font>  
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/Gettingsyntaxhighlightingforyourpowershe_AF5C/image_2.png" rel="lightbox"><img title="image" style="border-right: 0px; border-top: 0px; display: inline; border-left: 0px; border-bottom: 0px" height="248" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/Gettingsyntaxhighlightingforyourpowershe_AF5C/image_thumb.png" width="228" border="0" /></a>   
<font face="Arial" size="2">Download the following files (I place them in the appropriate folders in my vimfiles folder:</font>  
<a href="http://www.vim.org/scripts/script.php?script_id=1327"><font face="Arial" size="2">http://www.vim.org/scripts/script.php?script_id=1327</font></a><font face="Arial" size="2"> (Syntax File) </font>  
<a href="http://www.vim.org/scripts/script.php?script_id=1815"><font face="Arial" size="2">http://www.vim.org/scripts/script.php?script_id=1815</font></a><font face="Arial" size="2"> (Indent File) </font>  
<a href="http://www.vim.org/scripts/script.php?script_id=1816"><font face="Arial" size="2">http://www.vim.org/scripts/script.php?script_id=1816</font></a><font face="Arial" size="2"> (File Type Plugin) </font>  
<font face="Arial" size="2">Once I had copied those files into the appropriate folders: </font>  
<font face="Arial" size="2">vimfiles\syntax </font>  
<font face="Arial" size="2">vimfiles\indent </font>  
<font face="Arial" size="2">vimfiles\ftplugin </font>  
<font face="Arial" size="2">I edited my _vimrc file and have the following section (just before the syntax on command):</font>  
<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/Gettingsyntaxhighlightingforyourpowershe_AF5C/image_4.png" rel="lightbox"><img title="image" style="border-right: 0px; border-top: 0px; display: inline; border-left: 0px; border-bottom: 0px" height="241" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/Gettingsyntaxhighlightingforyourpowershe_AF5C/image_thumb_1.png" width="540" border="0" /></a>   
<font face="Arial" size="2">With that done I can open up a powershell file and get syntax highlighting. </font>  
<font face="Arial" size="2">Unlike in the [last post](http://blog.developwithpassion.com/GettingSyntaxHighlightingForYouPowershellScriptsGVim.aspx), this solution will also allow me to upgrade my version of Vim without issues as I am now placing custom plugins in my vimfiles folder (under version control, so I can quickly rebuild a machine if needed!!), as well as the fact that I am making use of my _vimrc file to enable the custom plugin.</font>  
<font face="Arial" size="2">Develop With Passion!!</font>




