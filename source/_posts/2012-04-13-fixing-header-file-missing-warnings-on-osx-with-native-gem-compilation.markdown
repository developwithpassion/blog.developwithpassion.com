---
layout: post
title: "Fixing header file missing warnings on OSX with native gem compilation"
date: 2012-04-13 18:29
comments: true
categories: [osx, gems, ruby]
---
Wiped away my install of XCode this evening to install the new version of Xcode (which I installed straight to /Applications!).

Prior to doing this I also completely deleted the /Developer folder.

Upon successfully reinstalling [RVM](http://beginrescueend.com) and [homebrew](https://github.com/mxcl/homebrew) using the [devtools](http://github.com/developwithpassion/devtools), I cd'd into a rvm managed folder and did the standard bundle install, upon which time I eventually received this error:

{% codeblock Error - error.sh  %}
: fatal error: 'stdio.h' file not found
{% endcodeblock %}

I had installed the Command Line Tools for Xcode, but I had not yet switched where it should resolve those tools. Running the following command fixed the issue:

{% codeblock Fix the missing header issue - fix.sh  %}
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
{% endcodeblock %}

[Develop With Passion®](http://www.developwithpassion.com)

