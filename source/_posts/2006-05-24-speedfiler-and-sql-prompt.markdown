---
layout: post
title: "SpeedFiler and Sql Prompt"
comments: true
date: 2006-05-24 09:00
categories:
- tools
---

I have been using [SpeedFiler](http://www.claritude.com/product.htm) for the last couple of weeks and love the productivity it has provided with regards to managing my email. After reading the [Igloo Coder](http://igloocoder.com/default.aspx) mentioning [SQL Prompt](http://www.red-gate.com/products/sql_prompt/), I thought I would download it and give it a whirl. I won't say no to intellisense for SQL!! It was shortly after this that I started noticing issues with SpeedFiler. I would go to file an item using the CTRL-SHIFT-V shortcut and the standard outlook Move-To dialog would pop up. The same applied for SpeedFilers 'Go To Folder' command. I could however, successfully invoke these commands if I explicitly used the SpeedFiler menu items that activated the custom dialogs. I was emailing back and forth with the [founder](http://itzy.wordpress.com/) of SpeedFiler (that's right, he truly stands behind his product) for a little while and he was offering lots of good tips to ensure that I was not messing anything up. It never even dawned on me that SQL Prompt could be the problem. Until, 20 minutes ago I realized that the only thing that differed between my machine configuration of today to yesterday was the installation of SQL Prompt. I fired up the options dialog of SQL Prompt :

<img alt="SqlPromptOptionsWindow" src="{{ site.cdn_root }}binary/speedFilerAndSqlPrompt/SqlPromptOptionsWindow.jpg" border="0" />

By default, SQL Prompt runs 'Enabled' in the tray. When I changed the status to 'Off', bang, speedfiler worked again like a charm. I mailed [Itzy](http://itzy.wordpress.com/) and let him know that this may be an issue to look into. But for now, I'll know to turn SQL Prompt off, when I'm not doing any DB work.




