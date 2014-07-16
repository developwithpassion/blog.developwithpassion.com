---
layout: post
title: "SSL - Generating an unencrypted key and csr for a cert request"
date: 2014-07-16 11:02
comments: true
categories: [ssl]
---
Had to generate a new ssh key and cert request the other day for a dreamhost server. Accidentally made the mistake of putting a passphrase on the key, so my first request came back no good.

Here is the script that I used to generate a new private key and csr request to submit to the certificate authority:

{% codeblock lang:bash %}
openssl req -nodes --newkey rsa:2048 --keyout new_key.key -out new_csr.csr
{% endcodeblock %}

The -nodes argument is what ensures that the new private key will remain unencrypted, which is essential if you are installing the certificate on a web server through some sort of admin interface, vs having access to the box yourself.

[Develop With Passion®](http://www.developwithpassion.com)
