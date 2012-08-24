---
layout: post
title: "Score 1 For Eliminating your hands flight path"
comments: true
date: 2008-04-15 09:00
categories:
- programming
- tools
---

For the last couple of weeks, I have been integrating Vim and a complementary set of tools into my development toolkit. I am firmly on board with what the pragmatic programmers say:  
"Learn a good editor, and learn it well!!"  
I am thoroughly impressed with Vim, Viemu etc. Last week I was recommended a registry hack that would allow my Caps Lock key to have the same behaviour as the ESC key. This results in a much smoother experience when using Vim.  
So far, I am loving the reg hack and much prefer the need to not have to move my hand to hit the ESC key. Here is the text of the reg file:  
Windows Registry Editor Version 5.00   
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]    
"Scancode Map"=hex:00,00,00,00,00,00,00,00,02,00,00,00,01,00,3a,00,00,00,00,00   
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout\DosKeybCodes]    
"00000804"="ch"     
"00000408"="gk"     
"00010408"="gk"     
"00020408"="gk"     
"00050408"="gk"     
"0001041f"="tr"     
"0000041f"="tr"     
"00000423"="us"     
"00000402"="bg"     
"00000419"="ru"     
"00010419"="ru"     
"00000c1a"="us"     
"00010c1a"="us"     
"00000422"="us"     
"00010402"="us"     
"00020402"="bg"     
"00030402"="bg"     
"00020422"="us"     
"00000412"="ko"     
"00000425"="et"     
"00000426"="us"     
"00010426"="us"     
"00000427"="us"     
"00000411"="jp"     
"00000404"="ch"     
"0000041C"="us"     
"0000041a"="yu"     
"00000424"="yu"     
"00000405"="cz"     
"00010405"="cz"     
"0000040e"="hu"     
"0001040e"="hu"     
"00000415"="pl"     
"00010415"="pl"     
"00000418"="ro"     
"00010418"="ro"     
"00020418"="ro"     
"0000041b"="sl"     
"0001041b"="sl"     
"00000442"="tk"     
"00000813"="be"     
"0000080c"="be"     
"00001009"="us"     
"00000c0c"="cf"     
"00010c0c"="cf"     
"00000406"="dk"     
"00000413"="nl"     
"0000040b"="su"     
"0000040c"="fr"     
"00000407"="gr"     
"00010407"="gr"     
"0000040f"="is"     
"00001809"="us"     
"00000410"="it"     
"00010410"="it"     
"0000080a"="la"     
"00000414"="no"     
"00000816"="po"     
"00000416"="br"     
"0000040a"="sp"     
"0001040a"="sp"     
"0000041d"="sv"     
"0000100c"="sf"     
"00000807"="sg"     
"00000809"="uk"     
"00010409"="dv"     
"00030409"="usl"     
"00040409"="usr"     
"00020409"="us"     
"00000409"="us"     
"00000452"="uk"     
"0000046e"="sf"   
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout\DosKeybIDs]    
"00010408"="220"     
"00020408"="319"     
"0001041f"="440"     
"0000041f"="179"     
"00010415"="214"     
"00000442"="440"     
"00000410"="141"     
"00010410"="142"   
Create a reg file and copy the contents into it, then merge the file into your registry. Make sure that you want to not have normal use of your caps lock key.  
Develop With Passion!!




