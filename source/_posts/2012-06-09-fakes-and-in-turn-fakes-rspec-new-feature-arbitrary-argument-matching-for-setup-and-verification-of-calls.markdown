---
layout: post
title: "fakes (and in turn, fakes-rspec) new feature - Arbitrary argument matching for setup and verification of calls"
date: 2012-06-09 15:27
comments: true
categories: [ruby,tdd]
---
Just added a new feature to [fakes](http://github.com/developwithpassion/fakes) to support something I was doing, and it surprised me how I was able to wait until now to add it.  The change did not require any changes to the [fakes-rspec](http://github.com/developwithpassion/fakes-rspec) library whatsoever (aside from rebuilding it against the new version of fakes!!

The feature in question is the ability to do arbitrary matching of arguments during both the setup phase for a fake and also for the verification section.

Here is an example of using the capability in your before block to setup a fake to return values for a call:

{% codeblock Setting up a fake to return values when called by using argument matchers - arg_matching_setup.rb %}
context "when setting up a fake using a combination of real values and matchers" do
 before (:each) do
  fake_item.stub(:do_work).with(2,3,arg_match.regex(/y/).and_return(3)
 end

 it "should be able to return values when calls are made that match the matchers and the real values" do
   fake_item.do_work(2,3,'yes').should == 3
   fake_item.do_work(2,3,'y').should == 3
 end
end
{% endcodeblock %}

This is a really basic example, but basically, when you are setting up a method call, you can now specify either the explicit arguments the method should be called with to return a certain value, or you can use argument matchers, or both!! The arg_match method is a gateway to a factory that can create matchers. In pattern terms its a gatway to a specification factory!! You can use one of the prexisting methods:

* nil
* not_nil
* any
* greater_than
* in_range
* regex
* condition 

I could add more convienience methods, but they all end up calling into the condition method which just requires a block which matches the signaure:

{% codeblock condition method signature -  condition.rb %}
  {|item| bool}
{% endcodeblock %}

An example of using this to create an arbitrary matcher is as follows:

{% codeblock Creating an arbitrary matcher- arbitrary_matcher.rb %}
context "when setting up a fake using a combination of real values and matchers" do
 let(:fake_item){fake}

 before (:each) do
  fake_item.stub(:do_work).with(arg_match.condition{|item| [2,3].include?(item)},3,arg_match.regex(/y)).and_return(3)
 end

 it "should be able to return values when calls are made that match the matchers and the real values" do
   fake_item.do_work(2,3,'yes').should == 3
   fake_item.do_work(2,3,'y').should == 3
 end
end
{% endcodeblock %}

Hopefully you can see that is a contrived example, as we already have the in_range method that can handle that. Of course in place of either of those existing methods, or the condition method, you can just pass in something that responds to: matches?(item). Here is another contrived example:


{% codeblock Passing in your own matcher - custom_matcher.rb %}
context "when setting up a fake using a combination of real values and matchers" do
 let(:fake_item){fake}

 class CustomArgMatching
   def self.matches?(item)
    item  != 42
   end
 end

 before (:each) do
  fake_item.stub(:do_work).with(CustomArgMatching,3,arg_match.regex(/y/)).and_return(3)
 end

 it "should be able to return values when calls are made that match the matchers and the real values" do
   fake_item.do_work(2,3,'yes').should == 3
   fake_item.do_work(2,3,'y').should == 3
   fake_item.do_work(42,3,'y').should == nil
 end
end
{% endcodeblock %}

This same mechanism works identically when you are doing post invocation verification. Here is another example:


{% codeblock Post invocation verification - post_invocation_verification.rb %}
context "when verifying that calls are made, using argument matchers" do
 let(:fake_item){fake}

 before (:each) do
  fake_item.do_work(2,3,'yes')
 end

 it "should be able to make call verifications" do
   fake_item.should have_received(:do_work,2,3,'yes') # this is doing fully explicit matching on each argument
   fake_item.should have_received(:do_work,2,3,arg_match.regex(/y/)) # this is matching explicitly on the first 2 arguments and using a matcher on the last
   fake_item.should have_received(:do_work,arg_match.any,arg_match.any,arg_match.regex(/y/)) # this is matching using matchers for all 3 (even though the first 2 matchers are just a special case)
 end
end
{% endcodeblock %}

Whether you are in the setup phase or the verification phase the model is consistent. You can mix and match the matchers in place of real arguments as you need to. This ultimately gives you much better control on focusing on what it is you care about in the particular interaction you are observing!!

Hopefully you will find this as useful as I do!!

[Develop With Passion®](http://www.developwithpassion.com)
