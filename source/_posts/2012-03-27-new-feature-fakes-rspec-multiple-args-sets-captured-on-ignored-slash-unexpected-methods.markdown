---
layout: post
title: "New Feature: fakes-rspec - multiple args sets captured on ignored/unexpected methods"
date: 2012-03-27 23:02
comments: true
categories: 
---
Just added a new feature to fakes-rspec to handle a scenario I ran into. The following test will hopefully explain it:

{% codeblock Interrogating Multiple Argument Sets on the same ignored method - ignored.rb %}
context "when expanding all of the items" do
  let(:folder){"item"}
  let(:target){"blah"}
  let(:sources){[]}
  let(:args){:sources => sources,:shell => fake} #this syntax is incorrect, but the formatting was getting garbled
  subject{Copy.new(target,args)}

  before (:each) do
    %w[1 2 3].each{|item| sources << item}
  end

  before (:each) do
    subject.expand_all_items
  end

  it "should copy each of the sources to the target" do
    sources.each do|source|
      item = "cp -rf #{source} #{target}"
      shell.should have_received(:run,item)
    end
  end
end
{% endcodeblock %}

The following line:

{% codeblock Verifying a Call - verify.rb %}
shell.should have_received(:run,item)
{% endcodeblock %}

I am testing to see whether the run method (which was never set up to get explicitly called), was actually called 3 different times, and am also verifying that each time it was called it was called with a specific set of arguments.

In the test above I am verifying that for each "source", a call was made to do a recursive, forced copy, to the "target" location.

Not needing to specify the call while also being able to verify each of the argument sets on each of the 3 invocations of the same method is handy, and introduced solely so I could support this feature that I was working on.

[Develop With Passion®](http://www.developwithpassion.com)
