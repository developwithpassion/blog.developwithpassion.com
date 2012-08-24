---
layout: post
title: "Thoughts On Readability"
comments: true
date: 2008-08-26 09:00
categories:
- c sharp
---

I am currently going through my existing application and refactoring for a bit more readability (with a focus on natural language). Could I get your feedback onthe readability of the following piece of code which demonstrates a chain of responsibility:  
  

{% codeblock lang:csharp %}
Run.the<wire_up_global_error_handling>()
   .then<initialize_the_container_for_the_user_interface>()
   .then<initialize_the_user_interface_registry>()
   .then<initialize_the_ui_images_registry>()
   .then<initialize_the_main_menus>()
   .execute();
{% endcodeblock %}





Underscores in code seem to have permeated a lot of my thinking. And I am currenlty playing around with lowercase method naming with underscores to separate significant words. How would you feel if you were presented with this code to read? Be brutally honest!!




Develop With Passion!!




