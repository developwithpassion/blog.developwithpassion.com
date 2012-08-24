---
layout: post
title: "The Static Gateway Pattern"
comments: true
date: 2007-10-15 09:00
categories:
- patterns
- programming
---

Now I am by no means claiming to be any sort of patterns naming authority, but after you see the same occurent pattern in your applications you often will try to formulate some sort of vocabulary among the team to express the concept that you see occurring over and over again. This is the very nature of how patterns popped up in the first place. This is a pet name that I have come up with for the 'recurring' theme you will see demonstrated here. If you are not familiar with the Gateway pattern check out the definition [here](http://martinfowler.com/eaaCatalog/gateway.html).

I am going to demonstrate this pattern with an example that most people should have in place at the beginning of a project. Logging.

One of the things about Logging, is that it should be simple. Let's assume that to get things rolling I really only care about logging informational messages. Assume I have a Calculator class that wants to do some logging, here are some possible code fragments that demonstrate the calculator class taking advantage of logging capabilities:

{% codeblock lang:csharp %}
public class Calculator
{
    private ILog log;

    public Calculator(ILog log)
    {
        this.log = log;
    }

    public int Add(int number1,int number2)
    {
        log.InformationalMessage("About to add two numbers");

        return number1 + number2;
    }
}
{% endcodeblock %}






In this scenario the calculator is constructed with a log which will take care of logging behaviour on its behalf. I don't like this as Logging falls under that set of 'cross-cutting' concerns, and I don't want to have to provide all of the objects in my application (domain layer or not) with this extra dependency. Here is another option:
{% codeblock lang:csharp %}
public class Calculator 
{
  private ILog log;
  public Calculator() 
  {

  }
  public ILog Log 
  {
    set  
    {
      this.log = value;
    }

  }
  public int Add(int number1,int number2) 
  {
    log.InformationalMessage("About to add two numbers");
    return number1 + number2;
  }

}

{% endcodeblock %}




Again, this is not optimal as it clutters up my object with unecessary noise. From a simplicity perspective, is it simpe for me to specify that 'all objects should have a field of type ILog if they want to consume logging functionality? I think that the simplest api would be something like this:
{% codeblock lang:csharp %}
public class Calculator 
{
  public int Add(int number1,int number2) 
  {
    Log.InformationalMessage("About to add two numbers");
    return number1 + number2;
  }
}
{% endcodeblock %}






Right now someone somewhere is screaming about the fact that I just introduced, what looks like, a Singleton. From an API perspective, the line above imposes the least design restrictions on my classes that want to consume logging functionality. The only caveat is that any class that wants to leverage logging is now coupled to the Log class. IMHO this is only an issue if it decreases the ability for me to test or if it decreases the option for me to swap out logging implementations (ex. Log4Net, MS Logging etc).

By the looks of the code above, it would seem that I have pinned myself into a fairly rigid design. I am not going to focus on how I test drive this out, but taking the API above, how could I go about testing the Log class? 

With the Static Gateway pattern, the Gateway (in this case the Log class) does not actually do any of the work. It just serves as the entry point to the functionality. If that is the case here is a cut at what the Log class could look like:
{% codeblock lang:csharp %}
public class Log
{
    private static ILogFactory logFactory;

    public static void InitializeLogFactory(ILogFactory logFactory)
    {
        Log.logFactory = logFactory;
    }

    public void InformationalMessage(string informationalMessage)
    {
        logFactory.Create().InformationalMessage(informationalMessage);
    }
}

public interface ILogFactory
{
    ILog Create();
}

public interface ILog
{
    void InformationalMessage(string message);
}
{% endcodeblock %}




How could you go about testing this class (I am demonstrating test-after, though the end solution was driven out test first). Here are two tests that prove out the functionality of the log class:

 
{% codeblock lang:csharp %}
[Test] public void Factory_should_be_leveraged_to_create_logger() 
{
  MockRepository mockery = new MockRepository();
  ILogFactory mockLogFactory = mockery.DynamicMock<ILogFactory>();
  ILog mockLog = mockery.DynamicMock<ILog>();
  using (mockery.Record()) 
  {
    Expect.Call(mockLogFactory.Create()).Return(mockLog);
  }
  Log.InitializeLogFactory(mockLogFactory);
  using (mockery.Playback()) 
  {
    Log.InformationalMessage("blah");
  }
  Log.InitializeLogFactory(null);
}
[Test] 
public void Informational_message_call_should_be_delegated_to_created_logger() 
{
  MockRepository mockery = new MockRepository();
  ILogFactory mockLogFactory = mockery.DynamicMock<ILogFactory>();
  ILog mockLog = mockery.DynamicMock<ILog>();
  using (mockery.Record()) 
  {
    SetupResult.For(mockLogFactory.Create()).Return(mockLog);
    mockLog.InformationalMessage("blah");
  }
  Log.InitializeLogFactory(mockLogFactory);
  using (mockery.Playback()) 
  {
    Log.InformationalMessage("blah");
  }
  Log.InitializeLogFactory(null);
}
{% endcodeblock %}




As you can see, these are completely interaction based tests (hence the lack of assertions). I broke up the test for leveraging the factory to create the logger and the delegation to the actual logger into 2 separate tests. I am also using the SetupResult vs Expect in the second test to indicate that, it is not the behaviour I care about testing. It just needs to be there to focus on what I actually care about, the delegation of the Log class to the created ILog implementation (which is currently a mock itself). 

The nice thing about this scenario is that neither the Log class, or the clients of the Log class are aware/tied to any one particular ILog implementation. As long as I can prove out the correct interaction between the Log class and it's dependency, I should be able to swap in any implementation of ILogFactory and the Log class is none the wiser. 

The only downside to the current implementation of the Log class is the need for the static field and static method to initialize that field. Outside of introducing other concepts too early, the initialization of the Log class with an ILogFactory implementation is something that can be done at application startup. It is very likely that is should be one of the first things that should happen, as many other objects in the system may rely on the functionality of the Log class. 

The only problem with the current solution is that the Log class is coupled to any changes that may occur in the ILog interface. To ensure that the ILog interface can vary independently of the Log class, I am going to make a small change to the API. Instead of calling methods on Log directly. I am going to change Log, and ILogFactory to the following: 
{% codeblock lang:csharp %}
public class Log
{
    private static ILogFactory logFactory;

    public static void InitializeLogFactory(ILogFactory logFactory)
    {
        Log.logFactory = logFactory;
    }

    public static ILog For(Type type)
    {
        return logFactory.CreateFor(type);
    }

    public static ILog For(object itemThatRequiresLoggingServices)
    {
        return For(itemThatRequiresLoggingServices.GetType());
    }
}
{% endcodeblock %}




The nice thing about this change is that now the Log class does not need to have a mirroring method for every method that may exist on the ILog interface. The ILog interface is now free to change independently of the Log class. Which means I could easily add methods to log with a specific logging level, etc. The Log class is now strictly a 'Static Gateway' to Logging functionality.

I'll finish up by making a call into this API from the Calculator class: 
{% codeblock lang:csharp %}
public class Calculator
{
    public int Add(int number1,int number2)
    {
        Log.For(this).InformationalMessage("About to add 2 numbers");
        return number1 + number2;
    }
}
{% endcodeblock %}






At this point the Calculator class is completely oblivious to the fact that there is currently no concrete ILogFactory/ILog implementation. It just cares about leveraging the Logging gateways 'Static' method to have it log on its behalf. When we actually swap in a real ILogFactory & ILog, neither the Calculator or Log class will have to change at all. 

In completion here is a quick implementation of an ILogFactory/ILog pair that will output log messages to the console (I'll leave it up to you to come up with a more testable implementation of the following 2 classes):
{% codeblock lang:csharp %}
public class ConsoleLogFactory : ILogFactory
{
    public ILog CreateFor(Type type)
    {
        return new ConsoleLogger();
    }

    private class ConsoleLogger : ILog
    {
        public void InformationalMessage(string message)
        {
            System.Console.Out.WriteLine(message);
        }
    }
}
{% endcodeblock %}






If you were to run the application now (after initializing the Log class with this ILogFactory implementation), you would see messages output to the Console, whenever the Add method on Calcuator was invoked.

In my next post, I'll demonstrate how to leverage the Static Gateway pattern with respect to an IOC gateway, that will allow me to remove the static field and initilization method on the Log class.

