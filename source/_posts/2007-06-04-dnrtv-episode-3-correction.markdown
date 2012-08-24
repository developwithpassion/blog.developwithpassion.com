---
layout: post
title: "DNRTv Episode 3 - Correction"
comments: true
date: 2007-06-04 09:00
categories:
- screencasts
---

A lot of people have been quick to point out the fact that .Net 1.1 does not have generics, even though I forgot to mention that fact also. In response to this, here is how you can implement the ListEnumerable in a pre 2.0 environment:

 
{% codeblock lang:csharp %}
public class ListEnumerable : IEnumerable
{
    private IList itemsToEnumerate;


    public ListEnumerable(IList itemsToEnumerate)
    {
        this.itemsToEnumerate = itemsToEnumerate;
    }

    public IEnumerator GetEnumerator()
    {
        return itemsToEnumerate.GetEnumerator();
    }
    
}
{% endcodeblock %}




I hope that clears that up!!




