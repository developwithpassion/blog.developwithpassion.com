---
layout: post
title: "Bash - Quickly deleting all but one item in a folder"
comments: true
date: 2010-08-13 08:00
categories: [bash, shell]
---

If you want to quickly delete all but one of the items in a particular folder here is one way to do it at the shell:

assuming a directory that contains the following contents:

{% codeblock bash %}
~/repositories/developwithpassion/blog/_posts/sample(master)
 ⇒ ls
1.txt  2.txt  3.txt  4.txt  5.txt
{% endcodeblock %}

I can get rid of all the files except 5.txt as follows:

{% codeblock bash %}
rm -rf $(ls | grep -v 5.txt)
{% endcodeblock %}

All that is going on here is that I am making use of both subshells and pipes to first list the contents of everything in the directory, which then pipes through to the grep command which return all of the items that don't match 5.txt. That set of items then gets acted on by the containing shell which removes each of the non matching items.

[Develop With Passion®](http://www.developwithpassion.com)





