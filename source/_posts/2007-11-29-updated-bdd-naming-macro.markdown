---
layout: post
title: "Updated BDD Naming Macro"
comments: true
date: 2007-11-29 09:00
categories:
- agile
---

After an awesome session pair programming with [Scott ](http://codebetter.com/blogs/scott.bellware/)the other day, I am going to start taking advantage of natural sentence style naming for not just my test method names, but the names of the test fixtures themselves.

The name of the fixture will now become the context for the tests inside of that fixture. It is actually surprising what level of detail this allows you to express yourself.

I had to change my test naming macro to support classes also. Here is the fix:

 
{% codeblock vbscript %}
Imports System 
Imports System.Windows.Forms 
Imports EnvDTE 
Imports EnvDTE80 
Imports System.Diagnostics 
Public Module CodeEditor 
  Sub ReplaceSpacesInTestNameWithUnderscores() 
    If DTE.ActiveDocument Is Nothing Then Return 
    Dim wrCS As Boolean = DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value 
    Try 
      DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value = False  
      Dim selection As TextSelection = CType(DTE.ActiveDocument.Selection(), EnvDTE.TextSelection) 
      Dim index As Integer  selection.SelectLine() If selection.Text = "" Then Return 
      Dim methodIndex As Integer = selection.Text.IndexOf("public void ") 
      Dim classIndex As Integer = selection.Text.IndexOf("public class ") 
      index = CType(IIf(methodIndex >= 0, methodIndex, classIndex), Integer) 
      Dim prefix As String = CType(IIf(methodIndex >= 0, "public void ", "public class "), String) 
      prefix = selection.Text.Substring(0, index) + prefix Dim description As String = selection.Text.Replace(prefix, String.Empty).Trim 
      selection.Text = prefix + description.Replace(" ", "_").Replace("'", "_") + vbCrLf 
      selection.LineDown() 
      selection.EndOfLine() 
    Catch ex As Exception 
      MsgBox(ex.Message) 
    Finally 
      DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value = wrCS 
    End Try 
  End Sub 
End Module  
{% endcodeblock %}




Develop With Passion




