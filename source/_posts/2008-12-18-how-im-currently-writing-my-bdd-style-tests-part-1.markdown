---
layout: post
title: "How I'm Currently Writing My BDD Style Tests - Part 1"
comments: true
date: 2008-12-18 09:00
categories:
- c sharp
- programming
---

In the ongoing goal of “Competing against yourself daily” I have changed many things about my coding style over this past year. One of the areas that has been most affected by all of this is how I organize and write tests for the systems I am building.  
Here is an example of a test that I wrote for something called a MappingStep:  
  

{% codeblock lang:csharp %}
    public abstract class concern_for_mapping_step : observations_for_a_sut_with_a_contract<IMappingStep<SomeSourceObject, SomeDestinationObject>,
                                                         MappingStep<SomeSourceObject, SomeDestinationObject, string>>
    {
        static protected ITargetAction<SomeDestinationObject, string> target_action;
        static protected ISourceEvaluator<SomeSourceObject, string> source_evaluator;

        context c = () =>
        {
            target_action = the_dependency<ITargetAction<SomeDestinationObject, string>>();
            source_evaluator = the_dependency<ISourceEvaluator<SomeSourceObject, string>>();
        };
    }

    [Concern(typeof (MappingStep<,,>))]
    public class when_an_expression_mapping_step_is_told_to_run :
        concern_for_mapping_step

    {
        static SomeSourceObject item;
        static SomeDestinationObject destination;
        static string name;

        context c = () =>
        {
            item = new SomeSourceObject();
            name = "JP";
            destination = new SomeDestinationObject();

            source_evaluator.Stub(x => x.evaluate_against(item)).Return(name);
        };

        because b = () => sut.map(item, destination);

        [Observation]
        public void should_run_the_target_evaluator_passing_it_the_information_retrieved_from_evaluating_the_source()
        {
            target_action.was_told_to(x => x.act_against(destination, name));
        }
    }
{% endcodeblock %}





First thing to notice is a convention I have started using when it comes to writing tests. I create a base class named concern_for_[name_of_system_under_test]. You will also see that all of the fields in the test classes are static and not instance. The 2 fields in the base concern_for_mapping_step class are there to hold references to dependencies of the system under test. I don’t need to have them there as they are accessible using a helper method on the base test class (more about the base test class hierarchy in a minute), I just like to have them as I find it a bit more readable than calling methods to access the dependencies of the system under test ex:

<ul>
  <li>I prefer referring to a field named: target_action as opposed to repeatedly having to call a method such as: 
    <ul>
      <li>Mock<ITargetAction<SomeDestinationObject,string>> / the_dependency<ITargetAction<SomeDestinationObject,string>> (of course, in this example, the generic signatures emphasize the issue even more!!!) </li>
    </ul>
  </li>
</ul>


Second thing to notice is the use of a field named c which is of a delegate type named context. Here is the definition for the context delegate type:




{% codeblock lang:csharp %}
public delegate void context();
{% endcodeblock %}





Nothing all that special about it. This field will get used back up in the base test class to “establish the context for the test to run” much like a traditional setup method would / constructor if you are using xUnit.


If we focus our attention now on the “when_an_expression_mapping_step_is_told_to_run’ class, you will see that it inherits from the base concern class. The base concern class will be used to hide fields/extra noise that would otherwise pollute the test. You will see that this test also has its own context block. Context blocks are applied recursively from the top of the hierarchy down, this ensures that any contexts in base classes will always run first. In the past I would use overriden methods to accomplish this, but then you had to deal with making sure to call the base “establish_context” method, and if you forgot you could have tests fail because of a silly omission. By adhering to a convention of placing scaffolding in a context block, the “framework” takes care of ensuring that contexts are run in the correct order.


The following block:

{% codeblock lang:csharp %}
 because b = () => sut.map(item, destination);
{% endcodeblock %}



focuses our attention to what behaviour of the system under test we are testing (in the particular context). You will notice that I use the name of the class to embody both action and context. Of course, in this particular test I am focusing on a happy day scenario. An example of testing in another context could be a test fixture named:

<ul>
  <li>when_a_mapping_step_is_told_to_map_from_an_invalid_source </li>
</ul>


This name implies context. In the first test I am just testing the behaviour of mapping. In the second test (which is a different context), I am testing how the sut behaves when it is provided invalid data. One of the things that is hard to see from this example is that one context (test fixture) could have several observations (assertions). In this current example there is only 1 observation being made.


Notice that the because block, like the context block is a field of a simple delegate type (another void delegate type). This means that the code does not execute as it is just an anonymous method of certain delegate type being assigned to a field of a matching delegate type.


Finally observations are made. Notice the use of the Observation attribute. Inside an observation (Test) I will make logical assertions against either the system under test, the dependencies, or the outputs of the method under test. It is best to try to stick to one logical assertion (keeping in mind that 2 actual assertions can be part of 1 logical assertion) per observation. This is why you will often see a single Context (TestFixture) with multiple Observations.


One of the things that you may have missed is the fact that the System Under Test is never instantiated. This is also taken care of in a base class. I have the ability to override the creation of the system under test, but for most tests, letting the SUT be created for me saves a couple of lines of code, and allows me to not have to change things as more dependencies get added.


So how does all of this work? Currently all of this is coded to run against MBUnit 2.5. I have a project called developwithpassion.commons.bdd (part of developwithpassion.commons) where I place all of the plumbing code to make all of this work. Here is a snapshot of the project:


