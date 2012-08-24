---
layout: post
title: "Answers To Some Good Questions"
comments: true
date: 2006-04-19 09:00
categories:
- .net 2.0
- c sharp
- patterns
---

After my last [presentation](http://www.dnrtv.com/default.aspx?showID=14) on [DNRTv](http://www.dnrtv.com/) MauricioC asked some good questions that I thought I should post some answers for. I am reposting the questions from the comments that he made to give you a context for the answers: 

Q: By the way, I also have an architecture question. When implementing the Service Layer pattern (as in Martin Fowler's Patterns of Enterprise Application Architecture), where would you put persistence code? The example on the book puts methods for filling the Domain Objects in themselves, but I am a little uncomfortable in introducing a dependency for the Data Access Layer in my Domain Layer (even while using Inversion of Control). Would you retrieve/persist data in the Service Layer itself, or the dependency is manageable and I am being paranoid? 

<font color="#0000ff">A: As with many patterns there are a multitude of ways that the pattern can be implemented. As Martin points out, the two most common approaches for the service layers are the 'Domain Facade' and 'Operation Script'. I tend to lean toward the domain facade approach as it keeps my logic inside of the domain objects as opposed to dispersed through multiple methods in the service layer. As far as persistence is concerned the approach that Mauricio is talking about when having domain objects responsible for persisting themselves is the Active Record approach. As he says, this places a dependency on the data access layer in the domain model. I prefer having a completely isolated domain model, one that knows nothing about the service layer, data access etc. This allows you to drive out the functionality of the domain model in isolation from anything else. In this scenario, the service layer would be responsible for talking to some sort of MapperRegistry to retrieve mappers that know how to persist objects that need to go back to the database. Again, with a domain facade the service layer code is kept as thin as possible. Having discrete mappers that know how to persist objects/families of objects, removes this responsibility from both the domain model and the service layer and puts it where it should be, in a mapping layer. Mappers can be developed test first to ensure that if a mapper is given a particular object that it can read/delete/insert that object. So the long and short of it is :</font>

<font color="#0000ff">The Service Layer coordinates the persistence, but it doesn't perform the persistence.</font>

<font color="#0000ff">Again, the active record pattern is still a viable alternative if you are working with a simpler object model, and you are comfortable with domain objects being responsible for persisting themselves.</font>


Q:Another very related question: Would you use test-driven development to create the service layer (I mean, it is a very thin wrapper that should not need inversion of control, as it's common for such facades)? The same question applies for the view in the MVP pattern: If you had used TDD in DNRtv, what parts of the view would have been tested? 

<font color="#0000ff">A: The short answer is yes. Assume you were asked to build out a new method that needs to exist on a service layer class. This method will be called whenever a new Customer is to be added to the system. Here's the catch, there is currently no mapper for a Customer object. And yet you still want to carry on developing the method without that in place. You can utilize TDD to drive out this scenario, even without the actual concrete mapper in place. If everything was already in place, then the test serves as a sanity check that the service layer class is talking and interacting with its dependencies as it should. An example of such a test would look like this.</font>

 



<pre class="hl"><span class="kwa">using</span> System<span class="sym">;</span>
<span class="kwa">using</span> NUnit<span class="sym">.</span>Framework<span class="sym">;</span>
<span class="kwa">using</span> Rhino<span class="sym">.</span>Mocks<span class="sym">;</span>

<span class="kwa">namespace</span> DataLayer<span class="sym">.</span>DataAccess<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="sym">[</span>TestFixture<span class="sym">]</span>
    <span class="kwa">public class</span> CustomerTaskTest
    <span class="sym">{</span>
        MockRepository mockery<span class="sym">;</span>

        <span class="sym">[</span>SetUp<span class="sym">]</span>
        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">Setup</span><span class="sym">()</span>
        <span class="sym">{</span>
            mockery <span class="sym">=</span> <span class="kwa">new</span> <span class="kwd">MockRepository</span><span class="sym">();</span>
        <span class="sym">}</span>

        <span class="sym">[</span>TearDown<span class="sym">]</span>
        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">TearDown</span><span class="sym">()</span>
        <span class="sym">{</span>
            mockery<span class="sym">.</span><span class="kwd">VerifyAll</span><span class="sym">();</span>
        <span class="sym">}</span>

        <span class="sym">[</span>Test<span class="sym">]</span>
        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">ShouldBeAbleToCreateNewValidCustomer</span><span class="sym">()</span>
        <span class="sym">{</span>
            ICustomerMapper customerMapper <span class="sym">=</span> mockery<span class="sym">.</span>CreateMock<span class="sym"><</span>ICustomerMapper<span class="sym">>();</span>
            CustomerDTO dto <span class="sym">=</span> <span class="kwa">new</span> <span class="kwd">CustomerDTO</span><span class="sym">(</span><span class="str">"JP"</span><span class="sym">,</span><span class="str">"Boodhoo"</span><span class="sym">);</span>

            ICustomerTask task <span class="sym">=</span> <span class="kwa">new</span> <span class="kwd">CustomerTask</span><span class="sym">(</span>customerMapper<span class="sym">);</span>

            customerMapper<span class="sym">.</span><span class="kwd">Insert</span><span class="sym">(</span><span class="kwa">null</span><span class="sym">);</span>

            LastCall<span class="sym">.</span><span class="kwd">On</span><span class="sym">(</span>customerMapper<span class="sym">).</span><span class="kwd">Constraints</span><span class="sym">(</span>
                Is<span class="sym">.</span><span class="kwd">NotNull</span><span class="sym">() &</span>
                Is<span class="sym">.</span><span class="kwd">TypeOf</span><span class="sym">(</span><span class="kwd">typeof</span><span class="sym">(</span>Customer<span class="sym">)) &</span>
                Property<span class="sym">.</span><span class="kwd">Value</span><span class="sym">(</span><span class="str">"FirstName"</span><span class="sym">,</span><span class="str">"JP"</span><span class="sym">) &</span>
                Property<span class="sym">.</span><span class="kwd">Value</span><span class="sym">(</span><span class="str">"LastName"</span><span class="sym">,</span><span class="str">"Boodhoo"</span><span class="sym">));</span>

            mockery<span class="sym">.</span><span class="kwd">ReplayAll</span><span class="sym">();</span>

            task<span class="sym">.</span><span class="kwd">CreateNewCustomer</span><span class="sym">(</span>dto<span class="sym">);</span>        

       <span class="sym">}</span>
    

    
    <span class="sym">}</span>
<span class="sym">}</span></pre><pre class="hl"></pre>

<font color="#0000ff">Notice that I am taking advantage of a new mocking framework that I have come to love (RhinoMock .Net). I am going to write up another post about working with RhinoMock, for those of you who have used NMock2 (also a great framework), the immediate distinction between the two is that I can actually set expectations by actually invoking the methods on a mock interface. Again, I will save the details of using RhinoMock for another post. This test was written test first without any existing code in place, but the intent of what the concrete service layer class should do is evident. After calling the CreateNewCustomer method we know that the service layer class is going to invoke the 'Insert' method on a ICustomerMapper implementation, and the Customer object that gets passed to the insert method will have had its firstname and lastname properties set. That is is. Thin service layer. We are not testing that the service layer can actually map the Customer to the database, we are testing that given a CustomerDTO, the service layer class can: </font>
<ul>
<li><font color="#0000ff">Unwrap the DTO and create the necessary Customer domain object</font></li>
<li><font color="#0000ff">Invoke the Insert method on a ICustomerMapper implementation</font></li></ul>

<font color="#0000ff">A test around a concrete ICustomerMapper implementation would actually verify whether a customer could be mapped to the database. If you want to see the code for the CustomerTask class, here it is:</font>

 <pre class="hl"><span class="kwa">public class</span> CustomerTask <span class="sym">:</span> ICustomerTask
<span class="sym">{</span>
        <span class="kwa">private</span> ICustomerMapper customerMapper<span class="sym">;</span>

        <span class="kwa">public</span> <span class="kwd">CustomerTask</span><span class="sym">(</span>ICustomerMapper customerMapper<span class="sym">)</span>
        <span class="sym">{</span>
            <span class="kwa">this</span><span class="sym">.</span>customerMapper <span class="sym">=</span> customerMapper<span class="sym">;</span>
        <span class="sym">}</span>

        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">CreateNewCustomer</span><span class="sym">(</span>CustomerDTO dto<span class="sym">)</span>
        <span class="sym">{</span>
            customerMapper<span class="sym">.</span><span class="kwd">Insert</span><span class="sym">(</span><span class="kwa">new</span> <span class="kwd">Customer</span><span class="sym">(</span>dto<span class="sym">.</span>FirstName<span class="sym">,</span>dto<span class="sym">.</span>LastName<span class="sym">));</span>
        <span class="sym">}</span>
<span class="sym">}</span>
</pre><pre class="hl"> </pre><font color="#0000ff">In this scenario, this results in an extremely "thin" service layer class. As far as testing the view in an MVP triad, now we are getting into the functional testing layer where you would want to use some sort of automated UI runner. For windows NUnitForms is a great free one, and for the web Ruby & Watir are a great combination. Again, when testing at the actual UI layer, you are really trying to test the thin layer that can't easily be accessed by the presenter (unless you tie presenters specifically to one particular UI framework).</font>




