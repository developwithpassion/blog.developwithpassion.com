---
layout: post
title: "Start Flying With ReSharper (and windows in general) - Use the Alt-Key"
comments: true
date: 2007-10-12 09:00
categories:
- general
- programming
---

I received this question a couple of days ago that I thought I would quickly take the time to respond to a question:
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"><em>'At work over the past few weeks we've been watching your patterns talks on dnrTV.  We've found them really enlightening (we're implementing some of them as I write this), but what has really amazed some of us is your use of ReSharper.  We have a printout of the default keymap for ReSharper, but we notice that you do some things using the keyboard that we would love to be able to do (and, in fact, didn't even know were options in ReSharper).  One co-worker surmises that you have mapped your own keyboard shortcuts.  Is this the case, or are you just very knowledgeable of all of the shortcuts that ReSharper provides out of the box.  Either way, do you have any sort of keyboard mapping that you would be willing to share?  We're always looking into ways to be better  - and what better way than to have a tool do all of the heavy lifting for you!!'</em></span>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"><em></em></span> 
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Here is the trick to getting really proficient with not just ReSharper, but also any and every program that windows throws at you. <strong>Start using the ALT key more!! </strong>With respect to the stuff that I am doing in ReSharper, let me confess that I have not mapped any extra keybinding other than the ones that come out of the box during the install.. Since 1.0 of ReSharper I have been leveraging , and will continue to use, the IntelliJ keyboard mappings. Before you can start leveraging the ALT key more effectively with ReSharper there is <strong>one thing </strong>you will have to do (you don't have to, but it will save you an extra 'R' in the keyboard sequences). If you are using VS2005 and you have both Refactor and ReSharper menu items (the Refactor menu is provided by the default install of VS2005, and will only show up if you are in a code file) you will need to remove the Refactor menu from your toolbar. If you want to get rid of it for good follow these steps:</span>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> 
<ul>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Right click on the toolbar in VS and choose customize</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Select the Commands tab</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Click the Rearrange commands button</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Ensure that the Menu Bar option is selected and choose the Refactor menu from the drop down list.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">The Controls list should now be populated with all of the Refactor menu items.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Highlight the first item in the Controls list and hit ALT- D (delete).</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Take care when deleting the last item as the list will automatically populate with the next set of controls from another menu item that you may not want to delete.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Click the close button on the dialog, and click the close button on the main dialog.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Voila, the Refactor menu item should be gone from your toolbar!!</span></div></li></ul>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Here are a couple of ReSharper key sequences that I use all of the time (I'll leave it up to you to experiment):</span>
<ul>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> N -> Enter - Create new class from file template template. This works because the first template in my list is the class template.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> N -> I - Create new interface from file template.</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> N -> F - Create new TestFixture from file template</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> N -> M - Create new MockTestFixture from file template</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> W -> D - Bring up the TODO exlorer</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">ALT -> R -> O - Bring up ReSharper options</span></div></li>
<li>
<div class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> </div></li></ul>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">With respect to the TestFixture and MockTestFixture files templates, these are just one of many custom file templates that I use to help me get off the ground faster. I leverage ReSharper file templates a lot as it helps me start with code files that are much leaner than the studio counterparts.</span>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> 
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Using the ALT key more will allow you to drop the mouse more than you think and start leveraging features directly from the keyboard.</span>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> 
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'">Develop with Passion!!</span>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> 
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><span style="FONT-SIZE: 10pt; FONT-FAMILY: 'Arial','sans-serif'"></span> 




