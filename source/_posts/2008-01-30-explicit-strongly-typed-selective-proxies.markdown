---
layout: post
title: "Explicit Strongly Typed Selective Proxies"
comments: true
date: 2008-01-30 09:00
categories:
- c sharp
---

Had the question the other day:

'How could I dynamically create a proxy around an object (interface based proxies are not a problem) and then selectively apply interceptors at a method by method level if necessary'.

Let's clear up a bit of terminology so that everyone is on the same page with regards to the problem at hand:

Proxy - An object that implements the same interface as a target object and intercepts methods calls to the target to perform some sort of pre and or post method invocation.

Interceptor - An object that can be plugged into a proxy to perform a pre/post method invocation step. Common example that most people are familiar with is a LoggingInterceptor.

Attacking the problem test first drove me down a fairly interesting path that I was pleased with for a first cut. I'll explain the details in a minute, but examples speak a lot louder than words. I created a couple of dummy interfaces and a simple object to demonstrate the proxying/interception capabilities. It should also be noted that I am making use of Castle DynamicProxy as I feel it is an much easier barrier of entry for people who want to take advantage of creating dynamic proxies vs dropping down to the wire and leveraging Reflection.Emit classes directly (though that is something that I strongly recommend playing with a couple of times, just so you have an understanding for it). Here are the interceptors that will be used in this example:
{% codeblock lang:csharp %}
public class SomeInterceptor : IInterceptor 
{
  public void Intercept(IInvocation invocation) 
  {
    Console.Out.WriteLine("Interception occured on method{0} with {1} ",invocation.Method.Name,this.GetType().Name);
    invocation.Proceed();
  }
}


public class SomeOtherInterceptor : IInterceptor 
{
  public void Intercept(IInvocation invocation) 
  {
    Console.Out.WriteLine("Interception occured on method {0} with {1} ",invocation.Method.Name,this.GetType().Name);
    invocation.Proceed();
  }
}
 
{% endcodeblock %}




As you can see. Both of these interceptors are ridiculously simple. They both implement the IInterceptor interface that comes from Castle.Core, the interface itself only has one method called Intercept which is the method that will get invoked by the proxy when a method call is intercepted. Both of these classes lived in a test fixture class file, so I was not concerned with the evident duplication. Here are the interface and implementation for the item that is going to be proxies:
{% codeblock lang:csharp %}
public interface IAnInterface
{
    void OneMethod();
    void SecondMethod();
    int FirstValueReturningMethod();
    int ValueReturningMethodWithAnArgument(int number);
}

public class SomeImplementation : IAnInterface
{
    public void OneMethod()
    {
        Console.Out.WriteLine("Real work is being done in OneMethod");       
    }

    public void SecondMethod()
    {
        Console.Out.WriteLine("Real work is being done in SecondMethod");
    }

    public int FirstValueReturningMethod()
    {
        Console.Out.WriteLine("Real work is being done in FirstValueReturningMethod");
        return 1;
    }

    public int ValueReturningMethodWithAnArgument(int number)
    {
        Console.Out.WriteLine("Real work is being done in ValueReturningMethodWithAnArgument");
        return 1 + number;
    }
}
{% endcodeblock %}




Again, substitute this interface and implementation with any interface/implementation pair that you would want to create a proxy for in your own application. With all of those, I'll show you some usages of the final product before explaining the solution:

<strong>Scenario 1 : Intercept on all method invocations with a SomeInterceptor</strong>
{% codeblock lang:csharp %}
[Test]
public void Should_proxy_all_methods_with_some_interceptor()
{            
    IAnInterface anImplementationOfTheInterfaceToProxy = new SomeImplementation();

    sut = new ProxyBuilder<IAnInterface>();
    sut.AddInterceptor<SomeInterceptor>();

    IAnInterface proxy = sut.CreateProxyFor(anImplementationOfTheInterfaceToProxy);
    proxy.OneMethod();
    proxy.SecondMethod();
}
{% endcodeblock %}




Which results in the following console output:<pre class="console">Interception occured on method OneMethod with SomeInterceptor
Real work is being done in OneMethod
Interception occured on method SecondMethod with SomeInterceptor
Real work is being done in SecondMethod</pre>



Notice that the interceptor was leveraged on both method calls prior to the call on the underlying item being made.

<strong>Scenario 2 : Intercept on all method invocations with multiple interceptors</strong>
{% codeblock lang:csharp %}
[Test]
public void Should_proxy_all_methods_with_multiple_interceptors()
{
    IAnInterface anImplementationOfTheInterfaceToProxy = new SomeImplementation();

    sut = new ProxyBuilder<IAnInterface>();
    sut.AddInterceptor<SomeInterceptor>();
    sut.AddInterceptor<SomeOtherInterceptor>();

    IAnInterface proxy = sut.CreateProxyFor(anImplementationOfTheInterfaceToProxy);
    proxy.OneMethod();
    proxy.SecondMethod();
    
}
{% endcodeblock %}




