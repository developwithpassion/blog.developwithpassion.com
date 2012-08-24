---
layout: post
title: "Clean up your (NAnt) build files by taking advancategories of fileset references"
comments: true
date: 2006-11-01 09:00
categories:
- agile
- tools
---

Imagine you have a buildfile and you have the following compile element that makes use of a couple of third party assemblies: 
 <pre class="code"><span style="color: rgb(0,0,255)">        <</span><span style="color: rgb(128,0,0)">csc</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">target</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">library</span>"<span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">output</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${dist.dir}\${app.library.name}</span>"<span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">debug</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${debug}</span>"<span style="color: rgb(0,0,255)">>
            <</span><span style="color: rgb(128,0,0)">sources</span><span style="color: rgb(0,0,255)">>                
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${app.src.dir}\**\*.cs</span>"<span style="color: rgb(0,0,255)"> />                
                <</span><span style="color: rgb(128,0,0)">exclude</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${app.src.dir}\**\AssemblyInfo.cs</span>"<span style="color: rgb(0,0,255)"> />
            </</span><span style="color: rgb(128,0,0)">sources</span><span style="color: rgb(0,0,255)">>    
            <</span><span style="color: rgb(128,0,0)">resources</span><span style="color: rgb(0,0,255)">>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${config.dir}\mapping\*hbm.xml</span>"<span style="color: rgb(0,0,255)">/>
            </</span><span style="color: rgb(128,0,0)">resources</span><span style="color: rgb(0,0,255)">>
<strong>            <</strong></span><span style="color: rgb(128,0,0)"><strong>references</strong></span><strong><span style="color: rgb(0,0,255)">>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\filehelpers\DotNet 2.0\FileHelpers.dll</span>"</strong><strong><span style="color: rgb(0,0,255)">/>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\binsor\Castle.Windsor.dll</span>"</strong><strong><span style="color: rgb(0,0,255)">/>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\log4net\log4net.dll</span>"</strong><strong><span style="color: rgb(0,0,255)">/>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\nhibernate\NHibernate.dll</span>"</strong><strong><span style="color: rgb(0,0,255)">/>
            </</span><span style="color: rgb(128,0,0)">references</span></strong><span style="color: rgb(0,0,255)"><strong>></strong>
        </</span><span style="color: rgb(128,0,0)">csc</span><span style="color: rgb(0,0,255)">>
</span></pre><pre class="code"><span style="color: rgb(0,0,255)"></span> </pre>

Pay close attention to the references element. Notice how I am explicitly including the names of libraries that I want to  that "references" fileset. 

Most people who are using NAnt are familiar with the concept of a fileset. Essentially it is a set of files that belong to a logical unit that you can make use of during the NAnt build process. 

Assume I have another target that needed to perform a similar compile. I could just copy the references element, but that would be unnecessary duplication. What I can do is create a fileset that can be later referenced and used by other targets/tasks in the build file. 

 

I'll start by creating the filset near the top of my build file (before any targets):

 <pre class="code"><span style="color: rgb(0,0,255)">    <</span><span style="color: rgb(128,0,0)">fileset</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">id</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">deploy.lib.fileset</span>"<span style="color: rgb(0,0,255)">>    
        <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\filehelpers\DotNet 2.0\FileHelpers.dll</span>"<span style="color: rgb(0,0,255)">/>
        <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\binsor\Castle.Windsor.dll</span>"<span style="color: rgb(0,0,255)">/>
</span><span style="color: rgb(0,0,255)">        <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\log4net\log4net.dll</span>"<span style="color: rgb(0,0,255)">/>                
        <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${lib.dir}\nhibernate\NHibernate.dll</span>"<span style="color: rgb(0,0,255)">/>                                
    </</span><span style="color: rgb(128,0,0)">fileset</span><span style="color: rgb(0,0,255)">>
</span></pre>

 

Notice how I have changed the element to be of type filset vs references. The references element is a special subclass of fileset reserved for the csc task. You will also notice how I have given the fileset an id. It is this id that will allow me to reference this fileset elsewhere. I can now replace the fileset I was originally using in the csc task with a reference to the fileset that contains all of the references that should be used for the compile task:

 <pre class="code"><span style="color: rgb(0,0,255)">        <</span><span style="color: rgb(128,0,0)">csc</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">target</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">library</span>"<span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">output</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${dist.dir}\${app.library.name}</span>"<span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">debug</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${debug}</span>"<span style="color: rgb(0,0,255)">>
            <</span><span style="color: rgb(128,0,0)">sources</span><span style="color: rgb(0,0,255)">>                
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${app.src.dir}\**\*.cs</span>"<span style="color: rgb(0,0,255)"> />                
                <</span><span style="color: rgb(128,0,0)">exclude</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${app.src.dir}\**\AssemblyInfo.cs</span>"<span style="color: rgb(0,0,255)"> />
            </</span><span style="color: rgb(128,0,0)">sources</span><span style="color: rgb(0,0,255)">>    
            <</span><span style="color: rgb(128,0,0)">resources</span><span style="color: rgb(0,0,255)">>
                <</span><span style="color: rgb(128,0,0)">include</span><span style="color: rgb(0,0,255)"> </span><span style="color: rgb(255,0,0)">name</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">${config.dir}\mapping\*hbm.xml</span>"<span style="color: rgb(0,0,255)">/>
            </</span><span style="color: rgb(128,0,0)">resources</span><span style="color: rgb(0,0,255)">>
            <</span><span style="color: rgb(128,0,0)">references</span><span style="color: rgb(0,0,255)"> </span><strong><span style="color: rgb(255,0,0)">refid</span><span style="color: rgb(0,0,255)">=</span>"<span style="color: rgb(0,0,255)">deploy.lib.fileset</span>"</strong><span style="color: rgb(0,0,255)">/>                
        </</span><span style="color: rgb(128,0,0)">csc</span><span style="color: rgb(0,0,255)">>
</span></pre>

  

You can see now that the references element in the csc task now uses the refid attribute to link back to a fileset that I have already defined elsewhere in the build file. Think how many filesets you may take advantage of when building your apps using NAnt:
<ul>
<li>sources 
<li>references 
<li>resources</li></ul>

And that is just a small sample. Streamlining and refactoring the build file is just as important as refactoring and improving the code base of the app that the build file is building.

Hopefully this has given you one more tool with which you can go and clean up some duplication that may exist in your build file.




