---
layout: post
title: "New feature for developwithpassion.specifications (nested contexts!!)"
comments: true
date: 2011-05-11 09:00
categories: [tdd, c#]
---
Technically this is a patch that I added to [mspec][mspec], so it is there also!! Instead of talking about it, I will demonstrate with a bit of contrived example:

{% codeblock lang:csharp %}
public abstract class concern : Observes<SimpleCalculator>
{
}

public class when_adding_two_numbers : concern
{
  Establish c = () =>
  {
    connection = depends.on<IDbConnection>();
    first_number = 1;
    second_number = 2;
  };

  Because b = () =>
    result = sut.add(first_number, second_number);

  public class and_both_numbers_are_positive
  {
    It should_not_open_a_connection_to_the_database = () =>
      connection.never_received(x => x.Open());
  }

  public class and_one_of_the_numbers_are_negative
  {
    Establish c = () => first_number = -2;

    It should_open_a_connection_to_the_database = () =>
      connection.received(x => x.Open());
  }

  It should_return_the_sum = () =>
    result.ShouldEqual(first_number + second_number);

  static IDbConnection connection;
  static int result;
  static int second_number;
  static int first_number;
}

public class SimpleCalculator
{
  IDbConnection connection;

  public SimpleCalculator(IDbConnection connection)
  {
    this.connection = connection;
  }

  public int add(int number1, int number2)
  {
    if (number1 < 0 || number2 < 0) connection.Open();
    return number1 + number2;
  }
}
{% endcodeblock %}

As you can see from this example. Nested contexts can be a useful tool when you want to have a different organizational mechanism for how you structure and separate concerns.  

The root concern [when_adding_two_numbers] contains its own establish, because and it blocks.   
Each of the nested contexts alters the setup as needed to test a different aspect of the component under a different context. And they also have their own it blocks to make their concern specific observations!!  

For information, it is important to note that this is nothing more than a different organizational tool. You can express the exact same tests currently in [mspec][mspec] without needing to use nested contexts.


[Develop With Passion®](http://www.developwithpassion.com)
[mspec]: https://github.com/developwithpassion/machine.specifications 
