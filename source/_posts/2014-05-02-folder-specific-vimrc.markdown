---
layout: post
title: "Folder specific .vimrc"
date: 2014-05-02 11:47
comments: true
categories: [vim]
---
As a vimmer, depending on the codebase you are working on, it's highly likely that you have folder/project specific macros, functions, tab-spacing, mappings that differ from what you would want to maintain in your main .vimrc.

One handy way to not clutter up your main vimrc as well as having the side benefit of having all the other developers working in that codebase using the same settings for the specific folder you are in is to place the following 2 lines of code in your main vimrc:

{% codeblock lang:vim  %}
" enable folder specific vimrc
set exrc
set secure
{% endcodeblock %}

Those two lines will enable you to have a .vimrc file per folder that you have. When you vim into a folder with a custom .vimrc in it, your main .vimrc will be applied, along with the settings and configuration in the folder specific .vimrc.

The line:

{% codeblock lang:vim  %}
set secure
{% endcodeblock %}

Ensures that folder specific vimrc disallow the use of :autocmd, shell and write commands. If this is a limitation for you, you can remove the set secure line, and open yourself up to potential vunerabilities.

[Develop With Passion®](http://www.developwithpassion.com)
