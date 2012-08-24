---
layout: post
title: "Refactoring to reveal intent"
comments: true
date: 2007-06-13 09:00
categories:
- c sharp
- patterns
---

[Bil Simser](http://weblogs.asp.net/bsimser) had a [post up the other day](http://weblogs.asp.net/bsimser/archive/2007/06/11/refactoring-dumb-dumber-dumbest-away.aspx) about Refactoring Dumb, Dumber, and Dumbest away. I had some small suggestions that I offered up and Bil implemented some of the changes that I had mentioned. Here is the code as it stands right now :
{% codeblock lang:csharp %}
 public class SegmentConfigurationFactory
     {
        /// <summary>
        /// Gets the configuration given the values provided.
        /// </summary>
        /// <param name="cableSegmentCount">The cable segment count.</param>
        /// <param name="segmentCount">The segment count.</param>
        /// <param name="passesCount">The passes count.</param>
        /// <param name="segmentIndex">Index of the segment.</param>
        /// <param name="supplyVoltage">The supply voltage.</param>
        /// <param name="voltageDrop">The voltage drop.</param>
        /// <param name="segmentPercentage">The segment percentage.</param>
        /// <returns></returns>
        public ISegmentConfiguration GetConfigurationGiven(
            int cableSegmentCount,
            int segmentCount,
            int passesCount,
            int segmentIndex,
            int supplyVoltage,
            decimal voltageDrop,
            decimal segmentPercentage
            )
        {
            ISegmentConfiguration configuration = new DefaultSegmentConfiguration(1, supplyVoltage, voltageDrop);
    
            if (segmentCount > 1)
            {
                if (cableSegmentCount == 1)
                {
                    if (passesCount > 1 && (segmentIndex <= (segmentCount - 2)))
                    {
                        configuration = new MultiPassConfiguration(passesCount, supplyVoltage, voltageDrop, segmentPercentage);
                    }
                    else
                    {
                        configuration = new SinglePassConfiguration(cableSegmentCount, supplyVoltage, voltageDrop, segmentPercentage);
                    }
                }
                else
                {
                    configuration = new MultipleCableCountConfiguration(cableSegmentCount, supplyVoltage, voltageDrop, segmentPercentage, passesCount);
                }
            }
    
            return configuration;
        }
{% endcodeblock %}




I was then asked how I could potentially take the refactoring further. I had mentioned that there were a lot of 'magic numbers' in the code, to which Bil correctly replied that there are, but they were numbers that represented real business rules, and as such were not that 'magic'. Armed with the following set of rules that center around the messy if statement:

<ul style="MARGIN-TOP: 0in" type="disc">
<li class="MsoNormal" style="MARGIN: 0in 0in 0pt; mso-list: l0 level1 lfo1; tab-stops: list .5in">
</li>
<li class="MsoNormal" style="MARGIN: 0in 0in 0pt; mso-list: l0 level1 lfo1; tab-stops: list .5in">
</li>
<li class="MsoNormal" style="MARGIN: 0in 0in 0pt; mso-list: l0 level1 lfo1; tab-stops: list .5in">
</li>
<li class="MsoNormal" style="MARGIN: 0in 0in 0pt; mso-list: l0 level1 lfo1; tab-stops: list .5in">
</li></ul>
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt; mso-list: l0 level1 lfo1; tab-stops: list .5in">
 
{% codeblock lang:csharp %}
public class SegmentConfigurationFactory : ISegmentConfigurationFactory
{
    public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters)
    {
        if (new MultiPassSegmentConfigurationParametersSpecification().IsSatisfiedBy(parameters))
            return new MultiPassSegmentConfigurationFactory().CreateUsing(parameters);

        if (new SinglePassSegmentConfigurationParametersSpecification().IsSatisfiedBy(parameters))
            return new SinglePassSegmentConfigurationFactory().CreateUsing(parameters);

        if (new MultipleCableCountSegmentConfigurationParametersSpecification().IsSatisfiedBy(parameters))
            return new MultiCableCountSegmentConfigurationFactory().CreateUsing(parameters);

        return new DefaultSegmentConfigurationFactory().CreateUsing(parameters);
    }
}
{% endcodeblock %}




The first step to achieve this refactoring was to introduce a parameter object that encapsulated all of the arguments that use to be called on the method. This:
{% codeblock lang:csharp %}
public ISegmentConfiguration GetConfigurationGiven(
         int cableSegmentCount,
         int segmentCount,
         int passesCount,
         int segmentIndex,
         int supplyVoltage,
         decimal voltageDrop,
         decimal segmentPercentage
         )
{% endcodeblock %}




Became this:
{% codeblock lang:csharp %}
public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters)
{% endcodeblock %}




