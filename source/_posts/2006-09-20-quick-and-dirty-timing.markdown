---
layout: post
title: "Quick and Dirty Timing"
comments: true
date: 2006-09-20 09:00
categories:
- .net 2.0
- c sharp
---

There are many times when you are coding up a solution that you want to get a quick idea for how long a given operation is taking. A common first attempt at this is the following: 
 
{% codeblock lang:csharp %}
[Test]
public void ShouldTimeMethodUsingOldSchoolMethod()
{
  DateTime startTime = DateTime.Now;
  someClass.MethodToTime();
  Console.Out.WriteLine(DateTime.Now.Subtract(startTime).Milliseconds);
}
{% endcodeblock %}


This test should be self explanatory. You set a start time, invoke a method, output the difference between the current time and the start time. So this is all well and good (I'm not even bringing up the issue of timer resolution), but anytime you want to quickly time an operation you will be duplicating yourself. Remember the DRY principle, it will guide you toward much more maintainable codebases. 

Remembering the DRY principle, you start to think of ways to encapsulate the concept of a StopWatch in your codebase. If you are in .Net 2.0, the framework has already taken care of this for you with the addition of the Stopwatch class in the System.Diagnostics namespace. If you are still in .Net 1.1, and want an equivalent to the 2.0 Stopwatch, then head over to [Jeff Atwood's blog](http://www.codinghorror.com/blog) and take a look at his [Stopwatch implementation](http://www.codinghorror.com/blog/archives/000460.html). Using either class, you retrofit you code to take advantage of its functionality:

  
{% codeblock lang:csharp %}
[Test]
public void ShouldTimeMethodUsingFrameworkStopwatch()
{
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.Start();
    MethodToTime();
    stopwatch.Stop();
    Console.Out.WriteLine(stopwatch.ElapsedMilliseconds);
}
{% endcodeblock %}


As you can see this takes us a step closer to being able to quickly time methods (for quick curiosity). This still seems a bit verbose for my liking. Anytime I want to time a method using this technique I have to:

 
<ul>
<li>Instantiate a stopwatch 
<li>Start the stopwatch 
<li><strong>Invoke the method to be timed</strong> 
<li>Stop the stopwatch 
<li>Output the duration</li></ul>

The only variant in those steps is the method that is going to be invoked (operation to perform). Anyone who knows me, will tell you that I stress the value of eliminating duplication. Let's eliminate the duplication by introducing a new layer of abstraction:

 
{% codeblock lang:csharp %}
public class MyStopwatch : IDisposable 
{
  private Stopwatch internalStopwatch; 
  public MyStopwatch() 
  {
    internalStopwatch = new Stopwatch(); internalStopwatch.Start(); 
  } 

  public void Dispose() 
  {
    internalStopwatch.Stop(); Console.Out.WriteLine(internalStopwatch.ElapsedMilliseconds); 
  } 
}

{% endcodeblock %}


 Notice the use of the IDisposable interface. With this class in place, my previous method now changes to this: 
{% codeblock lang:csharp %}
[Test] 
public void ShouldTimeMethodUsingCustomStopwatch() 
{ 
  using (new MyStopwatch()) 
  { 
    someClass.MethodToTime(); 
  } 
}
{% endcodeblock %}


Ahh, duplication be gone. Ok, so what if we now want the ability to time a method executing a certain number of times. We could do this:

  
{% codeblock lang:csharp %}
[Test]
public void ShouldTimeMethodExecutingACertainNumberOfTimeWithLoopAndCustomStopwatch()
{
    using (new MyStopwatch())
    {
        for (int i = 0; i < 10; i++)
        {
            someClass.MethodToTime();
        }
    }
}
{% endcodeblock %}


Again, this is something that is often done a lot of times, so why not take advantage of the class we have created and use accordingly (requires some refactoring):

 
{% codeblock lang:csharp %}
public class MyStopwatch : IDisposable
{
    public delegate void MethodToTime();

    private readonly MethodToTime methodToTime;
    private int numberOfTimesToInvokeMethod;

    public MyStopwatch(MethodToTime methodToTime):this(methodToTime,1)
    {
    }
    
    public MyStopwatch(MethodToTime methodToTime, int numberOfTimesToInvokeMethod)
    {
        this.methodToTime = methodToTime;
        this.numberOfTimesToInvokeMethod = numberOfTimesToInvokeMethod;
    }

    public void Dispose()
    {
        TimeMethodInvocation();
        
    }

    private void TimeMethodInvocation()
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        for (int i = 0; i < numberOfTimesToInvokeMethod; i++)
        {
            methodToTime();
        }
        stopwatch.Stop();
        Console.Out.WriteLine(stopwatch.ElapsedMilliseconds);
    }
}
{% endcodeblock %}


As you can see, the MyStopwatch class has undergone a serious facelift. To construct an instance of this, you now have to specify a delegate that points to the method you want to invoke!! You can also optionally specify a number of times you want the method to run. Here is a sample demonstrating how to use the upgraded class: 

     
{% codeblock lang:csharp %}
[Test] 
public void ShouldTimeMethodExecutingACertainNumberOfTimesUsingCustomStopwatch() 
{ 
  new MyStopwatch(someClass.MethodToTime,10).Dispose(); 
}
{% endcodeblock %}


Now we are getting somewhere!! Although, I am not sure if I like the fact that the client of the stopwatch has to either use it in a using block, or explicitly call dispose (as in the last example), in order to receive timing details. How about exposing a couple of static methods on MyStopwatch: 

 
{% codeblock lang:csharp %}
public static void Time(MethodToTime methodToTime) 
{
  Time(methodToTime, 1); 
}
public static void Time(MethodToTime methodToTime,int numberOfTimesToInvokeMethod) 
{
  new MyStopwatch(methodToTime,numberOfTimesToInvokeMethod).Dispose(); 
}
{% endcodeblock %}


Which leads to a much more convienient usage syntax of:

 
{% codeblock lang:csharp %}
[Test]
public void ShouldTimeMethodANumberOfTimesUsingConvenienceMethods()
{
    MyStopwatch.Time(someClass.MethodToTime);
    MyStopwatch.Time(someClass.MethodToTime,10);
}
{% endcodeblock %}


The nice thing about the convenience methods, is that there is no question about whether or not the client will get its output, as the static methods are ensuring that dispose is getting called on the object. And from my perspective, it eliminates the need for a completely static class (which I am not a big fan of).

 

If you are a fan of static classes (which depending on what you are doing, could become the bane of your developer existence), you could also use the following Stopwatch implementation (which ends up being a lot more compact):

  
{% codeblock lang:csharp %}
public class StaticStopWatch
{
    public delegate void MethodToTime();
    
    public static void Time(MethodToTime methodToTime)
    {
        Time(methodToTime, 1);
    }
    
    public static void Time(MethodToTime methodToTime,int numberOfTimesToInvokeMethod)
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        
        for (int i = 0; i < numberOfTimesToInvokeMethod; i++)
        {
            methodToTime();
        }
        
        stopwatch.Stop();
        Console.Out.WriteLine(stopwatch.ElapsedMilliseconds);
    }
}
{% endcodeblock %}


