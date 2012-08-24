---
layout: post
title: "So Long BDD Macro - Hello Autohotkey!!!"
comments: true
date: 2008-05-27 09:00
categories:
- tools
---

Well, it has been a good run and the BDD Macro has served its purpose to help me get into the swing with going down the BDD path, but now I find myself wanting a little bit more!!  
After a quick email from [Dave](http://davesquared.blogspot.com) I thought I would take a quick look at [AutoHotKey](http://www.autohotkey.com/) to see how it could help me accomplish my end result much simpler. Here are the 2 autohotkey scripts that I created to accomplish the end result:  
<strong>replace_spaces_with_underscores.ahk:</strong>  
#SingleInstance force    
Space::_  
<strong>spaces_back_to_spaces.ahk:</strong>  
#SingleInstance force    
Space::Space  
  
In my main autohotkey script (which is located in My Documents) I added the following lines of code:  
^!u::Run C:\utils\autohotkey\jpscripts\replace_spaces_with_underscores.ahk    
^+u::Run C:\utils\autohotkey\jpscripts\spaces_back_to_spaces.ahk  
The first line tells autohotkey that whenever the CTRL-ALT-U combination is pressed that it should run the replace_spaces_with_underscores.ahk to enable underscores being placed whenever I hit the space key.  
The second line tells autohotkey that whenever the CTRL-SHIFT-U combination is pressed that it should run the spaces_back_to_spaces.ahk to switch the space key back to its normal behavior.  
Autohotkey starts up at Windows start up, so I can use these commands no matter which application I am in. I have attached the script files. I also recorded a quick screencast, but I cannot currently upload it to my FTP server (issues). I have a feeling that me and AutoHotKey are going to become fast friends!!  <ul>   <li>[replace_spaces_with_underscores.ahk]({{ site.cdn_root }}binary/2008/may/27/so_long_bdd_macro_hello_autohotkey/replace_spaces_with_underscores.ahk) </li>    <li>[spaces_back_to_spaces.ahk]({{ site.cdn_root }}binary/2008/may/27/so_long_bdd_macro_hello_autohotkey/spaces_back_to_spaces.ahk) </li> </ul>  
Develop With Passion!!




