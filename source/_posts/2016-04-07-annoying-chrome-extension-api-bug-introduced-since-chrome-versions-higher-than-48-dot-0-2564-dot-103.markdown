---
layout: post
title: "Annoying Chrome Extension API Bug - Introduced since Chrome Versions higher than 48.0.2564.103"
date: 2016-04-07 13:12
comments: true
published: true
categories: [chrome]
---
Been working for the last year with a pretty awesome startup and one of the core components is a chrome browser extension.

We thankfully wrote our code so that most of the mechanics of the extension api itself are managed by an adapter layer that defines how we want to interact with the browser.

A couple of weeks ago Chrome automatically updated and one of the adapters stopped working. We swapped out the non working piece for a custom solution, but the cause of the error is in a core chrome api that we had been using for a long time. The following code demonstrates the bug in action:

{% codeblock lang: javascript %}
//Bug Demo - Background page sending a message to itself does not trigger onMessage listeners to fire - failing on Chrome versions > 48.0.2564.103

//The handler below will run only if a message is being sent from a content script,
chrome.runtime.onMessage.addListener(function(data) {
  console.log(data);
});

chrome.runtime.sendMessage(null, 'Hi There From A Background Page Sender', null);

{% endcodeblock %}

As you can see pretty basic, the background page will load and immediately send a message. The onMessage handler should be invoked with the message. The code above worked fine until Chrome went past 48.0.2564.103. I've submitted a bug report to Google with a full zip that contains a minimal extension that demonstrates this bug.

Currently this is not a blocker, as we just built another implementation of the adapter contract to negate the need to use sendMessage in the background page. It just seems to me that any other developers who are using sendMessage as a way to do asynchronous dispatch to other components in the "background component layer" should be being hit by this.

Anyone else seen this at all?

Develop With Passion®
