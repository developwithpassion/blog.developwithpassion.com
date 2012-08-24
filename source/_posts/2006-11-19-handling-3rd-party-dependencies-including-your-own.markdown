---
layout: post
title: "Handling 3rd Party Dependencies (Including your own)"
comments: true
date: 2006-11-19 09:00
categories:
- continuous integration
---

I received the following question a couple of days ago:

<font color="#0000ff">What do you suggest when having a (in house) library 
being used by several independent projects?</font>

In practice the simplest solution to this problem, and also (by coincidence) 
the one that causes the least headaches is to treat those "libraries" as just 
that, "libraries". It can be too tempting to come up with fancy solutions that 
brings in the source code of these "shared" projects into your solutions so that 
you can edit the library code on the fly when needed. This ,however, can open up 
a maintenance nightmare, as a change that is required for one dependent project 
may inadvertently cause a bug or disable functionality in another dependent 
project. 

To save myself the pain of dealing with these shared projects, I treat them 
like I would any third party library. I take the dll's and place them in a 
subfolder of the lib folder of my project. The lib folder is where I place any 
3rd party assemblies that I happen to be using on a project. Here is an example 
for a project I recently completed: 


<img src="{{ site.cdn_root }}binary/handling3rdPartyDependencies/libFolder.jpg"> 


 

Inside each of these respective subfolders is all of the dll's required for 
that third party dependency. All I would have to do is create a new subfolder 
named using the in house library I want to consume, and I would drop the latest 
current version of that assembly into the folder under the lib directory.

As I am developing my dependent app against this library, I am shielded from 
any changes that may be going on with the "shared" project, as I am just making 
references to the dll that lives in my lib folder. If a feature gets added into 
the shared library that I would like to consume in my dependent project, I could 
follow these steps:
<ul><li>Rename the existing library in my lib folder to something like : 
$LIBNAME$.bak 
</li><li>Drop in the new assembly into the lib folder 
</li><li>Run any unit/integration tests to ensure that the new assembly does not 
break any existing functionality in your dependent app. If it does, and you 
require the new feature, you will will obviously have to fix the dependent app. 
</li><li>Delete the old version of the assembly as it no longer needs to be in the 
lib folder</li></ul>

As you can see, extremely simple. This has worked for me on small, and very 
large projects. Hopefully you can take this idea and use it to fit your shared 
library dependency issues.




