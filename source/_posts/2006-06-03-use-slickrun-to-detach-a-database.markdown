---
layout: post
title: "Use SlickRun To Detach a Database"
comments: true
date: 2006-06-03 09:00
categories:
- tools
---

If you are a command line junkie like me, I strongly suggest you check out [Bayden Systems SlickRun](http://www.bayden.com/SlickRun/). It is a wicked floating command prompt that you can customise with things called MagicWords that allow you to open programs/perform tasks by simply typing in the magic word. I thought I would give a simple example of how to go about detaching a database using SlickRun. If I go to the setup for SlickRun and hit ALT-N (new magicword) I will be prompted with the new magic word dialog:

<a href="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/NewMagicWord.jpg" rel="lightbox[useSlickRunToDetachADatabase]"><img alt="NewMagicWord" src="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/NewMagicWord_thumb.jpg" border="0" /></a>

The following screenshot shows the settings that I require to detach a db from the slickrun prompt:

<a href="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/DetachDB.jpg" rel="lightbox[useSlickRunToDetachADatabase]"><img alt="DetachDB" src="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/DetachDB_thumb.jpg" border="0" /></a>

Notice that I am making use of the osql.exe (the command line utility for SQL Server). I am also making use of the parameters field to specify which parameters to send to the OSQL.exe program. I am using the -E argument to specify integrated windows authentication, and the -Q option to specify that I just want to execute a query from the command line. The query I want to execute is the sp_detach_db stored procedure, which requires the name of the database that I want to detach. I want to be able to use this MagicWord to detach any database, I do that by using the $I$ parameter. This is a placeholder for a user provided value. If I save this magicword,bring up SlickRun and type in the word detachdb I will be prompted with a dialog:

<a href="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/Parameter.jpg" rel="lightbox[useSlickRunToDetachADatabase]"><img alt="Parameter" src="{{ site.cdn_root }}binary/useSlickRunToDetachADatabase/Parameter.jpg" border="0" /></a>

If I enter in the name of the database I want to detach and hit the enter button, a command prompt will flash, detach the db and the command prompt will disappear.

 

You can use the same technique to write other magicwords that can save you a ton of mousing/keyboard time!!

 




