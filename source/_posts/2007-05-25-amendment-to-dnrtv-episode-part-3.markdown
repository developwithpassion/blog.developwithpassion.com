---
layout: post
title: "Amendment to DNRTV Episode Part 3"
comments: true
date: 2007-05-25 09:00
categories:
- c sharp
- screencasts
---

After I finished up recording part 3. I realized that I was not showing off as many ReSharper shortcuts as I could have. That will definitely change over the course of the next set of episodes. For the remainder of the series I will be recording the entire series 'sans mouse'. Hopefully this will give people an idea of how productive you can actually be without using the <strike>keyboard</strike> mouse. As soon as I had finished recording the session I thought to myself 'yikes, I made that list enumerable way more complicated that it should have been'. Instead of this:

 
{% codeblock lang:csharp %}
public class ListEnumerable<T> : IEnumerable<T>
{
    private IList<T> itemsToEnumerate;


    public ListEnumerable(IList<T> itemsToEnumerate)
    {
        this.itemsToEnumerate = itemsToEnumerate;
    }

    public IEnumerator<T> GetEnumerator()
    {
        return new ListEnumerator<T>(itemsToEnumerate);
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return new ListEnumerator<T>(itemsToEnumerate);
    }
}
{% endcodeblock %}




I could have simply done this:
{% codeblock lang:csharp %}
public class ListEnumerable<T> : IEnumerable<T>
{
    private IList<T> itemsToEnumerate;


    public ListEnumerable(IList<T> itemsToEnumerate)
    {
        this.itemsToEnumerate = itemsToEnumerate;
    }

    public IEnumerator<T> GetEnumerator()
    {
        return itemsToEnumerate.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return itemsToEnumerate.GetEnumerator();
    }
}
{% endcodeblock %}


And of course, an even easier way (if you have .Net 2.0) is to just leverage the yield keyword inside of a method returning IEnumerable. Which is how I started off the discussion on iterators.