Which produces the following console output:<pre class="console">Interception occured on method OneMethod with SomeInterceptor
Interception occured on method OneMethod with SomeOtherInterceptor
Real work is being done in OneMethod
Interception occured on method SecondMethod with SomeInterceptor
Interception occured on method SecondMethod with SomeOtherInterceptor
Real work is being done in SecondMethod </pre>



In this scenario both of the individual interceptors were invoked on any method call to the proxied item. Ok, so that was easy, lets try the next one:

<strong>Scenario 3 : Intercept on specific method invocations with a Single interceptor:</strong>

 
{% codeblock lang:csharp %}
[Test]
public void Should_proxy_only_targeted_methods_with_a_single_interceptor()
{
    sut = new ProxyBuilder<IAnInterface>();
    anImplementation = new SomeImplementation();

    IInterceptorConstraint<IAnInterface> constraint = sut.AddInterceptor<SomeInterceptor>();
    constraint.InterceptOn.OneMethod();

    IAnInterface proxy = sut.CreateProxyFor(anImplementation);
    proxy.OneMethod();
    proxy.SecondMethod();
}
{% endcodeblock %}




Which produces the following output:<pre class="console">Interception occured on method OneMethod with SomeInterceptor
Real work is being done in OneMethod
Real work is being done in SecondMethod </pre>



Notice in the test above the use of the constraint that is returned from the Add method. Notice the call to the constraint.InterceptOn.OneMethod(). That is actually setting a filter to only enable the interceptor when that method is invoked on the proxy. For those familiar with Natural Mocks syntax (Rhino Mocks / TypeMock) this should look similar. It also has the nice benefit of not requiring the use of strings to specify which methods to filter on. Which means that it is also refactoring friendly. Notice that even though 2 method calls are made on the proxy, the interceptor only kicks in for the method that the constraint was configured for!!

<strong>Scenario 4 : Intercept on specific method invocations with differing interceptors:</strong>
{% codeblock lang:csharp %}
[Test] 
public void Should_proxy_only_targeted_methods_with_differing_interceptors() 
{
  sut = new ProxyBuilder<IAnInterface>();
  anImplementation = new SomeImplementation();
  IInterceptorConstraint<IAnInterface> constraint1 = sut.AddInterceptor<SomeInterceptor>();
  constraint1.InterceptOn.OneMethod();
  IInterceptorConstraint<IAnInterface> constraint2 = sut.AddInterceptor<SomeOtherInterceptor>();
  constraint2.InterceptOn.SecondMethod();
  IAnInterface proxy = sut.CreateProxyFor(anImplementation);
  proxy.OneMethod();
  proxy.SecondMethod();
}
{% endcodeblock %}




Which results in the following console output:<pre class="console">Interception occured on method OneMethod with SomeInterceptor
Real work is being done in OneMethod
Interception occured on method SecondMethod with SomeOtherInterceptor
Real work is being done in SecondMethod </pre>



Notice how in this example the interceptors are firing selectively for the methods that they were configured for.

Finally you can configure multiple method constraints at a time using the following syntax:
{% codeblock lang:csharp %}
constraint.InterceptOnMethods( constraint.InterceptOn.FirstValueReturningMethod(), constraint.InterceptOn.ValueReturningMethodWithAnArgument(0));  
{% endcodeblock %}




Again, the syntax for this was heavily inspired by prolonged usage of Rhino Mocks. So let's inspect the players that come together to make this all work:

 
{% codeblock lang:csharp %}
public class ProxyBuilder<T> : IProxyBuilder<T>  
{
  private IProxyFactory proxyFactory;
  private IInterceptorConstraintSet constraintSet;
  public ProxyBuilder():this(new ProxyFactory(),new InterceptorConstraintSet()) 
  {

  }
  public ProxyBuilder(IProxyFactory proxyFactory, IInterceptorConstraintSet constraintSet) 
  {
    this.proxyFactory = proxyFactory;
    this.constraintSet = constraintSet;
  }
  public IInterceptorConstraint<T> AddInterceptor<Interceptor>() where Interceptor : IInterceptor,new() 
  {
    constraintSet.AddConstraintFor<Interceptor,T>();
    return constraintSet.GetConstraintFor<Interceptor,T>();
  }
  public T CreateProxyFor<T>(T instance) 
  {
    return proxyFactory.CreateProxyUsing<T>(instance, constraintSet);
  }

}
{% endcodeblock %}




