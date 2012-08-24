---
layout: post
title: "Quickly setting up Autospec and Growl for TDD goodness in Ruby!!"
comments: true
date: 2010-08-17 09:00
categories: [tools, ruby, bdd]
---
Do you want to quickly get going with tdd in ruby? Here is the simplest rundown to get a working effective tool stack that will help you start coding more effectively in a test driven fashion in your ruby environment. I am not even discussing rails here at the moment, along with all of the tools that it brings to the table for testing. Just core ruby.

##Basic Requirements

For this post I am assuming an osx based environment, mostly for the growl ability. All of the other tools that are mentioned will work without issue on a regular unix based environment (I have not tried this stuff on the windows platform yet):

* [Ruby](http://ruby-lang.org) - Need I say more
* [Growl](http://growl.cachefly.net/Growl-1.2.1.dmg) - install this so that you will later on be able to use growl notifications (think toast windows).
* [RVM](http://rvm.beginrescueend.com/) - Ruby Virtual Machine. This is a great tools to keep you base ruby installation completely clean, as well as be able to install/test multiple versions of ruby against your application. You don't need to install this, but I would strongly recommend it.  
  
  
  
##Gems

Assuming an installed ruby version of 1.8.7, here are the steps from the command line:

* gem install rspec
* gem install autotest
* gem install autotest-growl
* gem install autotest-fsevent

That's about it for the gems you need to install. Autotest is a tool that you can use to monitor your working folder in the background and it will automatically rerun the accompanying tests if there are changes to any of the items under lib/specs directory. RSpec has a thin wrapper around autotest called autospec. It has a default convention that it uses to monitor for file changes in your application. With the default convention, you just need to make sure that:

* your test code lives under a folder named spec
* your production code is in the lib folder

The last pieces of the puzzle is to hook into autotest to do the growl notification. I created a folder under my devtools folder named spec_growl add a simple .autotest file to your root directory that contains a couple of hooks into the AutoTest, I took a script that I found at [this location](http://pastie.org/227704) and just modified it slightly.

{% codeblock lang:ruby %}
#!/usr/bin/env ruby
AUTOTEST_IMAGE_PATH = File.dirname(File.symlink?(__FILE__) ? File.readlink(__FILE__) : File.expand_path(__FILE__))
MATCH_PATTERN = /\d+\s.*examples?,\s\d+\s.*failures?(?:,\s\d+\s.*pending)?/

module Autotest::Growl
  def self.display(results,image)
      growl "Spec Results", "#{results}", File.join(AUTOTEST_IMAGE_PATH,"#{image}.jpg")
  end

  def self.get_result_image(output)
    if output =~ /[1-9]\sfailures?/ || output =~ /errors/
      "red"
    elsif output =~ /pending/
      "pending"
    else
      "green"
    end
  end

  Autotest.add_hook :ran_command do |autotest|
    filtered = autotest.results.grep(/\d+\s.*examples?/)
    output = filtered.empty? ? "errors" : filtered.last.slice(MATCH_PATTERN)
    display(output,get_result_image(output))
  end

  private 
    def self.growl (title, message, image)
      system "growlnotify -n autotest --image #{image} -m #{message.inspect} #{title}"
    end

end

Autotest.add_hook :initialize do |autotest|
  %w{.svn .hg .git vendor}.each {|exception| autotest.add_exception(exception)}
end
{% endcodeblock %}

Either save that file to your home folder (~) with the name ~/.autotest. Or create a symlink to the file with a name of ~/.autotest. I have it all located in a folder under my devtools folder: 

{% codeblock bash %}
~/repositories/developwithpassion/devtools/mac/spec_growl/  
{% endcodeblock %}

This also allows me to put in custom images for the files:

* red.jpg
* green.jpg
* pending.jpg

Now you are ready to hit the ground running and start writing some tests!

##Screencast

The following screencasts demonstrates how it all works:

<object width="400" height="300"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=14196257&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=1&amp;color=&amp;fullscreen=1&amp;autoplay=0&amp;loop=0" /><embed src="http://vimeo.com/moogaloop.swf?clip_id=14196257&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=1&amp;color=&amp;fullscreen=1&amp;autoplay=0&amp;loop=0" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="300"></embed></object><p><a href="http://vimeo.com/14196257">AutoSpec Demo</a> from <a href="http://vimeo.com/user3741625">Jean-Paul Boodhoo</a> on <a href="http://vimeo.com">Vimeo</a>.</p>

[Develop With Passion®](http://www.developwithpassion.com)
