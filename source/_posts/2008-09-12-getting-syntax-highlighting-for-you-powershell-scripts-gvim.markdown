---
layout: post
title: "Getting Syntax Highlighting For You Powershell Scripts (GVim)"
comments: true
date: 2008-09-12 09:00
categories:
- tools
---

I was asked this question at my last course so I thought I would share the answer with everyone!!  
To get syntax highlighting for the powershell scripts that I edit I first downloaded a set of syntax files provided by [Peter Provost](http://www.peterprovost.org/). You can download the files from here:  
<a title="http://www.vim.org/scripts/script.php?script_id=1327" href="http://www.vim.org/scripts/script.php?script_id=1327">http://www.vim.org/scripts/script.php?script_id=1327</a> (Syntax File)  
<a title="http://www.vim.org/scripts/script.php?script_id=1815" href="http://www.vim.org/scripts/script.php?script_id=1815">http://www.vim.org/scripts/script.php?script_id=1815</a> (Indent File)  
<a title="http://www.vim.org/scripts/script.php?script_id=1816" href="http://www.vim.org/scripts/script.php?script_id=1816">http://www.vim.org/scripts/script.php?script_id=1816</a> (File Type Plugin)  
Once I had copied those files into the appropriate folders:  
$VIMRUNTIME\syntax  
$VIMRUNTIME\indent  
$VIMRUNTIME\ftplugin  
I had to edit my $VIMRUNTIME\filetype.vim and add the following line:  
" Powershell   
au BufNewFile,BufRead *.ps1 setf ps1  
With that done I can open up a powershell file and get syntax highlighting.  
Question for the long time Vim users. Can I not just place the files in the appropriate folders and have gvim automatically pick them up without having to edit the filetype.vim file?  
Develop With Passion!!




