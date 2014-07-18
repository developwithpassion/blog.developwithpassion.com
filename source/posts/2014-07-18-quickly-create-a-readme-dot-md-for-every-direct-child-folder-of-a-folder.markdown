---
layout: post
title: "Quickly Create A Readme.md for every direct child folder of a folder"
date: 2014-07-18 10:20
comments: true
published: true
categories: [unix]
---
Currently working on a project that is maintaining a lot of its own tiny node packages. Since we are still in dev, we are managing them currently directly with the main project and are placing them at the root of the repo in a folder called custom_node_modules.

Currently a directory listing of the folder looks something like this:

{% codeblock lang:bash Custom Node Modules Folder %}
Gruntfile.js
containers
core_utils
custom_node_modules.js
defining_classes
delegation
expect
extensions
fakes
jspec
jspec_helper.js
jspecs
key_generator
load_order.js
load_path
logging
matching
namespace
node_bootstrap
node_modules
package.json
package.json.mustache
resolution_root
{% endcodeblock %}

As you can see, there are a mix of files, folders, and the like. Each folder under this folder is its own node package with its own package json, etc.

Got tired of seeing the no README warnings during our vagrant provision process. Broke out the following bash script to generate a readme.md at the root of each modules folder that just contained the name of the module:

{% codeblock lang:bash %}
for module in $(find . -type dir -depth 1 | sed "s/\.\///"); 
do
  pushd $module
  echo \#$module > README.md
  popd
done
{% endcodeblock %}

First I am finding all of the direct subfolders of the folder that I am in, then I am removing the leading "./" from the output. The folder also contains other files so I can't just do an ls. This now gives me the folder name for each custom node module. Then its a simple matter of:

* Switch into the folder
* Create a README.md file that contains the #title element with the name of the module
* Switch bach to the main folder

This creates a README.md inside each of the custom node module folders, with the markdown that just has the name of the module.

[Develop With Passion®](http://www.developwithpassion.com)