I won't bother showing the parameter object as it is just an object that exposes all of the original parameters as properties.

Now that I had the parameter object, I could leverage it from a new factory interface:
{% codeblock lang:csharp %}
public interface ISegmentConfigurationFactory 
{ 
  ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters); 
}  
{% endcodeblock %}


If you look back to the original code you will realize that at each branch that is creating a configuration, a potential different set of arguments is being used. By coming up with an interface for the factory, I can now have specific factories that create specific configurations based on the configuration parameters:
{% codeblock lang:csharp %}
public class DefaultSegmentConfigurationFactory : ISegmentConfigurationFactory
{
  public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters)
  {
    return new DefaultSegmentConfiguration(1, parameters.SupplyVoltage, parameters.VoltageDrop);
  }
}

public class MultiPassSegmentConfigurationFactory : ISegmentConfigurationFactory 
{
  public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters) 
  {
    return new MultiPassConfiguration(parameters.PassesCount, parameters.SupplyVoltage, parameters.VoltageDrop, parameters.SegmentPercentage);

  }

}


public class SinglePassSegmentConfigurationFactory : ISegmentConfigurationFactory 
{
  public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters) 
  {
    return new SinglePassConfiguration(parameters.CableSegmentCount, parameters.SupplyVoltage, parameters.VoltageDrop, parameters.SegmentPercentage);

  }

}



public class MultiCableCountSegmentConfigurationFactory : ISegmentConfigurationFactory 
{
  public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters) 
  {
    return new MultipleCableCountConfiguration(parameters.CableSegmentCount, parameters.SupplyVoltage, parameters.VoltageDrop, parameters.SegmentPercentage, parameters.PassesCount);

  }

}

{% endcodeblock %}




Each factory is responsible for creating a specific configuration based on the parameters. This introduces a nice separation of responsibilities, because properties can be added to the SegmentConfigurationParameters without introducing any change to the individual factories and the original SegmentConfigurationFactory itself. It also allows each individual factory to only leverage the properties on the parameter object that it needs to. This allows fine grained tests against the individual factories to ensure that they are only pulling from properties that they should be, and that they are providing the configurations they create with the correct information.

That's great JP, you've introduced discrete factories but we are still left with the if statements and 'magic' numbers. Remember that at each branch in the if statement (where a configuration is being created) that configuration matches a certain 'Specification'. I just gave it away!! I can introduce discrete specifications that encapsulate the business rules so that each conveys more clearly what 'Cable' specification it matches. Once again I can use the parameter object in the new interface:
{% codeblock lang:csharp %}
public interface ISegmentConfigurationParametersSpecification
{
    bool IsSatisfiedBy(SegmentConfigurationParameters parameters);
}
{% endcodeblock %}




If you are not familiar with the specification pattern you can stay tuned to DNRTv as I am going to be drilling down deep into the pattern (way more than I am showing here!!). Here are specifications for the main types of configuration:
{% codeblock lang:csharp %}
public class MultiPassSegmentConfigurationParametersSpecification : ISegmentConfigurationParametersSpecification 
{
  public bool IsSatisfiedBy(SegmentConfigurationParameters parameters) 
  {
    return parameters.SegmentCount > 1 &&  parameters.CableSegmentCount == 1 &&  parameters.PassesCount > 1 &&  (parameters.SegmentIndex <= (parameters.SegmentCount - 2));

  }
}
{% endcodeblock %}



