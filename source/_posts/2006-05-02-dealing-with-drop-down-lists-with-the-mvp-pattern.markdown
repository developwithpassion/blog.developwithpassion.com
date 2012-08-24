---
layout: post
title: "Dealing with drop down lists with the MVP pattern"
comments: true
date: 2006-05-02 09:00
categories:
- .net 2.0
- c sharp
- patterns
---

I just had a great question asked by David Woods about one scenario that often comes up when utilising the Model View Presenter pattern:

Q: <font face="Arial" size="2">How do you deal with drop down lists? They vary from web to windows and I want to <span class="SpellE">refactor</span> my app so that it can use either</font>

<font face="Arial" size="2"><strong>A: The </strong><a href="{{ site.cdn_root }}binary/dealingWithDropDownListsInMVP/ListSolution.zip"><strong>code for this post</strong></a><strong> shows one solution to the problem. An interface (ILookupList) is created to abstract the details of the UI specific list controls from the presenter:</strong></font>

 <pre class="hl"><span class="kwa">namespace</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="kwa">public interface</span> ILookupList
    <span class="sym">{</span>
        <span class="kwb">void</span> <span class="kwd">Add</span><span class="sym">(</span>ILookupDTO dto<span class="sym">);</span>
        <span class="kwb">void</span> <span class="kwd">Clear</span><span class="sym">();</span>
    <span class="sym">}</span>
<span class="sym">}</span>
</pre>

 

One concrete implementation of this interface is the WebLookupList class:

 <pre class="hl"><span class="kwa">using</span> System<span class="sym">.</span>Web<span class="sym">.</span>UI<span class="sym">.</span>WebControls<span class="sym">;</span>

<span class="kwa">namespace</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="kwa">public class</span> WebLookupList <span class="sym">:</span> ILookupList
    <span class="sym">{</span>
        <span class="kwa">private readonly</span> ListControl listControl<span class="sym">;</span>

        <span class="kwa">public</span> <span class="kwd">WebLookupList</span><span class="sym">(</span>ListControl listControl<span class="sym">)</span>
        <span class="sym">{</span>
            <span class="kwa">this</span><span class="sym">.</span>listControl <span class="sym">=</span> listControl<span class="sym">;</span>
        <span class="sym">}</span>

        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">Add</span><span class="sym">(</span>ILookupDTO dto<span class="sym">)</span>
        <span class="sym">{</span>
            listControl<span class="sym">.</span>Items<span class="sym">.</span><span class="kwd">Add</span><span class="sym">(</span><span class="kwa">new</span> <span class="kwd">ListItem</span><span class="sym">(</span>dto<span class="sym">.</span>Text<span class="sym">,</span> dto<span class="sym">.</span>Value<span class="sym">));</span>
        <span class="sym">}</span>

        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">Clear</span><span class="sym">()</span>
        <span class="sym">{</span>
            listControl<span class="sym">.</span>Items<span class="sym">.</span><span class="kwd">Clear</span><span class="sym">();</span>
        <span class="sym">}</span>
    <span class="sym">}</span>
<span class="sym">}</span></pre>Notice how all the WebLookupList does is delegate to an actual “Web” ListControl. ListControl is the base class for both DropDownList and ListBox, so it is useful to use the superclass in this case. The last piece of the puzzle is the LookupCollection class: <pre class="hl"><span class="kwa">using</span> System<span class="sym">.</span>Collections<span class="sym">.</span>Generic<span class="sym">;</span>

<span class="kwa">namespace</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="kwa">public class</span> LookupCollection
    <span class="sym">{</span>
        <span class="kwa">private readonly</span> IEnumerable<span class="sym"><</span>ILookupDTO<span class="sym">></span> dtos<span class="sym">;</span>

        <span class="kwa">public</span> <span class="kwd">LookupCollection</span><span class="sym">(</span>IEnumerable<span class="sym"><</span>ILookupDTO<span class="sym">></span> dtos<span class="sym">)</span>
        <span class="sym">{</span>
            <span class="kwa">this</span><span class="sym">.</span>dtos <span class="sym">=</span> dtos<span class="sym">;</span>
        <span class="sym">}</span>

        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">BindTo</span><span class="sym">(</span>ILookupList list<span class="sym">)</span>
        <span class="sym">{</span>
            list<span class="sym">.</span><span class="kwd">Clear</span><span class="sym">();</span>

            <span class="kwa">foreach</span> <span class="sym">(</span>ILookupDTO dto in dtos<span class="sym">)</span>
            <span class="sym">{</span>
                list<span class="sym">.</span><span class="kwd">Add</span><span class="sym">(</span>dto<span class="sym">);</span>
            <span class="sym">}</span>
        <span class="sym">}</span>
    <span class="sym">}</span>
<span class="sym">}</span></pre>A LookupCollection gets instantiated with an IEnumerable<ILookupDTO> and can then be told to bind itself to any ILookupList. The ILookupDTO interface is just an interface that can be implemented by objects that want to be used as values in a lookup list. With all of these pieces in place it becomes relatively trivial to populate a list on a web page with all of the customers in the system. Take a look at an interface for such a view: <pre class="hl"><span class="kwa">namespace</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="kwa">public interface</span> IViewContactView
    <span class="sym">{</span>
        ILookupList Contacts <span class="sym">{</span> <span class="kwa">get</span><span class="sym">;}</span>
    <span class="sym">}</span>
<span class="sym">}</span></pre>

