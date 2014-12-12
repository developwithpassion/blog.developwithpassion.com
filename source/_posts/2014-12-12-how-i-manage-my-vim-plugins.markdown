---
layout: post
title: "How I manage my vim plugins"
date: 2014-12-12 10:26
comments: true
published: true
categories: [vim]
---
Way before tools like Vundler and the like came out for vim, as a perpetual automation junkie, I was constantly refining my workbench when it came to how to manage my vim plugins. What started off as a basic script has turned into a tiny ruby configuration tool that I can use to manage the downloading of my vim plugins. As a play on the tool it is mimics, I've called in VRundler, and since it evolved (very slightly) from basic script I wrote, there is no coverage (gasp!). I've ran my current configuration script
successfully on Windows, OSX, and Linux and it works great. I'm just throwing this out there to demonstrate how I manage one of my tools. I'm not remotely suggesting people use this in place of Vundle, this is just another example of a different style of automation. Here is my current configuration script:

```ruby
def windows?
  RUBY_PLATFORM =~ /(ming|cyg)/
end

bundles_folder = File.expand_path("~/repositories/developwithpassion/devtools/shared/dotfiles/vim/.vim_runtime/bundle")
open_source_folder = File.expand_path("~/repositories/open_source")

#A utility method I am using to build a qualified github user name that uses an ssh config host from my ssh configuration file
def github_user(name)
  "github:#{name}/"
end

# Specify the path where you want your bundles installed
bundles_dir bundles_folder

# A git group allows you to specify a git user you wish to clone vim plugins from
git github_user('vim-scripts') do
  # A bundle is a named vim plugin repo for the user, you can specify
  # multiple as the method accepts a splat of bundles, this is useful if you are
  # getting multiple plugins from a single author, you can also specify each plugin
  # with separate calls to: bundle '[PLUGIN]'
  bundle 'dbext.vim',
    'vimgrep.vim'
end

git github_user(:altercation) do
  bundle 'vim-colors-solarized'
end

git github_user(:benmills) do
  bundle 'vimux'
end

git github_user(:developwithpassion) do
  bundle 'TwitVim'
end

# A symlink bundle is just a vim plugin that is on your local file system somewhere 
# and you want it symlinked into your vim bundle folder, the first argument is 
# the name the symlink will be given in your plugin folder
symlink :dwp_vim_general, File.join(open_source_folder, 'dwp_vim_general')

git github_user(:ecomba) do
  bundle 'vim-ruby-refactoring'
end

git github_user(:elzr) do
  bundle 'vim-json'
end

git github_user(:ervandew) do
  bundle 'supertab'
end

git github_user(:OrangeT) do
  bundle 'vim-csharp'
end

git github_user(:nanotech) do
  bundle 'jellybeans.vim'
end

git github_user(:kana) do
  bundle 'vim-fakeclip'
end

git github_user(:kien) do
  bundle 'ctrlp.vim'
end

git github_user(:MarcWeber) do
  bundle 'vim-addon-mw-utils'
end

git github_user(:scrooloose) do
  bundle 'syntastic' , 
    'nerdtree'
end

git github_user(:jistr) do
  bundle 'vim-nerdtree-tabs'
end

git github_user(:sukima) do
  bundle 'xmledit'
end

git github_user(:timcharper) do
  bundle 'textile.vim'
end

git github_user(:thoughtbot) do
  bundle 'vim-rspec'
end

git github_user(:pangloss) do
  bundle 'vim-javascript'
end

git github_user(:SirVer) do
  bundle 'ultisnips'
end unless windows?

git github_user(:garbas) do
  bundle 'vim-snipmate'
end if windows?

git github_user(:tomtom) do
  bundle 'tcomment_vim', 
    'tlib_vim'
end

git github_user(:tpope) do
  bundle 'vim-cucumber', 
    'vim-endwise', 
    'vim-fugitive', 
    'vim-git', 
    'vim-haml', 
    'vim-markdown', 
    'vim-rails', 
    'vim-repeat',
    'vim-surround', 
    'vim-vividchalk'
end

git github_user(:Lokaltog) do
  bundle 'vim-distinguished'
end

git github_user(:rizzatti) do
  bundle 'dash.vim'
end

git github_user(:Valloric) do
  unless windows?
    # This demonstrates configuring the bundle using a block, in this 
    # example I am chdir'ing into the bundle folder after it has downloaded
    # and running a system command to configure the plugin, in this case for 
    # YouCompleteMe it initializes its submodules and then installs 
    # the native extensions
    bundle 'YouCompleteMe' do |b, context|
      b.after_download do 
        Dir.chdir(context.output_folder(b)) do
          system("git submodule update --init --recursive && ./install.sh")
        end
      end
    end
  end
  bundle 'MatchTagAlways'
end

git github_user('vim-ruby') do
  bundle 'vim-ruby'
end

git github_user('zweifisch') do
  bundle 'pipe2eval'
end

git github_user('hdima') do
  bundle 'python-syntax'
end

# A vimscripts group allows you to pull down individual script files from vimscripts.org
vimscripts do
  
  # when you define a group inside a vimscripts section, the first arugment specifies
  # what type of plugin the script is
  group :plugins do
    script 'IndexedSearch', 7062
    script 'autotag', 12473
    script 'DirDiff', 13435
  end

  group :syntax do
    script 'jquery', 12276
  end
end

# A vimzips group allows you to pull down individual zip files from vimscripts.org
vimzips do
  zip :vimgrep, 3407 
  zip :bufexplorer, 20953
end
```
The above config file (which is just a ruby script) demonstrates all fo the main type of vim plugins:

* Git based
* Script based
* Zip based
* Symlinked from local machine

I should also mention, that I am using pathogen for plugin resolution, so this utility primarily just deals with the downloading of said plugins!

[Develop With Passion®](http://www.developwithpassion.com)
