---
layout: post
title: "Slightly Different Way To Assert That Exceptions Are Thrown"
comments: true
date: 2008-05-11 09:00
categories:
- c sharp
---
For the longest time (the last 4 months!!) I have been using the following style of code to determine whether exceptions are thrown in my codebases:

{% codeblock lang:csharp %}
typeof (InterfaceResolutionException).ShouldBeThrownBy(() => DependencyRegistry.GetMeAn<IDbConnection>());
{% endcodeblock %}

As you can see, all that I am doing here is leveraging an extension method that hangs of the type class:

{% codeblock lang:csharp %}
public static void ShouldBeThrownBy(this Type exceptionType,Action workToDo) 
{
  GetExceptionFromPerforming(workToDo).ShouldBeAnInstanceOf(exceptionType);
}
{% endcodeblock %}

This extension method lives in a library of extension methods that I use when doing Behavior Driven Development and trying to leverage natural language as close as possible vs the traditional Assert this/that.

I just switched it up a bit to change it to make it completely foolproof, as with the original extension method you could have easily done this:

{% codeblock lang:csharp %}
typeof (SqlConnection).ShouldBeThrownBy(() => DependencyRegistry.GetMeAn<IDbConnection>());
{% endcodeblock %}


This code would compile and run, but SqlConnection is not an exception type. What I want to be able to do, to address this issue is flip things around like this: 

{% codeblock lang:csharp %}
(() => DependencyRegistry.GetMeAn<IDbConnection>()).ShouldThrowA<InterfaceResolutionException>();
{% endcodeblock %}


Notice how I am trying to use 2 different concepts here:
    
* Extension methods having off of a lambda expression
* Generics to ensure that the type provided to the ShouldThrowA method is an derivative of Exception

The only real problem with this is that you can't have an extension method that hangs off a lambda. What I can do is the following to get started:

{% codeblock lang:csharp %}
public static void ShouldThrowA<ExceptionType>(this Action workToDo) where ExceptionType : Exception 
{
  GetExceptionFromPerforming(workToDo).ShouldBeAnInstanceOf<ExceptionType>();
}
public static Exception GetExceptionFromPerforming(Action work) 
{
  try 
  {
    work();
  }
  catch(Exception e) 
  {
    return e;
  }
  return null;
}

{% endcodeblock %}


The first thing that I did is to create an extension method that belongs to any Action delegate instance. Notice the use of the generic constraint to ensure that the generic type parameter provided to the method is an actual derivative of Exception, which ensures that using this method is only applicable to exception throwing behaviors for a specific exception type. The second method GetExceptionFromPerforming (you will notice that I commonly use a style of naming that makes the method name coupled with its parameters the full name of the method, read the line as GetExceptionFromPerforming(work) vs GetExceptionFromPerformingWork(work), just a little bit of redundancy I don't care for) returns the exception caught while trying to execute the Action.

The ShouldBeAnInstanceOf method is another extension method that gets associated with any object, it just makes use of an existing assertion in the MbUnit library.

All of the building blocks are in place there is only one problem. I can't do this:

{% codeblock lang:csharp %}
(() => DependencyRegistry.GetMeAn<IDbConnection>()) .ShouldThrowA<InterfaceResolutionException>();
{% endcodeblock %}


So with just the following new class added to the my BDD Extensions Class:

{% codeblock lang:csharp %}
public static class The 
{
  public static Action Action(Action workToDo) 
  {
    return workToDo;
  }
}
{% endcodeblock %}


Looks a little weird, to have a method that looks like all it is doing is returning what it was called with, but in this case it is actually allowing us to allow assignment of the lambda to a known type which ultimately allows us to have extension methods that are bound to that known type (in this case the Action delegate). With all of these places in place this is how I now do assertions for exceptions thrown in a piece of SUT code:

{% codeblock lang:csharp %}
The.Action(() => DependencyRegistry.GetMeAn<IDbConnection>())
                    .ShouldThrowA<InterfaceResolutionException>(); 
{% endcodeblock %}

In this code the SUT is the DependencyRegistry which is actually a Static Gateway to container functionality.

Develop With Passion!!