Notice that the Contacts property is readonly. A presenter that can work with this view looks as follows:

 <pre class="hl"><span class="kwa">using</span> System<span class="sym">.</span>Collections<span class="sym">.</span>Generic<span class="sym">;</span>

<span class="kwa">namespace</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test
<span class="sym">{</span>
    <span class="kwa">public class</span> ViewContactsPresenter
    <span class="sym">{</span>
        <span class="kwa">private</span> IViewContactView view<span class="sym">;</span>

        <span class="kwa">public</span> <span class="kwd">ViewContactsPresenter</span><span class="sym">(</span>IViewContactView view<span class="sym">)</span>
        <span class="sym">{</span>
            <span class="kwa">this</span><span class="sym">.</span>view <span class="sym">=</span> view<span class="sym">;</span>
        <span class="sym">}</span>

        <span class="kwa">public</span> <span class="kwb">void</span> <span class="kwd">Initialize</span><span class="sym">()</span>
        <span class="sym">{</span>
            <span class="kwa">new</span> <span class="kwd">LookupCollection</span><span class="sym">(</span><span class="kwd">GetAllContacts</span><span class="sym">()).</span><span class="kwd">BindTo</span><span class="sym">(</span>view<span class="sym">.</span>Contacts<span class="sym">);</span>
        <span class="sym">}</span>


        <span class="kwa">public</span> IEnumerable<span class="sym"><</span>ILookupDTO<span class="sym">></span> <span class="kwd">GetAllContacts</span><span class="sym">()</span>
        <span class="sym">{</span>
            <span class="kwa">for</span> <span class="sym">(</span><span class="kwb">int</span> i <span class="sym">=</span> <span class="num">0</span><span class="sym">;</span> i <span class="sym"><</span> <span class="num">20</span><span class="sym">;</span> i<span class="sym">++)</span>
            <span class="sym">{</span>
                yield <span class="kwa">return new</span> <span class="kwd">ContactDTO</span><span class="sym">(</span>i<span class="sym">.</span><span class="kwd">ToString</span><span class="sym">(</span><span class="str">"Name 0"</span><span class="sym">),</span> i<span class="sym">.</span><span class="kwd">ToString</span><span class="sym">(</span><span class="str">"Address 0"</span><span class="sym">),</span> i<span class="sym">.</span><span class="kwd">ToString</span><span class="sym">());</span>
            <span class="sym">}</span>
        <span class="sym">}</span>
    <span class="sym">}</span>
<span class="sym">}</span></pre>In this example, assume that the GetAllContacts method actually lives in a service layer. The code in the Initialize method is now taking advantage of the LookupCollection class to populate the list on the view. The resulting code-behind for a web page becomes much tighter <pre class="hl"><span class="kwa">using</span> System<span class="sym">;</span>
<span class="kwa">using</span> System<span class="sym">.</span>Web<span class="sym">.</span>UI<span class="sym">;</span>
<span class="kwa">using</span> Lists<span class="sym">.</span>Web<span class="sym">.</span>Controls<span class="sym">.</span>Test<span class="sym">;</span>

<span class="kwa">public</span> partial <span class="kwa">class</span> _Default <span class="sym">:</span> Page<span class="sym">,</span>IViewContactView
<span class="sym">{</span>
    ViewContactsPresenter presenter<span class="sym">;</span>

    <span class="kwa">protected</span> <span class="kwb">void</span> <span class="kwd">Page_Load</span><span class="sym">(</span><span class="kwb">object</span> sender<span class="sym">,</span> EventArgs e<span class="sym">)</span>
    <span class="sym">{</span>
        presenter <span class="sym">=</span> <span class="kwa">new</span> <span class="kwd">ViewContactsPresenter</span><span class="sym">(</span><span class="kwa">this</span><span class="sym">);</span>

        <span class="kwa">if</span> <span class="sym">(!</span> IsPostBack<span class="sym">)</span>
        <span class="sym">{</span>
            presenter<span class="sym">.</span><span class="kwd">Initialize</span><span class="sym">();</span>
        <span class="sym">}</span>
    <span class="sym">}</span>

    <span class="kwa">public</span> ILookupList Contacts
    <span class="sym">{</span>
        <span class="kwa">get</span> <span class="sym">{</span> <span class="kwa">return new</span> <span class="kwd">WebLookupList</span><span class="sym">(</span><span class="kwa">this</span><span class="sym">.</span>contactDropDown<span class="sym">); }</span>
    <span class="sym">}</span>
<span class="sym">}</span>
</pre>

Hope this brief explanation, along with the accompanying source code, gives you a place to start David!!

 

For those of you who are curious about the order I wrote the tests (as this was done using TDD) here it  is:
<ul>
<li>1)WebLookupListTest.cs – ShouldAddItemToUnderlyingList 
</li><li>2)WebLookupListTest.cs – ShouldClearUnderlyingList 
</li><li>3)LookupCollectionTest.cs – ShouldBindToLookupList</li></ul>

Those 3 tests alone helped drive out the interfaces,classes etc. I did not write tests for the presenter and the view as MVP was not the main focus of the post, as much as how to have the presenter talk to the list controls. If you have any questions or feedback, please don’t hesitate to ask.

 

Resources:
<ul>
<li>[Code]({{ site.cdn_root }}binary/dealingWithDropDownListsInMVP/ListSolution.zip) 
</li><li>[NUnit](http://nunit.org/) 
</li><li>[Rhino Mocks .Net](http://www.ayende.com/projects/rhino-mocks.aspx)</li></ul>






