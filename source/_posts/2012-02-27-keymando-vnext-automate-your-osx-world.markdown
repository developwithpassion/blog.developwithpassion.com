---
layout: post
title: "Keymando vNext - Automate Your OSX World"
comments: true
date: 2012-02-27 09:00
categories: [tools, keymando, automation]
---
Between working full time jobs and lots of other responsibilities, Kevin and I are putting the final touches on the next release of [Keymando](http://keymando.com)!!

For a long time, we have observed that a large majority of Keymando users are using the tool for just basic shortcut remapping. Since we both use this tool all the time, it is now time to show off some of things it can do, and believe me when I say, that using it for jusk key remapping is a big waste of its potential.

Over the course of the next couple of weeks, I am going to be giving presentations to existing, and hopefully some new users, to show them what they can do with this tool, and the infinite customizations that are now possible with a bit of Ruby magic!!

If you take a look at my current [Keymando Configuration Scripts](https://github.com/developwithpassion/keymando_files) you can see how "basic" my regular shortcut mapping is:

{% codeblock keymandorc.rb %}
toggle "<Cmd-9>"
map "<Cmd-e>", "<Escape>"
map "<Cmd-Shift-d>", "<Cmd-Shift-Tab>"
map "<Cmd-d>", current_app_windows
map "<Cmd-f>", trigger_app
map "<Cmd-Shift-f>", "<Cmd-Tab>"
map "<Cmd-h>", "<Left>"
map "<Cmd-j>", "<Down>"
map "<Cmd-k>", "<Up>"
map "<Cmd-l>", "<Right>"
map "<Cmd-m>", "<Tab>"
map "<Cmd-,>", "<Shift-Tab>"
map "<Cmd-n>", "<Ctrl-n>"
map "<Cmd-r>", RightClick.instance
map "<Cmd-0>", "<Cmd-Shift-D>"
map "<Cmd-o>",RunLastCommand.instance
map "<Cmd- >", launch_app
map "<Cmd-i>", RunHistoryItem.instance
map "<Cmd-p>", hit_a_hint
map "<Cmd-y>", run_registered_command
{% endcodeblock %}

The 2 biggest new changes to the Keymando internal engine is that almost everything is modelled as commands. This allows for history, replaying and a host of other features. And the 2nd biggest new feature is the addition of an automation layer we are dubbing the Keymando Automation Engine. To see this engine in action, take a look at my script to manipulate iTunes:

{% codeblock Creating Command To Press iTunes Menu Items - itunes.rb %}
itunes_command_for_button("iTunes Play",/Play\s*space/)
itunes_command_for_button("iTunes Pause",/Pause\s*space/)
itunes_command_for_button("iTunes Stop",/Stop\s*space/)
itunes_command_for_button("iTunes Previous Song",/Previous/)
itunes_command_for_button("iTunes Next Song",/Next/)
itunes_command_for_button("iTunes Increase Volume",/Increase Volume/)
itunes_command_for_button("Decrease iTunes Volume",/Decrease Volume/)
{% endcodeblock %}

This is code in one of my configuration scripts under my plugins folder. It will setup one command for each iTunes function. Here is the code for the itunes_command_for_button method (written in the same plugin script):

{% codeblock Leveraging The Command DSL - command.rb %}
def itunes_command_for_button(name,name_reg_ex)
  Command.to_run :description => name do
    add_block do
      itunes_button(name_reg_ex).press
    end
  end
end
{% endcodeblock %}

Notice the use of the simple dsl for registering a command. This is one of 2 dsl's for registering commands. At the completion of the dsl block, a new command with the name provided in the description will be place in the set of available commands to run. And finally, the itunes_button method, shows the use of the Keymando Automation Engine to find the actual button:

{% codeblock Using The Keymando Accessiblity API - accessiblity.rb %}
def itunes_button(name_reg_ex)
  app = Accessibility::Gateway.get_application_by_name "itunes"
  return app.menu_bar.find.first_item_matching(:title => Matches.regex(name_reg_ex))
end
{% endcodeblock %}

I will be doing more posts on the Automation Engine over the next little while. In the meantime, looking through the scripts in my GitHub repository should give you an idea of what some of the capabilities are.

The net result of registering all of those commands is that when I press Cmd-y (which is my mapping to run a registered command), it will pop up a list of all of the registered commands based on my settings:

<div class="thumbnail"><a href="http://skitch.com/jpboodhoo/8fff6/keymando"><img src="http://img.skitch.com/20120227-ntncga3g9f32ncb1yq7rm773ae.preview.jpg" alt="Keymando" /></a><br /><span>Uploaded with <a href="http://skitch.com">Skitch</a>!</span></div>

[Develop With Passion®](http://www.developwithpassion.com)
