---
layout: post
title: "Slightly Different Way To Write Unit Tests"
comments: true
date: 2008-11-25 09:00
categories:
- c sharp
---

I was in the middle of the last Nothin But .Net class (more on that in a later post) and I started playing around with a slightly different way to write unit tests (inspired by the look of [MSpec](http://blog.eleutian.com/2008/09/02/MSpecV02.aspx)). It was cool to build it/demo it/ and use it in front of the class. Here is some sample code written using the new style:  

{% codeblock lang:csharp %}
[Concern(typeof (ShoppingCart))]
public class when_a_bag_of_ruffles_chips_is_added_to : a_shopping_cart_with_a_can_of_pepsi_in_it
{
    static IShoppingCartItem an_item_for_a_bag_of_ruffles;
    static IProduct a_bag_of_ruffles;

    context c = () =>
    {
        an_item_for_a_bag_of_ruffles = an<IShoppingCartItem>();
        a_bag_of_ruffles = an<IProduct>();

        when_the(shopping_cart_item_factory).is_told_to(x => x.create_a_shopping_cart_item_from(a_bag_of_ruffles))
            .Return(an_item_for_a_bag_of_ruffles);
    };

    because b = () => sut.add(a_bag_of_ruffles);

    [Observation]
    public void an_item_for_the_bag_of_ruffles_should_be_stored_in_the_cart()
    {
        shopping_cart_items.should_contain(an_item_for_a_bag_of_ruffles);
    }

    [Observation]
    public void should_have_items_for_both_the_can_of_pepsi_and_the_bag_of_ruffles()
    {
        shopping_cart_items.should_contain(an_item_for_a_can_of_pepsi, an_item_for_a_bag_of_ruffles);
    }
}
{% endcodeblock %}



The use of the lambdas for the context (setup) and because(action of the system under test) causes them to not jump to the eyes as quickly as the concern and the observations (as they attributes help draw your eyes to them faster. Lots of tests were written in class. The context block can be shared with other contexts that occur up the hierarchy. Outside of the mechanics of how setup and teardown are now handled, it is still very much a NUnit/MbUnit flavoured test with a heavy BDD spin on it. One of the nice things that I have started taking advantage of is having the system under test automatically created for me (in a base class, with the option to override). I have also put in a lot of effort to shield myself from the noise of mock object frameworks and testing specific nomenclature (notice the an method).


I am going to be releasing some more stuff on this in the next couple of days. I just wanted to give a sneak peek. You will notice that I have opted to not bother trying to come up with meaningful names for the context and because fields. I name the fixture/concern to be descriptive as to the context of the sut I am testing, and the names of the observations fill out the rest of the meaty details.


Thoughts?

Develop With Passion!!


