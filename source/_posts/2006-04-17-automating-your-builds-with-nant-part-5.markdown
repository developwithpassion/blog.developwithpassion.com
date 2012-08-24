---
layout: post
title: "Automating Your Builds With NAnt - Part 5"
comments: true
date: 2006-04-17 09:00
categories:
- tools
---

[I left off](http://blog.developwithpassion.com/AutomatingYourBuildsWithNAntPart4.aspx) talking about building and compiling the NUnit tests for the application. Of course, what good are tests if you can’t run them and see results! Time to shift our attention toward running the tests in an automated fashion so that we can get feedback on the health of the application. All of the tests that are currently in the application were written with the aid of the great [NUnit](http://www.nunit.org/) testing framework. Typically I utilize the NAnt [exec](http://nant.sourceforge.net/release/latest/help/tasks/exec.html) task to shell out to the NUnit console application to run all of the tests defined in an assembly. I prefer this to the actual [nunit](http://nant.sourceforge.net/release/latest/help/tasks/nunit.html) task and its variants as my build file is not affected in any way when I upgrade to a newer version of NUnit. Last time we left off with 2 compiled assemblies in the build directory. One assembly for the code to be tested, and one assembly for the tests themselves.

<a href="{{ site.cdn_root }}binary/buildProcessPart5/buildDirectoryPreTest.jpg" rel="lightbox[buildProcessPart5]"><img alt="BuildDirectoryPreTest" src="{{ site.cdn_root }}binary/buildProcessPart5/buildDirectoryPreTest_thumb.jpg" align="right" border="0"></a> It’s time to add a new target to the build file that will allow for execution of the tests:

<strong><target name="test" depends=”test.compile”>
</target></strong>

Notice that by again taking advantage of the “depends” attribute, we can ensure that the tests have been compiled prior to test execution.The first thing you need to see is if there are any objects that you are going to be testing that require a dependency on a .config file. If they do then you first need to copy the web/app.config into a file that NUnit can work with. It is always the same file name format <strong>“[ProjectName].Test.[OutputExtension].Config”</strong>. In our scenario, because the project name is DotNetRocks, the config file would get copied to the file :

DotNetRocks.Test.dll.config

To keep everything in one place (highly recommended) I am going to copy the config file (using the new name) to the build directory. To accomplish this I can make use of the [copy ](http://nant.sourceforge.net/release/latest/help/tasks/copy.html)task.

<target name="test" depends=”test.compile”>
    <strong><copy file="config\Web.Config" tofile="build\${nant.project.name}.Test.dll.config" /></strong>

</target>


Of course, you would change the location as necessary to pull the Web.Config file from wherever it may reside in your directory structure (typically with the web/win project itself). With the config file taken care of, I now need to copy to the build directory any libraries that will need to be in the build directory for the tests to work. In this particular scenario I need to copy the NUnit and NMock2 libraries into the build directory. Once again, I can take advantage of the copy task to accomplish this:

<target name="test" depends=”test.compile”>
       <copy file="config\Web.Config" tofile="build\${nant.project.name}.Test.dll.config" />
        <strong><copy todir="build" flatten="true">
            <fileset basedir="tools">
                <include name="**\NMock2.dll" />
            </fileset>
        </copy>
         <copy todir="build" flatten="true">
            <fileset basedir="tools\nunit\bin">
                <include name="*.dll" />
            </fileset>
        </copy></strong>               
    </target>

As you can see, because the tests make use of both the NUnit and NMock2 frameworks, I need to copy all of the relevant dll’s from those frameworks into the build directory before the tests can run. NUnit is an interesting one, because sometimes you can get away (by sheer fluke) with this step and NAnt will fallback to using the NUnit version that is installed in the GAC (if you installed NUnit on your machine). This is problematic though. If you upgrade the version of NUnit in your tools directory and build your tests against that version of NUnit, you will only be able to run the tests using the GAC version if it matches the one in your tool directory. If the versions are different, you will get an error when you try to run your test. Again, getting back to the principle of  “<strong>keeping everything you need to run the project in one place”</strong> it is best to avoid reliance on the GAC for NUnit and the like. This is why all of the necessary dlls from both frameworks are being copied into build directory. If I were to stop there, the build directory would look like this after running the test target:

<a href="{{ site.cdn_root }}binary/buildProcessPart5/buildDirectoryPreTest2.jpg" rel="lightbox[buildProcessPart5]"><img alt="BuildDirectoryPreTest2" src="{{ site.cdn_root }}binary/buildProcessPart5/buildDirectoryPreTest2_thumb.jpg" border="0"></a>

As you can see all of the files we actually are responsible for generating/maintaining are at the top of the directory (notice the config file with the correct NUnit naming convention), all of the other 22 dlls (that list could be streamlined by changing the filter for the fileset) are purely there for running the tests. 

With the supporting files all in place it is time to run the tests. To accomplish this, it is time to use a new task. The <strong>[exec ](http://nant.sourceforge.net/release/latest/help/tasks/exec.html)</strong>task. Again, I am not going to go into all of the details, attributes etc for the exec task, as the NAnt docs do a good job of that. I’m going to focus on using it to run NUnit. I’ll need to update my test target:

<target name="test" depends="test.compile">
  <copy file="config\Web.Config" tofile="build\${nant.project.name}.Test.dll.config" />        
        
        <copy todir="build" flatten="true">
            <fileset basedir="tools">
                <include name="**\NMock2.dll" />
            </fileset>
        </copy>
        
        <copy todir="build" flatten="true">
            <fileset basedir="tools\nunit\bin">
                <include name="*.dll" />
            </fileset>
        </copy>
                                       
        <strong><exec basedir="tools\nunit\bin"
              useruntimeengine="true"
              workingdir="build"
              program="nunit-console.exe"
              commandline="${nant.project.name}.Test.dll /xml=${nant.project.name}.Test-Result.xml" /></strong>            
        
    </target>

Pay attention to 2 of the key attributes : basedir and workingdir. basedir is the directory that the program I want to [execute ](%3Ca%20href=" exec.html="" tasks="" help="" latest="" release="" nant.sourceforge.net="" http=") is in. workingdir is the directory in which the program will execute (hence the need to copy all required dlls,config files etc to the build directory). The program attribute is self explanatory, and finally the commandline attribute is the argument string to invoke the program with. Notice I am telling nunit to execute against the test library I have place in the build directory (DotNetRocks.Test.dll), and I want the results of the tests to be placed in a file named DotNetRocks.Test-Result.xml (this file will be placed in the build directory). If I run my test target now I will get the high level results output to the console, <a href="{{ site.cdn_root }}binary/buildprocesspart5/consoleoutput.jpg" rel="lightbox[buildprocesspart5]"><img alt="consoleoutput" src="{{ site.cdn_root }}binary/buildprocesspart5/consoleoutput_thumb.jpg" align="left" border="0"></a>as well as a xml file containing detailed tests results placed in the build directory<a href="{{ site.cdn_root }}binary/buildprocesspart5/testresults.jpg" rel="lightbox[buildprocesspart5]"><img alt="testresults" src="{{ site.cdn_root }}binary/buildprocesspart5/testresults_small.jpg" align="right" border="0"></a>. As a quick heads up for things to come, I will talk about how you can integrate the results that are spit out by the NUnit console into a continuous build engine (CC.Net), for analyzation and integration of the results into the build process.

 

Hopefully this will get you started on the way to integrating automated tests into your build infrastructure. Next up, let’s bring the DB into the picture!















