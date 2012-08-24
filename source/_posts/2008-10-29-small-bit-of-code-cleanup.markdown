---
layout: post
title: "Small bit of code cleanup"
comments: true
date: 2008-10-29 09:00
categories:
- c sharp
---

Thanks to a suggestion from [Albert Weinert](http://der-albert.com/) I have added 2 new test attributes to the spec helpers layer of my codebase (this is the folder that contains all of the test related utilities).  
For a long time I have been aliasing the TestAttribute and changing it to observation. Instead with a suggestion from Albert, I have now added 2 new attribute classes to the spec helpers layer (Albert sent me the code, I just renamed the TestPatternAttribute class):

{% codeblock lang:csharp %}
[AttributeUsage(AttributeTargets.Method,AllowMultiple = false)] 
public class ObservationAttribute : TestPatternAttribute 
{

}


[AttributeUsage(AttributeTargets.Class,AllowMultiple = false)] 
public class Observations : TestFixturePatternAttribute 
{
  public Observations(string description) : base(description) 
  {

  }
  public Observations() 
  {

  }
  public override IRun GetRun() 
  {
    var run = new SequenceRun();
    run.Runs.Add(new OptionalMethodRun(typeof(SetUpAttribute),false));
    run.Runs.Add(new MethodRun(typeof(ObservationAttribute),true,true));
    run.Runs.Add(new OptionalMethodRun(typeof(TearDownAttribute),false));
    return run;
  }
}
{% endcodeblock %}


This is much cleaner than aliasing (as well as adhering to DRY). I chose to keep this in my codebase vs rolling it into MbUnit as it gives people the freedom to name the attributes the way they feel. Because all of my test fixtures inherit from a base fixture, this change only required changing the attribute on my base test fixture as well as a quick search/replace to eliminate the:

{% codeblock lang:csharp %}
using Observation = MbUnit.Framework.TestAttribute; 
{% endcodeblock %}


Thanks Albert.

Develop With Passion!!




