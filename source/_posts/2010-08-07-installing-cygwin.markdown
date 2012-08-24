---
layout: post
title: "Installing Cygwin"
comments: true
date: 2010-08-07 09:00
categories: [tools]
---

Just started configuring my cygwin environment so that I can jump between linux/mac/and windows without any issues. Just need to make a note of the bare bones cygwin installation that I need to get things going.

After going with the default installation, the following were packages that I added on:

* Archive
  * unzip - Unzipping zip files
* Utils
  * ncurses - Enable better handling of terminal
* Net
  * openssh - SSH Client and Server
  * curl - download internet resources
* Devl
  * git
  * git-completion
  * git-gui
  * git-svn
  * gitk

The first thing that I did was to add the following line into the $CYGWIN_INSTALL_PATH$/etc/profile file:

* HOME=/cygdrive/c/users/$USER
  export HOME

Once I had all of that installed I updated my .bashrc to source a new file called .bash_ssh which included the recommended code from github that can be used to enable an ssh-agent with cygwin:

<script src='http://pastie.org/1020623.js'/>

* Updated my hosts file to contain an entry for github.com. Without this, name resolution would fail (I'm sure there is a better way to do this!!)
* Updated my shared automation scripts so that I could switch between unix/windows based platforms with a snap. I currently share dotfiles across windows.osx,and ubuntu. All DRY with a bit of ruby magic sprinkled in (another article).

Well that is the quick 100 foot overview, there are lots of other packages that I can install, but this is the bare minimum I need to get started configuring my cygwin environment on windows!!

[Develop With Passion!!](http://www.developwithpassion.com)
