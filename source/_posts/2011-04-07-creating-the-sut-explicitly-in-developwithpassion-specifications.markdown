---
layout: post
title: "Creating the SUT explicitly in developwithpassion.specifications"
comments: true
date: 2011-04-07 09:00
categories: [developwithpassion.specifications]
---
There will be times when you will want to explicilty specify how the SUT should be created when you are inheriting from either of the following classes:

* Observes< SUT >
* Observes< Contract , SUT >

To accomplish this you need to leverage the following block of code in the Establish block for your context:

{% codeblock lang:csharp %}
  sut_factory.create_using(factory);
{% endcodeblock %}

Factory will be of type SUTFactory<SUT> which is bascially just a delegate type that takes no arguments and returns an instance of the system under test.

Most likely you will be using it as follows:

{% codeblock lang:csharp %}
  sut_factory.create_using(() => new Calculator()) 
{% endcodeblock %}

Hope this helps out!!

[Develop With Passion®](http://www.developwithpassion.com)

