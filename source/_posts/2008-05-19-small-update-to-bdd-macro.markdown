---
layout: post
title: "Small Update to BDD Macro"
comments: true
date: 2008-05-19 09:00
categories:
- programming
---

I noticed a small error in the BDD macro that I have just fixed. The text of the macro is below:  
Imports System   
Imports System.Windows.Forms   
Imports EnvDTE    
Imports EnvDTE80    
Imports System.Diagnostics   
Public Module CodeEditor   
 Public Sub ReplaceSpacesInTestNameWithUnderscores()   
 If DTE.ActiveDocument Is Nothing Then Return    
 Dim wrCS As Boolean = DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value   
 Try   
 DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value = False    
 Dim selection As TextSelection = CType(DTE.ActiveDocument.Selection(), EnvDTE.TextSelection)    
 Dim index As Integer   
 selection.SelectLine()   
 If selection.Text = "" Then Return   
 Dim methodIndex As Integer = selection.Text.IndexOf("public void ")   
 Dim classIndex As Integer = selection.Text.IndexOf("public class ")   
 If (methodIndex < 0 AndAlso classIndex < 0) Then Return   
 index = CType(IIf(methodIndex >= 0, methodIndex, classIndex), Integer)   
 Dim prefix As String = CType(IIf(methodIndex >= 0, "public void ", "public class "), String)   
 Dim whiteSpace As String = selection.Text.Substring(0, index)    
 prefix = whiteSpace + prefix    
 Dim description As String = selection.Text.Replace(prefix, String.Empty).Trim    
 Dim text As String = prefix + description.Replace(" ", "_").Replace("'", "_") + vbCrLf    
 selection.Delete()    
 selection.Insert(text)    
 selection.LineUp()    
 selection.LineUp()    
 selection.SelectLine()    
 If selection.Text.Trim = "{" Or selection.Text.Trim = "}" Or selection.Text.Trim = "" Then    
 If selection.Text.Trim = "{" Or selection.Text.Trim = "}" Then    
 selection.Insert(selection.Text.Replace(vbCrLf, "") + vbCrLf)    
 ElseIf selection.Text.Trim = "" Then    
 selection.Delete()    
 End If    
 End If    
 selection.LineDown()    
 selection.LineDown()    
 selection.EndOfLine()    
 Catch ex As Exception    
 MsgBox(ex.Message)    
 Finally    
 DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value = wrCS    
 End Try    
 End Sub    
End Module 




