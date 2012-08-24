---
layout: post
title: "The Open Closed Principle. - How Far Do You Take It"
comments: true
date: 2007-04-10 09:00
categories:
- programming
---

A couple of good comments came up in the last post about the use of utility classes in the realm of SRP. I made the statement that I personally don't mind using utility classes sparingly, as long as the class itself is adhering to the rules of SRP, meaning that the methods it is composed of revolve around one discrete area of functionality.

Ayende brought up a good code example and asked Jeff how he would handle the situation without using utility classes (Jeff posted a response to this question). This is the code that Ayende provided:


{% codeblock lang:csharp %}
public void QueueToExecute(ICommand command)
{

  Validation.NotNull(command, "command");

  // do stuff
}
{% endcodeblock %}














For those not familiar, the check that is being performed to ensure that the command is not null could be viewed as a simple validation check. Some developers refer to this as more than simple validation checking and refer to it as [DBC (Design By Contract).](http://en.wikipedia.org/wiki/Design_by_contract) Intentional or not, the explicit checking of the 'non null precondition' is a DBC technique, used to indicate to the client developer preconditions that must be in place for the method to continue, I digress!!

So what does [OCP](http://en.wikipedia.org/wiki/Open/closed_principle) have to do with any of the code that was talked about the other day? Looking at the code above, I could make an assumption that the method lives on some sort of ICommandQueue implementation (we'll call it CommandQueue). And it could look something like this (lots omitted for brevity):
{% codeblock lang:csharp %}
public class CommandQueue : ICommandQueue
{
    private Queue<ICommand> commands;

    public CommandQueue() : this(new Queue<ICommand>())
    {
    }

    public CommandQueue(IEnumerable<ICommand> initialSetToQueue)
    {
        commands = new Queue<ICommand>(initialSetToQueue);
    }

    public void QueueToExecute(ICommand command)
    {
        commands.Enqueue(command);
    }
}
{% endcodeblock %}


Notice that the current version of CommandQueue does not contain the check for nulls on the QueueToExecute method. I could leverage DBC to ensure that preconditions expected by the client are met before adding the Command to the queue. This results in the call to the utility Validation class that Ayende brought in earlier:
{% codeblock lang:csharp %}
public void QueueToExecute(ICommand command)
{
    Validation.NotNull(command,"command");
    commands.Enqueue(command);
}
{% endcodeblock %}


This works. If the Validation class is simply a static container for procedural methods the NotNull method could look as follows:<font face="Courier New"></font>
{% codeblock lang:csharp %}
public class Validation
{
    public static  void NotNull(object item,string itemDescription)
    {
        if (item == null) throw new ContractViolationException(itemDescription);
    }
}
{% endcodeblock %}


On the other hand, Validation could be a mere [Gateway](http://www.martinfowler.com/eaaCatalog/gateway.html) that provides convienient access to discrete Assertion objects etc. I could carry on but I would rather focus on the current consumer of the Validation class itself. The CommandQueue. In the original implementation of CommandQueue, it had no smarts about performing the null check on incoming commands. By introducing the explicit check in the QueueToExecute method I have satisfied a rule that needed to be encapsulated for the method, but in the process I have violated the Open Closed Principle.

<strong><u>The Open Closed Principle</u></strong>

<strong>'a class should be Open for extension but Closed for modification'.</strong>

Back to the CommandQueue example, the original CommandQueue implementation worked fine before the requirement came along that said that it should ensure that incoming commands are not null. If I wanted to adhere to OCP, the 'Closed' part of the principle states that I should not need to change my original implementation to deal with the new requirement. The 'Open' part of the principle means that my design should allow me to add new behaviour to a CommandQueue without needing to go in and actually change the code of the original CommandQueue implementation. There are a couple of ways I could accomplish this and still adhere to OCP. For now, I'll use a [Proxy](http://en.wikipedia.org/wiki/Proxy_pattern) to ensure that commands coming in cannot be null:
{% codeblock lang:csharp %}
public class NullRejectingCommandQueue : ICommandQueue
{
    private ICommandQueue queueToProxy;

    public NullRejectingCommandQueue(ICommandQueue queueToProxy)
    {
        this.queueToProxy = queueToProxy;
    }

    public void QueueToExecute(ICommand command)
    {
        Validation.NotNull(command,"command");
        queueToProxy.QueueToExecute(command);
    }

}
{% endcodeblock %}


With this proxy in place, I can remove the validation check from the original CommandQueue, and I have extended it without changing it. In my service layer (or container preferably), I could ensure that all instances of CommandQueues get wrapped in the NullRejectingCommandQueue proxy so that the null check will be performed. Without bringing a container into the mix, I could use a factory to get instances of CommandQueues: 
{% codeblock lang:csharp %}
public class CommandQueueFactory : ICommandQueueFactory
{
    public ICommandQueue Create()
    {
        return new NullRejectingCommandQueue(new CommandQueue());
    }
}
{% endcodeblock %}


<strong><u>Reality Check</u></strong>

I am hoping that most of you realize that this could very well be overkill for what you are trying to do. Part of evolving as a good designer is knowing when trying to adhere to a principle, or leverage a pattern can actually be detrimental to your code. What can help you answer that question? Time and practice. The first step in becoming a good designer, is being able to first identify the smells in your code. Just because you have a cold does not mean that everyone else can't smell the fish in your garbage can. Once you are able to identify the code smells, before even looking at design patterns, you should get a good handle on some of the fundamental design principles that can lead you to cleaner OO designs (SRP and OCP being 2 of them).

Remember how I said that all of the design principles in one way or another tie back to SRP. In this example, performing the check for null commands was not an intended 'responsibility' of the command queue class. It's responsibility was to queue commands for execution. By adding the null check, we added added another responsibility to the CommandQueue class. I am not suggesting that the null check should not be there. I just wanted to demonstrate how you can extend the behaviour of an object (open it up with new responsibilities) without having to change the target object itself.




