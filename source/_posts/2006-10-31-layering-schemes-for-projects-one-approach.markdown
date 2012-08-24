---
layout: post
title: "Layering Schemes For Projects (One approach)"
comments: true
date: 2006-10-31 09:00
categories:
- patterns
---

I was recently asked the following question in an email: 
<font color="#0000a0">Do you know where I can find information (blog or book) on how you are setting up your Domain Object (i.e. in your demo it was Northwind.Domain)?  Is that basically where you keep your rules (i.e. if it such and such customer then give them a 10% discount)?</font> 
I took this as a question as to how to go about setting up the layers in the application. Which caused me to go on the following tangent: 
<font color="#800080">The layering of a project is something that definitely falls into a personal taste category. There are also lots of well known strategies/suggestions for layering an application. Another thing to note is that there is not necessarily a one-to-one relationship between physical/logical layer and a VS project. In the example applications that I have shown I have definitely used a solution that demonstrates one physical project per layer of concern. There are definitely many times on large projects where one logical/physical layer is composed of many physical VS.Net projects.</font> 
<font color="#800080">The domain layer is where your entities, value objects, business rules, validations, and a whole host of other objects go. This is the heart of the system, and is often the place where you can drive out solutions in a test first manner to ensure that you are able to solve a particular business problem in a clean and meaningful way. For the most part, the domain layer consists of plain old objects. Saying plain does not mean that they are necessarily simple. It means that the domain should be completely oblivious to any “services” that will be required to support it in the context of the running application (mapping being one of the most well known services).</font> 
<font color="#800080">A layering scheme that I have come to use a lot is the following:</font> 
<font color="#800080">· UI (User interface components, web forms,winforms, mobile screens, consoles)</font> 
<font color="#800080">· Presentation (View interfaces, presenters, formatters, mappers (oo mappers not OR mappers), globalization)</font> 
<font color="#800080">· DTO (Data transfer objects, used for passing information between the UI, presentation, and service layers). Again, depending on the project you may not need to introduce a separate set of objects to marshal data between the presentation and service layer. You may opt instead to pass your domain objects to the presentation layer directly.</font> 
<font color="#800080">· Service (Transaction control, authorization, domain object coordination), there are definitely times when you may not want to think about utilizing a service layer. For the amount of work involved in creating a simple façade ,around your application functionality, I almost always use one.</font> 
<font color="#800080">· Data Access (O/R mapping, this layer can get pretty big if you are not taking advantage of existing O/R mappers)</font> 
<font color="#800080">· Utility (Utility classes that can be consumed and used by any layer in the application, each class follows the single responsibility principle, and great care is made to ensure classes in this layer are not just catch-alls for functionality that was not able to be placed correctly on an object in another layer.</font> 
<font color="#800080">This is a very basic layering scheme. Depending on the needs of the application, there may be more levels of indirection that are required.</font>




