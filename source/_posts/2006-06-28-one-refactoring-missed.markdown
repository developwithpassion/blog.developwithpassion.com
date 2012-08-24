---
layout: post
title: "One Refactoring Missed"
comments: true
date: 2006-06-28 09:00
categories:
- .net 2.0
- c sharp
- patterns
- screencasts
---

For those of you who are following along with my Applied TDD series there is one refactoring I forgot to do yesterday:
<div style="FONT-SIZE: 11pt; BACKGROUND: white; COLOR: black; FONT-FAMILY: Consolas">
<p style="MARGIN: 0px"><span style="COLOR: blue">            using</span> (mockery.Ordered())
<p style="MARGIN: 0px">            {
<p style="MARGIN: 0px">                <span style="COLOR: teal">Expect</span>.Call(mockTask.GetAllContacts()).Return(mockResults);
<p style="MARGIN: 0px">                mockView.<strong>Contacts</strong> = mockResults;
<p style="MARGIN: 0px">            }</div><!--EndFragment-->

Notice the bolded code. It used to read mockView.Employees. Halfway through the session I decided to first tackle displaying a list of contacts and not employees.

 




