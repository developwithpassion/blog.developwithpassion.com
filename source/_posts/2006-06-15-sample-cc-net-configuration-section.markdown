---
layout: post
title: "Sample CC.Net Configuration Section"
comments: true
date: 2006-06-15 09:00
categories:
- agile
- tools
---
As one of my readers kindly reminded me. I mentioned in the CC.Net video that I would make the CC.Net configuration section for the project demo available.

Here it is:

{% codeblock xml %}
<?xml version="1.0"?>
<cruisecontrol>
  <project name="AdventureWorks">
    <workingDirectory>C:\root\development\citools\cruise\checkouts\adventureworks</workingDirectory>
    <artifactDirectory>C:\root\development\citools\cruise\builds\adventureworks\artifacts</artifactDirectory>
    <webURL>http://localhost/ccnet</webURL>
    <modificationDelaySeconds>10</modificationDelaySeconds>
    <publishExceptions>true</publishExceptions>
    <triggers>
      <intervalTrigger seconds="60"/>
    </triggers>
    <state type="state" directory="C:\root\development\citools\cruise\builds\adventureworks\state"/>
    <sourcecontrol type="svn">
      <trunkUrl>file:///C:/root/development/svnrepo/playground/adventureworks</trunkUrl>
      <workingDirectory>C:\root\development\citools\cruise\checkouts\adventureworks</workingDirectory>
    </sourcecontrol>
    <tasks>
      <nant>
        <executable>c:\root\development\citools\nant\bin\nant.exe</executable>
        <baseDirectory>C:\root\development\citools\cruise\builds\adventureworks</baseDirectory>
        <buildFile>cruise.build</buildFile>
        <targetList>
          <target>all</target>
        </targetList>
        <buildTimeoutSeconds>300</buildTimeoutSeconds>
      </nant>
    </tasks>
    <publishers>
      <merge>
        <files>
          <file>C:\root\development\citools\cruise\checkouts\adventureworks\build\*Test-Result.xml</file>
        </files>
      </merge>
      <xmllogger/>
    </publishers>
  </project>
</cruisecontrol>
{% endcodeblock %}

Of course, you will need to ensure that you replace any occurrence of C:\root\development with a location that you want to use on your own machine.

[Develop With Passion!!](http://www.developwithpassion.com)
