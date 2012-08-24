---
layout: post
title: "Updated - Macro For Test Naming"
comments: true
date: 2007-11-13 09:00
categories:
- general
---

Since the last time I published this, things have changed a little. With the addition of some code from students in the last 2 classes, it definitely works a lot more fluid that it did in its original iteration:<font color="#0000ff" size="2">

Imports</font><font size="2"> System</font><font color="#0000ff" size="2">

Imports</font><font size="2"> System.Windows.Forms</font><font color="#0000ff" size="2">

Imports</font><font size="2"> EnvDTE</font><font color="#0000ff" size="2">

Imports</font><font size="2"> EnvDTE80</font><font color="#0000ff" size="2">

Imports</font><font size="2"> System.Diagnostics</font><font color="#0000ff" size="2">

Public</font><font size="2"> </font><font color="#0000ff" size="2">Module</font><font size="2"> CodeEditor

</font><font color="#0000ff" size="2">Sub</font><font size="2"> ReplaceSpacesInTestNameWithUnderscores()

</font><font color="#0000ff" size="2">If</font><font size="2"> DTE.ActiveDocument </font><font color="#0000ff" size="2">Is</font><font size="2"> </font><font color="#0000ff" size="2">Nothing</font><font size="2"> </font><font color="#0000ff" size="2">Then</font><font size="2"> </font><font color="#0000ff" size="2">Return</font><font size="2">

</font><font color="#0000ff" size="2">Dim</font><font size="2"> wrVB </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">Boolean</font><font size="2"> = DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"Basic"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value

</font><font color="#0000ff" size="2">Dim</font><font size="2"> wrPT </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">Boolean</font><font size="2"> = DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"PlainText"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value

</font><font color="#0000ff" size="2">Dim</font><font size="2"> wrCS </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">Boolean</font><font size="2"> = DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"CSharp"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value

</font><font color="#0000ff" size="2">Try</font><font size="2">

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"Basic"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = </font><font color="#0000ff" size="2">False</font><font size="2">

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"PlainText"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = </font><font color="#0000ff" size="2">False</font><font size="2">

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"CSharp"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = </font><font color="#0000ff" size="2">False</font><font size="2">

</font><font color="#0000ff" size="2">Dim</font><font size="2"> selection </font><font color="#0000ff" size="2">As</font><font size="2"> TextSelection = </font><font color="#0000ff" size="2">CType</font><font size="2">(DTE.ActiveDocument.Selection(), EnvDTE.TextSelection)

selection.SelectLine()

</font><font color="#0000ff" size="2">If</font><font size="2"> selection.Text = </font><font color="#a31515" size="2">""</font><font size="2"> </font><font color="#0000ff" size="2">Then</font><font size="2"> </font><font color="#0000ff" size="2">Return</font><font size="2">

</font><font color="#0000ff" size="2">Dim</font><font size="2"> prefix </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">String</font><font size="2"> = </font><font color="#a31515" size="2">"public void "</font><font size="2">

</font><font color="#0000ff" size="2">Dim</font><font size="2"> index </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">Integer</font><font size="2"> = selection.Text.IndexOf(prefix)

</font><font color="#0000ff" size="2">If</font><font size="2"> index < 0 </font><font color="#0000ff" size="2">Then</font><font size="2">

</font><font size="2"><font color="#0000ff">Return</font></font><font size="2">

</font><font color="#0000ff" size="2">End</font><font size="2"> </font><font color="#0000ff" size="2">If</font><font size="2">

prefix = selection.Text.Substring(0, index) + prefix

</font><font color="#0000ff" size="2">Dim</font><font size="2"> description </font><font color="#0000ff" size="2">As</font><font size="2"> </font><font color="#0000ff" size="2">String</font><font size="2"> = selection.Text.Replace(prefix, </font><font color="#0000ff" size="2">String</font><font size="2">.Empty).Trim

selection.Text = prefix + description.Replace(</font><font color="#a31515" size="2">" "</font><font size="2">, </font><font color="#a31515" size="2">"_"</font><font size="2">).Replace(</font><font color="#a31515" size="2">"'"</font><font size="2">, </font><font color="#a31515" size="2">"_"</font><font size="2">) + vbCrLf

selection.LineDown()

selection.EndOfLine()

</font><font color="#0000ff" size="2">Catch</font><font size="2"> ex </font><font color="#0000ff" size="2">As</font><font size="2"> Exception

MsgBox(ex.Message)

</font><font size="2"><font color="#0000ff">Finally</font></font><font size="2">

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"Basic"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = wrVB

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"PlainText"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = wrPT

DTE.Properties(</font><font color="#a31515" size="2">"TextEditor"</font><font size="2">, </font><font color="#a31515" size="2">"CSharp"</font><font size="2">).Item(</font><font color="#a31515" size="2">"WordWrap"</font><font size="2">).Value = wrCS

</font><font color="#0000ff" size="2">End</font><font size="2"> </font><font color="#0000ff" size="2">Try</font><font size="2">

</font><font color="#0000ff" size="2">End</font><font size="2"> </font><font color="#0000ff" size="2">Sub

End</font><font size="2"> </font><font color="#0000ff" size="2">Module</font>

<font color="#0000ff" size="2"></font> 

<font color="#0000ff" size="2">Enjoy.</font>




