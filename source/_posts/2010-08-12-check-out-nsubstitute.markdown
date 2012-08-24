---
layout: post
title: "Check out NSubstitute"
comments: true
date: 2010-08-12 09:00
categories: [tools, c#]
---

A couple of [develop with passion][dwp] alumni have been heads down and hard at work on a new framework that can be used to facilitate a slightly different way to do mocking. 

The name of the project is [nsubstitute](http://nsubstitute.github.com/). I have not used it yet, but the usage looks very simple. 

Taken directly from the site. If you have a contract as follows:

{% codeblock lang:csharp %}
public interface ICalculator
{
  int Add(int a, int b);
  string Mode { get; set; }
  event Action PoweringUp;
}
{% endcodeblock %}

You can create the fake and setup expectation as simply as this:

{% codeblock lang:csharp %}
calculator = Substitute.For<ICalculator>();

calculator.Add(1, 2).Returns(3);
Assert.That(calculator.Add(1, 2), Is.EqualTo(3));
{% endcodeblock %}

One of the things I challenge each of my students on is to have fun exploring their code, and challenging theirs and others assumptions about how things should be done. I think exploration and play are two elements that can help you become a great programmer. So I applaud them for "exploring" and playing around with this.

Their "Why use it?" section of their site says it best:

> There are already some great mocking frameworks around for .NET, so why create another? We found that for all their great features, none of the existing frameworks had the succinct syntax we were craving — the code required to configure test doubles quickly obscured the intention behind our tests.
> 
> We've attempted to make the most frequently required operations obvious and easy to use, keeping less usual scenarios discoverable and accessible, and all the while maintaining as much natural language as possible.
> 
> Perfect for those new to testing, and for others who would just like to to get their tests written with less noise and less lambdas.


It's always great to play around with the way you do things!!

If you have a couple of minutes to spike out a different tool, you may want to take a quick look at it and see what kind of things it brings to the table.

[Develop With Passion®](http://www.developwithpassion.com)

[dwp]: http://www.developwithpassion.com



