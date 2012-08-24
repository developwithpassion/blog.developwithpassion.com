---
layout: post
title: "One Small Gotcha With Custom Actions For Windows Services"
comments: true
date: 2006-11-20 09:00
categories:
- continuous integration
---

It's been a while since I used studio to create a deployment project. I am using NAnt to package my files for distribution, I then create a Setup project in my solution that basically points at the NAnt output and creates an MSI from it. 
I created an installer for a windows service, and added a custom commit action to make sure the ServiceInstaller ran during the commit phase of the installation. 
Upon running the installer I was prompted with the following error message while nearing completion of the installation: 
<img src="{{ site.cdn_root }}binary/oneSmallGotchaWithCustomActionsForWindowsServices/errorMessageWindow.jpg">  
After a bit of digging around it seems that I have to also add a custom install action that is identical to the commit action. Once that is done, the error disappears and the service installs correctly. 
Make sure you also add the custom action to the Uninstall step, otherwise the service will not be removed from the computer during uninstall. 
Hope this helps someone else.




