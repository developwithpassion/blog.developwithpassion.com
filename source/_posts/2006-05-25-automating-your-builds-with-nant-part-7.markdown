---
layout: post
title: "Automating Your Builds With NAnt - Part 7"
comments: true
date: 2006-05-25 09:00
categories:
- .net 2.0
- c sharp
- tools
---

It has been quite a bit of time since the [last installment](http://blog.developwithpassion.com/AutomatingYourBuildsWithNAntPart6.aspx) of the [NAnt Starter Series](http://blog.developwithpassion.com/NAntStarterSeries.aspx). We left off being able to successfully compile and test the main libraries of our application, and we progressed to bringing the database into the fold and looked at ways to manage the database in a multiple developer environment. In this installment we are going to talk about compiling and distributing the web portion of the application. Specifically, we are going to write a NAnt target that will build and deploy our entire web application into a directory that can be immediately deployed to a remote server if need be. Take a look at the current solution structure that is set up:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/solutionStructure.jpg" rel="lightbox[buildProcessPart7]"><img alt="SolutionStructure" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/solutionStructure_thumb.jpg" align="left" border="0" / /></a>

As you can see from the diagram, in this example I am going to be using the web-site project model, as opposed to the newly available [Web Application Project model](http://msdn.microsoft.com/asp.net/reference/infrastructure/wap/). You will quickly see that the only file that exists in this project is the ViewCustomers.aspx file. I am not using any of the new directories like the App_Code, App_Data etc. My web project should be extremely simple, consisting of purely UI elements like:

- Web Pages

- User Controls

- JavaScript Libraries

- Styles and Templates

 

By limiting the amount of code that is placed in this project, I can write unit tests against the real objects that will actually get work done. These objects , of course, live in projects separate from the web application. You might be asking yourself 'Where is the web.config file?'. That file is actually a template file that will have pre-processing done on it during the build process. The contents of that file before processing look as follows:

<?xml version="1.0"?>
<configuration xmlns="<A href="http://schemas.microsoft.com/.netconfiguration/v2.0">http://schemas.microsoft.com/.NetConfiguration/v2.0</A>">       
 <appSettings>  
  <add key="DatabaseConnection" value="SqlServer"/>
 </appSettings>
 
 <connectionStrings>
  <add name="SqlServer"
   connectionString="@CONFIG_CONNECTION_STRING@"  
   providerName="System.Data.SqlClient"
  />
 </connectionStrings>
 <system.web>
  <compilation debug="true"/>
  <authentication mode="Windows"/>
   <authorization>
       <deny users="?" />
   </authorization>
  <customErrors mode="Off" />
  <sessionState mode="Off" />  
 </system.web> 
</configuration>


If you look at the connectionStrings element, you will notice that the SqlServer connectionString is set up as a replaceable token in the Web.config.template file. Again, this is to ensure that at deploy time, the connectionString will be replaced with the appropriate string based on the environment that is getting deployed to.

Ok, let's turn our attention to the process of building and deploying the application. Take a look at a new target that will compile our web application from inside of NAnt:

 <target name="asp.compile" description="Compiles the webapp" depends="init, compile">
        <delete dir="build\dist" if="${directory::exists('build\dist')}" />
        
        <loadtasks assembly="tools\nant\NAnt.Contrib.Tasks.dll" />
 
 <delete>
     <fileset basedir="build\aspprecompile">
  <include name="**\*" />
     </fileset>
 </delete>
        <copy todir="build\aspprecompile">
            <fileset basedir="src\app\DotNetRocks.Web.UI">
                <include name="*" />
                <include name="images\**\*.*" />
                <include name="javascript\**\*.js" />
            </fileset>
        </copy>

        <copy todir="build\aspprecompile\bin">
            <fileset basedir="build">
                <include name="*.dll" />
            </fileset>
        </copy>


        <mkiisdir dirpath="build\aspprecompile" vdirname="aspprecompile" />
        <exec program="C:\WINDOWS\Microsoft.NET\Framework\${framework.version}\aspnet_compiler.exe" 
  useruntimeengine="true">
            <arg value="-p" />
            <arg value="build\aspprecompile" />
            <arg value="-v" />
            <arg value="aspprecompile" />
            <arg value="build\dist" />
        </exec>
        <deliisdir vdirname="aspprecompile" />        
    </target>


Whoa, there is a lot going on here so let's break it down piece by piece. We are making use of the 'depends' attribute to ensure that the asp.compile target cannot be run until all of the supporting libraries have been compiled:

                         target name="asp.compile" description="Compiles the webapp" depends="init, compile"

Don't worry about the deletes that are happening at the beginning of the target, they are just ensuring that cleanup happens from a prior build process. The first step to compiling the ASP application is copying all of the files that the ASP.Net precompiler will require for compilation into a transient build directory (I don't want to affect my main web project directory in any way whatsoever):

<copy todir="build\aspprecompile">
            <fileset basedir="src\app\DotNetRocks.Web.UI">
                <include name="*" />
                <include name="images\**\*.*" />
                <include name="javascript\**\*.js" />
            </fileset>
</copy>

I continue by copying all of the assemblies that the web project uses into an appropriate bin directory under the aspprecompile directory. Again, I am just pulling from the build directory any dll's that would have been created during the running of the compile target:

 <copy todir="build\aspprecompile\bin">
            <fileset basedir="build">
                <include name="*.dll" />
            </fileset>
 </copy>

If I were to stop the target there my build directory would look as follows:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/buildDirectory.jpg" rel="lightbox[buildProcessPart7]"><img alt="BuildDirectory" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/buildDirectory_thumb1.jpg" border="0" / /></a>

The aspprecompile directory would look like this:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/aspprecompileDirectory.jpg" rel="lightbox[buildProcessPart7]"><img alt="AspprecompileDirectory" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/aspprecompileDirectory_thumb.jpg" border="0" / /></a>


And the aspprecompiles bin directory would look like this:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/aspPrecompileBinDirectory.jpg" rel="lightbox[buildProcessPart7]"><img alt="AspPrecompileBinDirectory" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/aspPrecompileBinDirectory_small.jpg" border="0" / /></a>

You will see that I am copying pretty much all of the files from the DotNetRocks.Web.UI directory into this transient precompile directory. That's right every file, including code-behind files. Notice how at the beginning of the target I used the loadtasks task :

<loadtasks assembly="tools\nant\NAnt.Contrib.Tasks.dll" />


LoadTasks will load any custom NAnt tasks that are contained in the named assembly and make them available to you for use during the build process. The NAntContrib library, is an open source library that contains a plethora of tasks that you can make use of during your own build processes. The ones that I need specifically are the ones that let me manipulate IIS Virtual Directories. I create a new virtual directory called aspprecompile that will point to the build\aspprecompile directory:

 <mkiisdir dirpath="build\aspprecompile" vdirname="aspprecompile" />


All right the stage is set. The last time we compile a project we used the standard NAnt csc task that would compile a set of C# class files into a library. Even though there are cs files in the aspprecompile directory we cannot use the csc task to compile the web project. I need to take advantage of the ASP .Net precompiler to compile the web application for me. With .Net 2.0, you could actually deploy all of your *.cs files for the project into the web directory and the ASP.Net runtime would compile the cs files dynamically when the pages are requested. I am not a fan of this approach, I would rather just keep my source files out of the web directory completely. To allow you to do this, you have to take advantage of the ASP.Net precompiler. If you are not familiar with the ASP.Net precompiler you can read some more information about it [here](http://msdn2.microsoft.com/en-US/library/ms227972.aspx). I use the NAnt exec task to shell out to the asp.net precompiler to compile my site in place:

<exec program="C:\WINDOWS\Microsoft.NET\Framework\${framework.version}\aspnet_compiler.exe" 
  useruntimeengine="true">
            <arg value="-p" />
            <arg value="build\aspprecompile" />
            <arg value="-v" />
            <arg value="aspprecompile" />
            <arg value="build\dist" />
        </exec>

 Notice I am using a modified method to pass parameters to the aspnet_compiler executable. The full commandline would expand to this:

aspnet_compiler.exe -p 'build\aspprecompile' -v 'aspprecompile' 'build\dist'

The meaning of each of the arguments is a follows:
<ul>
<li><span><span>-p : <span id="ctl00_LibFrame_MainContent">Specifies the full network path or local disk path of the root directory that contains the application to be compiled. This option must be combined with the -v option.</span></span></span></li>
<li><span><span><span>-v : <span id="ctl00_LibFrame_MainContent">Specifies the virtual path of the application to be compiled</span></span></span></span></li>
<li><span><span><span><span>targetdir : This is not a named argument but if provided, specifies the directory to which the asp_compiler will place the final files for deployment</span></span></span></span></li></ul>

<span><span><span><span>After running the target the build\aspprecompile directory looks no different that the before the compilation happened, but notice that a new directory has been added to the build directory:</span></span></span></span>

<span><span><span><span></span></span></span></span><span><span><span><span><a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distDirectory.jpg" rel="lightbox[buildProcessPart7]"><img alt="DistDirectory" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distDirectory_thumb.jpg" border="0" / /></a></span></span>
<ul></span></span></ul>

 The following screenshots show the contents of this directory:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distDirectoryContents.jpg" rel="lightbox[buildProcessPart7]"><img alt="DistDirectoryContents" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distDirectoryContents_small.jpg" border="0" / /></a>   <a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distBinDirectoryContents.jpg" rel="lightbox[buildProcessPart7]"><img alt="DistBinDirectoryContents" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/distBinDirectoryContents_thumb3.jpg" border="0" / /></a>

Take a look at the interesting names that the aspnet_compiler generates for us!! Notice also, that although the aspprecompile directory contained a .cs file the the ViewCustomers.aspx page, the dist folder has no source files whatsoever!! The dist folder now contains everything that we would need to deploy to a production server. With the compilation safely taken care of I can go ahead and remove the temporary virtual directory I created for asp precompile purposes:

 <deliisdir vdirname="aspprecompile" />

Again, the deliisdir task lives is a task that is defined in the NAntContrib library.

To wrap it up, I can quickly add a target that will deploy the application to a local directory on my machine :

 

<target name="deploy" depends="asp.compile">
        <deliisdir vdirname="DotNetRocks" failonerror="false" />
        <delete>
            <fileset basedir="deploy">
                <include name="**/*" />                
            </fileset>
        </delete>
        <mkdir dir="deploy" />
        <copy todir="deploy">
            <fileset basedir="build\dist">
                <include name="**\*" />                
            </fileset>
        </copy>
        <copy file="config\Web.Config" tofile="deploy\Web.config" /> 
        <mkiisdir dirpath="deploy" vdirname="DotNetRocks" authntlm="true" defaultdoc="Default.aspx" />
    </target>  

 

I am not going to break this target down, as you have already seen all of the tasks that I am using. At the end of this target running I will be able to navigate to the ViewCustomers.aspx page by opening up my browser and typing in : http://localhost/DotNetRocks/ViewCustomers.aspx which brings me to:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/viewCustomers.jpg" rel="lightbox[buildProcessPart7]"><img alt="ViewCustomers" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart7/viewCustomers_thumb.jpg" border="0" / /></a>

 




