---
layout: post
title: "Validation In The Domain Layer - Take Two"
comments: true
date: 2006-06-15 09:00
categories:
- .net 2.0
- c sharp
---

It has been quite a while since I posted the [first part of this scenario](http://blog.developwithpassion.com/ValidationInTheDomainLayerTakeOne.aspx). I left off in a pretty good place, but now I need to revisit and solve the validation problems that I posed in the first entry:
<ul>
<li>Must be between the age of 18 - 75 to vote (yes there is an upper limit!!)</li>
<li>Must live in the country the candidate is running for</li></ul>

As well as the rules for voting, upon submitting a vote the person voting has to supply all of the required voter information:
<ul>
<li>FirstName</li>
<li>LastName</li>
<li>Age</li>
<li>Address</li>
<li>Gender</li>
<li>CountryOfResidence</li></ul>

We left off with having a Person domain object be able to perform validation. We now need to expand the scope to the vote class. A vote consists of both a Candidate and a Person. With the framework that is already in place, it becomes trivial to add the necessary validation for a Vote Class.



{% codeblock lang:csharp %}
public sealed class Rules 
{ 
  private Rules() 
  { 
  } 
  public static IBusinessRule<Vote> Age 
  { 
    get  
    { 
      return new BusinessRule<Vote>("Age", "Must be between 18 - 75 to vote", delegate(Vote vote) { return vote.voter.Age >= 18 && vote.voter.Age <= 75; }); 
    } 
  } 
  public static IBusinessRule<Vote> Country 
  { 
    get  
    { return new BusinessRule<Vote>("Country", "Must live in same country as Candidate", delegate(Vote vote) { return vote.voter.CountryOfResidence.Equals(vote.candidate.CountryOfResidence); }); } } public static IBusinessRuleSet Default { get  { return new BusinessRuleSet<Vote>(Age,Country); } } }

{% endcodeblock %}




This Rules class lives as a nested class inside of the Vote class. You will notice that the validation is fairly trivial. One thing that I have done is decrease the strong typing of the IBusinessRuleSet interface. Why? I want to have a layer supertype for all of my domain object that contains an IsValid property, and that will also invoke the appropriate BrokenBy method on the rule set. I accomplish this with minimum change required to the actual BusinessRuleSet class by changing the interface of IBusinessRuleSet<T> to the following:

 
{% codeblock lang:csharp %}
public interface IBusinessRuleSet 
{ 
  IBusinessRuleSet BrokenBy(IDomainObject item);
  bool Contains(IRule rule); 
  int Count { get; } 
  IList<string> Messages { get; } 
  bool IsEmpty { get; } 
}  
{% endcodeblock %}





With that change in place it means I now require a layer supertype for all of my domain objects:

 

{% codeblock lang:csharp %}
public class DomainObject : IDomainObject
{
    private IBusinessRuleSet rules;

    public DomainObject(IBusinessRuleSet rules)
    {
        this.rules = rules;
    }

    public IBusinessRuleSet Validate()
    {
        return rules.BrokenBy(this);
    }

    public bool IsValid
    {
        get { return Validate().IsEmpty; }
    }
}
{% endcodeblock %}




Notice how all DomainObjects will be constructed with a set of rules against which validation will be executed (great for testing, as well as loosening validation depending on the context). The layer supertype also takes care of performing the validation against itself. Even though it looks like I have lost some strong typing, this is not the case, as the main implementer of the IBusinessRuleSet interface is the BusinessRuleSet<T> class. It is still a generic class, and look at how it now implements the BrokenBy method:

 


{% codeblock lang:csharp %}
public IBusinessRuleSet BrokenBy(IDomainObject item)
{
    IList<IBusinessRule<T>> brokenRules = new List<IBusinessRule<T>>();

    foreach (IBusinessRule<T> rule in rules)
    {
        if (! rule.IsSatisfiedBy((T) item))
        {
            brokenRules.Add(rule);
        }
    }
    return new BusinessRuleSet<T>(brokenRules);
}
{% endcodeblock %}




Notice, that the BrokenBy method still ensures that the type of 'item' is the type that it expects to be able to work with. It does this by performing a cast using the type T that it was constructed to hold rules for. Tests that exercise this method for specific types of objects will fail if the object passed into the BrokenBy call is not of type T. 

So by making a small change to the interface we have now allowed for any new domain object  to now inherit from a layer supertype and have and its disposal a Validate and IsValid methods. Here is the first test that I wrote when it came to validating the rules for a vote:

  
{% codeblock lang:csharp %}
[Test] 
public void ShouldVerifyVoterLivesInSameCountryAsCandidate() 
{
  IPerson person = new Person("JP", "Boodhoo", "Test", 20, Country.CANADA, Gender.MALE); Candidate candidate = new Candidate("JP", "Boodhoo", "Test", 20, Country.CANADA, Gender.MALE, Party.CONSERVATIVE); 
  IPerson notInSameCountryAsCandidate = new Person("JP", "Boodhoo", "Test", 20, Country.USA, Gender.MALE); 
  Vote vote = new Vote(person, candidate); Assert.IsTrue(vote.IsValid); 
  vote = new Vote(notInSameCountryAsCandidate, candidate); Assert.IsFalse(vote.IsValid);
}  
{% endcodeblock %}


As you can see, small focused tests can help drive out lots of functionality. Last but not least is the introduction of a PollingStation class, that makes use of all of the code we have put into place:

 

 
{% codeblock lang:csharp %}
public class PollingStation
{
    private IList<Vote> invalidVotes;
    private IList<Vote> validVotes;
    private IList<IPerson> incompleteVoters;

    private int voteNumber;
    
    public PollingStation()
    {
        invalidVotes = new List<Vote>();
        validVotes = new List<Vote>();
        incompleteVoters = new List<IPerson>();
    }
    
    public void RegisterVoteFor(IPerson person,ICandidate candidate)
    {
        if (person.IsValid)
        {                
            Vote vote = new Vote(++voteNumber,person, candidate);
            if (vote.IsValid)
            {
                validVotes.Add(vote);
            }
            else
            {
                invalidVotes.Add(vote);
            }
        }
        else
        {
            incompleteVoters.Add(person);
        }
    }

    public IList<Vote> InvalidVotes
    {
        get { return invalidVotes; }
    }

    public IList<Vote> ValidVotes
    {
        get { return validVotes; }
    }

    public IList<IPerson> IncompleteVoters
    {
        get { return incompleteVoters; }
    }
}
{% endcodeblock %}


Here is the test that I wrote to drive out the usage of the PollingStation class:

 
{% codeblock lang:csharp %}
[Test]
public void ShouldRegisterPolls()
{
    ICandidate liberalCandidate = new Candidate("Lib", "Lib", "LibAddress", 30, Country.CANADA, Gender.MALE, Party.LIBERAL);
    ICandidate conservativeCandidate = new Candidate("Lib", "Lib", "LibAddress", 30, Country.CANADA, Gender.MALE, Party.CONSERVATIVE);
    ICandidate ndpCandidate = new Candidate("Lib", "Lib", "LibAddress", 30, Country.CANADA, Gender.MALE, Party.NDP);
    
    PollingStation station = new PollingStation();

    IPerson tooYoungToVote = new Person("DF", "DF", "dfd", 17, Country.CANADA, Gender.MALE);
    IPerson tooOldToVote = new Person("DF", "DF", "dfd", 78, Country.CANADA, Gender.MALE);
    IPerson livesInDifferentCountry = new Person("DF", "DF", "dfd", 18, Country.USA, Gender.MALE);
    IPerson incompleteInfo = new Person("", "DF", "dfd", 35, Country.CANADA, Gender.MALE);
    IPerson liberalVoter = new Person("fd", "DF", "dfd", 35, Country.CANADA, Gender.MALE);
    IPerson conservativeVoter = new Person("fd", "DF", "dfd", 35, Country.CANADA, Gender.MALE);
    IPerson ndpVoter = new Person("fd", "DF", "dfd", 35, Country.CANADA, Gender.MALE);
    
    
    station.RegisterVoteFor(tooYoungToVote,liberalCandidate);
    station.RegisterVoteFor(tooOldToVote,liberalCandidate);
    station.RegisterVoteFor(livesInDifferentCountry,liberalCandidate);
    station.RegisterVoteFor(incompleteInfo,liberalCandidate);
    station.RegisterVoteFor(liberalVoter,liberalCandidate);
    station.RegisterVoteFor(conservativeVoter,conservativeCandidate);
    station.RegisterVoteFor(ndpVoter,ndpCandidate);
    
    Assert.AreEqual(1,station.IncompleteVoters.Count);
    Assert.AreEqual(3,station.InvalidVotes.Count);
    Assert.AreEqual(3,station.ValidVotes.Count);

    OutputStats<IPerson>("Incomplete Voters", station.IncompleteVoters);
    OutputStats<Vote>("Invalid Votes", station.InvalidVotes);
}
{% endcodeblock %}



Are you wondering what is going on in the OutputStats<T> method. This was just something I put in so you could visualise the validation errors. When this test is run the following will be output to the console window:

 
<pre>Incomplete Voters
	First name is required

Invalid Votes
	Must be between 18 - 75 to vote

	Must be between 18 - 75 to vote

	Must live in same country as Candidate
</pre>



As is common lately, the source code for this completed project is [here]({{ site.cdn_root }}binary/validationInTheDomainLayerTake2/Validation.zip). And once again, comments are always encouraged and appreciated.

JP




