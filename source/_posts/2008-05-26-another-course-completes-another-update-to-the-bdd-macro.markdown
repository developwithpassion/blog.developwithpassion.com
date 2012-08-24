---
layout: post
title: "Another course completes, another update to the BDD Macro!!"
comments: true
date: 2008-05-26 09:00
categories:
- general
---

Hot on the heels of the Toronto course completion, one of the attendees (Michael Sevestre) just emailed me with a small update that fixes the issue on trying to reapply the macro to the name of the context when it is now inheriting from a base context class.  
Thanks Michael, it is greatly appreciated!!  
The update is below:  
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
 Dim implementIndex As Integer = selection.Text.IndexOf(":")   
 If (methodIndex < 0 AndAlso classIndex < 0) Then Return   
 index = CType(IIf(methodIndex >= 0, methodIndex, classIndex), Integer)   
 Dim prefix As String = CType(IIf(methodIndex >= 0, "public void ", "public class "), String)   
 Dim whiteSpace As String = selection.Text.Substring(0, index)    
 prefix = whiteSpace + prefix   
 Dim description As String = selection.Text.Replace(prefix, String.Empty)   
 'Find the ":" at the end of the line if defines   
 Dim suffix As String = String.Empty    
 If (implementIndex >= 0) Then    
 suffix = selection.Text.Substring(implementIndex).Trim()    
 description = description.Replace(suffix, String.Empty)    
 suffix = String.Format(" {0}", suffix)    
 End If   
 description = description.Trim   
 Dim text As String = prefix + description.Replace(" ", "_").Replace("'", "_") + suffix + vbCrLf    
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
 selection.EndOfLine()    
 Catch ex As Exception    
 MsgBox(ex.Message)    
 Finally    
 DTE.Properties("TextEditor", "CSharp").Item("WordWrap").Value = wrCS    
 End Try    
 End Sub    
End Module




