---
layout: post
title: "Automating Your Builds With NAnt - Part 8 (Enter CruiseControl)"
comments: true
date: 2006-06-08 09:00
categories:
- agile
- screencasts
- tools
---

[Last time](http://blog.developwithpassion.com/AutomatingYourBuildsWithNAntPart7.aspx) we left off adding in the compilation of the web project to our build process. If you remember back to when we introduced the database we brought in the concept of template files and replacement tokens that could be used to allow for multiple developers on a project with disparate machine configurations to build using the same build file without any changes required. What we want to do now is go the final step and take our standalone build file that is currently being used by individual developers (whether or not they are on a team), and use it to centralize the build process. We are going to set up an environment that a multi developer team can use to introduce a CI process into their environment. CI (for those of you that don't know) stands for Continuous Integration. Let me stress something very important here. <strong>CI is a process, not a tool.  </strong>If you want to read a concise definition of CI, check out [Martin Fowlers article on the subject](http://www.martinfowler.com/articles/continuousIntegration.html). That being said, there are a lot of tools that can aid you in introducing CI into your developer environment. We have already been taking advantage of a couple of these tools:
<ul>
<li>NAnt</li>
<li>NUnit</li></ul>

The new tool that we are going to introduce today is CruiseControl.Net. CC.Net is basically an automated build server. You would typically set it up so that at regular intervals it would poll the source code repository and see if there are any changes, if there are it would:
<ul>
<li>Update it's local copy of the source code from the latest version in the repository.</li>
<li>Perform a build against it's local code base</li>
<li>Run all unit tests, acceptance tests etc</li>
<li>Generate status reports on the health of the build</li></ul>

Obviously, this is a very high level description of some of the things CC .Net can do. 

This blog post could turn out to be huge, so to save my wrists I am going to try something a little bit different. I am posting a screencast that demonstrates the entire process required to:
<ul>
<li>Place a project under source control using Subversion</li>
<li>Installing CC.Net</li>
<li>Configuring CC.Net to build a project.</li></ul>

The video is available [here]({{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart8/AutomatingBuildPart8.html). Enjoy. (warning - it is close to 1hr, commercial free!!) 






