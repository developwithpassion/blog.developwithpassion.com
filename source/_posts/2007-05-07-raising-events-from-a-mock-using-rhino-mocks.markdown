---
layout: post
title: "Raising events (from a mock) using Rhino Mocks"
comments: true
date: 2007-05-07 09:00
categories:
- .net 2.0
- c sharp
---

I was just asked a question that I thought I would share with everyone in the event that it actually might help anyone else out.

The question was in regards to how (in a unit test) I can have a mock object raise an event when using Rhino Mocks. The particular case in question is to verify that a presenter actually consumes and handles an event published and broadcasted by a view.

Let's write a test to first encapsulate the requirement that a presenter should subscribe to a particular event of the view interface in the presenters constructor. I have a ReSharper file template that sets me up a MockTestFixture with the following structure: 
{% codeblock lang:csharp %}
using MbUnit.Framework;
using Rhino.Mocks;

namespace NothinButDotNetStore.Test.Presentation
{
    [TestFixture]
    public class EmployeeBrowserPresenterTest
    {
        private MockRepository mockery;

        [SetUp]
        public void Setup()
        {
            mockery = new MockRepository();
        }

        [TearDown]
        public void TearDown()
        {
            mockery.VerifyAll();
        }
        
    }
}
{% endcodeblock %}


I am making use of MbUnit and Rhino Mocks. MbUnit for unit testing and Rhino Mocks as my mock object framework. You'll notice that I create a MockRepository in the SetUp method and I call VerifyAll in the teardown method. This ensures that I never forget to make the call to VerifyAll as I never need to explicitly call it in any of my test methods.

Let's get to that first test:
{% codeblock lang:csharp %}
[Test]
  public void Construction_ShouldSubscribeToEventsOnView()
  {        
      IEmployeeBrowserView mockView = mockery.CreateMock<IEmployeeBrowserView>();
      mockView.Initialize += null;
      LastCall.Constraints(Is.NotNull());
      mockery.ReplayAll();

      new EmployeeBrowserPresenter(mockView);
  }
{% endcodeblock %}


The 2 most important lines in this test are the following: 
{% codeblock lang:csharp %}
mockView.Initialize += null; LastCall.Constraints(Is.NotNull());  
{% endcodeblock %}


These two lines make up the requirement that:
<ul>
<li>At some point in running this test, the object under test better subscribe to the Initialize event on the view with a Non-Null event handler.</li></ul>

Here is the initial code for the EmployeeBrowserPresenter: 
{% codeblock lang:csharp %}
public class EmployeeBrowserPresenter : IEmployeeBrowserPresenter
{
    private IEmployeeBrowserView view;

    public EmployeeBrowserPresenter(IEmployeeBrowserView view)
    {


    }

}
{% endcodeblock %}


The view interface looks as follows: 
{% codeblock lang:csharp %}
public interface IEmployeeBrowserView
{
    event EventHandler Initialize;
}
{% endcodeblock %}


If I were to run this test right now it would fail, because there is nowhere in the constructor of the presenter that it is subscribing to the events exposed by the view. To get the test running and passing I'll have to add the following code:

 
{% codeblock lang:csharp %}
public class EmployeeBrowserPresenter : IEmployeeBrowserPresenter
{
    private IEmployeeBrowserView view;

    public EmployeeBrowserPresenter(IEmployeeBrowserView view)
    {
        this.view = view;
        HookupEventHandlersTo(view);
    }

    private void HookupEventHandlersTo(IEmployeeBrowserView view)
    {
        view.Initialize += delegate { };
    }
}
{% endcodeblock %}




You can see that in the constructor, the presenter now subscribes to the Initialize method with a non null event handler (in this case an empty anonymous method). This gets my test passing. Now I need to write a separate test to verify that the presenter actually does something when the event is raised. Because I will be creating the presenter for each test, each test would need to setup the expecation for the event subscription. I don't want to duplicate my efforts so I will move some code to the setup method. This will cause my test class to look as follows:

 
{% codeblock lang:csharp %}
[TestFixture]
public class EmployeeBrowserPresenterTest
{
    private MockRepository mockery;
    private IEmployeeBrowserView mockView;


