---
layout: post
title: "Drop the temporary lists and leverage yield"
comments: true
date: 2007-10-10 09:00
categories:
- programming
---

I see lots of code bases throwing IList<T>, List<T> etc all over the place when half of the time all they really need is to return a set that can be either databound, or walked over and processed one at a time. For the scenarios where you don't need to count the number of items or much of the other functionality that is exposed by the IList<T> interface, you can start to leverage the yield keyword more to tighten up the code.

Here is a common example, a service layer method call that returns a list of DTO's that can be consumed by some sort of binding target. Assume that you are mapping domain objects into DTO's to be consumed by the upper level layer (which could then be mapped into a presentation model). Let's also assume that you have the following
<ul>
<li>Customer Domain Class</li>
<li>CustomerDTO Class</li>
<li>ICustomerDTOMapper interface (implementation knows how to map from domain to dto).</li>
<li>ICustomerRepository - repository interface to find customers</li>
<li>CustomerTask - service layer class</li></ul>

Here is the CustomerTask class with its appropriate dependencies injected, and the existing GetAllCustomers method using the temporary list:

 
{% codeblock lang:csharp %}
public interface ICustomerDTOMapper 
{
  CustomerDTO MapFrom(Customer customer);

}
public interface ICustomerRepository 
{
  IEnumerable<Customer> All();

}
public class CustomerTask 
{
  private ICustomerRepository customerRepository;
  private ICustomerDTOMapper customerDTOMapper;
  public CustomerTask(ICustomerRepository customerRepository,ICustomerDTOMapper customerDTOMapper) 
  {
    this.customerRepository = customerRepository;
    this.customerDTOMapper = customerDTOMapper;

  }
  public IEnumerable<CustomerDTO> GetAllCustomers() 
  {
    IList<Customer> results = new List<Customer>();
    foreach (Customer customer in customerRepository.All()) 
    {
      results.Add(customerDTOMapper.MapFrom(customer));

    }
    return results;

  }

}
 
{% endcodeblock %}




With a  small change the code in the GetAllCustomers method can be changed to the  following:<font color="#000000"></font>
{% codeblock lang:csharp %}
public IEnumerable<CustomerDTO> GetAllCustomers()
{            
  foreach (Customer customer in customerRepository.All())
  {
    yield return customerDTOMapper.MapFrom(customer);
  }        
}
{% endcodeblock %}




This is a small change, but handy nontheless. Again, this is not new information, I just think that more people could start taking advantage of yielding in more situations where full blown lists are not called for.




