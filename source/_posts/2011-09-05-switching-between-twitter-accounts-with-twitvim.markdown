---
layout: post
title: "Switching between multiple twitter accounts with TwitVim"
comments: true
date: 2011-09-05 09:00
categories: [vim, twitter]
---
For the last couple of years now, I have been making use of [TwitVim](http://www.vim.org/scripts/script.php?script_id=2204) to twitter from within vim. Seeing how much time I actually spend on twitter, it has been a good fit and enables me to help maintain focus without getting drowned out by the twitterverse. Plus I'm a vim freak, so the more I can use it for the better.

I often have to switch between posting/reading from multiple twitter accounts. In order to do this effectively, I came up with a quick hack to allow me to switch rapidly.  

Under my [devtools] folder I have an automation folder that contains a bunch of automation scripts that I have accumulated over the years. Under there I have my vim folder, here is the screenshot:

<div class="thumbnail"><a href="https://skitch.com/jpboodhoo/fsudd/terminal-zsh-80x24"><img style="max-width:638px" src="https://img.skitch.com/20110905-pc5swff4mftp8ypyi2p3perpg4.medium.jpg" alt="Terminal — zsh — 80×24" /></a><br /><span>Uploaded with <a href="http://skitch.com">Skitch</a>!</span></div>

As you can see, each of my OAuth tokens for the respective user accounts is stored in this folder. The twitvim script, is trivial ruby script to copy the appropriate token into the place where TwitVim looks for the token to do Twitter authentication:

{% codeblock lang:ruby %}
#!/usr/bin/env ruby

twitter_user = ARGV[0]

Dir.chdir(File.dirname(__FILE__)) do
  `cp #{twitter_user}.twitvim.token ~/.twitvim.token`
end
{% endcodeblock %}

Currently I can run this script passing in the account I want to switch to and startup vim and twitter using that account!!

What I want to be able to do is call this script from inside of Vim as so:

{% codeblock vim %}
function! Switch_twitter_user(user)
  ResetLoginTwitter
  let user_name = a:user
  let switch_command = "twitvim ".user_name.""
  .!switch_command
endfunction
{% endcodeblock %}

Only problem I am having is a bit of trouble with the last line of the function (shelling out with the command, I can't seem to get the substitution working correctly). I am just blasting this down right now, so, if anyone knows it would be greatly appreciated. That is literally the first vim script method I have written!!

That small wrinkle aside. You can be inside vim issue the ResetLoginTwitter command and then manually shell out to the twitvim script passing the correct username and you can carry on twittering on the different account.

Hope this helps!!

[Develop With Passion®](http://www.developwithpassion.com)



