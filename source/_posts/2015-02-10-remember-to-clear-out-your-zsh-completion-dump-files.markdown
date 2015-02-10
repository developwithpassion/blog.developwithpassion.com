---
layout: post
title: "Remember to clear out your zsh completion dump files!"
date: 2015-02-10 09:41
comments: true
published: true
categories: [zsh,rvm]
---
Everyone once in a while I'll start up a new zsh session and I'll start getting errors about:

{% codeblock lang: bash %}
__rvm_cleanse_variables: function definition file not found
{% endcodeblock %}

Whenver that happens it is useful to remember that the simplest fix is just to delete your zsh completion dump files:

{% codeblock lang: bash %}
rm -f ~/.zcompdump*
{% endcodeblock %}

Here's the [SO](http://stackoverflow.com/a/10585017) comment that set me straight!

[Develop With Passion®](http://www.developwithpassion.com)
