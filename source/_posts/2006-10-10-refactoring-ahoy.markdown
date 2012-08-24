---
layout: post
title: "Refactoring Ahoy!!"
comments: true
date: 2006-10-10 09:00
categories:
- .net 2.0
- c sharp
---

In response to [Stevens' post](http://www.stevenrockarts.com/blog/PermaLink,guid,ed07e269-1c74-40b6-a8e1-5002552a40b0.aspx) on the Decompose Conditional refactoring, I thought I would offer up a quick alternative that I could share with others. Take a look at the code after Stevens original refactoring (I am making guesses as to the actual implementations, but it should convey pretty accurately the general idea of what is going on. I converted the code to C#, for my sanity!! 
{% codeblock lang:csharp %}
public enum PaymentType
{
    Cash,
    CreditCard
}

public interface IPaymentView
{
    PaymentType PaymentType{get;}
    event EventHandler Save;
    decimal Amount{get;}
    void ShowMessage(string message,bool someFlag);
    void CloseView();
}

public interface IPaymentTask
{
    void SaveCashPayment(decimal amount);
    void SaveCreditCardPayment(decimal amount);
}

public class PaymentPresenter
{
    private IPaymentTask task;
    private IPaymentView view;
    
            
    public PaymentPresenter(IPaymentView view,IPaymentTask task)
    {
        this.task = task;
        this.view = view;
        HookupEventHandlersTo(view);            
    }
    
    private void HookupEventHandlersTo(IPaymentView view)
    {
        view.Save+=delegate{
                                ProcessPayment();
                            };                                
    }            
    
    
    public void ProcessPayment()
    {
        if (PaymentTypeIsCash()) 
        {
            SaveCashPayment();
        }
        else
        {
            SaveCreditCardPayment();
        }
    }
    
    private bool PaymentTypeIsCash()
    {
        return view.PaymentType == PaymentType.Cash;
    }
            
        
    private void SaveCashPayment()
    {
        try
        {
            task.SaveCashPayment(view.Amount);
        }
        catch (Exception)
        {
            view.ShowMessage("There was a problem saving the payment.",false);
        }
        view.CloseView();
    }
    
    private void SaveCreditCardPayment()
    {
        try
        {
            task.SaveCreditCardPayment(view.Amount);
        }
        catch (Exception)
        {
            view.ShowMessage("There was a problem saving the payment.",false);
        }
        view.CloseView();
    }
    
}
{% endcodeblock %}


By utilizing the Decompose Conditional refactoring, he was able to make the code in the ProcessPayment method a bit more readable. Steven asked for suggestions to help further refactor the code, and I am going to offer this one tidbit. Anytime I am switching on some data and then performing some processing based on the data, it screams like a good candidate for the "Replace Conditional with Strategy" refactoring. However, I am not going to go crazy. I will offer up a similar solution, that does not require the introduction of a whole strategy hierarchy.

The goal is to eliminate the conditional completely (and also, offer up a good migration path, in the event other payment types come into play). The key to this solution is to take advantage of delegates, and the PaymentType itself. One thing we can take advantage of in this scenario is the fact that the methods to process a payment have identical signatures. Let's create a delegate that can be used to invoke both of these methods:

 
{% codeblock lang:csharp %}
private delegate void PaymentProcessor(); 
{% endcodeblock %}


 

Armed with that signature we can now do the following:

 
{% codeblock lang:csharp %}
public class PaymentPresenter 
{
  private IPaymentTask task; 
  private IPaymentView view; 
  private delegate void PaymentProcessor(); 
  private IDictionary<PaymentType,PaymentProcessor> paymentProcessors; 
  
  public PaymentPresenter(IPaymentView view,IPaymentTask task) 
  {
    this.task = task; 
    this.view = view; 
    InitializePaymentProcessors(); 
    HookupEventHandlersTo(view); 
  }

  private void InitializePaymentProcessors() 
  {
    paymentProcessors = new Dictionary<PaymentType,PaymentProcessor>();
    paymentProcessors.Add(PaymentType.Cash,SaveCashPayment);
    paymentProcessors.Add(PaymentType.CreditCard,SaveCreditCardPayment);
  }

  private void HookupEventHandlersTo(IPaymentView view) 
  {
    view.Save+=delegate
    {
      ProcessPayment(); 
    };
  }
  public void ProcessPayment() 
  {
    paymentProcessors[view.PaymentType](); 
  }
  // public void ProcessPayment() // 
  {
    // if (PaymentTypeIsCash()) // 
    {
      // SaveCashPayment(); // 
    }
    // else // 
    {
      // SaveCreditCardPayment(); // 
    }
    // 
  }
  // private bool PaymentTypeIsCash() // 
  {
    // return view.PaymentType == PaymentType.Cash; // 
  }
  private void SaveCashPayment() 
  {
    try  
    {
      task.SaveCashPayment(view.Amount); 
    }
    catch (Exception) 
    {
      view.ShowMessage("There was a problem saving the payment.",false); 
    }
    view.CloseView(); 
  }
  private void SaveCreditCardPayment() 
  {
    try  
    {
      task.SaveCreditCardPayment(view.Amount); 
    }
    catch (Exception) 
    {
      view.ShowMessage("There was a problem saving the payment.",false); 
    }
    view.CloseView(); 
  }

}
{% endcodeblock %}


By taking advantage of the dictionary we have removed the need for both the if statement in the ProcessPayment method, as well as the method that determines whether a payment type is cash. Each payment type will be initialized to be processed by a particular process method. If a new payment type is added, it is as simple as adding a new method for processing the payment type, and an accompanying line to the InitializePaymentProcessors method, no change would be required to the ProcessPayment method.

For one last refactoring, let's eliminate the duplication that is happening in both of the Save methods. Both methods try to call the appropriate method on the service layer, if they fail the presenter tells the view to display a message, otherwise they tell the view to close. We can consolidate that logic into the ProcessPayment method as follows:

 
{% codeblock lang:csharp %}
public void ProcessPayment()
{            
    try
    {
        paymentProcessors[view.PaymentType]();            
    }
    catch (Exception)
    {                
        view.ShowMessage("There was a problem saving the payment.",false);
    }
    view.CloseView();            
}
{% endcodeblock %}


With that change in place our respective save methods become one liners:

 
{% codeblock lang:csharp %}
private void SaveCashPayment() 
{
  task.SaveCashPayment(view.Amount); 
}
private void SaveCreditCardPayment() 
{
  task.SaveCreditCardPayment(view.Amount); 
}
{% endcodeblock %}


 

Once those methods are collapsed as such, you can also inline the method calls themselves, and eliminate the methods that are just wrapping calls to the underlying service layer. To do that we need to change the signature of our delegate to a signature that matches the methods that will get called on the underlying service layer. The final result of this refactoring results in a much tighter presenter:

 
{% codeblock lang:csharp %}
public class PaymentPresenter
{
  private IPaymentTask task;
  private IPaymentView view;
  private IDictionary<PaymentType,PaymentProcessor> paymentProcessors;

  private delegate void PaymentProcessor(decimal amount);


  public PaymentPresenter(IPaymentView view,IPaymentTask task)
  {
    this.task = task;
    this.view = view;
    InitializePaymentProcessors();
    HookupEventHandlersTo(view);                        
  }

  private void InitializePaymentProcessors()
  {
    paymentProcessors = new Dictionary<PaymentType,PaymentProcessor>();            
    paymentProcessors.Add(PaymentType.Cash,task.SaveCashPayment);
    paymentProcessors.Add(PaymentType.CreditCard,task.SaveCreditCardPayment);
  }

  private void HookupEventHandlersTo(IPaymentView view)
  {
    view.Save+=delegate{
      ProcessPayment();
    };                                
  }            

  public void ProcessPayment()
  {            
    try
    {
      GetPaymentProcessorFor(view.PaymentType)(view.Amount);            
    }
    catch (Exception)
    {                
      view.ShowMessage("There was a problem saving the payment.",false);
    }
    view.CloseView();            
  }

  private PaymentProcessor GetPaymentProcessorFor(PaymentType paymentType)
  {
    return paymentProcessors[paymentType];
  }
{% endcodeblock %}


 

Of course, another option altogether is to offset the strategy for processing a payment off to the service layer (backed up by a rich domain model, with strategies for handling different payment types). With such a scenario in place you could end up with a presenter that looks like the following:

 
{% codeblock lang:csharp %}
public class ProcessPaymentDTO
{
  private decimal amount;
  private PaymentType paymentType;

  public ProcessPaymentDTO(decimal amount,PaymentType paymentType)
  {
    this.amount = amount;
    this.paymentType = paymentType;
  }

  public PaymentType PaymentType
  {
    get{return this.paymentType;}
  }

  public decimal Amount
  {
    get{return this.amount;}
  }
}

public interface IModifiedPaymentTask
{
  void Process(ProcessPaymentDTO paymentToProcess);        
}

public class ModifiedPaymentPresenter
{
  private IModifiedPaymentTask task;
  private IPaymentView view;


  public ModifiedPaymentPresenter(IPaymentView view,IModifiedPaymentTask task)
  {
    this.task = task;
    this.view = view;            
    HookupEventHandlersTo(view);                        
  }

  private void HookupEventHandlersTo(IPaymentView view)
  {
    view.Save+=delegate{
      ProcessPayment();
    };                                
  }            

  public void ProcessPayment()
  {            
    try
    {
      task.Process(new ProcessPaymentDTO(view.Amount,view.PaymentType));
    }
    catch (Exception)
    {                
      view.ShowMessage("There was a problem saving the payment.",false);
    }
    view.CloseView();            
  }

}
{% endcodeblock %}
    
Again, this is just another option you could choose,based on the requirements and architecture you already have in place. The nice thing about this solution is that the presenter and view do not need to change in order to handle new types of payments. All the work is done in the back end!!
