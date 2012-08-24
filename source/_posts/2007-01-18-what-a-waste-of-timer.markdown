---
layout: post
title: "What a waste of timer"
comments: true
date: 2007-01-18 09:00
categories:
- .net 2.0
- c sharp
---

I was working on a project at a client site almost a month ago, and ran into an annoying issue with the System.Timers.Timer class. The following code snippet should demonstrate the issue clearly: 
 
{% codeblock lang:csharp %}
public static void Main() 
{
  System.Timers.Timer timer = new System.Timers.Timer(3000);
  timer.Elapsed+=delegate  
  {
    Console.WriteLine("About to throw unhandled exception");
    throw new Exception();
  };
  Console.ReadLine();
}
{% endcodeblock %}


 

If you go ahead an run this code you can quickly take note that the program does not die. It will continually output the message "About to throw unhandled exception" until you press a key and hit enter.

If , however, you make use of the System.Threading.Timer class :

 
{% codeblock lang:csharp %}
public static void Main() 
{
  Timer timer = new Timer(delegate 
  {
    Console.WriteLine("About to throw unhandled exception");
    throw new Exception();
  },null,3000,3000);
  Console.ReadLine();
}
{% endcodeblock %}


The program will die a horrible death (as expected) and you could deal with the error accordingly using a global error handler. Of course, using a global error handler is only useful if the unhandled error can be caught in the first place in the case of the System.Timers.Timer this is not the case:

 
{% codeblock lang:csharp %}
public static void Main() 
{
  AppDomain.CurrentDomain.UnhandledException += delegate  
  {
    Console.WriteLine("An unexpected error occurred.");
  };
  Timer timer = new Timer(3000);
  timer.Elapsed+=delegate  
  {
    Console.WriteLine("About to throw unhandled exception");
    throw new Exception();
  };
  timer.Start();
  Console.ReadLine();
}
{% endcodeblock %}


Just a quick bit of information in case you ever run into this problem.




