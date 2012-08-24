---
layout: post
title: "Running all of the sql files in a directory"
comments: true
date: 2006-05-04 09:00
categories:
- agile
- tools
---

Just got asked a question by Scott Cowan :

Q:  <font size="2">is there a way in nant to run a call for each .sql file in a dir ?</font>

<font size="2"><font color="#0000ff" size="3">A: <font size="2">If you wanted to execute the scripts for a whole directory of sql files (and the order of the files running is not important), then you can take advantage of the NAnt <foreach> task.   Here is an example of a target that you could set up to run all of the sql files in a specific folder:

<target name="exec.sql.folder">
    <foreach item="File" property="filename">
       <in>
          <items basedir="${folder}">
             <include name="*.sql"/>     
          </items>
      </in>
      <do>
          <property name="target" value="${filename}"/>
          <call target="exec.sql.template"/>
      </do>  

</foreach>

</target>

Notice that you would want to call this target from another target that sets the folder property to execute against:

<target name="exec.all.sql">

     <property name="folder" value="sql"/>

    <call target="exec.sql.folder"/>

</target>

Hope this helps.

JP</font></font></font>




