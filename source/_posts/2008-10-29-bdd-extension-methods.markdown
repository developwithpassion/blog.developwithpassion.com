---
layout: post
title: "BDD Extension Methods"
comments: true
date: 2008-10-29 09:00
categories:
- c sharp
---

In response to a comment from the last post, here is the interface of the BDDExtensions that were driven out from the last NBDN course:

{% codeblock lang:csharp %}
public static class BDDExtensions
{
  public static void force_traversal<T>(this IEnumerable <T> items)
  public static void should_be_null(this object item)
  public static void should_contain <T> (this IEnumerable <T> items,T item)
  public static void should_be_greater_than<T>(this T item, T other) where T : IComparable<T>
  public static void should_not_be_equal_to<T>(this T item, T other)
  public static void should_be_equal_ignoring_case(this string item, string other)
  public static void should_only_contain<T>(this IEnumerable<T> items, params T[] items_to_find)
  public static void should_only_contain_in_order<T>(this IEnumerable<T> items, params T[] items_to_find)
  public static void should_be_true(this bool item)
  public static void should_be_false(this bool item)
  public static void should_be_equal_to<T>(this T actual, T expected)
  public static ExceptionType should_throw_an<ExceptionType>(this Action work_to_perform)
  public static void should_not_throw_any_exceptions(this Action work_to_perform)
  public static void should_be_an_instance_of<Type>(this object item)
  public static void should_not_be_null(this objectitem)
}
{% endcodeblock %}





This is the main base set of extensions. I usually have a whole family of application specific extensions that come into play for doing application specific assertions.


Develop with Passion!!




