---
layout: post
title: "Running VMWare images on Windows and Macs"
comments: true
date: 2007-10-03 09:00
categories:
- general
---

As I said the other day, I finally bit the bullet and purchased an awesome MacBook pro!!

From day 1 (in the Mac world) I have been utilizing [VMWare Fusion](http://www.vmware.com/products/fusion/) as my virtualization software of choice. This is a list of things that I should have done before I made the switch from my windows VM's to VM Ware Fusion.
<ul>
<li>Make sure that when you create your images in [VMWare Workstation](http://www.vmware.com/products/fusion/), that you select the option to split the disk files into 2GB increments. This is imperative as ,if you are like me, and need to run the images on both Mac and Windows machines, then the only file system that you will be able to use effectively with both (without extra tools that are not officially supported) is the FAT32 files system.</li>
<li>To further emphasize point one, if you don't check off the option (which I did not do when creating my original images), you will most likely fail to be able to copy the images to a FAT32 drive as the virtual disks will most likely be over the 4GB file size limit for a FAT32 file.</li>
<li>Don't copy the original images onto a Mac partition which can allow for larger files sizes as once you copy it onto the Mac, you won't be able to run the VMWare utility to split the original disk file back into 2GB increments, as this utility is not present in Fusion. Keep the images on an XP/Vista host and run the VMWare Workstation disk manager utility that can be used to convert the virtual disk file from a single large file to multiple files of a specified size. Once you have completed this step, you should be able to successfully copy the images onto a FAT32 partition, circumventing the 4GB file size limit.</li></ul>

.... As an aside, I made all sorts of mistakes when migrating my images to work with both Mac and Windows. Of course, this is ultimately how you learn the right way to do it!!

Just as a side note, I think I seriously messed things up when opening the images multiple times on both windows and Mac. It got to the point where I had to open up both the vmx file and the vmdk files to ensure that pathing issues were not present.

It just so happened that somewhere during the course of flipping constantly between a windows host and the mac host, the paths of some of the files got munged up. Once I edited the files manually to resolve the path issues, it was all good.

Just in case any of you newly acquainted with a Mac and Fusion experience this issue, you may need to check to see if there are pathing issues in either of the sets of files I mentioned.

 




