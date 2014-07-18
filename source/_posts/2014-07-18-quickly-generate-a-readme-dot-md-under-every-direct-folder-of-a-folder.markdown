---
layout: post
title: "Quickly generate a README under every direct folder of a folder"
date: 2014-07-18 10:54
comments: true
published: true
categories: [unix]
---
Quickly needed to generate a README.md under every folder of a folder that contains custom node packages

The output of the following command:

{% codeblock lang:bash find %}
find . -type dir -depth 1
{% endcodeblock %}

gives me this:

{% codeblock lang: Custom Node Modules %}
./containers
./core_utils
./defining_classes
./delegation
./expect
./extensions
./fakes
./jspecs
./key_generator
./load_path
./logging
./matching
./namespace
./node_bootstrap
./resolution_root
{% endcodeblock %}. 

I was getting tired of seeing missing readme warning when vagrant provisioning, so I wrote the following:

{% codeblock lang:bash Generate Readme %}
for module in $(find . -type dir -depth 1 | sed "s/\.\///");
do
  pushd $module
  echo \#$module > README.md
  popd
done
{% endcodeblock %}

I used sed to get rid of the the leading ./ so I can use the output for the title in the readme file.

That quickly generates a file called readme.md under each custom node package that is being maintained in the folder that I am in.

It's good to break out the shell scripting foo every now and then!!

[Develop With Passion®](http://www.developwithpassion.com)
