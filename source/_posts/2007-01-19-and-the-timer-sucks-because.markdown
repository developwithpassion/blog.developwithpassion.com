---
layout: post
title: "And the timer sucks because...."
comments: true
date: 2007-01-19 09:00
categories:
- .net 2.0
- c sharp
---

Following on from the last post, [Ayende](http://www.ayende.com/blog) reminded me that I forgot to use reflector on the offending piece of code. Here is code taken straight from the System.Timers.Timer class that shows exactly why it is behaving the way it is (pay attention to the try block): 
 
{% codeblock lang:csharp %}
private void MyTimerCallback(object state) 
{
  if (state == this.cookie) 
  {
    if (!this.autoReset) 
    {
      this.enabled = false;

    }
    Timer.FILE_TIME file_time1 = new Timer.FILE_TIME();
    Timer.GetSystemTimeAsFileTime(ref file_time1);
    ElapsedEventArgs args1 = new ElapsedEventArgs(file_time1.ftTimeLow, file_time1.ftTimeHigh);
    try  
    {
      ElapsedEventHandler handler1 = this.onIntervalElapsed;
      if (handler1 != null) 
      {
        if ((this.SynchronizingObject != null) && this.SynchronizingObject.InvokeRequired) 
        {
          this.SynchronizingObject.BeginInvoke(handler1, new object[] 
          {
            this, args1 
          });
        }
        else  
        {
          handler1(this, args1);
        }
      }
    }
    catch  
    {

      //if an exception occurs in the forest, does anyone handle it? 
    }

  }

}
{% endcodeblock %}


And there we have it (ok, so I added in the comment in the catch block)!!




