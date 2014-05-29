---
layout: post
title: "Updated TMUX, regaining splitting/creating new windows based on current directory"
date: 2014-05-28 20:16
comments: true
categories: [tmux, unix]
---
Just upgraded my copy of tmux and went to split my windows and realized that the default behaviour to split the window based on the current directory disappeared.

The quick fix to this for me (could be a better one, but I have not done any research yet) was to remap my map binding to augment the commands to maintain their old behaviour:

{% codeblock lang:bash Updating Tmux split bindings %}
bind c new-window -c '#{pane_current_path}'
bind-key d split-window -v -c '#{pane_current_path}'
bind-key % split-window -h -c '#{pane_current_path}'
{% endcodeblock %}

Each of these bindings maintain the exact same behaviour that was there prior to my tmux update. 

[Develop With Passion®](http://www.developwithpassion.com)