{% codeblock lang:csharp %}
public class SinglePassSegmentConfigurationParametersSpecification : ISegmentConfigurationParametersSpecification 
{
  public bool IsSatisfiedBy(SegmentConfigurationParameters parameters) 
  {
    return parameters.SegmentCount > 1 &&  parameters.CableSegmentCount == 1 &&  parameters.PassesCount == 1;

  }

}

{% endcodeblock %}



{% codeblock lang:csharp %}
public class MultipleCableCountSegmentConfigurationParametersSpecification : ISegmentConfigurationParametersSpecification
{
    public bool IsSatisfiedBy(SegmentConfigurationParameters parameters)
    {
        return parameters.SegmentCount > 1 &&
               parameters.CableSegmentCount > 1;
    }
}
{% endcodeblock %}




As you can see, each specification is responsible for answering the question 'Does this parameter object meet the 'Specification' of a certain type of configuration. Again, each class can be tested independently of one another. Notice that there is duplication between the classes that could be easily refactored out by using composite specifications. I tried to name the specifications and factories so they conveyed clearly to the developers what business rules they were encapsulating.

To recap, the refactorings are as follows:
<ul>
<li>Introduce Parameter Object</li>
<li>Replace business specific conditionals with Specification (that is not an actual Refactoring, but I think I'm going to coin that name!!)</li>
<li>Introduced discrete factories for the different configurations.</li></ul>

Of course, taken it to the Nth degree you could introduce the following interface (I won't bother showing the implementation, but I'll give you a hint 'Use Object Composition'):

 
{% codeblock lang:csharp %}
public interface ISegmentConfigurationSpecificationBasedFactory : ISegmentConfigurationParametersSpecification,ISegmentConfigurationFactory
  {
      
  }
{% endcodeblock %}




With that interface in hand SegementConfigurationFactory can become:
{% codeblock lang:csharp %}
public class SegmentConfigurationFactoryToTheMaxx : ISegmentConfigurationFactory
{
    private IEnumerable<ISegmentConfigurationSpecificationBasedFactory> configurationFactories;


    public SegmentConfigurationFactoryToTheMaxx(ISegmentConfigurationFactory defaultConfigurationFactory, IEnumerable<ISegmentConfigurationSpecificationBasedFactory> configurationFactories)
    {
        this.configurationFactories = configurationFactories;
    }

    public ISegmentConfiguration CreateUsing(SegmentConfigurationParameters parameters)
    {
        foreach (ISegmentConfigurationSpecificationBasedFactory factory in configurationFactories)
        {
            if (factory.IsSatisfiedBy(parameters)) return factory.CreateUsing(parameters);
        }
        throw new ArgumentException(
            "There is no factory configured to create a configuration from the set of parameters");
    }
}
{% endcodeblock %}






Which now leaves the SegmentConfigurationFactory adhering to OCP.

Once again, like all of the refactorings I have demonstrated on this blog, this is just an example to show that there are always ways you can refactor code. Whether the extent of the refactoring is warranted is something that you have to figure out between you and your team members. I am not suggesting that this is the route you want to go (although it could be). 

Have I had to introduce more classes and interfaces? Absolutely. Do I have more testability from going this route? Absolutely. Have I made the domain more resilient to change? I think so.

When you are refactoring to reveal intent, don't expect that your codebase is going to shrink. To make the model more expressive sometimes you will need to introduce new concepts into the codebase that up the LOC, but increase the readability and maintainability. 

At the end of the day, if the original code conveys intent more clearly (Good rule of thumb is to use the 6 month rule, in 6 months when you come back to look at the code, will it still convey its intent) then that trumps elegance of the code.

In all of this make sure that 'Maintainability' trumps all the other 'ilities'.




