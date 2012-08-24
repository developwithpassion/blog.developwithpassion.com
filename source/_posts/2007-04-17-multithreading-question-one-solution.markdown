---
layout: post
title: "Multithreading Question - One Solution"
comments: true
date: 2007-04-17 09:00
categories:
- c sharp
- programming
---

This morning had a good question asked:

Q: Basically we're writing the billing processing part of our business
application.  On the 1st and 15th of the month, we bill all our
policy holders and it's usually 10,000 or so transactions that need to
be run.  The processor gateway runs as a webservice.  Now since these
10,000 don't rely on each other at all, I figured to speed it up I
could run 10-20 at a time in a job.
 
So I wrote this simple class so far, but I'm not sure if it's even
close, it just takes a processing date, loads all the queued
transactions, and sends them into the authorize and payment manager.
It seems that async threads you have to delegate to a void
parameterless method, so I built a locked incrementer for the index on
the generic list of transactions and try to process them like that.
It's the while loop stuff that is lame, I'd really like it to just
spawn X number of threads where X is configurable.  Maybe I just dont'
get it, here's the code though: 
{% codeblock lang:csharp %}
public class Billing
{
     public Billing(DateTime ProcessDate)
     {
         _ProcessDate = ProcessDate;
         PopulateTransactions();
         ExecuteBilling();
     }

     private Int32 _TransactionIndex = 0;
     private List<Transaction _TransactionsToBill;
     private DateTime _ProcessDate;

     private void PopulateTransactions()
     {
        _TransactionsToBill = TransactionManager.GetQueuedTransactions(_ProcessDate);
     }

     private void ExecuteBilling()
     {
         do
         {
             Thread t1 = new Thread(new ThreadStart(ProcessTransaction));
             t1.Start();

             Thread t2 = new Thread(new ThreadStart(ProcessTransaction));
             t2.Start();

             Thread t3 = new Thread(new ThreadStart(ProcessTransaction));
             t3.Start();

             Thread t4 = new Thread(new ThreadStart(ProcessTransaction));
             t4.Start();

             Thread t5 = new Thread(new ThreadStart(ProcessTransaction));
             t5.Start();

         } while (_TransactionIndex < _TransactionsToBill.Count);
     }

     private void ProcessTransaction()
     {
        string Message;
        Transaction transaction = GetNextTransaction();

        if (transaction != null)

        CyberSourceManager.AuthorizeAndCapture(transaction.InvoiceID,transaction.ID, out Message);
     }

     private Transaction GetNextTransaction()
     {
         Interlocked.Increment(ref _TransactionIndex);
         if (_TransactionsToBill.Count  _TransactionIndex)
         {
             return _TransactionsToBill[_TransactionIndex - 1];
         }

         return null;
     }
}
{% endcodeblock %}


A: The main problem that you are concerned about is : 'I'd really like it to just spawn X number of threads where X is configurable'. The following code is another alternative implemented using the Monitor class to create a producer/consumer queue:
{% codeblock lang:csharp %}
public class Billing
{
    private Queue<Transaction> transactionQueue;
    private IList<Thread> workerThreads;
    private object mutex;

    public Billing(int numberOfWorkerThreadsToUse,IEnumerable<Transaction> itemsToProcess)
    {
        mutex = new object();
        workerThreads = new List<Thread>();
        transactionQueue = new Queue<Transaction>();

        InitializeConsumers(numberOfWorkerThreadsToUse);
        QueueUp(itemsToProcess);
        QueueEmptyTransactionsForEachActiveThread();
    }

    private void QueueUp(IEnumerable<Transaction> toProcess)
    {
        foreach (Transaction transaction in toProcess)
        {
            QueueForProcessing(transaction);
        }
    }

    private void QueueEmptyTransactionsForEachActiveThread()
    {
        foreach (Thread wokerThread in workerThreads)
        {
            QueueForProcessing(null);
        }
    }

    private void QueueForProcessing(Transaction transaction)
    {
        lock (mutex)
        {
            transactionQueue.Enqueue(transaction);
            Monitor.PulseAll(mutex);
        }
    }

    private void InitializeConsumers(int numberToInitialize)
    {
        for (int i = 0; i < numberToInitialize; i++)
        {
            Thread thread = new Thread(ProcessTransactions);
            workerThreads.Add(thread);
            thread.Start();
        }
    }

    private void ProcessTransactions()
    {
        while (true)
        {
            Transaction transaction = null;
            lock (mutex)
            {
                while (transactionQueue.Count == 0) Monitor.Wait(mutex);
                transaction = transactionQueue.Dequeue();
            }
            if (transaction == null) return;

            Process(transaction);
        }
    }

    private void Process(Transaction transaction)
    {
        //Do you work here
    }
}
{% endcodeblock %}


The advantage of this code over the prior code is it mitigates unecessary allocation of an unknown number of threads and opts for the creation of an explicit 'known' number of worker threads that will process items on the queue. This code leverages the ability to wait on a locked object. When a transaction is Queued up, Monitor.PulseAll is invoked (on the mutex) to wake up all threads that may already be waiting on that mutex,based on which thread is currently highest in the lock queue, it will be able to Dequeue a single transaction from the 'transaction' queue and process it.

The constructor for the Billing class allows you to specify how many worker threads should be created. You should notice, that the Consumer threads can start immediately processing Transactions the second a Transaction is queued for processing. This has the benefit of not needing to have the queue populated in its entirety before processing. As new items are added to the queue, a worker thread can pick it up and process it. Once all of the real transactions have been added to the queue for processing, a 'null' transaction is placed onto the queue for each worker thread that was created. This ensures that each thread will actually terminate.

Notice how in the ProcessTransactions method, it does not stop processing if the number of items in the queue == 0. This is because (again, multi threaded coding is hard) since items are being added to the queue from a separate thread, and items are being processed by 1 of the many worker threads, the client thread may not have had the opportunity to place items on the queue before the (transactionQueue.Count 









{% codeblock lang:csharp %}
new Billing(5,transactionService.GetTransactionsToProcess()); 
{% endcodeblock %}

