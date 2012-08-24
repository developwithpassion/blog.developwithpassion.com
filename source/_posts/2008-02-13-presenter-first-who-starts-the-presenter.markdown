---
layout: post
title: "Presenter First - Who starts the presenter"
comments: true
date: 2008-02-13 09:00
categories:
- c sharp
---

Had a question recently with regards to presenter first development in a smart client application.

'How do you tell the presenter to run?'

In presenter first style, the presenter will be the first point of contact from the ApplicationController. It will be the presenters responsibility to tell its associated view to render, etc. In my current smart client application I am making heavy use of commands that can be attached to arbitrary elements : buttons, linkbutton, menu items, to initiate the running of a command. Here is a small piece of code that should give away how I am hooking up commands to presenters in the application:
{% codeblock lang:csharp %}
public class RunPresenterCommand<Presenter> : ICommand where Presenter : IPresenter
{
    private IApplicationController controller;

    public RunPresenterCommand(IApplicationController controller)
    {
        this.controller = controller;
    }

    public void Execute()
    {
        controller.Run<Presenter>();
    }
}
{% endcodeblock %}




Notice that all this command does when told to execute is to dispatch a call to the application controller, telling it to run the associated presenter. This keeps the responsibility of starting up the presenter in the place that it should be, the ApplicationController.

Hope that answers the question.

Develop With Passion!!


