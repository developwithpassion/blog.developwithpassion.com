---
layout: post
title: "Automating Your Builds With NAnt - Part 4"
comments: true
date: 2006-04-11 09:00
categories:
- .net 2.0
- c sharp
- tools
---

In the last <a title="Part 3" href="http://blog.developwithpassion.com/PermaLink,guid,f209dcb5-f005-4f70-90bb-6465f3d7f85c.aspx">post</a> I talked about compiling the main supporting assemblies for the web/win project. Let’s shift focus now to talk about building the associated unit tests for the application. The solution I was working with <a href="{{ site.cdn_root }}binary/buildProcessPart4/solutionStructure.jpg" rel="lightbox[buildProcessPart4]"><img alt="SolutionStructure" src="{{ site.cdn_root }}binary/buildProcessPart4/solutionStructure_small.jpg" align="left" border="0"></a>actually had a 1–1 (almost) correspondence of Test projects per deployable projects. In my opinion, this structure is a lot better than placing the tests in the same project that you are testing as it makes separating the files from test/deployment builds a lot simpler, as you don’t need to worry about naming your files in a special way to exclude them from the build process. I have already successfully compiled each of the assemblies that needs to be tested, using NAnt I compiled all of the source from the 8 projects into a single assembly.

Before I can run my tests (in an automated fashion from the command line), they need to be compiled. It stands to reason that the NAnt xml required to accomplish this task is very similar to compiling the non-test projects:

<target name="test.compile">
        <csc target="library" output="build\${nant.project.name}.Test.dll" debug="${debug}">
            <sources>
                <include name="src\test\**\*.cs" />
                <exclude name="src\test\**\AssemblyInfo.cs" />
            </sources>                                                                            
                                                             </csc>
                                                     </target>

Everything looks good, right? I should be able to switch to the command line and run the “build test.compile” command. If I do that right now I will run into a few problems. I won’t even show you the screenshot for what the errors look like, as it will take up too much space. The long and short of it is that I cannot compile the test project without preserving references that are essential to allow the dll to be built. Wait, why was this not an issue for the last time I compiled? This was because the only things the other dll depended on were System assemblies that are automatically resolved by NAnt. The fact that all of the code from the 8 projects was being compiled into a single assembly eliminated the need to duplicate project level references. Unfortunately, as picture 2 shows, most (if not all) of the test projects <a href="{{ site.cdn_root }}binary/buildProcessPart4/references.jpg" rel="lightbox[buildProcessPart4]"><img alt="References" src="{{ site.cdn_root }}binary/buildProcessPart4/references_small.jpg" align="right" border="0"></a>need to have a reference to the actual projects that they are testing as well as 2 third party utilities (NMock and NUnit).

Of course, I took care to ensure that when I created these references in Visual Studio that I pointed to the correct location of the tools within my tools folder (for NUnit and NMock2 that is). As far as the project references, all I had to do was add a standard project reference. Unfortunately, when I am in NAnt it knows nothing about these things. I have to set it up manually. Let’s make a small change to the test.compile target to compensate for this:

<target name="test.compile" <strong>depends=”compile”</strong>>
        <csc target="library" output="build\${nant.project.name}.Test.dll" debug="${debug}">
            <sources>
                <include name="src\test\**\*.cs" />
                <exclude name="src\test\**\AssemblyInfo.cs" />
            </sources>                                                                            
        </csc>
 </target>

Remember, the “depends” attribute for a target ensures that any targets listed for the value of that attribute have to run before this target can run. I am ensuring that the code to be tested has been compiled before I can compile the tests. Of course, I am still going to get compilation errors if I try to compile, as I have still not taken care of the references needed to build the test library. I’ll take care of NUnit and NMock2 first by making use of the <strong>references </strong>element:

<target name="test.compile" <strong>depends=”compile”</strong>>
        <csc target="library" output="build\${nant.project.name}.Test.dll" debug="${debug}">
            <sources>
                <include name="src\test\**\*.cs" />
                <exclude name="src\test\**\AssemblyInfo.cs" />
            </sources>

            <strong><references>
                <include name="tools\nunit\bin\nunit.framework.dll" />
                <include name="tools\nmock\NMock2.dll" />                                
            </references></strong>                                                                        
        </csc>
 </target>

 

The references element is used by the csc task, to tell the compiler where to look for references required to build the project. As mentioned before, I don’t need to worry about framework libraries as NAnt resolves those for me. Again, note how referencing “references” becomes simpler when everything you need is located within your checkout directory!! Ok, I’m one step closer, but I still cant<img alt="CompileError" src="{{ site.cdn_root }}binary/buildProcessPart4/compileError_small.jpg" align="right" border="0"><a href="{{ site.cdn_root }}binary/buildProcessPart4/compileError.jpg" rel="lightbox[buildProcessPart4]"></a> compile as it still cannot see classes that live in the assembly that should be being tested. As you have probably already guessed, I can fix this quickly by just adding another reference. But wait, what do I reference? Now you will see the important of having the “build” staging area, if you remember the compile target :

<target name="compile" 
            depends="init"
            description="compiles the application">
        <csc target="library" <strong>output="build\${nant.project.name}.dll"</strong> debug="${debug}">
          <sources>
            <include name="src\app\**\*.cs" />
            <exclude name="src\app\DotNetRocks.Web.UI\*.*" />
            <exclude name="src\app\**\AssemblyInfo.cs" />                                
         </sources>                        
        </csc>

</target>

I already know where the dll that I need to reference is going to get placed, so I can just add a reference to it!!:

<target name="test.compile" depends="compile">
        <csc target="library" output="build\${nant.project.name}.Test.dll" debug="${debug}">
            <sources>
                <include name="src\test\**\*.cs" />
                <exclude name="src\test\**\AssemblyInfo.cs" />
            </sources>            
            <references>
                <strong><include name="build\${nant.project.name}.dll" />
</strong>                <include name="tools\nunit\bin\nunit.framework.dll" />
                <include name="tools\nmock\NMock2.dll" />                                
            </references>
        </csc>
    </target>

With that change in place, I can now run the test.compile target, which will result in a new dll being placed in the build directory!! Next up, I’ll talk about running the tests in an automated setup, that will prepare us for when we start talking about CC.Net integration!!

<img alt="TestCompile" src="{{ site.cdn_root }}binary/buildProcessPart4/testCompile_small.jpg" align="texttop" border="0"><a href="{{ site.cdn_root }}binary/buildProcessPart4/testCompile.jpg" rel="lightbox[buildProcessPart4]"></a>







