---
layout: post
title: "BDD Specification Base Class"
comments: true
date: 2007-12-19 09:00
categories:
- c sharp
- programming
---

With a newfound interest in leveraging the [AutoMockingContainer](http://blog.eleutian.com/2007/08/05/UsingTheAutoMockingContainer.aspx) (credit to [James ](http://www.jameskovacs.com/) for convincing me of this approach) here is the code for my base class used to write BDD style interaction based tests:
{% codeblock lang:csharp %}
public abstract class Specification
  {
      private MockRepository mockery;
      private AutoMockingContainer container;

      protected MockRepository Mocks
      {
          get { return mockery; }
      }

      protected AutoMockingContainer Container
      {
          get { return container; }
      }

      [SetUp]
      public void BaseSetup()
      {
          mockery = new MockRepository();
          container = new AutoMockingContainer(mockery);
          container.Initialize();
          Before_each_spec();
      }

      [TearDown]
      public void TearDown()
      {
          After_Each_Spec();
      }

      protected virtual void After_Each_Spec()
      {
      }


      public IDisposable PlayBackOnly
      {
          get
          {
              using (Record)
              {
              }
              return PlayBack;
          }
      }

      public void BackToRecord(object mockObject)
      {
          Mocks.BackToRecord(mockObject);
      }

      public IDisposable Record
      {
          get { return Mocks.Record(); }
      }

      public IDisposable PlayBack
      {
          get { return Mocks.Playback(); }
      }

      public abstract void Before_each_spec();


      public Item CreateSUT<Item>()
      {
          return container.Create<Item>();
      }

      public Interface CreateStrictMockOf<Interface>()
      {
          return mockery.CreateMock<Interface>();
      }

      public IEnumerable<T> CreateMockEnumerable<T>()
      {
          return CreateMock<IEnumerable<T>>();
      }

      public T Mock<T>() where T : class
      {
          return container.Get<T>();
      }

      public void ProvideAnImplementationOf<Interface, Implementation>()
      {
          container.AddComponent(typeof (Implementation).FullName, typeof (Interface), typeof (Implementation));
      }

      public void ProvideAnImplementationOf<Interface>(object instance)
      {
          container.Kernel.AddComponentInstance(instance.GetType().FullName, typeof (Interface), instance);
      }


      protected Interface CreateMock<Interface>()
      {
          return Mocks.DynamicMock<Interface>();
      }
  }
{% endcodeblock %}


I changed some of my original method names to match up with what [Dave ](http://codebetter.com/blogs/david_laribee/archive/2007/12/17/approaching-bdd.aspx)was doing (for a bit of consistency).Here is an example of a testfixture that leverages this as the base (this test happens to use an explicit CreateSUT method, vs the one provided by the AutoMockingContainer):

 
{% codeblock lang:csharp %}
[TestFixture]
public class When_told_to_visit_all_items : Specification
{
  private IVisitor<int> visitor;
  private RichList<int> numbers;
  private IEnumerableActions<int> sut;

  private IEnumerableActions<int> CreateSUT()
  {
    return new EnumerableActions<int>(numbers);
  }
  public override void Before_each_spec()
  {
    numbers = new RichList<int>();
    numbers.Add(1);
    numbers.Add(2);
    sut = CreateSUT();
    visitor = CreateMock<IVisitor<int>>();            
  }

  [Test]
    public void Should_tell_visitor_to_visit_all_items_in_the_enumerable()
    {
      using (Record)
      {
        foreach (int i in numbers)
        {
          visitor.Visit(i);
        }                
      }
      using (PlayBack)
      {
        sut.VisitAllItemsUsing(visitor);
      }
    }
}
{% endcodeblock %}




Develop With Passion!




