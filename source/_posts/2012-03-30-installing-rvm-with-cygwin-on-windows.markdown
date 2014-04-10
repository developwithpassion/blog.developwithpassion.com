---
layout: post
title: "Installing RVM with Cygwin On Windows"
date: 2012-03-30 18:19
comments: true
categories: [tools windows cygwin ruby]
---
A couple of people have asked me how to get rvm working successfully on windows with cygwin.

I'll write another post later about how I use [devtools](http://github.com/developwithpassion/devtools) to successfully run msys and cygwin side by side from the same set of dotfiles (customized per environment)!

I started with a brand new vm image with the software installed according to the post [here](http://blog.developwithpassion.com/2012/03/12/repaving-a-new-window-7-vm/).

If you don't wish to read that previous post just know I installed cygwin to C:\utils\cygwin (for the purpose of this post it you are following along, I would suggest installing to that path also). I also included the following packages (some of these are not necessary for ruby compilation, but they have become my base for a cygwin install):

* Archive
  * unzip - Unzipping zip files
* Net
  * openssl - bin and sources
  * openssh - Only if you are not going to compile openssh yourself
  * curl - download internet resources
* Devl
  * colorgcc
  * gcc
  * gcc-core - compiler
  * git
  * git-completion
  * git-gui
  * git-svn
  * gitk
  * libtool - Shared library generation tool. You'll need it when trying to compile rubies
  * libncurses-devel - Used when compiling several other tools I use
  * make
  * mercurial
  * openssl-devel - Required for compiling openssh (not necessarily required for rvm, but I always install it to compile openssh myself)
  * readline
* Libs
  * zlib
  * zlib-devel
  * libyaml
  * libyaml-dev
* Utils
  * ncurses - Enabling better handling of terminal
  * patch - Apply a diff file to an original. Again, you'll need it when rvm is trying to patch the ruby installs

Once the cygwin install completes we can continue.

##Setting Up

* Open up a new cygwin session (C:\utils\cygwin\cygwin.bat).

* Issue the following commands in the cygwin session:
  
{% codeblock Get The devtools - devtools.sh %}
mkdir repositories
cd repositories
mkdir developwithpassion
cd developwithpassion
git clone git://github.com/developwithpassion/devtools
cd devtools
{% endcodeblock %}
    
  The results should look as follows:

{% img centered https://img.skitch.com/20120415-8sw3uup1pamxd4gbr934s3hshd.jpg %}

* You should now be sitting in the devtools folder so you can now run the kick_off_script:

{% codeblock Prep - kick_off.sh %}
./osx_or_cygwin_kick_off
{% endcodeblock %}

* Repeat the above step(the first time you run it, it creates a settings file for your user that can be edited further if you are going to make further use of [devtools](http://github.com/developwithpassion/devtools) later on) 

  For the curious, the script is [here](https://raw.github.com/developwithpassion/devtools/master/osx_or_cygwin_kick_off)

  The script does the following:
   * kicks off an rvm installation script
   * updates to the latest rvm
   * installs a couple of rubies and sets 1.9.3 as the default ruby

The last step takes a little time to complete, but the end result is definitely worth it!!:
 
{% img centered https://img.skitch.com/20120331-1ix7mmijphenimhb4jui3cic45.jpg %}

[Develop With Passion®](http://www.developwithpassion.com)
