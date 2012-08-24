---
layout: post
title: "Purge Subversion Files"
comments: true
date: 2008-12-23 09:00
categories:
- general
---

Often times when I am copying files between different subversion folders, I want to make sure that I copy them and place them in the new location while not keeping any of the subversion folders/files kicking around. In the past I had a system for doing this (mostly with some well placed keyboard shortcuts). Now that I am moving most of my automation tasks into powershell, I thought I would share this script with you:  
  <pre style="overflow: auto">param([string] $folder)
  if (($folder -eq $null) -or ([System.IO.Directory]::Exists($folder) -eq $false))
  {
    "usage: kill_subversion_files.ps1 [path_to_folder_to_purge_subversion_files_from]"
  }
  else
  {
    "Deleting all subversion files from $folder"
    get-childitem $folder -recurse -force -include *svn | remove-item -recurse -force
  }</pre>





I place this scripts (named kill_subversion_files.ps1) in my powershell path, then I can just open up a powershell prompt and type in:


kill_subversion_files [path_to_folder_to_remove_subversion_files_from]


Develop With Passion!!




