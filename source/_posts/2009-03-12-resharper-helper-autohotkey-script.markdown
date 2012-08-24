---
layout: post
title: "ReSharper Helper - AutoHotkey Script"
comments: true
date: 2009-03-12 09:00
categories:
- tools
---

In my quest to keep my fingers as close to home row as possible, I am publishing the script I used to allow me to hit most of the ReSharper shortcuts I use by staying on home row. To run this you will have to:  <ul>   <li>Run AutoHotkey</li>    <li>Not worry about having different Resharper keyboard shortcuts than most!! (you can still use the original ones if you want!!)</li> </ul>  
Here is the script:  
;==========================   
;Initialise    
;==========================    
#NoEnv    
SendMode Input    
SetWorkingDir %A_ScriptDir%     
SetTitleMatchMode 2   
;==========================   
;Process Move Down A Method    
;==========================    
$!J::    
 Send, !{Down}    
return   
;==========================   
;Process Move Up A Method    
;==========================    
$!K::    
 Send, !{Up}    
return   
;==========================   
;Process Move Method Up    
;==========================    
$^+!K::    
 Send, ^+!{Up}    
return   
;==========================   
;Process Move Method Down    
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
;==========================    
;Highlight Current Usages    
;==========================    
$!8::    
 Send, ^+{F7}    
return    
;==========================    
;Find Usages    
;==========================    
$!9::    
 Send, !{F7}    
return    
;==========================    
;Next Error In Solution    
;==========================    
$!0::    
 Send, !{F12}    
return




