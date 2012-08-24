---
layout: post
title: "Static Gateway - Part 2"
comments: true
date: 2007-11-21 09:00
categories:
- general
---

In the [last installment ](http://blog.developwithpassion.com/TheStaticGatewayPattern.aspx)I left off with a class that served as a Static Gateway for Logging functionality. The nature of the members being accessed statically allowed for pure syntactic sugar for clients who wanted to consume logging functionality. I got a lot of feedback from people who made comments about why I could not make use of a IOC container to accomplish the same thing. This post is my answer to those questions as that is exactly what I do on my own projects.

When I get to the point that I need to introduce IOC into my codebase I drive it out in a test first manner. In the last implementation that I did here was the first test that I wrote:

 
{% codeblock lang:csharp %}
[Test]
public void Should_leverage_container_to_resolve_an_implementation_of_an_interface()
{
    Provide<IDependencyContainer>(CreateMock<IDependencyResolver>());
    IDbConnection mockDbConnection = CreateMock<IDbConnection>();

    using (Mocks.Record())
    {
        Expect.Call(mockDependencyResolver.GetImplementationOf<IDbConnection>()).Return(mockDbConnection);
    }

    using (Mocks.Playback())
    {
        DependencyResolver.InitializeWith(mockDependencyResolver);

        IDbConnection result = DependencyResolver.GetImplementationOf<IDbConnection>();

        Assert.AreEqual(mockDbConnection, result);
    }    
}
{% endcodeblock %}






I am making use of the automocking container in this test so try not to get hung up on the semantics of what the Provide<IDependencyResolver> call is doing.

All this test demonstrates is that I am going to have a class called DependencyResolver that will serve as the Static Gateway, to IOC functionality. I have also show that it is not necessarily going to do the work, but rather it will delegate to an IDependencyResolver implementation (mocked out in this test) to accomplish the work on its behalf. The implementation code to get this test passing is as follows: 
{% codeblock lang:csharp %}
public class DependencyResolver 
{
  private static IDependencyResolver resolver;
  public static void InitializeWith(IDependencyResolver resolver ) 
  {
    DependencyResolver.resolver = resolver;
  }
  public static Interface GetImplementationOf<Interface>() 
  {
    return resolver.GetImplementationOf<Interface>();
  }
}
public interface IDependencyResolver { Interface GetImplementationOf<Interface>(); }
{% endcodeblock %}


So far so good. I continued to write one more test (based on my prior experience with leveraging containers) to ensure that I had better error messages if a dependency could not get resolved properly. This is most often caused by the underlying container not being configured with an implementation of a particular contract: 
{% codeblock lang:csharp %}
[ExpectedException(typeof(InterfaceResolutionException))]
[Test]
public void Should_report_more_detail_if_unable_resolve_an_implementation_of_an_interface()
{
    Provide<IDependencyResolver>(CreateMock<IDependencyResolver>());
    using (Mocks.Record())
    {
        Expect.Call(mockDependencyResolver.GetImplementationOf<IDbConnection>()).Throw(new Exception());
    }

    using (Mocks.Playback())
    {
        DependencyResolver.InitializeWith(mockDependencyResolver);
        DependencyResolver.GetImplementationOf<IDbConnection>();
    }
}
{% endcodeblock %}


The accompanying implementation is fairly trivial:

 
{% codeblock lang:csharp %}
public static Interface GetImplementationOf<Interface>()
{
    try
    {
        return resolver.GetImplementationOf<Interface>();
    }
    catch (Exception e)
    {
        throw new InterfaceResolutionException(e,typeof(Interface));
    }
}
{% endcodeblock %}


The custom exception is as follows:

 
{% codeblock lang:csharp %}
public class InterfaceResolutionException : Exception 
{
  public const string ExceptionMessageFormat = "Failed to resolve an implementation of an {0} "; 
  public InterfaceResolutionException(Exception innerException, Type interfaceThatCouldNotBeResolvedForSomeReason):base(string.Format(ExceptionMessageFormat,interfaceThatCouldNotBeResolvedForSomeReason.FullName),innerException) 
  {

  }
}
{% endcodeblock %}


Having used this technique on my last couple of projects, it did not matter if the underlying implementation of IDependencyResolver was a Spring adapter, a Castle adapter, or a StructureMap adapter, if the real container framework had trouble resolving a dependency, I would get a nice line in my log file that read:

(omitting tracing information**) - Failed to resolve an implementation of an (Whatever the contract is).

This helped me quickly go to the container configuration and deal with the errors as they were always to do with the way I was wiring things up.

Now that I have this gateway for Dependency resolution in place, I should be able to leverage this from the Logging static gateway. I do this by changing my Logger test as follows: 
{% codeblock lang:csharp %}
[Test]
public void Should_ask_dependency_resolver_for_a_logger_factory_that_can_be_used_to_return_a_logger_to_the_client()
{
    ILog mockLog = CreateMock<ILog>();
    ILogFactory mockLogFactory = CreateMock<ILogFactory>();
    Provide<IDependencyResolver>(mockDependencyResolver);

    using (Mocks.Record())
    {
        Expect.Call(mockDependencyResolver.GetImplementationOf<ILogFactory>()).Return(mockLogFactory);
        Expect.Call(mockLogFactory.CreateFor(typeof (LogTest))).Return(mockLog);
    }

    using (Mocks.Playback())
    {
        DependencyResolver.InitializeWith(mockDependencyResolver);
        ILog log = Log.For(this);
        Assert.AreEqual(mockLog, log);
    }
}
{% endcodeblock %}


This turns my implementation of the Log static gateway into the following: 
{% codeblock lang:csharp %}
public class Log
{

    public static ILog For(object itemThatRequiresLoggingServices)
    {
        return For(itemThatRequiresLoggingServices.GetType());
    }

    public static ILog For(Type type)
    {
        return DependencyResolver.GetImplementationOf<ILogFactory>().CreateFor(type);
    }
}
{% endcodeblock %}


This means that from this point on, when I want to introduce another static gateway for some other piece of, typically, cross cutting functionality such as logging. The Static Gateway for that functionality can make use of the dependency resolver to resolve its dependency and it completely eliminates the need for static fields and initialization method in everything but the main DependencyResolver Static Gateway itself.

I like to keep classes like Log kicking around because in my code that consumes Logging functionality I would much rather have a line of code in a client class that reads:

Log.For(this).InformationalMessage('Blah')

As opposed to:

DependencyResolver.GetImplementationOf<ILogFactory>().CreateFor(this).InformationalMessage('Blah')

The Log Static Gateway still shields the consumer from the details of how to go about logging so the consumer can carry on it its happy simple world.

Develop With Passion!!




