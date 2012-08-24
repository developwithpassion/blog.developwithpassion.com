---
layout: post
title: "Macro to aid BDD test naming style"
comments: true
date: 2007-09-04 09:00
categories:
- programming
---

During the DevTeach seminar that occured in Montreal in May I got an awesome opportunity to pair deliver a TDD workshop with Scott Bellware. One of the things he got me hooked on was using natural sentences as a test naming convention. So instead of this:

ShouldBeAbleToTransferFundsBetweenAccounts

You write it out like this:

Should be able to transfer funds between accounts.

Of course, only one of these is legitimate from a compilation perspective. So Scott had written a macro that would replace all of the spaces in the test name with underscore. You invoked it by highlighting the name of the test and hitting a key combination that was bound to the macro. Which would convert the natural sentence to the following:

Should_be_able_to_transfer_funds_between_accounts.

During the last course, Terry Hughes improved upon the macro so that now all I have to do is type out the name of the test and hit ALT + _ (that is what I have the macro bound to). I don't need to select the name of the test.

It is a subtle change, but one that allows me to just write out the name of my test without worrying about camel casing or underscores.

Here is the macro:

 
{% codeblock vbscript %}
Imports System 
Imports EnvDTE 
Imports EnvDTE80 
Imports System.Diagnostics 

Public Module CodeEditor 
  Sub ReplaceSpacesInTestNameWithUnderscores() 
    If DTE.ActiveDocument Is Nothing Then Return 
    Dim selection As TextSelection = CType(DTE.ActiveDocument.Selection(), EnvDTE.TextSelection) selection.SelectLine() 
      If selection.Text = "" Then Return 
      Dim prefix As String = "public void "  
    Dim index As Integer = selection.Text.IndexOf(prefix) 
      prefix = selection.Text.Substring(0, index) + prefix 
    Dim description As String = selection.Text.Replace(prefix, String.Empty) 
      selection.Text = prefix + description.Replace(" ", "_").Replace("'", "_") 
      selection.LineDown() 
    selection.EndOfLine() 
  End Sub 
End Module
{% endcodeblock %}


[This video]({{ site.cdn_root }}binary/2007/september/04/macrotoaiddbddtestnamingstyle/Macros.html" target="_blank) shows the macro in action.

 

Enjoy