And of course, to top it off, if you want to allow for a more flexible mechanism of outputting the results you could do this:

 
{% codeblock lang:csharp %}
public class StaticStopWatch
{
    public delegate void MethodToTime();
    
    public static void Time(MethodToTime methodToTime)
    {
        Time(methodToTime, Console.Out);
    }                        
    
    public static void Time(MethodToTime methodToTime,TextWriter output)
    {
        Time(methodToTime, 1,output);
    }                        
    
    public static void Time(MethodToTime methodToTime,int numberOfTimesToInvokeMethod)
    {
        Time(methodToTime, numberOfTimesToInvokeMethod, Console.Out);
    }
                            
    public static void Time(MethodToTime methodToTime,int numberOfTimesToInvokeMethod,TextWriter output)
    {
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        
        for (int i = 0; i < numberOfTimesToInvokeMethod; i++)
        {
            methodToTime();
        }
        
        stopwatch.Stop();
        output.WriteLine(stopwatch.ElapsedMilliseconds);                
    }
}
{% endcodeblock %}


Notice the convenience methods that will pass in the Console.Out as the TextWriter to use. This leaves you the ability to pass in your own TextWriter; if you want to,for example, write to a file.

I hope the "timing" of this blog entry was good for you, and that it helped spark you brain with new ideas for implementing your own (ad-hoc) timers in your applications.