This is entry point to the api used to create proxies and associate interceptors with them. Driving out the design in a test first manner really helped me push off responsibilities to the last possible moment. Which leaves the ProxyBuilder class fairly simple. It leverages both a ProxyFactory and an InterceptorContraintSet. The InterceptorConstraintSet is just a strongly typed collection of constraints with a little bit of smarts to it:
{% codeblock lang:csharp %}
public class InterceptorConstraintSet : IInterceptorConstraintSet 
{
  private IDictionary<Type, object> constraints;
  private IInterceptorConstraintFactory constraintFactory;
  public InterceptorConstraintSet():this(new Dictionary<Type,object>(),new InterceptorConstraintFactory(new ProxyFactory())) 
  {

  }
  public InterceptorConstraintSet(IDictionary<Type, object> constraints, IInterceptorConstraintFactory constraintFactory) 
  {
    this.constraints = constraints;
    this.constraintFactory = constraintFactory;
  }
  public void AddConstraintFor<Interceptor, Target>() where Interceptor : IInterceptor, new() 
  {
    if (constraints.ContainsKey(typeof(Interceptor))) return;
    constraints.Add(typeof (Interceptor), constraintFactory.CreateFor<Interceptor, Target>());
  }
  public IInterceptorConstraint<Target> GetConstraintFor<Interceptor, Target>() where Interceptor : IInterceptor, new() 
  {
    return (IInterceptorConstraint<Target>) constraints[typeof (Interceptor)];
  }
  public IInterceptor[] AllInterceptors<Target>() 
  {
    return SetOfAllInterceptorsFor<Target>().AsList().ToArray();
  }
  private IEnumerable<IInterceptor> SetOfAllInterceptorsFor<Target>() 
  {
    foreach (IInterceptorConstraint<Target> constraint in constraints.Values) 
    {
      yield return constraint.BuildInterceptor();
    }
  }
}
{% endcodeblock %}




The SetOfAllInterceptorsFor<Target> method is interesting as this is where the work to create the interceptors for a proxy is delegated to the constraint. The InterceptorConstraint and its accompanying collaborators is what allows for the natural syntax:

 
{% codeblock lang:csharp %}
public class InterceptorConstraint<Target,Interceptor> : IInterceptorConstraint<Target> where Interceptor : IInterceptor,new()
{
    private readonly IMethodCallTracker<Target> callTracker;


    public InterceptorConstraint(IMethodCallTracker<Target> callTracker)
    {
        this.callTracker = callTracker;
    }


    public Target InterceptOn
    {
        get { return callTracker.Target; }
    }

    public void InterceptOnMethods(params object[] makeMethodCallsUsingInterceptOnProperty)
    {

    }


    public void InterceptOnMethods(params Action[] makeMethodCallsToInterceptOnPropertyInsideOfActionDelegate)
    {
        foreach (Action action in makeMethodCallsToInterceptOnPropertyInsideOfActionDelegate)
        {
            action();
        }
    }

    public IInterceptor BuildInterceptor()
    {
        if (callTracker.CallsWereMade) return new SelectiveInterceptor(new Interceptor(), callTracker.AllMethods());

        return new Interceptor();
    }
}
{% endcodeblock %}




The work of doing the interceptor filtering is done in the BuildInterceptor method. The InterceptorConstraint makes use of a MethodCallTracker which keeps track of whether calls were made to filter on selective methods. If the client is requesting a filtered interceptor the InterceptorConstraint returns an instance of a SelectiveInterceptor. SelectiveInterceptor is a proxy for an Interceptor (I know that is a mouthful!!):
{% codeblock lang:csharp %}
public class SelectiveInterceptor : IInterceptor 
{
  private IInterceptor interceptor;
  private IDictionary<string,string> methodsToInterceptOn;
  public SelectiveInterceptor(IInterceptor interceptor, IDictionary<string, string> methodsToInterceptOn) 
  {
    this.interceptor = interceptor;
    this.methodsToInterceptOn = methodsToInterceptOn;
  }
  public void Intercept(IInvocation invocation) 
  {
    if (methodsToInterceptOn.ContainsKey(invocation.Method.Name)) 
    {
      interceptor.Intercept(invocation);
      return;
    }
    invocation.Proceed();
  }
}
  
{% endcodeblock %}




Selective interceptor decides whether or not to forward the call onto the associated interceptor, if the method is not in the dictionary of methods to intercept on, it bypasses the interceptor and directly forwards the call onto the item to proxy.

Notice the user of : {% codeblock lang:csharp %}new Interceptor(); {% endcodeblock %}



