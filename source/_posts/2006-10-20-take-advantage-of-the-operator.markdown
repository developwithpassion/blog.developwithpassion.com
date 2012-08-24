---
layout: post
title: "Take Advancategories of the ?? operator"
comments: true
date: 2006-10-20 09:00
categories:
- .net 2.0
- c sharp
---

I stumbled onto this awesome operator after a month or 2 of working with C# 2.0 (almost 2 years ago now). Take advantage of it to make your lazy initialization a lot simpler (not worrying about thread safety here). The operator simply returns the left-hand operand if it is not null otherwise it returns the right-hand operand. Take a look at the following progression of the code: 
  
Simple If Statement: 

{% codeblock lang:csharp %}
public ISession ActiveSession
{
  get
  {
    if(activeSession == null)
    {
      activeSession = mappingSessionFactory.Create();
    }
    return activeSession;
  }
}


public ISession ActiveSession
{
  get
  {
    if(activeSession == null) activeSession = mappingSessionFactory.Create();                
    return activeSession;
  }
}
{% endcodeblock %}

Further condensed by taking advantage of the ternary operator :

{% codeblock lang:csharp %}
public ISession ActiveSession
{
  get{ return (activeSession == null ? activeSession = mappingSessionFactory.Create() : activeSession); }
}

{% endcodeblock %}        
        
Made readable again by taking advantage of the ?? operator:

{% codeblock lang:csharp %}

public ISession ActiveSession
{
  return activeSession ?? (activeSession = mappingSessionFactory.Create()); }
}

{% endcodeblock %}
 

Notice what is happening in that line? If the left hand side of the operand (the activeSession field) evaluates to null,  the right-hand operand is returned; which in this case results in an initialization of the field that was null in the first place.Again, this is not new information, I just thought I would throw it out there as a reminder.


JP




