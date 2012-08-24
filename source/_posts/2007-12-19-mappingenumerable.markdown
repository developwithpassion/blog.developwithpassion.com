---
layout: post
title: "MappingEnumerable<T>"
comments: true
date: 2007-12-19 09:00
categories:
- c sharp
- programming
---

In my infrastructure layer of my projects I regularly include the following interface:
{% codeblock lang:csharp %}
public interface IMapper<Input, Output>
{
  Output MapFrom(Input input);
}
{% endcodeblock %}




This interface should be fairly self-explanatory, it takes in an item of type Input and spits out an item of type Output. For those who care about details (and I do) it is also good to note that this interface matches the signature for a Converter generic delegate.

One of the (many) places that I use implementations of this interface is in the service layer to marshal data back up to the higher level layers as DTOS. Here is an example of a simple Mapper:
{% codeblock lang:csharp %}
public class DepartmentDisplayItemDTOMapper : IDepartmentDisplayItemDTOMapper 
{
  public DepartmentDisplayItemDO MapFrom(IDepartment department) 
  {
    return new DepartmentDisplayItemDO
      (department.Name, department.Id);
  }
}
{% endcodeblock %}




One of the ways that I would have leveraged this in the past would have been to inject the service layer component with the appropriate mapper and then map items that were returned from the repository in place.

Here is another alternative that takes advantage of a type I am calling a MappingEnumerable<T>. Take a look at the code for the class:
{% codeblock lang:csharp %}
public class MappingEnumerable<Input, Output> : IMappingEnumerable<Input, Output>
{
    private IMapper<Input, Output> mapper;
    private IEnumerable<Input> inputItems;


    public MappingEnumerable(IMapper<Input, Output> mapper, IEnumerable<Input> inputItems)
    {
        this.mapper = mapper;
        this.inputItems = inputItems;
    }


    IEnumerator<Output> IEnumerable<Output>.GetEnumerator()
    {
        return MapAllFrom(inputItems).GetEnumerator();
    }

    public IEnumerator GetEnumerator()
    {
        return ((IEnumerable<Output>) this).GetEnumerator();
    }

    private IEnumerable<Output> MapAllFrom(IEnumerable<Input> input)
    {
        foreach (Input item in input)
        {
            yield return mapper.MapFrom(item);
        }
    }
}
{% endcodeblock %}




Using this class from the service layer is as simple as:

 
{% codeblock lang:csharp %}
public IEnumerable<DepartmentDisplayItemDO> GetAllSubdepartmentsOf(long departmentId)
{
    IDepartment parentDepartment = departmentRepository.FindBy(departmentId);
    IEnumerable<IDepartment> subdepartments = departmentRepository.AllSubDepartmentsOf(parentDepartment);
    return
        new MappingEnumerable<IDepartment, DepartmentDisplayItemDO>
            (subdepartments,
             departmentDisplayItemDTOMapper);
    
}
{% endcodeblock %}




Notice that the MappingEnumerable decorates the existing enumerable with mapping behaviour. Because the MappingEnumerable is itself an implementation of an IEnumerable<T> interface, the mapping of each item will not start until the iteration of the enumerable happens.

Taking this class and applying it in the 3.5 world (I prefer using components vs free floating extension methods) can result in the following:
{% codeblock lang:csharp %}
 IDepartment parentDepartment = departmentRepository.FindBy(departmentId);
 IEnumerable<IDepartment> subdepartments = departmentRepository.AllSubDepartmentsOf(parentDepartment);
 return subdepartments.MapAllUsing(departmentDisplayItemDTOMapper);
{% endcodeblock %}




Where MapAllUsing is an extension method on IEnumerable<t> which lives in my infrastructure layer. The simplified implementation of MapAllUsing just delegates the work to the MappingEnumerable class: 
{% codeblock lang:csharp %}
public static IEnumerable<Output> MapAllUsing<T,Output>(this IEnumerable<T> itemsToMap,IMapper<T,Output> mapper) 
{ 
  return new MappingEnumerable<T, Output> (mapper,itemsToMap);
}
{% endcodeblock %}




One more short example to show how I leverage this pattern in my apps take a look at this method on a DatabaseGateway interface:
{% codeblock lang:csharp %}
IEnumerable<DataRow> GetASetOfRowsUsingA(IQuery query); 
{% endcodeblock %}




A simple method to return an enumerable of DataRows. You can now leverage this to do things like:
{% codeblock lang:csharp %}
public IEnumerable<DomainObject> GetAllUsing(IQuery query)
{
   return gateway.GetASetOfRowsUsingA(query).MapAllUsing(dbMapper);
}
{% endcodeblock %}




Where the mapper in this case knows how to hydrate datarows into domain objects of the specific (DomainObject) type the mapper is defined for.

One of the things I tell people in class (and work) is that IEnumerable is the ultimate [Separated Interface](http://martinfowler.com/eaaCatalog/separatedInterface.html) and this post just scratches the surface of the things you can do by just getting creative with the IEnumerable interface.

Develop With Passion!!




