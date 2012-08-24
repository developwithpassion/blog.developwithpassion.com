---
layout: post
title: "Automating Your Builds With NAnt - Part 3"
comments: true
date: 2006-04-07 09:00
categories:
- .net 2.0
- c sharp
- tools
---

Ok, last time we left off being able to clean/create a staging area for the build. Let’s now work on actually compiling the projects in the solution. If you take a quick look at the solution structure <a href="{{ site.cdn_root }}binary/buildProcessPart3/solutionStructure.jpg" rel="lightbox[buildProcess]"><img alt="SolutionStructure" src="http://www.developwithpassion.com/solutionStructure_small.jpg" align="right" border="0"></a> you will notice that there are 16 projects. More than half of these projects are test projects, and one of them is a web project. To be more specific, I am using the standard VS2005 web project model to organize my web project. Some of you may not be aware but there is another model called the Web Application Project model, that basically looks and behaves very similar to the way web projects worked pre VS2005. More on that another day!! Today I will focus on just building the supporting assemblies for the web project. Right now, I am talking about a build for test, not for deployment. These are 2 quite different animals. When I am doing a build for test I can choose to take a very simple route and just compile all of the code from the 8 supporting projects into a single dll, as opposed to compiling them the way studio does. This also keeps the build file a lot simpler. More often than not, as developers we utilize projects as a way to logically organize the application. Whether or not each of the individual projects actually resolves to one deployable unit is a choice that you have to make as a project team. Personally, once you have an automated deployment scenario in place, it really does not matter. As deploying becomes (almost) as simple as running a NAnt target.

Let’s get back to actually building the 8 projects we are interested in. It stands to reason that some of the projects in the solution have dependencies on other projects in the solution <a href="{{ site.cdn_root }}binary/buildProcessPart3/projectReferences.jpg" rel="lightbox[buildProcess]"><img alt="ProjectReferences" src="http://www.developwithpassion.com/projectReferences_thumb1.jpg" align="left" border="0"></a>. Obviously these projects will not be able to build properly unless those references are maintained and obligated within the build file. A better question to ask is how do you actually go about compiling the 8 projects using NAnt? If you have been taking a look at the NAnt [NAnt Task Reference](http://nant.sourceforge.net/release/latest/help/tasks/" target="_blank) reference you will notice that one of the tasks in there is the <strong>csc</strong>  task. This is a dedicated task with the sole responsibility of compiling C# programs. It stands to reason that this would have to enter the mix somewhere!! 

I am not even going to try and attempt to cover all of the attributes/flags that can be used in conjunction with the csc task. I believe an example will speak louder than words and get you going in the right direction. Let’s switch back to the build file and start working on adding in the compile task. In case you forgot what the build file currently looks like, here it is:

<?xml version="1.0"?>
<project name="DotNetRocks" default="all"><o:p></o:p>

    <property name="debug" value="true" /><o:p></o:p>

   <target name=”all”/> <o:p></o:p>

   <target name="clean" description="remove all build products">
        <delete dir="build"  if="${directory::exists('build')}" />
    </target><o:p></o:p>

    <target name="init">
        <mkdir dir="build" />
    </target>

</project>

I’ll add the entire compile target and then discuss and dissect for the remainder of the post:

<?xml version="1.0"?>
<project name="DotNetRocks" default="all"><o:p></o:p>

    <property name="debug" value="true" /><o:p></o:p>

   <target name=”all”/> <o:p></o:p>

   <target name="clean" description="remove all build products">
        <delete dir="build"  if="${directory::exists('build')}" />
    </target><o:p></o:p>

    <target name="init">
        <mkdir dir="build" />
    </target>

<strong>    <target name="compile" 
            depends="init"
            description="compiles the application">
        <csc target="library" output="build\${nant.project.name}.dll" debug="${debug}">
            <sources>
                <include name="src\app\**\*.cs" />
                <exclude name="src\app\DotNetRocks.Web.UI\*.*" />
                <exclude name="src\app\**\AssemblyInfo.cs" />                                
            </sources>                        
        </csc>
    </target></strong><o:p></o:p>

</project> 

First point of interest is the use of the new “depends” attribute in the compile target. This tells NAnt to ensure that the “init” target has been run before the compile target runs. If the init target has not already been executed in this NAnt session, then NAnt will ensure that the init target is run before it carries on processing the compile target. NAnt processes dependencies from left to right so you can have a target depend on multiple targets using comma-separated lists such as : depends = “clean,init”. If you have a dependency on a target that also has a dependency on <strong>init</strong>, NAnt will make sure that the <strong>init</strong> target is only executed once, as not to waste execution cycles. The rest of the target deals with the actual csc task itself.

First off, I tell NAnt that I am going to be compiling a “library” (dll) and that it should place the resulting dll in the build directory. What’s with the ${nant.project.name} syntax? This is the way you access properties in NAnt. We did not, however, define that particular property in our build file. This is because ${nant.project.name} is one of many predefined NAnt properties that we can make use of during the build process. The value of the ${nant.project.name} property will resolve to the name you give your project in the project element of the build file:

<project name="<strong>DotNetRocks</strong>" default="all"><o:p></o:p>

So when this dll is compiled it will actually be compiled to : build\DotNetRocks.dll.

Finally I have to tell the csc task, what files (sources) to include in the compile process. The sources element is actually just a NAnt [fileset](http://nant.sourceforge.net/release/latest/help/types/fileset.html). I can include/exclude files from the fileset. Notice how I am excluding everything in the Web.UI project? Why, this is because I am using the WSP model and a lot of the code for web projects, when using this model, is dynamically generated. In a future post, I will show one way to compile the Web.UI project. I am also excluding any AssemblyInfo.cs file from the list of sources. If I did not do this, the compiler would choke because there would be multiple classes of type AssemblyInfo attempting to be compiled into the assembly. <a href="{{ site.cdn_root }}binary/buildProcessPart3/multipleAssemblyInfos.jpg" rel="lightbox[buildProcess]"><img alt="MultipleAssemblyInfos" src="http://www.developwithpassion.com/multipleAssemblyInfos_thumb.jpg" align="right" border="0"></a> When I usually compile multiple projects into a single assembly, I usually create a single AssemblyInfo file for that group of projects, and include that AssemblyInfo file into the compile process.

With that target completed, I can run the compile target from the command line and see the result placed into my build directory.<a href="{{ site.cdn_root }}binary/buildProcessPart3/buildDirectoryWithNewAssembly.jpg" rel="lightbox[buildProcess]"><img alt="BuildDirectoryWithNewAssembly" src="http://www.developwithpassion.com/buildDirectoryWithNewAssembly_thumb1.jpg" align="left" border="0"></a> 

Next up is testing the assembly!!

 











