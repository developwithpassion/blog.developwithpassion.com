---
layout: post
title: "Automating Your Builds With NAnt - Part 6"
comments: true
date: 2006-05-04 09:00
categories:
- .net 2.0
- c sharp
- tools
---

Ok, it's been a few weeks since my last [post](http://blog.developwithpassion.com/AutomatingYourBuildsWithNAntPart5.aspx) on automating your build with NAnt. We left off being able to compile and run all of the unit tests for the code. This is an essential step to be able to perform quickly. When solution sizes get bigger and the codebase gets larger, you will be glad that you spent the time automating the build process. There is a large difference between the time required to perform build activities at the command line using NAnt vs Studio. So far, we have not even talked about the database. As most of us are building applications with some sort of database back-end, it is essential that we can also automate the steps necessary to prep the database for use in our builds. Remember back to folder structure for our root directory?

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/folderStructure1.jpg" rel="lightbox[buildProcessPart6]"><img alt="folderstructure1" src="{{ site.cdn_root }}binary/automatingyourbuildswithnantpart6/folderstructure1_thumb.jpg" align="right" border="0"></a>

It is now time to shift our attention to the “sql” directory. In this post, I am making the assumption that the schema you will be creating will be your own (ie. You are not needing to deal with 3rd party databases that you need to integrate with. That is a story for another day). Let’s take a quick look at the contents of the sql directory. Here are the files that I have set up so far:
<ul>
<li>data.sql.template – File containing any seed data that is required to actually run the application.</li>
<li>nwind.sql.template – File containing the sql necessary to recreate the database,tables,indexes etc</li>
<li>security.sql.template – File containing the sql necessary to add roles,grant roles, add users etc to the database</li>
<li>storedProcedures.sql.template - File containing the CRUD procedures for data access</li>
<li>views.sql.template – File containing any views required by the application</li></ul>

As you can see. This list is pretty short, and you could add files for different responsibilities very easily.

You are probably asking yourself what the .template extension is for? Take a look at the first couple of lines in the nwind.sql.template file (pay attention to the items that have the red boxes around them):

<a href="{{ site.cdn_root }}binary/automatingyourbuildswithnantpart6/startofsqlscript.jpg" rel="lightbox[buildProcessPart6]"></a><img alt="StartOfSqlScript" src="{{ site.cdn_root }}binary/automatingyourbuildswithnantpart6/startOfSqlScript_thumb.jpg" align="left" border="0"> All of the items that are surrounded by the @ symbol will actually get replaced at build time by values that NAnt retrieves from a local settings file for the user. This is what will allow multiple developers on the team to build the database to whatever location they want on their own hard drives, as well as naming the catalog for the database whatever they want. This allows for a lot of flexibility when it comes to how individual developers configure their workstations and dev environments. With this (and the other sql files in place), I need to add a target(s) to actually build the database using NAnt.

The first thing I am going to do is add a couple of new properties to the top of the build file:

    <!-- environment-specific properties -->    
    <property name="osql.exe" value="C:\program files\microsoft sql server\90\Tools\Binn\osql.exe" />
    <property name="osql.ConnectionString" value="-E" />    
    <property name="env.COMPUTERNAME" value="${environment::get-variable('COMPUTERNAME')}" />
    <property name="aspnet.account" value="${env.COMPUTERNAME}\ASPNET" />    
    <property name="framework.version" value="v2.0.50727" />    

Notice that I have specified values for the location of osql and the connection string with which to connect to OSQL. Now of course, I can’t assume that everyone on my team has loaded SQL to the default location. In which case, their path to SQL will be different. I also can’t assume that all of the developers on my team have integrated windows authentication enabled on their sql server install. If they don’t the -E switch for OSQL won’t work. Let me stress a point I am about to make “<strong>All Developers On A Team Regardless of machine configuration, should be able to utilise the build file without changing it”. </strong>Now as you can see, if I relied solely on the properties that I have created in the buildfile, I would be constraining the machine configurations of my team to have to use the exact same settings. This is where local property files come into play. Notice in the root directory I have a file named local.properties.xml.template. <a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/localPropertiesXmlTemplate.jpg" rel="lightbox[buildProcessPart6]"><img alt="LocalPropertiesXmlTemplate" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6//localPropertiesXmlTemplate_small1.jpg" align="right" border="0"></a>