This creates a new instance of whatever the interceptor type was that was specified by the AddInterceptor<Interceptor> method call back on the ProxyBuilder. This works because of the generic constraint that ensured that the IInterceptor implementation also had a public no-arg constructor.

Last but not least, you are probably curious as to how the natural syntax is enabled? Take a look at the MethodCallFactory class:

{% codeblock lang:csharp %}
public class MethodCallTrackerFactory : IMethodCallTrackerFactory
{
    private ProxyGenerator proxyGenerator;

    public MethodCallTrackerFactory(ProxyGenerator proxyGenerator)
    {
        this.proxyGenerator = proxyGenerator;
    }

    public IMethodCallTracker<T> CreateFor<T>()
    {
        MethodCallTracker<T> methodCallTracker = new MethodCallTracker<T>();
        T target = proxyGenerator.CreateInterfaceProxyWithoutTarget<T>(methodCallTracker);
        methodCallTracker.Target = target;
        return methodCallTracker;
    }
}
{% endcodeblock %}










The ProxyGenerator class is supplied by Castle.DynamicProxy. I am using it to create a proxy around an interface without an actual underlying target:
{% codeblock lang:csharp %}
T target = proxyGenerator.CreateInterfaceProxyWithoutTarget<T>(methodCallTracker); 
{% endcodeblock %}

Notice how after the MethodCallTracker is instantiated, it is passed in as an argument to the CreateInterfaceProxyWithoutTarget method? This method takes either a single or variable array of IInterceptor implementations. That’s right. The MethodCallTracker is itself as IInterceptor implementation. It intercepts calls on its Target property so that it can store the calls to be used in the Interception filtering process:

{% codeblock lang:csharp %}
public class MethodCallTracker<T> : IMethodCallTracker<T>
{
  public T Target{get;set;}

  private IDictionary<string, string> methodNames;


  public MethodCallTracker() : this(new Dictionary<string, string>())
  {
  }

  public MethodCallTracker(IDictionary<string, string> methodNames)
  {
    this.methodNames = methodNames;
  }


  public void Intercept(IInvocation invocation)
  {
    SetReturnValueFor(invocation);

    if (methodNames.ContainsKey(invocation.Method.Name)) return;

    methodNames.Add(invocation.Method.Name, invocation.Method.Name);
  }

  private void SetReturnValueFor(IInvocation invocation)
  {
    Type returnType = invocation.Method.ReturnType;

    if (returnType == typeof(void)) return;

    invocation.ReturnValue = (returnType.IsValueType ? Activator.CreateInstance(returnType) : null);
  }


  public bool CallsWereMade
  {
    get { return methodNames.Count > 0; }
  }


  public IDictionary<string, string> AllMethods()
  {
    return methodNames.Copy();
  }
}
{% endcodeblock %}




And finally, the glue that ties it all together. ProxyFactory, this class actually creates proxies instances leveraging the Castle ProxyGenerator as well as the completed InterceptorConstraintSet:

 
{% codeblock lang:csharp %}
public class ProxyFactory : IProxyFactory
{
    private ProxyGenerator proxyGenerator;
    private IMethodCallTrackerFactory methodCallTrackerFactory;


    public ProxyFactory():this(new ProxyGenerator(),new MethodCallTrackerFactory(new ProxyGenerator()))
    {
    }

    public ProxyFactory(ProxyGenerator proxyGenerator, IMethodCallTrackerFactory methodCallTrackerFactory)
    {
        this.proxyGenerator = proxyGenerator;
        this.methodCallTrackerFactory = methodCallTrackerFactory;
    }

    public IMethodCallTracker<T> CreateMethodCallTracker<T>()
    {
        return methodCallTrackerFactory.CreateFor<T>();
    }

    public T CreateProxyUsing<T>(T instance, IInterceptorConstraintSet constraints)
    {
        return proxyGenerator.CreateInterfaceProxyWithTarget<T>(instance, constraints.AllInterceptors<T>());
    }
}
{% endcodeblock %}




People ask me why I love TDD? It's because you can start with a blank slate, drive out the components one at a time in isolation from another, isolating/deferring responsibilities as you go, and finally you can plug all of the pieces together. In all of the code samples above I added in the poor mans dependency injection so that people could see the concretes being injected into the dependent. In the actual source code, an IOC container is being used. As when driving out the solution the interfaces were used to defer responsiblity to another object that did not exist yet. Taking this code, it would not be hard to add the pre/post/both filter also so that you could choose when specifically to apply an interceptor!! And of course I could eliminate the method call tracker altogether if I made use of lambda expressions and parsed the expression tree to see what method was called. I'll leave that for another day!!

Develop With Passion!!




