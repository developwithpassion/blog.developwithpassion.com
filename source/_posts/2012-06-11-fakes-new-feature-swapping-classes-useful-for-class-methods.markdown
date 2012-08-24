---
layout: post
title: "fakes - New Feature - Swapping Classes (useful for class methods)"
date: 2012-06-11 08:26
comments: true
categories: [ruby,tdd]
---
Just added another new feature to [fakes](http://github.com/developwithpassion/fakes) to support something I was doing.  

The feature in question is the ability to swap out classes at test time. The most useful aspect for this is in both configuring and monitoring calls made to class methods. Up until now, I have just used the rspec (predominant testing library I use) out of box mechanism to do this. With this feature added now, I don't need to use any of the out of box rspec mocking features.

Here is an example of using the capability to monitor a call made to delete a file:

{% codeblock Monitoring a call made to the File class - class_swapping_example_1.rb %}
class DeleteFileCommand
  def initialize(filename)
    @filename = filename
  end
  def run
    File.delete(@filename)
  end
end
context "when run" do
  let(:filename){'blah.rb'}
  let(:sut){DeleteFileCommand.new(filename)}
  before (:each) do
    fake_class File # I usually use multiple before blocks to separate setup from invoking the method I am testing, this could also be in the before block below
  end

  before (:each) do
    sut.run
  end

  it "should delete the file" do
    File.should have_received(:delete,filename)
  end
end
{% endcodeblock %}

The use of the new fake_class method creates a fake instance (using the existing fake infrastructure) and uses it to be the value used for all class methods on the specified class. You can notice how in the assertion we are verifying that the File class received a call to the delete method with a specified argument. This mechanism is identical to how you can already verify calls made to fakes, with all of the goodness of the [new arg matching capabilities](http://blog.developwithpassion.com/2012/06/09/fakes-and-in-turn-fakes-rspec-new-feature-arbitrary-argument-matching-for-setup-and-verification-of-calls/) also available to use.

When you make use of the fake_class method, from that point on any reference to the class that you specified is now talking to the fake. Which means you can also treat it like any other fake when you are setting up fake behaviour. Here is another example:


{% codeblock setting up fake return values -  fake_return_values.rb %}

before(:each) do
  fake_class File

  File.stub(:exist?).with(arg_match.any).and_return(true)
end

it "should never have a file that does not exist" do
  File.exist?('totally_non_existent_file').should be_true
end
{% endcodeblock %}


Hopefully you can see that is a contrived example, but it demonstrates how you can setup behaviours now fully using fakes and not needing to mix and match between fakes and (in my original case, RSpec mocks and stubs).

[fakes-rspec](http://github.com/developwithpassion/fakes-rspec) has already been rebuilt against this library to take advantage of this feature. The only change that was added to it was literally the following lines of code:

{% codeblock fakes-rspec changes - changes_to_fakes_rspec.rb %}
RSpec.configure do |config|
  config.after(:each) do
    reset_fake_classes
  end
end
{% endcodeblock %}

This just ensures that after each test run, the classes get reset back to their original behaviour. Which means if you are already using fakes-rspec, you can just start using by updating to the latest version!!

[Develop With Passion®](http://www.developwithpassion.com)
