---
layout: post
title: "Simple Script To Create Directory Specific Gemsets"
date: 2013-05-23 18:18
comments: true
categories: [programming]
---
When I'm working on ruby based projects I use rvm to manage and switch between differing ruby versions and gemsets.

I don't ever keep my .ruby-version or .ruby-gemset files (or the old .rvmrc) under version control. Which means that I have to recreate them each time I clone a copy of the project. Sometimes I will have the same project cloned out in differing folders. I have usually tried to keep folder specific gemsets; that way I don't have to get creative with gemset names as the gemset is basically the full path of the folder that I am in.

Here is the script that I use to create a new .ruby-version and .ruby-gemset in the current folder that I am in:

{% codeblock lang:ruby RVM Gemset Create - rvmgsc %}
#!/usr/bin/env ruby
def rubies
  ruby_pattern = /\s*(ruby-.*)\s\[/

  rubies = `rvm list`
  rubies = rubies.split("\n")
  rubies = rubies.select{ |item| ruby_pattern =~ item }
  rubies = rubies.map{ |item| ruby_pattern.match(item)[1] }
  rubies.sort! { |left, right| right <=> left }

  rubies
end

def pick_ruby_version
  puts "Which Ruby Version?"
  versions = rubies
  versions.each_with_index do |version, index|
    puts "\t#{index + 1} - #{version}"
  end
  puts "Which?: "
  version = gets.chomp.to_i
  version = version - 1
  versions[version]
end

def ruby_version
  return pick_ruby_version if ARGV.length == 0

  version = ARGV[0]
  full_version = "ruby-#{version}"

  return full_version
end

def gemset_name(gemset)
  gemset = gemset.gsub(/[\/\-\s]/,'_')
  gemset = gemset.gsub(/_{2,}/,'_')
  gemset = gemset.slice(1, gemset.length)
  gemset.downcase
end

gemset = gemset_name(Dir.pwd)

`echo #{ruby_version} > .ruby-version`
`echo #{gemset} > .ruby-gemset`

{% endcodeblock %}

This file is marked executable and in my path (I name it rvmgsc). Whenever I enter a new folder that I want a gemset for I can call it either with an argument of the ruby version that I want to use. If I don't pass any arguments it will list the ruby versions that I have and let me choose. The script will then continue to make an .ruby-version and .ruby-gemset file, with the correct contents.

[Develop With Passion®](http://www.developwithpassion.com)
