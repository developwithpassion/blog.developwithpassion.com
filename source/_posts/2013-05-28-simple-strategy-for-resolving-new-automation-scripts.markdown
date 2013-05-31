---
layout: post
title: "Simple strategy for resolving new automation scripts"
date: 2013-05-28 08:49
comments: true
categories: [automation]
---
I have a large (and continually increasing) number of automation scripts in play on my machine. I usually keep a simple notebook page going where I will make a note of automation items that I seem to be missing, usually identified by things that I have to do multiple times that I think could be automated. Once a week I will look at that list and complete one of the automation items.

After doing this for a while, it became apparent that I needed to have a simple way to be able to have new automation scripts be recognized, so I could quickly start using them. As my automation scripts grew, I wanted to be able to organize the scripts by functional area, so I could quickly get a listing of my automation folder and see what types of automation items I had in play.

My automation scripts currently consist of predominantly bash, python, and ruby scripts, all of which are marked executable (the ones that are automation items anyway).

I won't get into how I organize my dotfiles, but here is an important couple of lines in one of my dotfiles that ensures that all of my automation scripts (regardless of folder they are organized into) are picked up and available in my path:

{% codeblock Automation Scripts - scripts.sh %}
OLD_PATH=$PATH
export PATH="$OLD_PATH:$(find [my automation root folder] -name '.*' -prune -type d | tr "\n" ":")"
{% endcodeblock %}

Obviously, you would replace [my automation root folder], with the path to the folder which is the parent of all of your automation script folders. For me that is ~/repositories/developwithpassion/devtools/automation.

Notice the use of the find command to find all folders underneath my automation root, which are then piped into the tr utility to convert every newline into the required path separator.

This allows me to either add a new executable automation script under an existing folder in my automation hierarchy; or I can add a new automation script under a brand new subfolder in my automation hierarchy. Either way it will be picked up.

[Develop With Passion®](http://www.developwithpassion.com)


