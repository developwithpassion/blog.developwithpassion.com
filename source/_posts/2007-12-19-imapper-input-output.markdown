---
layout: post
title: "IMapper<Input,Output>"
comments: true
date: 2007-12-19 09:00
categories:
- c sharp
- programming
---

Got some feedback on my MappingEnumerable post. People wanted to see me leveraging some of the new language features (specifically linq). 

I can leverage linq to change the extension method to eliminate the need for the MappingEnumerable (which was brought in to mitigate the absence of extension methods) and replace it with the following code: 
{% codeblock lang:csharp %}
public static IEnumerable<Output> MapAllUsing<Input,Output>(this IEnumerable<Input> items,IMapper<Input,Output> mapper)
{
    return from item in items
           select mapper.MapFrom(item);

}
{% endcodeblock %}




[K. Scott Allen](http://odetocode.com/blogs/scott/default.aspx) had the suggestion to use property initializers:  
{% codeblock lang:csharp %}
IEnumerable<Department> departments = departmentRepository.GetAllDepartments();
  return
    from d in departments
    select new DepartmentDisplayItemDTO() { ID = d.ID, Name = d.Name };
{% endcodeblock %}




Which you can definitely do if you so wish, that specific dto is completely immutable so the above would not work, but could be changed to accommodate. 

It is important to note that the IMapper<Input,Output> interface is an interface that can be implemented to perform all sorts of mapping. Some examples of how I have used this in the past are: 
<ul>
<li>Mapping from DB to Domain</li>
<li>Mapping from Domain to DTO</li>
<li>Mapping from Errors to ScreenElements</li>
<li>Mapping from DTO to Presentation Model</li>
<li>....</li></ul>

You are only limited by your imagination. And because each mapper has a single MapFrom method, it is very easy to test specific implementations of the interface, you can even create a non generic IMapper interface that you can use for completely reflective scenarios (picture externally defined OO mapping).

K. Scott Allen also mentions DTO Tax, and I don't think his point is specific to just DTO's but the cost of mapping in general. Focusing on 1 mapping at a time, refactoring out the duplication and moving on; is a way that you can grow and add all sorts of mapping in a very organic way to your applications.

Develop With Passion!!
<p align="center">






