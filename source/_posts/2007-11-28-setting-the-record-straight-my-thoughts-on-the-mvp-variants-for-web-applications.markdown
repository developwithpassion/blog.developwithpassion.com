---
layout: post
title: "Setting The Record Straight - My Thoughts On The MVP Variants (for web applications)"
comments: true
date: 2007-11-28 09:00
categories:
- .net 2.0
- agile
- c sharp
- programming
---

Having received a bunch of emails in the past couple of weeks from people who have been asking me questions with regards to Passive View/Supervising controller patterns for web applications. I needed to let people know that for the last couple of months I have been developing web apps in a completely MVC style which eliminates the need for patterns like Passive View/ Supervising Controller.

For the people who are using the MVP pattern in their (web) applications I personally would now lean to the Supervising Controller style as it eliminates a lot of necessary chattiness between the view and the presenter. It also lends itself to much more simple unit tests.

Having gotten back into the Smart Client realm, I am once again reminded of the importance of patterns like Supervising Controller and presentation model as becoming essential to ensuring correct separation of responsibilities. 

For my web applications, however, all I use now is a:

* Front Controller
* Commands
* View Templates (ASPX style!!)

Here is an example of what I mean, for the nothinbutdotnetstore.web.app project that is currently hosted on google code, here is the Command that processes getting a list of the main departments in the store for viewing:

{% codeblock lang:csharp %}
using NothinButDotNetStore.Infrastructure;
using NothinButDotNetStore.Infrastructure.Container.Common;
using NothinButDotNetStore.Tasks;
using NothinButDotNetStore.Web.FrontController;

namespace NothinButDotNetStore.Web.DepartmentBrowser
{
    public class ViewMainDepartments : ICommand
    {
        private ICatalog catalog;
        private IRequestContext requestContext;
        private IViewEngine viewEngine;


        public ViewMainDepartments(IHttpContext context) : this(context,
                                                                DependencyResolver.GetImplementationOf<IRequestContextFactory>().CreateFrom(context),
                                                                DependencyResolver.GetImplementationOf<IViewEngine>(),
                                                                DependencyResolver.GetImplementationOf<ICatalog>())
        {
        }

        public ViewMainDepartments(IHttpContext context, IRequestContext requestContext, IViewEngine viewEngine, ICatalog catalog)
        {
            this.catalog = catalog;
            this.viewEngine = viewEngine;
            this.requestContext = requestContext;
        }

        public void Execute()
        {
            requestContext.AddToStateBag(ViewBagItem.Departments, catalog.GetMainDepartments());

            viewEngine.Display(Views.ViewDepartments);
        }
    }
}
{% endcodeblock %}

Here is the complete ASPX (View Template) that gets rendered for that command executing:

{% codeblock lang:csharp %}
<%@ MasterType VirtualPath="~/Store.master" %> 
<%@ Page Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.Page"  MasterPageFile="~/Store.master" %> 
<%@ Import namespace="NothinButDotNetStore.Web.FrontController"%> 
<%@ Import namespace="NothinButDotNetStore.Web"%> 
<%@ Import namespace="NothinButDotNetStore.Infrastructure"%> 
<%@ Import namespace="NothinButDotNetStore.DTO"%> 
<asp:Content ID="content" runat="server" ContentPlaceHolderID="childContentPlaceHolder">  
  <p class="ListHead">Select An Isle  
  <table>  
    <% int rowIndex = 0; %>  
    <% foreach (DepartmentDisplayItem dto in ViewBag.GetItem(ViewBagItem.Departments)) 
    { 
    %>  
     <tr class='<%=(rowIndex++ %2 ==0 ? "nonShadedRow" : "shadedRow" ) %>'> 
      <td>   
        <a href='<%= Url.ToBeProcessedBy(CommandNames.ViewSubDepartments).AddPayloadValue(PayloadKeys.DepartmentId,dto.Id).Build() %>'>  <%=dto.DepartmentName %>  </a>  
      </td>  
     </tr>  
    <% 
    } 
    %> 
  </table> 
</asp:Content>
{% endcodeblock %}


There is no code behind for this aspx page. The logic in the aspx file is there because it is rendering related logic. This aspx page does not talk to a service layer or domain objects or even a data access layer. It reaches into a ViewBag looking for information that it can render, and then it proceeds to do exactly what it should, render the information. What may not be immediately obvious is that this is a plain aspx file with no codebehind file. The page inherits from System.Web.UI.Page.

As far as testability of this style of development, here is a sample test for one behaviour of the ViewMainDepartments command:

{% codeblock lang:csharp %}
[RunInUnitTestContainer] 
[Test] 
public void Should_populate_the_context_with_the_departments_to_display() 
{
  ICommand sut = CreateSUT<ViewMainDepartments>();
  IEnumerable<DepartmentDisplayItem> results = CreateMock<IEnumerable<DepartmentDisplayItem>>(); using (Mocks.Record()) 
  {
    Expect.Call(mockCatalog.GetMainDepartments()).Return(results);
    mockRequestContext.AddToStateBag(ViewBagItem.Departments, results);
  }
  using (Mocks.Playback()) 
  {
    sut.Execute();
  }
}
{% endcodeblock %}





In the next little while I am going to shed some more light on this approach to web application development. IMHO, the separation of concerns for web applications written in this style is much greater than when trying to stuff in a pattern that (again IMHO) did not fit well for the technology, and was leveraged for the sake of increased testability.



