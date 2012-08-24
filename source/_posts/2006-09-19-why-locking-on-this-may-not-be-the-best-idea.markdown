---
layout: post
title: "Why Locking On This May Not Be The Best Idea"
comments: true
date: 2006-09-19 09:00
categories:
- .net 2.0
- c sharp
---

Ever since .Net came on the scene, developers have been able to "easily" add multithreaded features to their codebases. I say "easily" because even in .Net, multithreading is something that lots of developers are still not completely comfortable with, or understand well enough to take advantage of it without the pitfalls commonly associated. 
Take a look at a code fragment for a class I want to have used in a multithreaded environment (note that in this code fragment, the code that takes advantage of invoking methods on the Console object is not particularly thread-safe, but for the purpose of demonstrating work being done ignore it!!). 
 
{% codeblock lang:csharp %}
public class NotSoSafeConsumer : IConsumer 
{ 
  public void DoSomething() 
  { 
    lock(this) 
    { 
      Console.WriteLine("DoSomething"); Thread.Sleep(8000); 
    } 
  } 
  public void DoSomethingElse() 
  { 
    lock(this) 
    { 
      Console.WriteLine("DoSomethingElse"); Thread.Sleep(8000); 
    } 
  } 
}

{% endcodeblock %}


Notice that I am locking on this. Here is a sample console app that demonstrates utilizing this class from multiple threads:

 

 
{% codeblock lang:csharp %}
public static void Main()
{        
    LockAndWorkWith(new NotSoSafeConsumer());            
    Console.ReadLine();
}


private static void LockAndWorkWith(IConsumer consumer)
{          
    Thread firstMethod = new Thread(consumer.DoSomething);
    Thread secondMethod = new Thread(consumer.DoSomethingElse);
    firstMethod.Start();
    secondMethod.Start();
    firstMethod.Join();
    secondMethod.Join();        
    Console.Out.WriteLine("Finished");
}
{% endcodeblock %}


If you run the code you will notice that it behaves as expected. Ok, JP, what's the point!! Here is all that it takes to break this code: 

  
{% codeblock lang:csharp %}
private static void LockAndWorkWith(IConsumer consumer)
{     
    lock (consumer)
    {
        Thread firstMethod = new Thread(consumer.DoSomething);
        Thread secondMethod = new Thread(consumer.DoSomethingElse);
        firstMethod.Start();
        secondMethod.Start();
        firstMethod.Join();
        secondMethod.Join();        
        Console.Out.WriteLine("Finished");
    }
}
{% endcodeblock %}


Notice that the only change that I made was to add the lock statement around the consumer that is passed into the method. Once I have done that the method has acquired a lock on the consumer object. So when the consumer inside of its own method, tries to lock on itself, it cannot acquire the lock as it is already owned. 

This happens because when you are taking advantage of locking on "this" you are basically saying I want to lock critical sections of my code using a global locking construct (this), that is available to any object that can access "this"(the object in question). Here is another implementation of the IConsumer that will not suffer from the safe problems as the NotSoSafeConsumer:

 

 
{% codeblock lang:csharp %}
public class SafeConsumer : IConsumer 
{ 
  private object lockObject = new object(); public void DoSomething() 
  { 
    lock(lockObject) 
    { 
      Console.WriteLine("DoSomething"); Thread.Sleep(8000); 
    } 
  } 
  public void DoSomethingElse() 
  { 
    lock(lockObject) 
    { 
      Console.WriteLine("DoSomethingElse"); Thread.Sleep(8000); 
    } 
  } 
}

{% endcodeblock %}


If I replace the code in the main method with the following: 

 
{% codeblock lang:csharp %}
public static void Main() 
{ 
  LockAndWorkWith(new SafeConsumer()); 
  Console.ReadLine(); 
}
{% endcodeblock %}


You will notice that the code now works. I have made no changes to the LockAndWorkWith method, it is still acquiring a lock on the object itself. The object is unaffected by this now because it is using a private locking construct that no other class has access to.

There are lots more interesting locking mechanisms available in .Net such as Mutexes, Semaphores, WaitHandles etc. A large percentage of people have their needs satisfied by taking advantage of the Monitor class, which can actually provide all of the functionality of the other classes when used properly. A larger percentage of people accomplish their simple locking schemes by making use of the lock keyword. If you are going to do that, I suggest making the small change required to protect your "mutex" from the outside world.



c
