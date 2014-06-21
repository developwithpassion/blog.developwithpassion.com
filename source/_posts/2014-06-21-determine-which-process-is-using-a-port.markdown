---
layout: post
title: "Determine which process is using a port"
date: 2014-06-21 08:35
comments: true
categories: [unix]
---

Quick bit of unix trivia!

Every so often I will be recreating one of my [Vagrant](http://www.vagrantup.com/) vm's, and even though it should have been destroyed I will get errors about forwarded ports colliding.

In this situation I want to verify that it is the vm provider that is locking the port (vmware fusion in my case).

To do that just run:

{% codeblock lang:bash %}
lsof -i :[port_number] 
{% endcodeblock %}


{% codeblock lang:bash %}
lsof -i :[port_number] 
{% endcodeblock %}

As an example (using port 80), this is the output I get:

{% codeblock lang:bash %}
COMMAND     PID USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
Dropbox     418   jp   23u  IPv4 0x3321ede7d20f87c3      0t0  TCP 192.168.1.2:49204->snt-re3-6c.sjc.dropbox.com:http (ESTABLISHED)
firefox   82810   jp   58u  IPv4 0x3321ede7e980cfab      0t0  TCP 192.168.1.2:60421->pb-in-f95.1e100.net:http (ESTABLISHED)
firefox   82810   jp   59u  IPv4 0x3321ede7eeddc7c3      0t0  TCP 192.168.1.2:60422->pb-in-f95.1e100.net:http (ESTABLISHED)
{% endcodeblock %}


At that point I have the PID that I can then terminate expeditiously!!


[Develop With Passion®](http://www.developwithpassion.com)

