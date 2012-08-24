---
layout: post
title: "Handling Dynamic Rules - A Precursor"
comments: true
date: 2006-06-16 09:00
categories:
- .net 2.0
- c sharp
---

I had a great question from Andy MacDonald about my [previous post](http://blog.developwithpassion.com/ValidationInTheDomainLayerTakeTwo.aspx) on validation in the domain layer:

Q: Is there anyway that the rule delegates can be stored in a database/xml file as this would provide a really powerful way of implementing ever shifting business rules about age and so forth without having to recompile any of the layers in the application (as well as supporting context rules)?

While I am not going to dive into the question today, I am going to give Andy and others some thoughts to chew on (which should actually enable them to proceed without waiting for part 2 of this post!):
<ul>
<li>A couple of questions you need to ask yourself before answering this question are as follows:</li>
<ul>
<li>'How often does a given rule change?'</li>
<li>'Is the end user going to be provided a mechanism to dynamically alter a given rule'?</li></ul></ul>

I am asking these question because I want you to realize that if a rule does not change very often, and the user has not requested a UI that will allow them to manipulate the rule, the effort involved in making the rule more dynamic may not be worth the effort. If you already have an automated build in place, one that allows you to deploy a new version of the app by just typing in the name of a target at the command line. Then the effort involved to 'change' a rule every once in a while is next to nothing. Now remember, this deploy on the fly model also works for Windows applications, if you are using a deployment model that allows for automatic updating of the clients (ex. ClickOnce / Updater components). If this is the case, changing a rule involves a couple of steps:
<ul>
<li>Update any tests that utilize the rule directly</li>
<li>Update the rule</li>
<li>Run the tests</li>
<li>Deploy the app</li></ul>

I am suggesting this for infrequent rule changes as it is still a viable option. Being a programmer, and a lazy one at that, makes me try to look for the simplest solution first. 

Of course, there are lots of situations where rules can change daily, and different installations of the system utilize slight variations on rules. In these situations, you need to isolate the rules that change frequently from the ones that don't. For these 'dynamic' rules, you can take advantage of the IBusinessRule<T> interface and create implementations that are parameterized with information from external sources. In the example that Andy talks about with the age example, a dynamic rule could be created to take in the minimum and maximum age of people allowed to vote:

 

 
{% codeblock lang:csharp %}
public class ValidVotingAgeRule : IBusinessRule<Vote>
{
    private int minimumAge;
    private int maximumAge;

    public ValidVotingAgeRule(int minimumAge, int maximumAge)
    {
        this.minimumAge = minimumAge;
        this.maximumAge = maximumAge;
    }

    public bool IsSatisfiedBy(Vote item)
    {
        return item.voter.Age >= minimumAge && item.voter.Age <= maximumAge;
    }

    public string Name
    {
        get { return "Valid Voting Age"; }
    }

    public string Description
    {
        get { return string.Format("Must be between {0} - {1} to vote", minimumAge, maximumAge); }
    }
}
{% endcodeblock %}


Again, I've said it before (maybe not on this blog) and I'll say it again. I love interfaces. Here I have created a dynamic rule called ValidVotingRule, you construct it using a minimumAge and maximumAge (which could easily come from the database. Notice how even the description is now parameterized based on the min and max age!! Notice also, that it implements the IBusinessRule<Vote> interface, which means that it could be added to any BusinessRule<Vote> instance, which gets passed into the constructor of a Vote class!!

Hopefully this gives Andy and others, some other things to think about!!