<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/HowImCurrentlyWritingMyBDDStyleTestsPart_1379D/image_2.png" rel="lightbox"><img title="image" style="border-top-width: 0px; display: inline; border-left-width: 0px; border-bottom-width: 0px; border-right-width: 0px" height="373" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/HowImCurrentlyWritingMyBDDStyleTestsPart_1379D/image_thumb.png" width="488" border="0" /></a> 


This is one of those utility type projects that got harvested over time as I saw patterns start to emerge. Under the concern folder there are 4 main classes:


<a href="{{ site.cdn_root }}binary/WindowsLiveWriter/HowImCurrentlyWritingMyBDDStyleTestsPart_1379D/image_4.png" rel="lightbox"><img title="image" style="border-top-width: 0px; display: inline; border-left-width: 0px; border-bottom-width: 0px; border-right-width: 0px" height="156" alt="image" src="{{ site.cdn_root }}binary/WindowsLiveWriter/HowImCurrentlyWritingMyBDDStyleTestsPart_1379D/image_thumb_1.png" width="518" border="0" /></a> 


In my projects I derive from either one of the following 3:

<ul>
  <li>observations_for_a_static_sut </li>

  <li>observations_for_a_sut_with_a_contract </li>

  <li>observations_for_a_sut_without_a_contract </li>
</ul>


Those 3 base classes cover the range of classes I may want to write tests against. I am hoping that the naming of the classes is pretty self explanatory. Here are the definitions for each of the above 3 classes:




{% codeblock lang:csharp %}
  public abstract class observations_for_a_static_sut : an_observations_set_of_basic_behaviours
  {
  }
{% endcodeblock %}





This one is the most basic, it simply inherits from “an_observations_set_of_basic_behaviours”. I derive from this class when I am testing static classes. The other 2 are equally as simple with a little twist:




{% codeblock lang:csharp %}
  public abstract class observations_for_a_sut_with_a_contract<Contract, ClassUnderTest> : observations_for_an_instance_sut<Contract, ClassUnderTest>
        where ClassUnderTest : Contract
    {
    }
{% endcodeblock %}





I derive from this class when I want to write tests against a class, but code the tests against an interface of the class, and not the class itself. Here the term interface/contract applies to either a C# interface, or a class that the ClassUnderTest inherits from (usually an abstract class). The final base class (that I can choose to derive from) is very similar:




{% codeblock lang:csharp %}
 public abstract class observations_for_a_sut_without_a_contract<SystemUnderTest> : observations_for_an_instance_sut<SystemUnderTest, SystemUnderTest>  { } 
{% endcodeblock %}


Notice how this class derives from the same class as the previous class, except that it uses the same type for providing the generic arguments to the “observations_for_an_instance_sut”


Again, the 3 classes that I have just covered are there to introduce a convention for people (right now just me) to follow when they are writing their own tests classes. The naming of the 3 makes it pretty simple( I think) to figure out which one you would start with.


With those 3 covered it really leaves the 2 “big ones” that hide a lot of plumbing and MBUnit specific details. Let’s start by taking a look at the skeleton for the “an_observations_set_of_basic_behaviours”:




{% codeblock lang:csharp %}
    [Observations]
    public abstract class an_observations_set_of_basic_behaviours
    {
        static protected IDictionary<Type, object> dependencies;
        static Exception exception_thrown_while_sut_performed_its_work;
        static protected Action behaviour_of_the_sut;

        [SetUp]
        public void setup() { }

        [TearDown]
        public void tear_down() { }

        void do_setup() { }

        after_each_observation a = () => dependencies.Clear();

        ICommand build_command_chain<DelegateType>() { }

        void run_action<DelegateType>() { }

        protected virtual void initialize_system_under_test() { }

        static public void doing(Action action) { }

        static protected Exception exception_thrown_by_the_sut { }

        static Exception get_exception_throw_by(Action action_that_should_be_taken_by_the_sut) { }

        static protected object an(Type type) { }

        static protected InterfaceType an<InterfaceType>() where InterfaceType : class { }
    }
{% endcodeblock %}





This is just the interface (we’ll dive into implementation of each method in time!!). Let’s break it down step by step. First thing you should see is the use of the Observations attribute on the class itself. This is basically just an alternative to the TestFixtureAttribute (thanks go to Albert Weinert for suggesting this). Here is the code:




{% codeblock lang:csharp %}
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
    public class ObservationsAttribute : TestFixturePatternAttribute
    {
        public ObservationsAttribute(string description) : base(description)
        {
        }

        public ObservationsAttribute()
        {
        }

        public override IRun GetRun()
        {
            var run = new SequenceRun();
            run.Runs.Add(new OptionalMethodRun(typeof (SetUpAttribute), false));
            run.Runs.Add(new MethodRun(typeof (ObservationAttribute), true, true));
            run.Runs.Add(new OptionalMethodRun(typeof (TearDownAttribute), false));
            return run;
        }
    }
{% endcodeblock %}





The main thing you should get out of this is that the GetRun method tells MbUnit to look for methods that are decorated with the ObservationAttribute, and to treat them as tests. The ObservationAttribute is really simple:




{% codeblock lang:csharp %}
  [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public class ObservationAttribute : TestPatternAttribute
    {
    }

{% endcodeblock %}




You have already seen this attribute used on the test earlier. The thing that should be immediately apparent about the “an_observations_basic_set_of_behaviours” class is that it is there to shield the rest of the test code from the details of whatever xUnit framework you are targeting (in this case, MBUnit).


Tomorrow I’ll continue by breaking down the responsibilities of this class in a piece meal fashion.


Develop With Passion!!




