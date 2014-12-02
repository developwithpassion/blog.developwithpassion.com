---
layout: post
title: "Fixing SSL_connect error with ruby on windows"
date: 2014-12-02 11:41
comments: true
published: false
categories: [ruby, windows]
---
It's been a while since I had to work on windows project!

Just getting my machine setup and ran into the following error when trying to update my gems:

```bash
Gem::RemoteFetcher::FetchError: SSL_connect returned=1 errno=0 state=SSLv3 
```

Not wanting to do the easy thing of just changing my gemfile to use unsecured gem location (http vs https). I just ran the following script inside a currently active msys shell:

```bash
mkdir /c/transient
cd /c/transient
curl http://curl.haxx.se/ca/cacert.pem -o cacert.pem
SSL_CERT_FILE="cacert.pem" gem update --system
rm cacert.pem
cd..
rm -rf transient

```

This script downloads the current SSL certificate and runs a gem system update with the current certificate.

Once that was completed, I just uninstalled and reinstalled bundler and then just reinstalled my gems using the new version of bundler. Updating bundler is not necessarily required, I just did it for being thorough.

[Develop With Passion®](http://www.developwithpassion.com)


