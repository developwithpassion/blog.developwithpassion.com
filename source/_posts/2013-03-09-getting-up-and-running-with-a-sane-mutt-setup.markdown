---
layout: post
title: "Getting Up And Running With A Sane Mutt Setup"
date: 2013-03-09 06:58
comments: true
categories: [mouseless, unix]
---
Well, I finally bit the bullet and ditched the gmail web interface in favour of a full terminal based email solution.

I spend the majority of my day inside a shell based environment, and a large majority of my workflow/tooling has been heavily modded to allow me to do pretty much all of my activities from a shell.

* I edit code in vim
* I compile from the command line
* I manage keychain entries using the command line clients
* I have a easy to customize automation/expansion library that allows me to add new shell automation tasks easily
* For the rare times that I use twitter, I use a vim plugin for that
* I compose blog entries in vim

I have occassionally messed around with using links as a browser client. In reality, between chrome+vimium or firefox+vimperator, I have my mouseless browsing covered. The only scenario this setup does not work well for me is when I am ssh'd into a machine and want to browse the web (hence the use of links in those scenarios).

##Focused, specific tools that do one job and do it well

This post is mostly for my own journalling purposes, but I am sharing it in the event that it proves useful to others. If you are running on osx, I am going to strongly recommend that you install the [homebrew]() package manager, as that is what I use, and will be using to describe how I setup.

The tools that I installed to get a sane mouseless, terminal based mail experience going are. Out of this list, the only one that I did not have a lot of prior experience with was mutt.

* [mutt - Shell based email client]()
* [offlineimap - Offline imap mail management]()
* [urlview - View urls in files]()
* [msmtp - Smtp client]()
* [gnupg - Encyrption utilities]()

##Getting Started

As noted above, you will more than likely want to install [homebrew](http://docs.offlineimap.org/en/latest/FAQ.html#id8) to follow along with these instructions the best. I love homebrew as it is a ruby based package management system for non gem based utilities (think nodejs, sqlite ...)

##Installing and configuring offlineimap

Having briefly played around with mutt as a simple gmail client, I realized a lot of annoying "freezes" when using mutt with gmail. I came to the conclusion that using mutt as a replacement for the Gmail web interface would not really bring me a lot of the benefits that I wanted from a shell based email interface. I decided that it would be handy to be able to manage email offline, which would allow me to not have to connect to gmail unless I
actually needed to send emails or synchronize local changes. To that end I decided to go with offlineimap to download a complete copy of my gmail imap folders and be able to deal with mail completely offline if need be.

As is the case with the rest of the tools in this guide, the install process is a snap, the configuration process is a little involved. To install offline imap just type the following in a shell:

{% codeblock Install Homebrew - install.sh }  
brew install offlineimap
brew install sqlite
{% endcodeblock }

The reason I installed sqlite is that I wanted to use it to store mail status as it seemed to be a bit quicker, than the default approach.

Ok, that was painless now lets configure it:

{% codeblock Copy Initial Configuration File - copy_config.sh }  
cp $(brew --prefix)/Cellar/offlineimap/HEAD/offlineimap.conf ~/.offlineimaprc
{% endcodeblock }

This just copies a stock sample configuration file into one of the standard places that offlineimap looks for configuration. To read more about offlineimap configuration go [here](http://docs.offlineimap.org/en/latest/MANUAL.html#configuration). The documentation that comes with the sample configuration file is pretty informative, so you should be able to tweak a lot of things. As far as configuration goes I leveraged the sample configuration outlined by [Steve Losh](http://stevelosh.com/blog/2012/10/the-homely-mutt/#configuring-offlineimap), who also went through the joys of configuring this setup a while ago. I wanted to understand how all these pieces worked, so I just leveraged his guide to rip off his configuration. His guide is also a great walkthrough of how to get this setup going. I am a bit of the mindset that I like to struggle on my own for a bit as I try to figure things out, so instead of using his awesome guide, I set aside a half day and did this myself, mostly for kicks!! In the docs it mentions that the offlineimaprc file can also include a regular python file that can have supplementary code you want to leverage!! Pretty awesome concept. Steve uses this in a clever way to get around the need to have plain text passwords in the config file. Read his post for the details, but it basically makes use of the security utility (usr/bin/security on most unix based systems), to access the password in a keychain item.

Ok, so I configured things appropriately and was ready to kick off offlineimap to download the mail locally onto my computer (only about 1.5GB, but seeing as how we live out in the boonies, this would take a while). I fired up offlineimap and was immediately hit with an error about an incorrect fingerprint for the gmail stmp server. I figured this had something to do with a gmail cert change. This was rectified by following the instructions [here](https://wiki.archlinux.org/index.php/OfflineIMAP#SSL_fingerprint_does_not_match) which resulted in my adding the following config item in my JPBoodhoo-Remote Repository section:

{% codeblock Adding gmail cert fingerprint - cert_fingerprint.sh }  
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
{% endcodeblock }

With that change in place, things looked good to go, I reran offlineimap and went about with other work while our country network connection proceeded to choke on the download for the next couple of hours.

Here is the majority of the pertinent stuff from my current configuration:

{% codeblock offlineimap configuration - configuration.ini }  
[general]
ui = TTYUI
accounts = jp_developwithpassion_gmail
pythonfile = ~/repositories/developwithpassion/devtools/automation/offlineimap/offlineimap.py
fsync = False


[Account jp_developwithpassion_gmail]
localrepository = jp_developwithpassion_gmail_local
remoterepository = jp_developwithpassion_gmail_remote
status_backend = sqlite


[Repository jp_developwithpassion_gmail_local]
type = Maildir
localfolders = ~/Dropbox/imap_mail/jp_developwithpassion
nametrans = lambda folder: {'sent':    '[Gmail]/Sent Mail',
                            'flagged': '[Gmail]/Starred',
                            'trash':   '[Gmail]/Trash',
                            'archive': '[Gmail]/All Mail',
                            'drafts': '[Gmail]/Drafts'
                            }.get(folder, folder)


[Repository jp_developwithpassion_gmail_remote]
maxconnections = 1
type = Gmail
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
remoteuser = jp@developwithpassion.com
remotepasseval = get_keychain_password(account="jp@developwithpassion.com")
realdelete = no
nametrans = lambda folder: {'[Gmail]/Sent Mail': 'sent',
                            '[Gmail]/Starred': 'flagged',
                            '[Gmail]/Trash': 'trash',
                            '[Gmail]/All Mail': 'archive',
                            '[Gmail]/Drafts': 'drafts'
                            }.get(folder, folder)

folderfilter = lambda folder: folder not in ['[Gmail]/Spam',
                                           '[Gmail]/Important'
                                           ]                           
{% endcodeblock }

On my second imap sync I got an UID validity error on one of the folders I was trying to sync. This was resolved using the following [doc](http://docs.offlineimap.org/en/latest/FAQ.html#id8).


##Who let the dogs out

Next up it was time to get going with mutt. Mutt at its core is a text-based mail client. For the purpose of my setup, I am going to be using it to primarily read and compose messages. It has out of the box support to be able to interface with gmail, and its own smtp utility, but I prefer to use msmtp as I have used it consistently without issues for years. To that end, most of the configuration for mutt will be setting it up to basically be able to work with the local copy of messages
that gets pulled down by offlineimap.

Let's install it:

{% codeblock Install Mutt - install_mutt.sh }  
brew install mutt
{% endcodeblock }






