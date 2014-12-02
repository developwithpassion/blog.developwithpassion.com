---
layout: post
title: Fixing SSL_connect error with ruby on windows
date: 2014-12-02 12:04
comments: true
published: true
categories:
- ruby
- windows
---
Been a while since I've worked on a windows project!

Just needed to update some of my gems in an automation project and ran into the following error:

```bash
Gem::RemoteFetcher::FetchError: SSL_connect returned=1
```
I did not want to do the easy thing and update the Gemfile to use the unsecured gem location, so I used the following script which I ran inside of an msys shell:

```bash
mkdir /c/transient
cd /c/transient
curl http://curl.haxx.se/ca/cacert.pem -o cert.pem
SSL_CERT_FILE="cert.pem" gem update --system
cd ..
rm -rf transient
```

This script just simply downloads the latest SSL cert and updates the gem program. Once that was completed I uninstalled and installed the latest version of bunder and then was able to happily bundle install.

[Develop With Passion®](http://www.developwithpassion.com)