The local.properties.xml.template file contains all of the properties that could possibly differ on each individual developers workstation. The template file is actually a repository artifact. So when a new setting gets introduced that could potentially be different of each persons machine, it is added to the template file. Take a look at the contents of the template file:

<?xml version="1.0"?>
<properties>
  <property name="sqlToolsFolder" value="C:\Program Files\Microsoft SQL Server\90\Tools\Binn"/>
  <property name="osql.ConnectionString" value="-E"/>
  <property name="initial.catalog" value="Northwind"/>
  <property name="config.ConnectionString" value="data source=(local);Integrated Security=SSPI;Initial Catalog=${initial.catalog}"/> 
  <property name="database.path" value="C:\root\development\databases" />
  <property name="osql.exe"  value="${sqlToolsFolder}\osql.exe" />
</properties>

Notice that it is a well formed xml document. You should also notice that the names of some of the properties are named identically to the names of properties that already exist in the build file (osql.ConnectionString, osql.exe). When a developer performs a fresh check out or the template file is changed, they will copy the template file into the same directory as the template file and rename it to local.properties.xml. Once renamed, the developer will open up the local.properties.xml file (not under source code control), and change the value of any of the properties that they need to, to reflect the configuration of their own machines. Ok, so this is great, but how do the settings in this file make integrate themselves into the actual build file? If I switch back to my build file, I will now add a check to include the settings from the local.properties.xml file, if the file is present:

<!-- environment-specific properties -->    
    <property name="osql.exe" value="C:\program files\microsoft sql server\90\Tools\Binn\osql.exe" />
    <property name="osql.ConnectionString" value="-E" />    
    <property name="env.COMPUTERNAME" value="${environment::get-variable('COMPUTERNAME')}" />
    <property name="aspnet.account" value="${env.COMPUTERNAME}\ASPNET" />    
    <property name="framework.version" value="v2.0.50727" />    
            
<font color="#ffff00"> </font><font color="#0000ff">   <if test="${file::exists('local.properties.xml')}">
        <echo message="Loading local.properties.xml" />
        <include buildfile="local.properties.xml" />
    </if>
</font>

Notice I am telling NAnt to include an external file into the buid file. If the developer has created and modified their local.properties.xml file, then all of the settings they specified in that file will overwrite the default values of the properties that were already in the build file. Voila, multi-dev setup taken care of. 

Now it is time to focus on performing activities with the database. The first thing we need to take care of is changing the template files in the sql directory into the appropriate .sql files. Remember, as I said before. The .template files are the files that actually get placed/versioned in the repository. The .sql files will get automatically created by NAnt but not get stored in the repository. Let’s add a new target that will be able to convert a .template file into a file that can actually get worked with.

<font color="#0000ff"><target name="convert.template">
        <copy file="${target}.template" tofile="${target}" overwrite="true">
            <filterchain>
                <replacetokens>
                    <token key="INITIAL_CATALOG" value="${initial.catalog}" />                    
                    <token key="ASPNETACCOUNT" value="${aspnet.account}" />
                    <token key="OSQL_CONNECTION_STRING" value="${osql.ConnectionString}" />
                    <token key="CONFIG_CONNECTION_STRING" value="${config.ConnectionString}" />                    
                    <token key="DBPATH" value="${database.path}"/>
                </replacetokens>
            </filterchain>
        </copy>
    </target></font>

The convert.template target will copy a file with the .template extension to a file without the .template extension. At the same time, I am taking advantage of NAnt ability to apply filters during the copy process. In this scenario I am using the replacetokens filter to replace any occurrence of a token in the file (tokens in NAnt are specified by surrounding the item with the @ symbol), with a specific value. If you look back to the [beginning of the nwind.sql.template file ]({{ site.cdn_root }}binary/automatingyourbuildswithnantpart6/startofsqlscript.jpg" rel="lightbox[buildProcessPart6]) you will see that there are several tokens that will be replaced with settings pulled from my local settings file:
<ul>
<li>All instances of @INITIAL_CATALOG@ will be replaced by the value of the initial.catalog property (“Northwind”)</li>
<li>All instances of @DBPATH@ will be replaced by the value of the database.path property (“C:\root\development\databases”)</li></ul>

