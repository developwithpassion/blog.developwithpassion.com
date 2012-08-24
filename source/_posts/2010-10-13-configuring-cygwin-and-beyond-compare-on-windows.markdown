---
layout: post
title: "Configuring Beyond Compare On Windows With Cygwin"
comments: true
date: 2010-10-13 09:00
categories: [tools]
---
Having to spend the week back in windows, it has forced me to verify that all of my configuration is actually able to be shared between the different environments.

When working with source code on windows I much prefer to use [beyond compare][bc] to work with diffs and merges.

Here is a look at my .gitconfig (after transformation to appropriate target environment[windows]; more on that later):

{% codeblock ini %}
[core]
autocrlf = true

[user]
  email = jp@developwithpassion.com
  name = Jean-Paul S. Boodhoo

[alias]
  st = status -s
  ci = commit
  co = checkout
  df = diff
  dft = difftool
  lg = log -p
  lol = log --graph --decorate --oneline
  lola = log --graph --decorate --oneline --all

[merge]
  tool = bc3

[diff]
  tool = bc3

[push]
    default = current

[color]
  ui = auto

[difftool "kaleidoscope"]
  cmd = ksdiff-wrapper git \"$LOCAL\" \"$REMOTE\"

[difftool "bc3"]
	cmd = beyondcompare-diff.sh \"$LOCAL\" \"$REMOTE\"

[difftool]
  prompt = false

[mergetool "bc3"]
  cmd = beyondcompare-merge.sh \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"
  trustExitCode = true
  keepBackup = false

{% endcodeblock %}

Notice the difftool section of "bc3". It is told to trigger an external script named beyondcompare-diff.sh. This is a much better version of a simpler script that I had to written accomplish the same thing (I can't even remember where I was pointed to these scripts, but I thank the author for sharing them):

[Configuration Scripts](http://gist.github.com/564573)

In my unix environments I have a folder called devtools that lives at the following location:

{% codeblock bash %}
 /home/repositories/developwithpassion/devtools/ 
{% endcodeblock %}

Automation is a folder where I keep all of my scripts and files that are shared between the different unix envionments that I run:

* Cygwin
* OSX
* Ubuntu

To ensure that all of my automation scripts are accessible I have the following line in my .bash_env file:

{% codeblock bash %}
export PATH="/usr/local/sbin:/usr/local/mysql/bin:$(find ~/repositories/developwithpassion/devtools/automation/ -name '.*' -prune -o -type d | tr "\n" ":"):$PATH"
{% endcodeblock %}

Notice the one section in path:

{% codeblock bash %}
$(find ~/repositories/developwithpassion/devtools/automation/ -name '.*' -prune -o -type d | tr "\n" ":"):$PATH"
{% endcodeblock %}

This ensures that any existing or new scripts that I drop under the automation folder, are picked up right away. Following this simple convention, I have a folder under the automation folder named git, that contains all of the scripts that are meant to be leveraged in the context of git.

Hopefully this will help you out if you need to configure bc3 on windows under cygwin!!

[Develop With Passion®](http://www.developwithpassion.com)

[bc]: http://www.scootersoftware.com/ 
