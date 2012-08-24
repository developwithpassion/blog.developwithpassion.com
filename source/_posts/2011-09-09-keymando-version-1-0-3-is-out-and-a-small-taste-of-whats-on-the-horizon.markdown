---
layout: post
title: "Keymando - Version 1.0.3 is out and a small taste of what's on the horizon!!"
comments: true
date: 2011-09-09 09:00
categories: [tools, keymando, ruby, objective-c]
---
[Keymando](http://keymando.com) version 1.0.3 is out, and we have opened up a long awaited trial mode so that people can give it a whirl.  We understand that a $20 price tag for most developers is not spent lightly, so we want to make sure that people get time to play with it. For anyone who knows me and know what a keyboard freak I am, I can literally say, that I can't even use a machine that does not have this program on it anymore!! I am going to create some small 1-2 minute screen casts that will
demonstrate some of the worflows that I use on a day to day basis.  

There are many constructs, algorithms and patterns that go into making this thing sing. [Kevin](http://kevin.colyar.net) and I are hard at work adding new features, and for now we are going to keep the lid closed on 2 awesome features that are coming down the pipe. I can say with complete confidence that it will revolutionize the way you use osx with the keyboard!!

It is also beneficial to know that we have a small, but growing, community of plugin developers who are writing freely available plugins and making them available through the official [keymando plugin repository](https://github.com/keymando). 2 that I use quite often are the:

1. [underscore](https://github.com/keymando/underscore) - Great if you like to type with underscores when you code (or if you are like me, all over the place!!)
2. [abbrev](https://github.com/keymando/abbrev) - An abbreviation plugin that emulates complex text expansion!!

What more OSX power users and developers need to realize, is that there is so much you can do for customization if you know how to code ruby. For regular users we are keeping the barrier to entry as low as possible and keeping the dsl as "simple" for the 80/20 rule. For developers who know ruby, well, you are really only limited by your imagination.

We are going to be adding more capabilities to the core pipeline that will be exposed to plugin developers, or just simple config scripts. So hold onto your hats!! For now we are also not focusing on any fancy user interfaces, as we are currently focusing on growing the core engine. The pretty UI's for some of the features will come in time!!

For now, I'll leave you with a large section of code from my current .keymandorc.rb file (the main configuration script). Keep in mind that some of the code in this file is based on the main line of development!! Hopefully most of it will be self descriptive enough for me to not need to include comments.

{% codeblock lang:ruby %}
  
# Ignore the following apps
disable "Remote Desktop Connection"
disable /VirtualBox/

#commands----------------------------------------------------
launch_firefox = launch("Firefox")
quit_the_current_application = send_keys("<Cmd-q>", :description => "Quit current application",:remember => true)
vimperator_pass_through_mode = send_keys("<Shift-Escape>")
gmail_send_new_mail = send_keys("<Shift-Tab>" * 6)
gmail_send_reply_mail = send_keys("<Shift-Tab>" * 5)
gmail_discard_new_mail = send_keys("<Shift-Tab>" * 4)
gmail_discard_reply_mail = send_keys("<Shift-Tab>" * 3)
screen_flow_stop_recording = send_keys("<Cmd-Shift-2>")
window_hide_current = send_keys("<Cmd-w>")
#end_commands----------------------------------------------------
 
#----------------------------------------
#core_shortcuts
#----------------------------------------
toggle "<Cmd-9>"
map "<Cmd-d>","<Cmd-Shift-Tab>"
map "<Cmd-e>", "<Escape>"
map "<Cmd-f>","<Cmd-Tab>"
map "<Cmd-h>", "<Left>"
map "<Cmd-j>", "<Down>"
map "<Cmd-k>", "<Up>"
map "<Cmd-l>", "<Right>"
map "<Cmd-m>", "<Tab>"
map "<Cmd-,>", "<Shift-Tab>"
map "<Cmd-n>", "<Ctrl-n>"
map "<Cmd-r>", RightClick.instance
map "<Cmd-0>", "<Cmd-Shift-D>"
map "<Cmd-c>",RunLastCommand.instance
map "<Cmd- >", launch_quicksilver

# end_core_shortcuts---------------------

#mnemonic_mappings-----------------------
@window_management= {
    "wm" => mercury_mover_move_window,
    "wfs" => Divvy.full_screen,
    "wtl" => Divvy.top_left,
    "wtr" => Divvy.top_right,
    "wbl" => Divvy.bottom_left,
    "wbr" => Divvy.bottom_right,
    "wl" => Divvy.left,
    "wr" => Divvy.right,
    "wt" => Divvy.top,
    "wb" => Divvy.bottom,
    "wc" => Divvy.center,
    "w" => window_hide_current
  }

@itunes = {
  "iiv" => itunes_increase_volume,
  "div" => itunes_decrease_volume,
  "bt" => itunes_browse_tracks
}

@firefox = {
  "fi" => launch_firefox,
  "pp" => vimperator_pass_through_mode
}
 

@quicksilver ={
  "mi" => show_current_menu_items,
  "wi" => show_current_app_windows
}
 
@gmail ={
  "msn" => gmail_send_new_mail ,
  "msr" => gmail_send_reply_mail,
  "mdn" => gmail_send_reply_mail,
  "mdr" => gmail_discard_reply_mail
}
 
@skype ={
  "sl" => skype_login,
  "scp" => skype_call_phones
}

@sound = {
  "sts" => switch_to_speakers,
  "sti" => switch_to_imic
}
 
@general_mappings = {
  "aa" => app_code_all_items,
  "rel" => reload_configuration,
  "ls" => lock_the_screen,
  "x" => quit_the_current_application,
  "gmm" => gotomeeting_mute_me,
  "sr" => screen_flow_stop_recording,
  "ntt" => things_new_task,
  "jj" => RunHistoryItem.instance
}
#end_mnemonic_mappings------------------------------------------------------------

map "<Cmd-y>" do 
  input(@general_mappings
         .merge(@window_management)
         .merge(@itunes)
         .merge(@firefox)
         .merge(@quicksilver)
         .merge(@gmail)
         .merge(@skype)
         .merge(@sound)
        )
end
{% endcodeblock %}

Happy keyboarding!!

[Develop With Passion®](http://www.developwithpassion.com)
