---
layout: post
title: "Visit a url from tmux"
date: 2014-04-30 08:46
comments: true
categories: [unix, shell, bash, tmux]
---
As I spend the majority of my day between any number of shell sessions, one of things I like to be able to do is quickly display all of the urls in my active pane in tmux.

[urlview](http://linuxcommand.org/man_pages/urlview1.html) is a program that can help me with this.

If you are running osx and [homebrew](http://brew.sh/) installing it is as simple as:

{% codeblock lang:bash Install URL View - install.sh %}
brew install urlview
{% endcodeblock %}

Once you have urlview installed you can give it a whirl as follows:

{% codeblock lang:bash Programming Rocks- programming_rocks.sh %}
echo "https://www.google.ca/search?q=programming+rocks" | urlview 
{% endcodeblock %}

This will pop up a list prompting you to press the number of the link you want to visit:

{% img https://www.evernote.com/shard/s52/sh/f134fc47-cc08-48dc-b4f6-1a51061044c5/7792c32862b3184d0a765a41e3595cbc/deep/0/1.-tmux-(tmux).png 'Url View' 'url_view' %}

Great, so now we know the basics of how urlview works, let's tie it into tmux. Here is the tmux configuration line I use to tie it all together:

{% codeblock lang:bash View Urls In tmux  %}
bind-key u capture-pane \; save-buffer /tmp/active_tmux_buffer \; new-window -n urlview '$SHELL -c "urlview < /tmp/active_tmux_buffer && rm /tmp/active_tmux_buffer"'
{% endcodeblock %}

When I press CTRL-b followed by u, it will do the following:

* save the contents of my current buffer to a file named /tmp/active_tmux_buffer
* open up a new tmux window and run the urlview utility with the previous saved file as the input
* removes the temp file

Never get tired of using small tools that do one thing well and are composable with other tools!!

[Develop With Passion®](http://www.developwithpassion.com)