    [SetUp]
    public void Setup()
    {
        mockery = new MockRepository();
        mockView = mockery.CreateMock<IEmployeeBrowserView>();
        mockView.Initialize += null;
        LastCall.Constraints(Is.NotNull());
    }

    [TearDown]
    public void TearDown()
    {
        mockery.VerifyAll();
    }

    [Test]
    public void Construction_ShouldSubscribeToEventsOnView()
    {
        mockery.ReplayAll();
        new EmployeeBrowserPresenter(this.mockView);
    }
}
{% endcodeblock %}




Now I can write the test to ensure that the presenter does something when the view raises its Initialized event. For arguments sake, let's have the presenter Invoke a method on the view in response to handling the Initialize event:
{% codeblock lang:csharp %}
[Test]
public void ViewInitializationHandler_PresenterShouldPushMessageToView()
{
    mockView.DisplayMessage(null);
    LastCall.Constraints(Is.NotNull());
    mockery.ReplayAll();

    IEmployeeBrowserPresenter presenter = new EmployeeBrowserPresenter(mockView);
    IEventRaiser eventRaiser = new EventRaiser((IMockedObject) mockView, "Initialize");
    eventRaiser.Raise(null,null);
}
{% endcodeblock %}




Notice how I am leveraging the EventRaiser class to simulate the mock object raising an event. Unfortunately, using this approach defeats the purpose for using Rhino over NMock2 in the sense that you have to resort to providing the name of the event as a string. No good. Let's refactor this to eliminate the need for the string. I'll make a change to the Setup method as follows:
{% codeblock lang:csharp %}
private IEventRaiser initializeEventRaiser;


[SetUp]
public void Setup()
{
    mockery = new MockRepository();
    mockView = mockery.CreateMock<IEmployeeBrowserView>();
    mockView.Initialize += null;
    LastCall.Constraints(Is.NotNull());
    initializeEventRaiser = LastCall.GetEventRaiser();
}
{% endcodeblock %}




Using LastCall.GetEventRaiser provides me a way to get access to an event raiser bound to a particular event on a mock object. The caveat is that you have to ensure that the previous mock object expectation (in this call mockView.Initialize += null) was an expectation on an event exposed by the interface. With this IEventRaiser in hand I can refactor my test as follows:

 
{% codeblock lang:csharp %}
[Test]
public void ViewInitializationHandler_PresenterShouldPushMessageToView()
{
    mockView.DisplayMessage(null);
    LastCall.Constraints(Is.NotNull());
    mockery.ReplayAll();

    IEmployeeBrowserPresenter presenter = new EmployeeBrowserPresenter(mockView);
    initializeEventRaiser.Raise(null,null);
}
{% endcodeblock %}


The Raise method expects a set of parameters that match up with the signature for the delegate type of the event. In this case the Initialize event on the view interface is an EventHandler delegate type. The EventHandler delegate is the basic event handler signature in the framework that takes a sender and an EventArgs. In this scenario, because my presenter does not care about either, I pass null for both. To get this test to pass I can write the following code on my presenter:

 
{% codeblock lang:csharp %}
private void HookupEventHandlersTo(IEmployeeBrowserView view) 
{ 
  view.Initialize += delegate { view.DisplayMessage(DateTime.Now.ToString());}; 
}  
{% endcodeblock %}




In the anonymous event handler, I have the presenter invoke the DisplayMessage method on the view, passing it the current time as a string. This satisfies the new requirement in the test:
{% codeblock lang:csharp %}
mockView.DisplayMessage(null); LastCall.Constraints(Is.NotNull());
{% endcodeblock %}




Now you know how to raise events in a refactorable way using Rhino Mocks.

 

Develop with passion!




