---
layout: post
title: "BDD AutoHotKey Script Update - Take 2"
comments: true
date: 2008-05-28 09:00
categories:
- tools
---

I think I now have a version of the script that I love. With some additions made by [Aaron Jensen](http://aaron.codebetter.com/) the script now watches for whenever the Enter/Escape key are pressed. Whenever those keys are pressed test naming style will turn off until it is reenabled again. I also modified the script so that when you are in test naming mode and you hit enter/escape it will disable that mode as well as send the keystroke (this is handy when you are in a dialog box, you enable the script, type in the natural name of the class/field,etc and hit enter. Without the modification you will have to hit enter twice!!  
Aaron also made a tweak to ensure that the script is only live when VS is active. I find myself using this all over the place, so my version of the script omits that check.  
Here is the new version of the script:  
;=======================================================================================   
;BDD Test Naming Mode AHK Script    
;    
;Description:    
; Replaces spaces with underscores while typing, to help with writing BDD test names.    
; Toggle on and off with Ctrl + Shift + U.    
;=======================================================================================   
;==========================   
;Initialise    
;==========================    
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.    
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.    
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.   
enabledIcon := "testnamingmode_16.ico"   
disabledIcon := "testnamingmode_disabled_16.ico"    
IsInTestNamingMode := false    
SetTestNamingMode(false)   
;==========================   
;Functions    
;==========================    
SetTestNamingMode(toActive) {    
 local iconFile := toActive ? enabledIcon : disabledIcon    
 local state := toActive ? "ON" : "OFF"   
 IsInTestNamingMode := toActive   
 Menu, Tray, Icon, %iconFile%,    
 Menu, Tray, Tip, Test naming mode is %state%   
 Send {Shift Up}   
}   
;==========================   
;Test Mode toggle    
;==========================    
^+u::    
 SetTestNamingMode(!IsInTestNamingMode)    
return   
;==========================   
;Handle Enter press    
;==========================    
$Enter::    
 if (IsInTestNamingMode){    
 SetTestNamingMode(!IsInTestNamingMode)    
 }    
 Send, {Enter}    
return   
;==========================   
;Handle Escape press    
;==========================    
$Escape::    
 if (IsInTestNamingMode){    
 SetTestNamingMode(!IsInTestNamingMode)    
 }    
 Send, {Escape}    
return   
;==========================   
;Handle SPACE press    
;==========================    
$Space::    
 if (IsInTestNamingMode) {    
 Send, _    
 } else {    
 Send, {Space}    
 }   
Having used this for the past 2 days now, I am convinced that AHK is the way to go to allow for much more fluidity when trying to write your tests in a more natural english style.  
Develop With Passion!!




