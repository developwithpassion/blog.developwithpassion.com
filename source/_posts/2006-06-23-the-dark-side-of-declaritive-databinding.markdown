---
layout: post
title: "The Dark Side Of Declaritive Databinding"
comments: true
date: 2006-06-23 09:00
categories:
- .net 2.0
- c sharp
---
Most people who have talked/worked with me know that I am not the biggest fan of the demoware databinding techniques. When choosing to implement databinding in your application you have to decide what you will use as a data source. Of the many sources of data that can be bound to, the most common are 
<p class="BodyText" style="MARGIN: 0in 0in 0pt"><?xml:namespace prefix ="" o /><o:p> </o:p>
<p class="BodyText" style="MARGIN: 0in 0in 0pt 0.25in">-DataSets
<p class="BodyText" style="MARGIN: 0in 0in 0pt 0.25in">-XML
<p class="BodyText" style="MARGIN: 0in 0in 0pt"><span style="mso-tab-count: 1">      </span>-Custom Objects
<p class="BodyText" style="MARGIN: 0in 0in 0pt"><o:p> </o:p>
<p class="BodyText" style="MARGIN: 0in 0in 0pt">I am going to (eventually) focus in particular on the use of the Custom object scenario. I will, however, start by using datasets as for the purpose of contrasting it to my approach. In my first attempt at databinding I will utilize some of the new controls made available in ASP.Net 2.0, namely the new <span class="BodyTextBold"><span style="mso-bidi-font-family: Arial"><strong>Data Source Controls.</strong></span></span> Here is the markup required to configure the SqlDataSource control as well as an accompanying gridview to display the information.
<p class="BodyText" style="MARGIN: 0in 0in 0pt"> 
<p class="BodyText" style="MARGIN: 0in 0in 0pt"> 
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><asp:SqlDataSource<span style="mso-spacerun: yes">     </span><span style="COLOR: red">ID</span>="customersDataSource" <o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">      </span><span style="COLOR: red">runat</span>="server" <o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">         </span><span style="COLOR: red">ConnectionString</span>="<SPAN style="background: yellow; mso-highlight: yellow"><%</SPAN>$ ConnectionStrings:DatabaseConnection <SPAN style="background: yellow; mso-highlight: yellow">%></SPAN>" <o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">         </span><span style="COLOR: red">SelectCommand</span>="SELECT * FROM Customers" /></font></span><span style="mso-no-proof: yes">
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2">   <asp:GridView <span style="COLOR: red">ID</span>="customersGridView" <span style="COLOR: red">runat</span>="server" <span style="COLOR: red">DataSourceID</span>="customersDataSource" <o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">            </span><span style="COLOR: red">AutoGenerateColumns</span>="false"><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">            </span><Columns><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="CompanyName" <span style="COLOR: red">HeaderText</span>="CompanyName"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="ContactName" <span style="COLOR: red">HeaderText</span>="ContactName"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="ContactTitle" <span style="COLOR: red">HeaderText</span>="ContactTitle"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="Address" <span style="COLOR: red">HeaderText</span>="Address"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="City" <span style="COLOR: red">HeaderText</span>="City"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="Region" <span style="COLOR: red">HeaderText</span>="Region"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="PostalCode" <span style="COLOR: red">HeaderText</span>="PostalCode"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="Country" <span style="COLOR: red">HeaderText</span>="Country"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="Phone" <span style="COLOR: red">HeaderText</span>="Phone"/><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">                </span><asp:BoundField <span style="COLOR: red">DataField</span>="Fax" <span style="COLOR: red">HeaderText</span>="Fax"/><span style="mso-tab-count: 1">   </span><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">            </span></Columns><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><span style="mso-no-proof: yes"><font size="2"><span style="mso-spacerun: yes">        </span></asp:GridView><o:p></o:p></font></span>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><o:p></o:p></span> 
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><o:p><font size="2">And here is the app in action:</font></o:p>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><o:p><font size="2"></font></o:p> 
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"><o:p><span style="FONT-SIZE: 12pt; FONT-FAMILY: 'Times New Roman'; mso-fareast-font-family: 'Times New Roman'; mso-ansi-language: EN-US; mso-fareast-language: EN-US; mso-bidi-language: AR-SA"><?xml:namespace prefix ="" v /><v:shapetype id="_x0000_t75" coordsize="21600,21600" o:spt="75" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f"><v:stroke joinstyle="miter"></v:stroke><v:formulas><v:f eqn="if lineDrawn pixelLineWidth 0"></v:f><v:f eqn="sum @0 1 0"></v:f><v:f eqn="sum 0 0 @1"></v:f><v:f eqn="prod @2 1 2"></v:f><v:f eqn="prod @3 21600 pixelWidth"></v:f><v:f eqn="prod @3 21600 pixelHeight"></v:f><v:f eqn="sum @0 0 1"></v:f><v:f eqn="prod @6 1 2"></v:f><v:f eqn="prod @7 21600 pixelWidth"></v:f><v:f eqn="sum @8 21600 0"></v:f><v:f eqn="prod @7 21600 pixelHeight"></v:f><v:f eqn="sum @10 21600 0"></v:f></v:formulas><v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"></v:path><o:lock v:ext="edit" aspectratio="t"><a href="{{ site.cdn_root }}binary/theDarkSideOfDeclaritiveDatabinding/screenShot1.jpg" rel="lightbox[thedarksideofdeclaritivedatabinding]"><img alt="ScreenShot1" src="{{ site.cdn_root }}binary/theDarkSideOfDeclaritiveDatabinding/screenShot1_thumb1.jpg" align="left" border="0" /></a></o:lock></v:shapetype></span></o:p>
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in">On the surface this all looks great. I've developed a fully data driven web page in under 2 minutes and didn't have to type a single line of code. What could be wrong with that? 
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in"> 
<p class="ListingText" style="MARGIN: 0in 2.25in 0pt 0in">First, the use of the SqlDataSource control requires that the view have initimate knowledge of the database. The view is responsible for determining where to pull the data from as well as how to display that data. And if it were not for the fact that the connection string was stored in a configuration file, then it would also be responsible for providing a connection string used to connect to the database. This is just plain old poor separation of responsibility. 
<p class="BodyText" style="MARGIN: 0in 0in 0pt">
<p class="BodyText" style="MARGIN: 0in 0in 0pt"> 
<p class="BodyText" style="MARGIN: 0in 0in 0pt">Second and no less important. One of the biggest problems with this method of databinding is the fact that you have to run the application in order to verify that the databinding will work. I'll prove this by making a small change to the db schema. I'm going to change the name of the 'Customers' table to 'Customer'. I've made the change and rebuilt the db (using Nant of course!!). 
<p class="BodyText" style="MARGIN: 0in 0in 0pt"> 
<p class="BodyText" style="MARGIN: 0in 0in 0pt"> 
<p class="BodyText" style="MARGIN: 0in 0in 0pt">Now I'll run the app.
<p class="BodyText" style="MARGIN: 0in 0in 0pt">
<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"> 


<p class="MsoNormal" style="MARGIN: 0in 0in 0pt"><a href="{{ site.cdn_root }}binary/theDarkSideOfDeclaritiveDatabinding/invalidObject.jpg" rel="lightbox[thedarksideofdeclaritivedatabinding]"><img alt="invalidobject" src="{{ site.cdn_root }}binary/thedarksideofdeclaritivedatabinding/invalidobject.jpg" border="0" /></a>
<p class="msonormal" style="MARGIN: 0in 0in 0pt"> 
<p class="msonormal" style="MARGIN: 0in 0in 0pt">Ouch. And to add insult to injury; the only reason I found this error was by running the app and navigating to the page in question. Not efficient.
<p class="bodytext" style="MARGIN: 0in 0in 0pt">
<p class="msonormal" style="MARGIN: 0in 0in 0pt"> 
<p class="bodytext" style="MARGIN: 0in 0in 0pt">This is all too common a scenario I experience when going in to mentor teams of developers who are strong proponents of a data-driven approach to application development. One small change can cause ripple effects which are often not realized until the application is run. This is a very slow process and is not conducive to rapid, confident development of application functionality. In future installments I will talk about ways to handle this issue with a bit more style and grace, using a TDD perspective!!

 




