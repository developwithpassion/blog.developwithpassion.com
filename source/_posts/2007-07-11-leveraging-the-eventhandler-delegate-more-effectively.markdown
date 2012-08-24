---
layout: post
title: "Leveraging the EventHandler<T> delegate more effectively"
comments: true
date: 2007-07-11 09:00
categories:
- .net 2.0
- .net 3.0
- c sharp
---

If you are now coding in .Net 2.0/3.0/3.5 and are creating types that expose events. Chances are you have started leveraging the EventHandler<T> delegate that frees you from creating custom delegate signatures for events anymore. If not this post is for you. Let's say that you want to expose an event that another object could consume. Normally you would follow these steps:
<ol>
<li>Create a type that inherits from EventArgs if the event is going to propagate event specific data. This step is optional as you may not have any custom data to propagate.</li>
<li>Create a delegate signature for the event. If you are not using a custom EventArgs derivative, then you can get away with just leveraging the EventHandler delegate that already exists in the framework.</li>
<li>Create the type that is going to raise the event and have it declare the event using either implicit or explicit event registration.</li>
<li>Create a method on the type that will raise the event.</li></ol>

In .Net 2.0/3.0/3.5 these steps can now become:
<ol>
<li>Create a type that inherits from EventArgs if the event is going to propagate event specific data. This step is optional as you may not have any custom data to propagate.</li>
<li>Create the type that is going to raise the event and have it declare the event using either the EventHandler delegate type for an event that does not propagate custom data, or leverage the generic EventHandler<T> delegate to declare an event bound to the specific EventArgs derivative you need to use. Again you can use either implicit or explicit event registration.</li>
<li>Create a method on the type that will raise the event.</li></ol>

This can actually become slightly better. Instead of always creating a class that derives from EventArgs if you need to pass custom data; create a parameter object that encapsulates the information you would want to propagate in the event. This class does not need to inherit from EventArgs. Then create the following utility class:

 
{% codeblock lang:csharp %}
public class EventArgs<T> : EventArgs
{
    private T eventData;

    
    public EventArgs(T eventData)
    {
        this.eventData = eventData;
    }


    public T EventData
    {
        get { return eventData; }
    }
}
{% endcodeblock %}




This means that the 3 steps above can now be changed to:
<ol>
<li>Create a parameter object that encapsulates any information you want to propagate in the event.. This step is optional as you may not have any custom data to propagate.</li>
<li>Create the type that is going to raise the event and have it declare the event using either the EventHandler delegate type for an event that does not propagate custom data, or leverage the generic EventHandler<T> delegate, with the generic EventArgs<T> class to declare an event bound to the specific <strong>parameter object</strong> you need to use. Again you can use either implicit or explicit event registration.</li>
<li>Create a method on the type that will raise the event.</li></ol>

 

So if I had a parameter object that looked like this:
{% codeblock lang:csharp %}
public class ReportingPeriod
{
    private DateTime start;
    private DateTime end;


    public DateTime Start
    {
        get { return start; }
    }

    public ReportingPeriod(DateTime start, DateTime end)
    {
        this.start = start;
        this.end = end;
    }
}
{% endcodeblock %}




I would be able to create a type that raises an event to propagate this data as follows (using implicit registration):
{% codeblock lang:csharp %}
public class ReportTrigger
{
    public event EventHandler<EventArgs<ReportingPeriod>> RunReport;
}
{% endcodeblock %}




Or using explicit registration:
{% codeblock lang:csharp %}
public class ReportTrigger
{
    private EventHandler<EventArgs<ReportingPeriod>> subscribers;

    public event EventHandler<EventArgs<ReportingPeriod>> RunReport
    {
        add
        {
            subscribers += value;
        }   
        remove
        {
            subscribers -= value;
        }
    }
}
{% endcodeblock %}




Develop With Passion!




