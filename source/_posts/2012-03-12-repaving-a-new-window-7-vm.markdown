---
layout: post
title: "Repaving a new Windows 7 VM"
date: 2012-03-12 09:15
comments: true
categories: [tools,vmware,windows]
---
On Thurday my windows vm image died along with my backup of it!!

I thought this was a good opportunity to repave a brand new vm that I can also create linked clones from to quickly scaffold new vm's moving forward.

This post is mostly to help me remember the install process and the base tools that I install on a fresh windows 7 vm, as this is not something I do very often!! I included screenshots of most of the install steps, just so I can both remind myself what my defaults are, as well as for your benefit if you wish to copy this setup.

##Base Tools Install

1. [Vista Switcher](http://www.ntwind.com/software/vistaswitcher/download.html)
    {% img centered http://img.skitch.com/20120312-1xpe8rkihtbti8bi7ny7m17sc3.jpg %}
    {% img centered https://img.skitch.com/20120312-dusptjfftx1w4u363eqbjbwgn6.jpg %}
2. [Ruby](http://rubyinstaller.org/downloads/)
    {% img centered https://img.skitch.com/20120417-8eg1kmdq7medirmy7ssi9f1i6d.jpg %}
3. [MinGW](http://sourceforge.net/projects/mingw/files/Installer/)
    {% img centered https://img.skitch.com/20120312-tdxfh2jm2g6a4j9c56jjscffwa.jpg %}
    {% img centered https://img.skitch.com/20120312-qxe4ktaj9gb3njbs9kxe4k4815.jpg %}
    {% img centered https://img.skitch.com/20120312-qr4263hkwifxhc949jay5r9d5m.jpg %}
    {% img centered https://img.skitch.com/20120312-8fqc842ijwnyx5as7dkfpdihum.jpg %}
    {% img centered https://img.skitch.com/20120312-jxgg9ihgj4ggxjep4upxsc6jtx.jpg %}
4. [Autohotkey](http://www.autohotkey.com/)
    {% img centered http://img.skitch.com/20120312-f3ehi51ir2mqqx5i3x1pewpe3m.jpg %}
    {% img centered http://img.skitch.com/20120312-g3rkx6ihgfr35pmfuw7ubpnc4x.jpg %}
    {% img centered http://img.skitch.com/20120312-cghgifmy7dsq3ige5k793jy3pd.jpg %}
5. Copy the contents of /to_backup/new_windows_install/startup_software/utils to /c/utils. This folder contains:
    * sysinternals
    * myuninstaller
6. [Beyond Compare](http://www.scootersoftware.com/download.php)
    {% img centered http://img.skitch.com/20120312-ka9bmr2kndp22tup6dctd1ybrt.jpg %}
    {% img centered http://img.skitch.com/20120312-tftdp5xk875g73q9shnewy7bek.jpg %}
    {% img centered http://img.skitch.com/20120312-ex7nfxha9aya4jyerkhstjmuec.jpg %}
7. [Executor](http://www.1space.dk/executor/download.html)
    {% img centered http://img.skitch.com/20120312-nqdearkgwdx8q77rnhpdhnyc81.jpg %}
    {% img centered http://img.skitch.com/20120312-tdwp3ukimbpsrtrsa3p6x8jb7h.jpg %}
    {% img centered http://img.skitch.com/20120312-c9knb43uq9ep2erx3qdmi3kgse.jpg %}
    {% img centered http://img.skitch.com/20120312-8pb625hra27aaup5s5ywgwjyg2.jpg %}
    {% img centered http://img.skitch.com/20120312-grjegt4fjxur83wpcpbpjr1s6n.jpg %}
    {% img centered http://img.skitch.com/20120312-egr8u1fbkpsh4k6m8fcp93e5f2.jpg %}
    {% img centered http://img.skitch.com/20120312-jypj1a6aapd9e41ahdg2kpyda1.jpg %}
8. [Unlocker](http://www.emptyloop.com/unlocker/)
    {% img centered http://img.skitch.com/20120312-8s84c89cy5gnn83812cwm5g8sh.jpg %}
    {% img centered http://img.skitch.com/20120312-mgwcr5ynb43167fxeqymfkh7cs.jpg %}
9. [msysgit](http://code.google.com/p/msysgit/downloads/list)
    {% img centered http://img.skitch.com/20120312-c4sn9mehad9kdp1nyqkitenbke.jpg %}
    {% img centered http://img.skitch.com/20120312-ndn2rt75g27gfhnex5cks4x4tf.jpg %}
    {% img centered http://img.skitch.com/20120312-rqw8g91j95y4357sd4k3bxibri.jpg %}
    {% img centered https://img.skitch.com/20120417-xk9b2q7rdf297p3npx5k1s1g73.jpg %}
    {% img centered http://img.skitch.com/20120312-t3rh2n9gfpb6mimjfipk7kgndh.jpg %}
10. [gvim](ftp://ftp.vim.org/pub/vim/pc/gvim73_46.exe)
    {% img centered http://img.skitch.com/20120312-dq3n1ab22mq6nw72p2r2qmjec2.jpg %}
    {% img centered http://img.skitch.com/20120312-cuds5yn1jxuet4nd9gm49ud79p.jpg %}
    {% img centered http://img.skitch.com/20120312-qbitgimwn6tsqak5hyufktcpyj.jpg %}
11. [cygwin](http://www.cygwin.com/)
    {% img centered https://img.skitch.com/20120417-kn8tdfutqnih5yfw8r645xeihy.jpg %}
    {% img centered https://img.skitch.com/20120417-xxc1s4hwgtgih3438eattc3bc9.jpg %}
    {% img centered https://img.skitch.com/20120417-g4xuuy9pmxc42hjsbaswj15km4.jpg %}
    {% img centered https://img.skitch.com/20120417-d5sa1uymet4u3h17mqjwi3q6cf.jpg %}
    {% img centered https://img.skitch.com/20120417-cybastr9d32gtc172gey8u7fup.jpg %}
    Install the following packages:

    * Archive
      * unzip - Unzipping zip files
    * Net
      * openssl - bin and sources
      * openssh - Only if you are not going to compile openssh yourself
      * curl - download internet resources
    * Devl
      * colorgcc
      * gcc
      * gcc-core - compiler
      * git
      * git-completion
      * git-gui
      * git-svn
      * gitk
      * libtool - Shared library generation tool. You'll need it when trying to compile rubies
      * libncurses-devel - Used when compiling several other tools I use
      * make
      * mercurial
      * openssl-devel - Required for compiling openssh (not necessarily required for rvm, but I always install it to compile openssh myself)
      * readline
    * Utils
      * ncurses - Enabling better handling of terminal
      * patch - Apply a diff file to an original. Again, you'll need it when rvm is trying to patch the ruby installs

    {% img centered https://img.skitch.com/20120417-xg7ygk74y94j11rn1hgu2p6epi.jpg %}

Along with the tools outlined above I also manually compiled the following:

* [dvtm](http://github.com/developwithpassion/dvtm)
* [vim](http://www.vim.org)
* [screen](git://git.savannah.gnu.org/screen.git)
* [zsh](git://zsh.git.sf.net/gitroot/zsh/zsh)


Well that's it for the base tool install!! There are a couple of other steps I do to configure msys and cygwin to play nice together, but that's another post!! Outside of that, this is what constitutes my bare minimum for a usable windows vm. From this base image, I can create [linked clones](http://blog.developwithpassion.com/2012/04/17/screencast-creating-linked-clones-with-vmware-fusion/) that allow me to create project specific vm's that have further tools installed (such as vs, vs.net etc) specific to the contract/project I am working on.

##Still To Come
In a follow up post I'll detail a set of tools, scripts and code that allows me to configure this entire toolset, so that I can have a seamless environment that supports :

* Vim with a host of my favourite plugins
* An organized eaash environment with well partitioned dotfiles etc
* Simple, plugin style automation tasks

Most importantly, the bash/vim/automation setup I have allows me to share all of the important scripts such as:

* dotfiles
* automation scripts

On all three of the main environments I work in :

* OSX
* Ubuntu
* Windows (cygwin and mingw)

Until next time!!

[Develop With Passion®](http://www.developwithpassion.com)
