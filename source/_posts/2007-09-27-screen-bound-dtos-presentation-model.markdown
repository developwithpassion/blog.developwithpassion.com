---
layout: post
title: "Screen Bound DTO's (Presentation Model)"
comments: true
date: 2007-09-27 09:00
categories:
- programming
---

Currently, in a lot of the projects that I work on I tend to take a top down approach to development. Which means that I will start at test that focus on the presentation layer of the application.

Some people are curious as to this approach. My answer for this is simple. From the customers perspective, the first and simplest entry point to the application is the UI of the application itself. The UI also happens to be the place where developers spend a lot of their time, as that is often the place of most contention because of user expectations for how the UI should behave. By focusing on presenters and their accompanying view implementations, I can focus on stubbing out the behavior of the required service layer pieces as well as the accompanying <strong>Screen Bound DTOS</strong> that are required to present data to the particular user interface.

The concept of Screen Bound DTOS is probably not a new one, but one that I have been able to use with lots of success. Most people who look at my code are probably aware that I favour the use of DTOS with regards to use in the presenter to service layer communication as well as for displaying data in the UI. This is because you can build DTOS specific to the screens that they are going to service. They are completely separate from the underlying domain layer that will ultimately handle the business logic, and therefore are completely unaffected when a change to the domain model actually occurs. When a domain object or set of domain objects that ultimately map to a DTO change, the only thing that needs to change is the mapping from domain to the DTO. This ultimately allows my domain to evolve completely independently of the needs of the user interface.

Also keep in mind that a given screen may have the concept of more than one type of DTO for the different behaviours that can occur. For example, when I am displaying a list of products to purchase in an online store, I may have the need for a DTO that consists of the name, description, and price, as well as the SKU number for the product. When it comes time to add an item to my cart, what are the pieces of information that are really relevant to pass to the service layer? Only the SKU and the number that I want to add. I can encapsulate this information in an AddItemToCartDTO that contains the sku of the product and the quantity to be added. This DTO is free of all of the extra noise that existed in the previous DTO that is not necessary for the add to cart behavior

With regards to the presenter to service layer communication, these DTOs become essentially stripped down commands without the behaviour necessary to complete the task.

Using this technique and Top Down Development, I can completely finish off a screen, hand it off to the user to verify that it works the way that they want. I can do this by stubbing out service layer implementations to return fake data.

Once I get sign off from the user that the screen is up to par, I can now switch down to another layer and repeat the process of Top Down Development, from a different layer in the application.

 




