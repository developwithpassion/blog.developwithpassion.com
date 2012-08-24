---
layout: post
title: "Another Rhino Mocks extension method to support your AAA style"
comments: true
date: 2008-08-30 09:00
categories:
- programming
---
If you want to carry on setting expectations on void methods on your mocks, just use the following method 


{% codeblock lang:csharp %}
public static IMethodOptions when_told_to(this T mock, Action action)
{
     return mock.Expect(action);
}
{% endcodeblock %}




Here is an example of the usage:
{% codeblock lang:csharp %}
db_connection.when_told_to(x => x.Open()) .Throw(new Exception());  
{% endcodeblock %}

Just another small play on words, but I like the readability of it. 

Develop With Passion!!




