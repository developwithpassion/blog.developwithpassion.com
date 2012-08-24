---
layout: post
title: "Using TransactionScope in .Net 2.0 To Test Your Mapping Layer"
comments: true
date: 2005-12-13 09:00
categories:
- .net 2.0
---
How many times have you found yourself writing code to cleanup changes that your mapping tests make to the database. Save yourself some time and make use of the new TransactionScope class in .Net 2.0.

Take a look at the following code fragment to see a good pattern for use. The class makes use of the NUnit 2.2.3 testing framework.



{% codeblock lang:csharp %}
 [TestFixture]
  public class SomeMapperTest
  {
          TransactionScope scope;
  
          [SetUp]
          public void SetUp()
          {
              scope = new TransactionScope();
          }        
         
          [Test]
           public void ShouldBeAbleToInsertDomainObjectToDatabase()
          {
               using(scope)
               {
                    TestDatabaseGateway gateway = new TestDatabaseGateway();
                    int existingRowsInTargetTable = gateway.GetRowCountFor("TargetTable");
                    SomeDomainObject objectToPersist = new SomeDomainObject();
                    SomeMapper mapper = new SomeMapper();
                    mapper.Insert(objectToPersist);
                    Assert.AreEqual(existingRowsInTargetTable+1,
                    gateway.GetRowCountForTable(“TargetTable”));
               }
           }
 
   }
{% endcodeblock %}
