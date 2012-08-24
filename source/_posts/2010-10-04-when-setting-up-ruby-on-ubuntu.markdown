---
layout: post
title: "When setting up Ruby on Ubuntu [fixing zlib (LoadError)]"
comments: true
date: 2010-10-04 09:00
categories: [tools, linux]
---
Just in the process of repaving a new desktop [Ubuntu](http://www.ubuntu.com/) image. Installed rvm and got the following error when trying to update the gems package:

{% codeblock bash %}
$ sudo gem update --system 
... in `require': no such file to load -- zlib (LoadError)
{% endcodeblock %}

Simple fix:

{% codeblock bash %}
sudo apt-get install zlib1g zlib1g-dev 
{% endcodeblock %}

After that it's smooth sailing.

[Develop With Passion®](http://www.developwithpassion.com)
