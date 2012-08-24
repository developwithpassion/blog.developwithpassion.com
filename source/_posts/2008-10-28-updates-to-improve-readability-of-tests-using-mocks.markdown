---
layout: post
title: "Updates to improve readability of tests using mocks"
comments: true
date: 2008-10-28 09:00
categories:
- c sharp
---

In my ongoing quest to simplify the use of mock objects and to make the test code that I write remove the need for testing specific nomenclature. I made a small update to the BDDExtensions that I use when working with Rhino Mocks. Here is the class in question:  
  
{% codeblock lang:csharp %}
public static class RhinoMocksExtensions 
{
  public static VoidMethodCallOccurance<T> was_told_to<T>(this
      T mock, Action<T> item) 
  {
    return new VoidMethodCallOccurance<T>(mock, item);
  }
  public static IMethodOptions<R> when_told_to<T, R>(this T mock
      , Function<T, R> func) where T : class 
  {
    return mock.Stub(func);
  }
}

{% endcodeblock %}





The above 2 extension methods are the only ones I need to use when working with my mock objects. As you can see, they are just non-testing-nomenclature specific wrappers around existing rhino mocks methods.The was_told_to extension method is a method that I use to verify that a void method call message was sent to a mock object. You can see that the method returns a VoidMethodCallOccurance class that looks like this:

{% codeblock lang:csharp %}
public class VoidMethodCallOccurance<T>  
{
  public Action<T> action;
  private T mock;
  public VoidMethodCallOccurance(T mock, Action<T> action) 
  {
    this.mock = mock;
    this.action = action;
    mock.AssertWasCalled(action);
  }
  public void times(int number_of_times_the_method_
      should_have_been_called) 
  {
    mock.AssertWasCalled(action, y => y.Repeat.Times(number_of
          _times_the_method_should_have_been_called));
  }
  public void only_once() 
  {
    times(1);
  }
  public void twice() 
  {
    times(2);
  }
}
{% endcodeblock %}





This class allows you to specify the number of times a method was called on mock object. Which allows you to do this:



{% codeblock lang:csharp %}
[Observation] 
public void should_tell_the_log_4_net_initialization_command_to_run() 
{
  initialization_command.was_told_to(x => x.run())
    .only_once();
}
{% endcodeblock %}






as opposed to this:

{% codeblock lang:csharp %}
[Observation] 
public void should_tell_the_log_4_net_initialization_command_to_run() 
{
  initialization_command.AssertWasCalled(x => x.run()
      ,y => y.Repeat.Times(1));
}

{% endcodeblock %}

It is a small change, but one that, IMHO, adds a lot to the
readability of the test.
 
Develop With Passion!!
          
          