Some of the other files in the sql directory make use of some of the other tokens. Some of the tokens do not exist in any of the sql files, but exist in other template files that I will talk about in future posts. With the “convert.template” target in place. I now want to create a target that I can use to execute a sql script:

 <font color="#0000ff"><target name="exec.sql.template">
        <call target="convert.template" />
        <exec program="${osql.exe}" commandline="${osql.ConnectionString} -n -b -i ${target}" />
 </target></font>

Notice that the exec.sql.template is taking advantage of the fact that each developer could have a different location and connection specifics for osql. For the astute reader, you will note that if you were to just call exec.sql.template on its own, nothing would happen as the convert.template target assumes that a ${target} property has been set up before being invoked. You will notice that the exec.sql.template does not provide a value for the ${target} property, it is also attempting to make use of a ${target} property that should have already been assigned. For this reason, the exec.sql.template target is meant to be called from a target that will actually execute the scripts for db creation in the correct order. And here it is:

<font color="#0000ff"><target name="builddb">
        <property name="target" value="sql\nwind.sql" />
        <call target="exec.sql.template" />
    
        <property name="target" value="sql\views.sql" />
         <call target="exec.sql.template" /></font>

<font color="#0000ff">         <property name="target" value="sql\storedProcedures.sql" />
         <call target="exec.sql.template" />
                
         <property name="target" value="sql\security.sql" />
         <call target="exec.sql.template" />
</target></font>

Notice that the builddb target knows the correct order in which to execute the sql scripts. Also notice the use of the call task that can be used to invoke targets from other targets. You will see that before the execution of the exec.sql.template target, the builddb target will set the value for the ${target} property for the file to act against next. Remember, first time builddb is run there will be no .sql files in the sql directory only .sql.template files. The convert.template target knows to tack on the .template extension and copy/transform accordingly. 

After running the builddb target, the database will be completely rebuilt from scratch (it will be deleted if it exists already). Again, something that I haven't talked about is the usefulness of keeping all of the db in .sql files. They are easy to maintain in the repository. When another developer on your team adds a table,view etc (making sure that they make changes to the .template files not the .sql files). You just need to update your sql directory and run your builddb target again. If 2 or more of you have made changes to the same table, worst case scenario you will need to use your merge/diff tool to see the differences. Best case scenario, your files will merge together seamlessly with all of your combined changes. Once the application has been deployed to production you can create subdirectories under the sql directory corresponding to each release/db update. These folder would only contain alters/new table additions. Once you have deployed to production you will want to leave the existing scripts under the sql directory as is. That way when you do a builddb, your database will get deleted created from the original sql scripts, and then all of the alters that have been applied in production will be applied against your local database. This is a much better process that changing the original sql files, as your DB’s probably don’t have the luxury of tearing down/recreating the database whenever a change goes into place. It also makes providing sql for the DB’s easy as you can just send them the alter file that you will also have in your repository. Of course, I can post about strategies for maintaining DB’s for deployed apps another time. After the builddb target runs, the sql directory will now look like this:

<a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/sqlDirectoryAfterBuildDb.jpg" rel="lightbox[buildProcessPart6]"><img alt="SqlDirectoryAfterBuildDb" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/sqlDirectoryAfterBuildDb_small1.jpg" align="left" border="0"></a>

 

 

 

 

 

 

 

 

 

As you can see, NAnt took care of copying the files and renaming them as necessary. If you take a look at the first couple of lines in the nwind.sql file (pay attention to the items in the red boxes) <a href=""><img alt="StartOfSqlScriptAfterTransform" src="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/startOfSqlScriptAfterTransform_thumb.jpg" align="left" border="0"></a><a href="{{ site.cdn_root }}binary/automatingYourBuildsWithNAntPart6/startOfSqlScriptAfterTransform.jpg" rel="lightbox[buildProcessPart6]"></a>.

 

 

 

 

 

 

 

 

 

 

 

 

 

You will notice that what use to be tokens are now concrete settings specific to my machine!! Feel free to ask questions, provide feedback etc. Enjoy automation.

 

 





