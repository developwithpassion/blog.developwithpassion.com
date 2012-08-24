---
layout: post
title: "BDD, AAA Style Testing and Rhino Mocks"
comments: true
date: 2008-06-13 09:00
categories:
- c sharp
- programming
---
Having downloaded and started to use Rhino Mocks 3.5 beta pretty much as soon as Oren released. I am very happy with the AAA style (Arrange, Act, Assert) and the readability and brevity it has brought to my tests. The current project I am on has a huge set of tests. Here is an example of using Rhino Mocks, in conjunction with some BDD style naming:

{% codeblock lang:csharp %}
[Concern(typeof (UnitOfWorkFactory))] 
public class When_a_new_unit_of_work_is_requested_to_be_created : behaves_like_unit_of_work_with_scope_storage_in_play 
{
  protected override void because() 
  {
    sut.Create();
  }
  [Observation] 
  public void Should_access_scoped_storage_to_determine_if_a_unit_of_work_is_already_active() 
  {
    scoped_storage.was_told_to(item => item.DoesNotContain<IUnitOfWork>());
  }

}
[Concern(typeof (UnitOfWorkFactory))] 
public class When_creating_a_unit_of_work_and_the_scoped_storage_does_not_contain_an_active_unit_of_work : behaves_like_unit_of_work_with_scope_storage_in_play 
{
  private ISession session;
  protected override void establish_context() 
  {
    base.establish_context();
    session = Dependency<ISession>();
    scoped_storage.setup_result(item => item.DoesNotContain<IUnitOfWork>()).Return(true);
    nhibernate_session_factory.setup_result(item => item.OpenSession()).Return(session);
  }
  protected override void because() 
  {
    sut.Create();
  }
  [Observation] 
  public void Should_store_the_newly_created_unit_of_work_in_scoped_storage() 
  {
    scoped_storage.was_told_to(item => item.Store(Arg<IUnitOfWork>.Matches(uow => uow != null)));
  }

}
[Concern(typeof (UnitOfWorkFactory))] 
public class When_a_new_unit_of_work_is_requested_and_one_already_exists_in_scoped_storage : behaves_like_unit_of_work_with_scope_storage_in_play 
{
  private ISession session;
  private IUnitOfWork new_unit_of_work;
  private IUnitOfWork active_unit_of_work;
  protected override void establish_context() 
  {
    base.establish_context();
    session = Dependency<ISession>();
    active_unit_of_work = Dependency<IUnitOfWork>();
    nhibernate_session_factory.setup_result(item => item.OpenSession()).Return(session);
    scoped_storage.setup_result(item => item.Contains<IUnitOfWork>()).Return(true);
    scoped_storage.setup_result(item => item.Retrieve<IUnitOfWork>()).Return(active_unit_of_work);

  }
  protected override void because() 
  {
    new_unit_of_work = sut.Create();
  }

  [Observation] 
  public void Should_return_a_non_disposing_unit_of_work_proxy() 
  {
    new_unit_of_work.should_be_an_instance_of<NonDisposableUnitOfWork>();
  }
}
{% endcodeblock %}


I am no longer using the automocking container so you are probably wondering what the Dependency method call is all about. It is simply a method defined on a base ContextSpecification class whose definition is as follows:

{% codeblock lang:csharp %}
[Context] 
public abstract class ContextSpecification 
{
  [SetUp] 
  public void setup() 
  {
    unit_test_container.Initialize();
    establish_context();
    because();

  }
  [TearDown] 
  public void teardown() 
  {
    after_each_specification();
    unit_test_container.tear_down_and_unregister_from_dependency_registry();
  }
  protected abstract void because();
  protected abstract void establish_context();
  protected virtual void after_each_specification() 
  {

  }
  protected InterfaceType Dependency<InterfaceType>() 
  {
    return MockRepository.GenerateMock<InterfaceType>();
  }
  protected InterfaceType Stub<InterfaceType>() 
  {
    return MockRepository.GenerateStub<InterfaceType>();
  }
}
{% endcodeblock %}

And I have some extension methods that wrap the RhinoMocks "assertions" with more language oriented assertions: Instead of AssertWasCalled you get was_told_to, and so on.

Decvelop With Passion!!
