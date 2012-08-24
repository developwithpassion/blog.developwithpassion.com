---
layout: post
title: "TwitVim and Direct Message - Getting Them Working Again"
comments: true
date: 2011-07-02 14:00
categories: [tools, vim]
---
For the last couple of year I have been using Vim to twitter using the awesome [TwitVim](http://www.vim.org/scripts/script.php?script_id=2204) client. I like to keep the distraction factor low during my days, so it is a client that matches both criteria of:  

* Using Vim for as many of many of my day to day tasks as possible.
* No annoying toast windows, popups or the like to pull the focus away.

I just went to check some direct messages and I got good old error code 93:"This application is not allowed to access or delete your direct messages".

This has to do with the OAuth token being an old token that is no longer valid for the new permission scheme.

Simple fix was to:  

1. Delete the twitvim_token_file (by default in $HOME/.twitvim.token)
2. Try and access twitvim functionality again - which will force a reauthentication and issuing of a new oauth token.  

After that everything is working again as normal.

[Develop With Passion®](http://www.developwithpassion.com)
