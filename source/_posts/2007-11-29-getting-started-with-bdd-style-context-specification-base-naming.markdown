---
layout: post
title: "Getting started with BDD style Context/Specification base naming"
comments: true
date: 2007-11-29 09:00
categories:
- agile
- programming
---

I have received a number of good responses from people who have a couple of aesthetic issues with the BDD style naming that I am starting to use. Let me clarify, I have been using the natural sentence style test naming since [Scott ](http://codebetter.com/blogs/scott.bellware/)introduced me to it in earlier in the year. I have not used the context/specification style test naming on a project yet, though it is my intent to write each successive test from this point forward in that style and if I feel pain points I will let you know.

From my experience so far here are some tips that I think will resolve the issues that the people who are trying to use it will find:

Issue 1 - '<font face="Consolas" size="3">I ended up really not liking those fixture names because I felt it was hard to find fixtures for specific classes, and navigate with Resharper Type navigation.<span style="mso-spacerun: yes">  </span>Was wondering what naming convention you came up with for fixtures?'</font>

<font face="Consolas" size="3">A: My recommendation for this is to create a single test class in your test project called $SystemUnderTest$Specs. Where SystemUnderTest corresponds to the name of the class that you will be testing. This is just a grouping construct for all of the 'Contexts' that will be run against that fixture. Inside the 'Specs' class, you will create classes for each of the different contexts. Here is an example of one that I just rewrote the tests for the ShoppingCart class is the nothinbutdotnetweb.app project using this new style and I personally have to say that it was an awesome experience. One of the things that I found was that I could copy the body of one fixture and change the name to reflect the new context and I could focus solely on the interactions and behaviour that is pertinent to that particular context. Take a look at the Report that is generated when run against the specs in the ShoppingCartSpecs class:</font>
<ul>
<li><font face="Consolas" size="3">When a product is added that is not already in the cart</font></li>
<ul>
<li><font face="Consolas" size="3">The cart item factory should be used to create a cart item for the product being added.</font></li></ul>
<li><font face="Consolas" size="3">When an item is added</font></li>
<ul>
<li><font face="Consolas" size="3">The item count should be incremented</font></li>
<li><font face="Consolas" size="3">The item should be added to the underlying list</font></li></ul>
<li><font face="Consolas" size="3">When the same product is added again</font></li>
<ul>
<li><font face="Consolas" size="3">The item factory should not be leveraged</font></li>
<li><font face="Consolas" size="3">The quantity of the item should be incremented</font></li></ul>
<li><font face="Consolas" size="3">When changing the quantity of a product in the cart</font></li>
<ul>
<li><font face="Consolas" size="3">The item should be updated with the new quantity</font></li></ul>
<li><font face="Consolas" size="3">When changing the quantity of a product causes the item to be empty</font></li>
<ul>
<li><font face="Consolas" size="3">The item should be removed from the cart</font></li></ul>
<li><font face="Consolas" size="3">When changing the quantity of a product that is not in the cart</font></li>
<ul>
<li><font face="Consolas" size="3">Nothing should happen</font></li></ul>
<li><font face="Consolas" size="3">When a product is removed from the cart</font></li>
<ul>
<li><font face="Consolas" size="3">The item representing the product should be removed</font></li>
<li><font face="Consolas" size="3">The number of items in the cart should decrease</font></li></ul>
<li><font face="Consolas" size="3">When asked to remove a product that is not already in the cart</font></li>
<ul>
<li><font face="Consolas" size="3">Nothing should happen</font></li></ul>
<li><font face="Consolas" size="3">When the cart is emptied</font></li>
<ul>
<li><font face="Consolas" size="3">There should be no more items</font></li></ul>
<li><font face="Consolas" size="3">When asked for the quantity of a product</font></li>
<ul>
<li><font face="Consolas" size="3">The cart item representing the product should be asked for its quantity</font></li>
<li><font face="Consolas" size="3">The result should be the quantity of the item for the product</font></li></ul>
<li><font face="Consolas" size="3">When asked to calculate the total cost</font></li>
<ul>
<li><font face="Consolas" size="3">Should be the sum of the total cost for all items</font></li></ul></ul>

<font face="Consolas" size="3"></font> 

<font face="Consolas" size="3">One of the things you will notice about the tests in these fixtures compared to the others in the rest of the project (so far) is the use of Setup to stress the context setup. I added a virtual method to the AutoMockingTest base called because, which calls out the action being invoked on the SUT.</font>

<font face="Consolas" size="3">This actually resulted is some tests that contained no body whatsoever, and the ones with assertions actually only needed one assertion.</font>

<font face="Consolas" size="3">This is a learning experience for me to, but so far, I am loving the expressiveness and focus this style of testing brings to the table.</font>

<font face="Consolas" size="3">By grouping all of the fixtures into the ShoppingCartSpecs class, you can solve the navigability issue.</font>

<font face="Consolas" size="3"></font> 

<font face="Consolas" size="3">The second issue I received was:</font>

<font face="Consolas" size="3">'Quick question ... while the idea is great, it doesn;t flow for me, as ReSharper keeps cutting in and completing my words for me - Intellisence is great, but in this context is is annoying as hell ...</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><?xml:namespace prefix ="" o /><o:p><font face="Consolas" size="3"> </font></o:p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">How do you avoid this problem?'</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">A - This is actually a ReSharper setting that I have had turned off pretty much since I started using ReSharper:</font>
<ul>
<li>
<div class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Go to ReSharper - Options</font></div></li>
<li>
<div class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Select the Intellisense item in the left nav bar</font></div></li>
<li>
<div class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Uncheck Letters and Digits in the Completion Behaviour pane on the right!!</font></div></li></ul>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">That's it. Now you can write you natural sentences without ReSharper getting in your way. Since I have been without this setting since ReSharpers inception, I have gotten quick at using ALT-SPACE/CTRL-ALT-SPACE a lot, this may take a bit of getting used to for the people who were use to the Letters and Digits autocompletion behaviour.</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Again, as far as quickly navigating to the tests for a sut, you can just go CTRL-SHIFT-N and then start typing in the significant letters for the Spec class, in this case it would be:</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">CTRL-SHIFT-N -> SCS</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Because all of the fixtures will be contained in the file but there will be no ShoppingCartSpecs type. I guess you could create one as a nesting construct, but that is what the file is for.</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Again, let me stress that this Context/Specification style naming is a little new for me, and there is a possibility that the tests in the ShoppingCartSpecs that have no assertions could be a smell (I'll get that verified by Scott in a little while), I already see the benefits from both the documentation perspective as well as the ability to truly only focus on one specific context at a time.</font>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3"></font> 
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><font face="Consolas" size="3">Develop With Passion.</font>

<font face="Consolas" size="3"></font> 




