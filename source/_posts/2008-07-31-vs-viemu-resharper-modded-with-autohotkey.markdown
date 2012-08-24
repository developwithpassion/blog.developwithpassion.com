---
layout: post
title: "VS + ViEmu + (ReSharper  modded with AutoHotkey)"
comments: true
date: 2008-07-31 09:00
categories:
- programming
---

Now that I have been using Vim for a couple of months I feel very comfortable with it. Thanks to someone in my last class who has been a Vim user for years, I have started to use Vim for more than just editing (more on that in a later post). Vim has permeated a lot of the applications that I use:  <ul>   <li>Firefox</li>    <li>Visual Studio</li>    <li>Word</li>    <li>SQL Server Management Studio</li> </ul>  
  
Anyone who knows me well is aware of the fact that I am a keyboard junkie who is obsessed with keeping my hands as close to home row as possible! This is why for the longest time I have not used the ALT-Insert [Resharper](http://www.jetbrains.com/resharper/) shortcut, but rather ALT-R-C-G-I, which is the traversal path to get to the ReSharper generate dialog.  
Some of the features that I love about ReSharper also require the use of arrow keys, features such as:  <ul>   <li>Go to next member/tag</li>    <li>Go to previous member/tag</li>    <li>Move code up</li>    <li>Move code down</li>    <li>Go to next usage</li>    <li>Go to previous usage</li> </ul>  
I use [ViEmu](http://www.viemu.com/) in studio, but also use ReSharper for the awesome features it provides. As cool as the above ReSharper features are, I have never liked having to reach for the arrow keys (or memorize the menu traversal path) when editing with ReSharper. A couple of days ago I decided to use [AutoHotkey](http://www.autohotkey.com/) to allow me to tweak the keyboard so that I could perform all of the above operations using the exact keystrokes as ReSharper except replacing the use of the arrow keys with the appropriate Vim alternative (H,J,K,L). So now I can do the above as follows:  <ul>   <li>Go to next member/tag</li>    <ul>     <li>Original - Alt + Down Arrow</li>      <li><strong>Now - Alt + J</strong></li>   </ul>    <li>Go to previous member/tag</li>    <ul>     <li>Original - Alt + Up Arrow</li>      <li><strong>Now - Alt + K</strong></li>   </ul>    <li>Move code up</li>    <ul>     <li>Original - Ctrl + Shift + Alt + Up Arrow</li>      <li><strong>Now - Ctrl + Shift + Alt + K</strong></li>   </ul>    <li>Move code down</li>    <ul>     <li>Original - Ctrl + Shift + Alt + Down Arrow</li>      <li><strong>Now - Ctrl + Shift + Alt + J</strong></li>   </ul>    <li>Go to next usage</li>    <ul>     <li>Original - Ctrl + Alt + Down Arrow</li>      <li><strong>Now - Shift + Alt + J</strong></li>   </ul>    <li>Go to previous usage</li>    <ul>     <li>Original - Ctrl + Alt + Up Arrow</li>      <li><strong>Now - Shift + Alt + J</strong></li>   </ul>    <li>Generate Code</li>    <ul>     <li>Original - Alt - Insert</li>      <li><strong>Now - Alt + I</strong></li>   </ul> </ul>  
  
Only the go to next usage functions got a key replacement (Shift instead of Ctrl). Of course, none of the scripts affect the original ReSharper shortcuts, so when I am pairing with someone proficient with ReSharper and not Vim, they do not have an issue as they don't need to use the alternatives (and I can hit the shortcut to temporarily disable ViEmu also). They can carry on using the original ReSharper shortcuts. Notice that I also did the Generate Code so that now I can just hit ALT + I to do the same thing as ALT - Insert (no flight path for the hands at all!!). The nice thing is that now I can pull off all of the above functionality without having to leave home row and I get the benefit of consistent Vim style navigation.  
  
Here are the scripts (simplified for brevity):  
;=============================   
;Process Go to next member/tag    
;=============================    
$!J::    
 Send, !{Down}    
return   
;=================================   
;Process Go to previous member/tag    
;=================================    
$!K::    
 Send, !{Up}    
return   
;==========================   
;Process Move Code Up    
;==========================    
$^+!K::    
 Send, ^+!{Up}    
return   
;==========================   
;Process Move Code Down    
;==========================    
$^+!J::    
 Send, ^+!{Down}    
return   
;==========================   
;Process Go to next usage     
;==========================    
$+!J::    
 Send, ^!{Down}    
return   
;==========================   
;Process Go to previous usage     
;==========================    
$+!k::    
 Send, ^!{Up}    
return   
;==========================   
;Process Generate Code    
;==========================    
$!I::    
 Send, !{Insert}    
return  
  
Develop With Passion!!




