---
layout: post
title: "Bye Bye Arrow Keys"
comments: true
date: 2010-01-27 09:00
categories:
- mouseless computing
- tools
---

One of the great things about being able to teach people from all over the world is the amazing tricks and techniques that you can pick up that can improve all aspects of your life (not just the dev realm).   
Being the ever aspiring keyboard ninja, last July I picked up an [autohotkey](http://www.autohotkey.com/) script from Rob Henry. Rob is a vim wizard. Having a year of vim under my belt, I was always on the look out for people who could teach me how to use it more proficiently. One of the things you "will" experience if you ever take the time to learn vim is that you will quickly miss some of its basic navigation features in lots of you other programs. One of the biggest things that I missed in all of my applications was not being able to use vim style navigation to get around, instead having to resort to the use of the arrow keys.  
As soon as I started using vim I wrote a quick autohotkey script that would allow me to remap my caps key to escape. During the course in July, Rob made a great observation - "What a waste of a perfectly good control key". He promptly showed me an autohotkey script he had written to use the caps key as another control key that could be used to simulate simple vim style navigation anywhere in windows.  
   
What does this mean? It means I pretty much never need to use the arrow keys!! That's right, being the home row nut that I am, this allowed me to cut out the flight to the arrow keys. This is especially significant for me when using tools like [R#](http://www.jetbrains.com/resharper/index.html" target="_blank)!!    
Unfortunately, there was a slight problem with the autohotkey script (actually its not the script). When running [VMWare Fusion](http://www.vmware.com/products/fusion/" target="_blank) on a Mac, the use of the Caps Lock keycode could not be combined with another keycode to accomplish what I wanted. I wrote a second version of Robs script that remapped my Caps Lock to the LWIN key. This means that when I hit my Caps lock key on its own, the windows menu pops up.  
   
Of course, I am rarely hitting the caps lock key on its own, I am usually hitting it in conjunction with one or more other keys to save my hands the flight path. Here are a couple of examples of some combinations and what they simulate:   
CAPS + E - Esc   
CAPS + J - Down Arrow    
CAPS + K - Up Arrow    
CAPS + L - Right Arrow    
CAPS + H - Left Arrow    
CAPS + F - Cycle forward through task switcher apps    
CAPS + D - Cycle backward through task switcher apps   
One of the switches that I needed to make adjusting to this new scheme was to make sure that I was actually hitting CAPS in conjunction with another key as not to have the windows launcher pop up. I also realized that because I had previously only used the CAPS lock to get back into command mode in Vim, my pinky was not used to being stretched that far all the time. I know, I know, you are thinking to yourself that it is not that far at all, but the muscle memory in that finger was not used to using it so heavily at all, so after the first week, the left side of my hand was sore from the stretch. After the 2nd week it was totally normal.  
   
As well as Robs script, I have updated a whole bunch of my resharper autohotkey scripts so that I can use the caps lock key to pull off some resharper goodness. I can't even remember what the "default shortcuts" are anymore, I have heavily customized those scripts for the way that I work and the way that I use the keyboard.    
  
Download the zip containing the files [here]({{ site.cdn_root }}binary/2010/january/27/bye_bye_arrow_keys/autohotkey.rar).  
Develop With Passion!!!




