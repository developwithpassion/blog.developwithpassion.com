---
layout: post
title: "Unix based development on windows (redux)"
date: 2014-09-18 13:37
comments: true
published: true
categories: [unix, windows]
---
I wrote a [post](http://blog.developwithpassion.com/2012/03/30/installing-rvm-with-cygwin-on-windows/) a couple of years ago on how to setup RVM in a cygwin environment on windows.

There have been quite a few people who have been able to follow this post successfully. There is an equally high number of people who were not able to get the setup working correctly. My current take is the following:

#Don't bother trying to do any unix style development under windows"

Please, do yourself a favour, install [vagrant](https://www.vagrantup.com/) and setup a virtual machine for your project. Everyone on the team will be using the same machine setup, you won't have to fight with annoying windows/unix based irregularities. And the tools that you are probably trying to develop with will more than likely just work the way you expect.

It's been a number of years since I have been on a windows based project. And if I had to be on a windows based project again, it would more than likely be a C++, .Net or some other development environment that is a first class citizen under windows.

When I'm working on a unix based project, I'll be working in a fully supported unix development environment, and based off of current history, with a vagrant backed vm that can be shared by the other team members.

My current dev setups are OSX/Unix based hosts, with Vagrant vms configured per project.

[Develop With Passion®](http://www.developwithpassion.com)

