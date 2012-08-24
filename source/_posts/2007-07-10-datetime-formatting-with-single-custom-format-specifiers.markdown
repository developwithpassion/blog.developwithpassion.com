---
layout: post
title: "DateTime Formatting with single custom format specifiers"
comments: true
date: 2007-07-10 09:00
categories:
- .net 2.0
- .net 3.0
- c sharp
---

I may be the last one in the .Net world to find this one out!! Say you wanted to execute the following string format statement:

 
{% codeblock lang:csharp %}
return string.Format("{0:MMMM} {0:d}-{1:d}, {0:yyy}", start, end); 
{% endcodeblock %}




The result of that format command would be: January 1/1/2007-1/7/2007, 2007. This is obviously not what I was expecting. In order to specify a single character format specifier I have to use the following:
{% codeblock lang:csharp %}
return string.Format("{0:MMMM} {0:%d}-{1:%d}, {0:yyy}", start, end); 
{% endcodeblock %}




Which results in the following output: January 1-7, 2007 (which is what I wanted).

Notice the use of the % format specifier prior to the single digit day format specifier. That is what I was missing. If you want to know more about how this works check out the documentation [here](http://msdn2.microsoft.com/en-us/library/8kb3ddd4(vs.80).aspx#UsingSingleSpecifiers).

Develop with passion!




