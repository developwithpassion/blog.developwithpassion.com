---
layout: post
title: "Explicit Strongly Typed Selective Proxies - Part 2"
comments: true
date: 2008-01-30 09:00
categories:
- c sharp
---

This is a very short post to demonstrate the concept that I mentioned in parting during the [last post](http://blog.developwithpassion.com/ExplicitStronglyTypedSelectiveProxies.aspx).

'And of course I could eliminate the method call tracker altogether if I made use of lambda expressions and parsed the expression tree to see what method was called'

Someone fired an email asking how to do this so I thought I would quickly implement to show them the result. You can now also set filters on the interceptor by use of a lambda expression. So instead of this (and you can still do this):
{% codeblock lang:csharp %}
IInterceptorConstraint<IAnInterface>constraint = sut.AddInterceptor<SomeInterceptor>(); constraint.InterceptOn.OneMethod();  
{% endcodeblock %}






or this: 
{% codeblock lang:csharp %}
IInterceptorConstraint<IAnInterface> constraint = sut.AddInterceptor<SomeInterceptor>(); constraint.InterceptOnMethods(constraint.InterceptOn.ValueReturningMethodWithAnArgument(1));  
{% endcodeblock %}




You can now use a lambda expression which negates the need to store a reference to the constraint to apply constraints:
{% codeblock lang:csharp %}
sut.AddInterceptor<SomeInterceptor>()
   .InterceptCallTo(x => x.OneMethod())
   .InterceptCallTo(x => x.SecondMethod());
{% endcodeblock %}




The InterceptCallTo method accepts an ExpressionTree of type Action<T> where T is the target to be proxied. The code to parse this expression tree into a method call is very simple. The InterceptorConstraint class just forwards the call onto its MethodCallTracker:
{% codeblock lang:csharp %}
public IInterceptorConstraint<Target> InterceptCallTo(Expression<Action<Target>> expression)
{
    callTracker.AddCallInferredFrom(expression);
    return this;
}
{% endcodeblock %}




Notice that the method returns the InterceptorConstraint itself, which is what allows for the very limited fluent interface. As far as parsing the expression to store the method to be intercepted on, it is all done by the MethodCallTracker itself: 
{% codeblock lang:csharp %}
public void AddCallInferredFrom(Expression<Action<T>> expression)
{
    MethodCallExpression methodCallExpression = expression.Body as MethodCallExpression;
    if (methodCallExpression != null) AddCallFor(methodCallExpression.Method.Name);
}
{% endcodeblock %}




That's it, that's all. The AddCallFor method is now called from both here and the original Interception tracker to store the list of methods that should be intercepted on.

Develop with Passion!!




