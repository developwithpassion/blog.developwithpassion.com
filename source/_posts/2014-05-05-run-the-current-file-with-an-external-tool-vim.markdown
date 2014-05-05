---
layout: post
title: "Run the current file with an external tool - Vim"
date: 2014-05-05 11:02
comments: true
categories: [vim]
---
There are lots of times when I am working with a file in vim that I want to be able to trigger an external tool against the current file.

Of course, I can drop to a shell or enter ex mode, but most of the time I would like to be able to just trigger a mapping that executes the external tool against the current file. An example of this would be editing a javascript file and being able to have it executed by nodejs, or editing a ruby file and being able to have it executed by the interpreter.

I set up the current script in my custom plugins folder (you can just place it in your .vimrc if you want a simple start):

{% codeblock lang:vim %}
if !exists("g:external_tool")
  let g:external_tool = "echo {current_file}"
endif

function! RunCurrentFileWithExternalCommand()
  let l:current_file = @%
  let l:command = "!clear && echo " . g:external_tool . " && " . g:external_tool
  execute substitute(g:external_tool, "{current_file}", l:current_file, "g")
endfunction
{% endcodeblock %}

The following line:

{% codeblock lang:vim %}
let g:external_tool = "echo {current_file}"
{% endcodeblock %}

Sets up an global external_tool variable that is initialized to the echo command (not immediately useful!). Notice the use of {current_file}, this is just a placeholder that will be replaced in a later substitution.

The RunCurrentFileWithExternalCommand function captures the name of the current file into the local variable current_file:

{% codeblock lang:vim %}
let l:current_file = @%
{% endcodeblock %}

The @ operator lets you address the contents of a register. The % register is the register that contains the name of the current file being edited. The next line:

{% codeblock lang:vim %}
let l:command = "!clear && echo " . g:external_tool . " && " . g:external_tool
{% endcodeblock %}

Sets up the command string that will be executed. The "." is how you do string concatenation in vim. In this case, if the g:external tool variable is not changed, the default command that would be run is:

{% codeblock lang:bash %}
clear && echo "the_current_file_name" && echo [the_current_file_name]
{% endcodeblock %}

Finally the substitute command is run to replace the {current_file} marker with the name of the current file, and then it is run through the execute command.

Here is an example of one of the mappings I have in place for a project I am currently working on:

{% codeblock lang:javascript %}
nnoremap <Leader>rnv :let g:external_tool = "vagrant ssh -c \"cd app && node {current_file}\""<CR>
{% endcodeblock %}

This command will run the current file I am editing against the vagrant instance that hosts the app and all of its dependencies. This allows my base machine to just be the editor.

Here are the remaining set of config I have for my vim setup to make this happen:

{% codeblock lang:vim %}
source ~/.vim_runtime/remaps.vim
{% endcodeblock %}

All of my main key remappings are defined in this file, here is the mapping that I have in my vimrc file to run the current file with the currently configured external tool is:

{% codeblock lang:vim %}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Running Current File
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>rrf :wa<cr> :call RunCurrentFileWithExternalCommand()<cr>
{% endcodeblock %}

With that setup, I can have folder specific mappings that alter the g:external_tool variable, and then I can always hit <leader>rrf to run the current file with the external tool.

[Develop With Passion®](http://www.developwithpassion.com)

