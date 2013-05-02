---
layout: post
title: "Getting Up And Running With A Sane Mutt Setup"
date: 2013-03-09 06:58
comments: true
categories: [mouseless, unix]
---
Well, for the last 2 months I have been using [Mutt](http://www.mutt.org/) as my primary email client, and I have not missed gmail at all!!

I spend the majority of my day inside a shell based environment, and a large majority of my workflow/tooling has been heavily modded to allow me to do pretty much all of my activities from a shell.

* I edit all my code in vim
* I manage keychain entries using the command line clients
* I have a easy to customize automation/expansion library that allows me to add new shell automation tasks easily
* For the rare times that I use twitter, I use a vim plugin for that!
* I compose blog entries in vim

You get the point!

I have occassionally messed around with using [links]() as a browser client. In reality, between chrome+vimium or firefox+vimperator, I have my mouseless browsing covered. The only scenario this setup does not work well for me is when I am ssh'd into a machine and want to browse the web (hence the use of links in those scenarios).

##Focused, specific tools that do one job and do it well

This post is mostly for my own journalling purposes, but I am sharing it in the event that it proves useful to others. If you are running on osx, I am going to strongly recommend that you install the [homebrew]() package manager, as that is what I use, to install other programs.

This post will outline the way that I setup the following tools:

* [mutt - Shell based email client]()
* [offlineimap - Offline imap mail management]()
* [urlview - View urls in files]()
* [msmtp - Smtp client]()
* [gnupg - Encyrption utilities]()

##Getting Started

As noted above, you will more than likely want to install [homebrew](http://docs.offlineimap.org/en/latest/FAQ.html#id8) to follow along with these instructions the best. I love homebrew as it is a ruby based package management system for non gem based packages (think nodejs, sqlite ...)

##Installing and configuring offlineimap

After a brief 30 minute sessions messing around with mutt as a simple gmail client I was running into a lot of annoying "freezes". I came to the conclusion that using mutt as a replacement for the Gmail web interface would not really bring me a lot of the benefits that I wanted from a shell based email interface. I decided that it would be handy to be able to manage email offline, which would allow me to not have to connect to gmail unless I
actually needed to send emails or synchronize local changes. To that end I decided to go with [offlineimap](http://offlineimap.org/) to download a complete copy of my gmail imap folders and be able to deal with mail completely offline if need be.

As is the case with the rest of the tools in this guide, the install process is a snap, the configuration process is a little involved. I installed the current version of offlineimapTo install offline imap just type the following in a shell:

{% codeblock Install Homebrew - install.sh %}  
brew install offlineimap
brew install sqlite
{% endcodeblock %}

I installed sqlite to use it as the storage for offlineimap mail status.

Ok, that was painless now lets configure it:

{% codeblock Copy Initial Configuration File - copy_config.sh %}  
cp $(brew --prefix)/Cellar/offlineimap/HEAD/offlineimap.conf ~/.offlineimaprc
{% endcodeblock %}

This just copies a stock sample configuration file into one of the standard places that offlineimap looks for configuration. To read more about offlineimap configuration go [here](http://docs.offlineimap.org/en/latest/MANUAL.html#configuration). I spent quite a bit of time reading through the docs and messing around with a bunch of the settings, along with messing up my install a couple of times!! That is how I learn the best though!! The documentation that comes with the sample configuration file is pretty informative, so you should be able to tweak a lot of things. As far as configuration goes I leveraged the sample configuration outlined by [Steve Losh](http://stevelosh.com/blog/2012/10/the-homely-mutt/#configuring-offlineimap), who also went through the joys of configuring this setup a while ago. I wanted to understand how all these pieces worked, so I just leveraged his guide to rip off his configuration. His guide is also a great walkthrough of how to get this setup going. I am of the mindset that I like to struggle on my own for a bit as I try to figure things out. Instead of using his and other awesome guides, I set aside a half day and did this myself!! In the docs it mentions that the offlineimaprc file can also include a regular python file that can have supplementary code you want to leverage!! Pretty awesome concept. Steve uses this in a clever way to get around the need to have plain text passwords in the config file. Read his post for the details, but it basically makes use of the security utility (usr/bin/security on most unix based systems), to access the password in a keychain item.



Ok, so I configured things appropriately and was ready to kick off offlineimap to download the mail locally onto my computer (only about 1.5GB, but seeing as how we live out in the boonies, this would take a while). I fired up offlineimap and was immediately hit with an error about an incorrect fingerprint for the gmail stmp server. I figured this had something to do with a gmail cert change. This was rectified by following the instructions [here](https://wiki.archlinux.org/index.php/OfflineIMAP#SSL_fingerprint_does_not_match) which resulted in my adding the following config item in my JPBoodhoo-Remote Repository section:

{% codeblock Adding gmail cert fingerprint - cert_fingerprint.sh %}  
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
{% endcodeblock %}

With that change in place (keep in mind, the fingerprint can change at a later time, which would require this line to be updated), things looked good to go, I reran offlineimap and went about with other work while our country network connection proceeded to choke on the download for the next couple of hours.

Here is the majority of the pertinent stuff from my current configuration:

{% codeblock offlineimap configuration - configuration.ini %}  
[general]
ui = TTYUI
accounts = jp_developwithpassion_gmail, jboodhoo------gmail
pythonfile = ~/repositories/developwithpassion/devtools/shared/dotfiles/offlineimap/offlineimap.py
fsync = False


[Account jp_developwithpassion_gmail]
localrepository = jp_developwithpassion_gmail_local
remoterepository = jp_developwithpassion_gmail_remote
status_backend = sqlite
postsynchook = notmuch new

[Account jboodhoo----gmail]
localrepository = jboodhoo----gmail_local
remoterepository = jboodhoo----gmail_remote
status_backend = sqlite
postsynchook = notmuch new


#developwithpassion
[Repository jp_developwithpassion_gmail_local]
type = Maildir
localfolders = ~/Dropbox/imap_mail/jp_developwithpassion
nametrans = get_remote_name


[Repository jp_developwithpassion_gmail_remote]
maxconnections = 1
type = Gmail
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
remoteuser = jp@developwithpassion.com
remotepasseval = get_password("jp@developwithpassion.com")
realdelete = no
nametrans = get_local_name
folderfilter = is_included

#***
[Repository jboodhoo-----gmail_local]
type = Maildir
localfolders = ~/Dropbox/imap_mail/jboodhoo---
nametrans = get_remote_name


[Repository jboodhoo----gmail_remote]
maxconnections = 1
type = Gmail
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
remoteuser = jboodhoo@----
remotepasseval = get_password("jboodhoo@----")
realdelete = no
nametrans = get_local_name
folderfilter = is_included
{% endcodeblock %}

You can check out Steves post for a very thorough explanation of the configuration that matches. I took advantage of the python file to DRY up my configuration for the nametrans setting. When you are working with one of the remote repositories (jp_developwithpassion_gmail_remote) in one of the examples above; the nametrans setting determines how to map the remote imap folder names to names on your local machine. In the examples on the offlineimap site, they would set up reverse entries in
the nametrans for the local and remote options. That would look something like this (lifted from the offlineimap site):

{% codeblock nametrans configuration - nametrans.ini %}
[Repository blah-Local]
type = Maildir
localfolders = ~/.mail/blah.com
nametrans = lambda folder: {'drafts':  '[Gmail]/Drafts',
                            'sent':    '[Gmail]/Sent Mail',
                            'flagged': '[Gmail]/Starred',
                            'trash':   '[Gmail]/Trash',
                            'archive': '[Gmail]/All Mail',
                            }.get(folder, folder)

[Repository blah-Remote]
maxconnections = 1
type = Gmail
remoteuser = blah@blah.com
remotepasseval = "password"
realdelete = no
nametrans = lambda folder: {'[Gmail]/Drafts':    'drafts',
                            '[Gmail]/Sent Mail': 'sent',
                            '[Gmail]/Starred':   'flagged',
                            '[Gmail]/Trash':     'trash',
                            '[Gmail]/All Mail':  'archive',
                            }.get(folder, folder)

{% endcodeblock %}

Of course, as you can see above, it seems a little redundant. In my config I dry it up as follows:
{% codeblock Drying up the name translation - nametrans_dry.ini %}

[Repository jp_developwithpassion_gmail_local]
type = Maildir
localfolders = ~/Dropbox/imap_mail/jp_developwithpassion
nametrans = get_remote_name

[Repository jp_developwithpassion_gmail_remote]
maxconnections = 1
type = Gmail
cert_fingerprint = 6d1b5b5ee0180ab493b71d3b94534b5ab937d042 
remoteuser = jp@developwithpassion.com
remotepasseval = get_password("jp@developwithpassion.com")
realdelete = no
nametrans = get_local_name
folderfilter = is_included

{% endcodeblock %}

This is done by leveraging the following code that exists in the python file that I include at the top of my configuration:

{% codeblock OfflineImap Python Configuration - offline.py %}
#!/usr/bin/python
import subprocess
import re

class NameMapping:
  def __init__(self, local_name, remote_name):
    self.local_name = local_name
    self.remote_name = remote_name

class LocalName:
  def __init__(self, folder):
    self.folder = folder

  def matches(self, mapping):
    return mapping.remote_name == self.folder

  def mapped_folder_name(self, mapping):
    return mapping.local_name
  
class RemoteName:
  def __init__(self, folder):
    self.folder = folder

  def matches(self, mapping):
    return mapping.local_name == self.folder

  def mapped_folder_name(self, mapping):
    return mapping.remote_name



def get_password(account):
  program ='/Users/jp/repositories/developwithpassion/devtools/automation/keychain/get_keychain_password'

  command = "{0} --account:{1}".format(program, account)

  output = subprocess.check_output(command, shell=True)

  return output.rstrip()


def is_included(folder):
  result = True

  for pattern in exclusion_patterns:
    result = result and (re.search(pattern, folder) == None)

  return result

exclusion_patterns = [
  "efax",
  "earth_class_mail",
  "eventbrite",
  "gotomeeting",
  "moshi_monsters",
  "peepcode",
  "raini_fowl",
  "stuart_know",
  "training.*2008",
  "training.*2009",
  "training.*2010",
  "training.*2011",
  "training.*2012",
  "training.*nbdn",
  "training.*nothin_but_bdd",
  "unblock_us",
  "web_hosting",
  "webinars",
  "Gmail.*Important"
]

name_mappings = [
  NameMapping('sent', '[Gmail]/Sent Mail'),
  NameMapping('spam', '[Gmail]/Spam'),
  NameMapping('flagged', '[Gmail]/Starred'),
  NameMapping('trash',   '[Gmail]/Trash'),
  NameMapping('archive', '[Gmail]/All Mail'),
  NameMapping('drafts', '[Gmail]/Drafts')
]



def find_name_mapping(name):
  default_mapping = NameMapping(name.folder, name.folder)

  for mapping in name_mappings:
    if (name.matches(mapping)):
      return mapping

  return default_mapping

def get_name_mapping(name):
  mapping = find_name_mapping(name)
  return name.mapped_folder_name(mapping)

def get_remote_name(local_folder_name):
  name = RemoteName(local_folder_name)
  return get_name_mapping(name)

def get_local_name(remote_folder_name):
  name = LocalName(remote_folder_name)
  return get_name_mapping(name)
{% endcodeblock %}

The name mappings array is the single place where the mappings are defined. That way I don't have to worry about typos between sections. The config also shows how I am doing exclusions as well as shelling out to a custom ruby script to get passwords.

On my second imap sync I got an UID validity error on one of the folders I was trying to sync. This was resolved using the following [doc](http://docs.offlineimap.org/en/latest/FAQ.html#id8).

As you can see from the above config, I have 2 different email accounts that are currently setup. The second account is starred out due to privacy reasons.

One of the cool things about the offlineimap configuration is that you can specify a python file that will get mixed into the current config file and you can leverage code in the python file to help with configuration.  I am using this feature for both retrieving account passwords and for remote & local name translation.

##Installing Mutt

Next up it was time to get going with mutt. Mutt at its core is a text-based mail client. For the purpose of my setup, I am going to be using it to primarily read and compose messages. It has out of the box support to be able to interface with gmail, and its own smtp utility, but I prefer to use msmtp as I have used it consistently without issues for years. To that end, most of the configuration for mutt will be setting it up to basically be able to work with the local copy of messages
that gets pulled down by offlineimap.

Let's install it:

{% codeblock Install Mutt - install_mutt.sh %}  
brew install mutt
{% endcodeblock %}

##Configuring gpg

As I am currently working with a client that requires encrypted messages for all internal communications, it was necessary for me to setup and configure mutt with gpg encryption. I am using [GPGTools for OSX](https://gpgtools.org/). After installing and setting up my necessary keys, here is the config that I need to place in the file ~/.mutt/gpg.rc (your file location may vary), this is only a slight modification of the stock gpg configuration.

{% codeblock GPG Configuration - gpg.sh %}  
# -*-muttrc-*-
#
# Command formats for gpg.
#
# This version uses gpg-2comp from
# http://70t.de/download/gpg-2comp.tar.gz
#
# $Id$
#
# %p The empty string when no passphrase is needed,
# the string "PGPPASSFD=0" if one is needed.
#
# This is mostly used in conditional % sequences.
#
# %f Most PGP commands operate on a single file or a file
# containing a message. %f expands to this file's name.
#
# %s When verifying signatures, there is another temporary file
# containing the detached signature. %s expands to this
# file's name.
#
# %a In "signing" contexts, this expands to the value of the
# configuration variable $pgp_sign_as. You probably need to
# use this within a conditional % sequence.
#
# %r In many contexts, mutt passes key IDs to pgp. %r expands to
# a list of key IDs.

set pgp_decode_command="gpg --status-fd=2 %?p?--passphrase-fd 0? --no-verbose --quiet --batch --output - %f"
set pgp_verify_command="gpg --status-fd=2 --no-verbose --quiet --batch --output - --verify %s %f"
set pgp_decrypt_command="gpg --status-fd=2 %?p?--passphrase-fd 0? --no-verbose --quiet --batch --output - %f"
set pgp_sign_command="gpg --no-verbose --batch --quiet --output - %?p?--passphrase-fd 0? --armor --detach-sign --textmode %?a?-u %a? %f"
set pgp_clearsign_command="gpg --no-verbose --batch --quiet --output - %?p?--passphrase-fd 0? --armor --textmode --clearsign %?a?-u %a? %f"
set pgp_encrypt_only_command="pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust -- -r %r -- %f"
set pgp_encrypt_sign_command="pgpewrap gpg %?p?--passphrase-fd 0? --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust -- -r %r -- %f"

set pgp_import_command="gpg --no-verbose --import %f"
set pgp_export_command="gpg --no-verbose --export --armor %r"
set pgp_verify_key_command="gpg --verbose --batch --fingerprint --check-sigs %r"
set pgp_list_pubring_command="gpg --no-verbose --batch --quiet --with-colons --list-keys %r"
set pgp_list_secring_command="gpg --no-verbose --batch --quiet --with-colons --list-secret-keys %r"

# fetch keys
# set pgp_getkeys_command="pkspxycwrap %r"

# pattern for good signature - may need to be adapted to locale!

# set pgp_good_sign="^gpgv?: Good signature from "

# OK, here's a version which uses gnupg's message catalog:
# set pgp_good_sign="`gettext -d gnupg -s 'Good signature from "' | tr -d '"'`"

# This version uses --status-fd messages
set pgp_good_sign="^\\[GNUPG:\\] GOODSIG"

set pgp_timeout=9000

{% endcodeblock %}

For more thorough explanations of the above settings, you can check out the guide that I followed [here](http://dev.mutt.org/trac/wiki/MuttGuide/UseGPG)

As far as my mutt configuration goes, I added the following lines to my mutt configuration file:

{% codeblock Mutt GPG Config - gpg.sh %} 
bind compose p pgp-menu

# Prepare GPG usage
source ~/.mutt/gpg.rc
{% endcodeblock %}

The keybinding allows me to hit p after I have composed a message, and it will bring up all of the options I can apply to my mail (sign, encrypt, ...)

##Access GMail Contacts In Vim Header Fields Using goobook

Another piece of the puzzle was for me to be able to access my gmail contacts through mutt. To do that I leveraged a python utility called [goobook](http://code.google.com/p/goobook/).

Install python if you don't already have it:
{% codeblock Install Python - install_python.sh %}  
brew install python
{% endcodeblock %}

Install goobook:
{% codeblock Install goobook - install_goobook.sh %}  
pip install goobook
{% endcodeblock %}

To leverage goobook as my contact lookup mechanism, I added the following lines to my mutt configuration file:

{% codeblock Goobook related settings - goobook.sh %}
set query_command="goobook query '%s'"
set editor = "vim --cmd 'let g:goobookrc=\"/Users/jp/.goobookrc\"'"
bind editor <Tab> complete-query
{% endcodeblock %}

The first settings tells mutt which utility to use to query for contact completion. The second setting allows me to have vim be able to autocomplete google contacts when I am editing mail headers in Vim. The third setting is just a mutt keybinding that will trigger the goobook search when I hit tab in mail header fields.

##Mail Searching With notmuch

The last piece of the puzzle was being able to locally search email. I accomplished this by setting up [notmuch](http://notmuchmail.org/). Getting going was as simple as running:

{% codeblock Installing notmuch- not_much_setup.sh %}
brew install notmuch
notmuch setup #setting up for first time use
notmuch new #run the first search
{% endcodeblock %}

To hook into the search from inside of mutt, I added the following configuration line to my mutt configuration file:

{% codeblock Configuring mutt with notmuch - mutt_not_much.sh %}
macro index S "<enter-command>unset wait_key<enter><shell-escape>mutt_notmuch /tempfiles/notmuch_search_results<enter><change-folder-readonly>/tempfiles/notmuch_search_results<enter>" "search mail (using notmuch)"
{% endcodeblock %}

Basically, when I am in mutt and want to search for mail, I can hit S and then enter in a search term. At that point it will shell out to a small ruby script that I wrote, that executes the notmutt search and builds up the appropriate directory structure for mutt to treat the search results as a mail folder that can be explored in mutt. Finally, I change the working folder to the folder containing the search results (for me /tempfiles/notmuch_search_results). Here is the script that I wrote
to do the search and result dir creation:

{% codeblock Searching for mail - mutt_notmuch.rb %}
#!/usr/bin/env ruby

require 'digest/sha1'
require 'optparse'
require 'fileutils'

class Hasher
  def initialize
    @hasher = Digest::SHA1.new
  end

  def get_email_hash(file_name)
    @hasher.hexdigest(IO.read(file_name))
  end
end

def build_results_folder(results_path)
  FileUtils.rm_rf(results_path)
  FileUtils.mkdir_p(results_path)

  %w/cur new/.each do |folder|
    combined_path = File.join(results_path, folder)
    FileUtils.mkdir_p(combined_path)
  end
end

def read_line(message)
  print "Query:"
  STDIN.gets.chomp
end

def get_unique_files(files)
  hasher = Hasher.new
  messages = {}
  files.each do |file|
    hash = hasher.get_email_hash(file)
    messages[hash] = file
  end
  messages.values
end

def get_matching_files(query)
  files = `notmuch search --output=files #{query}`
  files.split("\n")
end

def sym_link(files, target_path)
  files.each do |file|
    system("ln -s #{file} #{target_path}")
  end
end

def run(results_path)
  build_results_folder(results_path)
  query = read_line("Search Phrase?")
  files = get_matching_files(query)
  unique_files = get_unique_files(files)
  sym_link(unique_files, "#{results_path}/cur/")
end

def parse_arguments
  OptionParser.new do|options|
    options.banner = "Usage is: mutt_notmuch [RESULTS_PATH]"
  end.parse!
  
  path = ARGV.length == 0 ? "/tempfiles/notmuch_search_results" : ARGV[0]
end

run parse_arguments
{% endcodeblock %}

##Sending Mail

Up to this point I have only talked about a scenario optimized for reading mail. One of the main things you will also want to be able to do is send mail. Mutt has support for smtp, but there are more robust programs out there that only focus on smtp. One of those programs is [ msmtp ](http://msmtp.sourceforge.net/). This is program that I configured mutt to use to do mail sending.

Installing is a simple as:

{% codeblock Installing msmtp - msmtp_install.sh %}
brew install msmtp
{% endcodeblock %}

Here is what my current msmtp configuration file looks like:

{% codeblock Configuring msmtp - msmtp_config.sh %}

account jp
host smtp.gmail.com
port 587
protocol smtp
auth on
from jp@developwithpassion.com
user jp@developwithpassion.com
tls on
tls_trust_file ~/.mutt/equifax_gmail.cert

account jp_---
host smtp.gmail.com
port 587
protocol smtp
auth on
from jp@developwithpassion.com
user jboodhoo@------
tls on
tls_trust_file ~/.mutt/equifax_gmail.cert

account default : jp
{% endcodeblock %}

I "dashed" out the information for my current client in the second account configuration. Notice that I am using the first account as the default. In my mutt configuration (for my local mail account), I have the following configuration line for using msmtp as the mail sender:

{% codeblock Mutt msmtp config - mutt_msmtp_config.sh %}

set from = "jp@developwithpassion.com"
set sendmail = "/usr/local/bin/msmtp -a jp" #using the account named jp from my msmtp configuration file
set sendmail_wait = 0
unset record # gmail records sent mail automatically, so we don't need to track

{% endcodeblock %}

I have 2 aliases set up that allow me to start mutt with my local mail account, and the other for my client mail account. Each instance uses a client specific mutt configuration that is also configured with the correct msmtp account to use for sending. That is outside of the scope of this article, but it is just a matter of templates and aliases.

##Handling mail attachments
One of the first snags I ran into was correctly handling mail that contained attachments (sending mail with attachments is a snap, so I won't go into it in this article). By defaualt, mutt will use you [ mailcap ](http://en.wikipedia.org/wiki/Mailcap) file to try to determine how to handle email. The contents of my mailcap file look as follows:

{% codeblock Mailcap file - mailcap.sh %}
# MS Office files
application/msword; ~/.mutt/view_mail_attachment.rb --file:%s --type:"-" --open_with:'/Applications/OpenOffice.org.app'
application/vnd.ms-excel; ~/.mutt/view_mail_attachment.rb --file:%s --type:"-"
application/vnd.openxmlformats-officedocument.presentationml.presentation; ~/.mutt/view_mail_attachment.rb --file:%s --type:"-" --open_with:'/Applications/OpenOffice.org.app'
application/vnd.oasis.opendocument.text; ~/.mutt/view_mail_attachment.rb --file:%s --type:"-" --open_with:'/Applications/OpenOffice.org.app'

# Images
image/jpg; ~/.mutt/view_mail_attachment.rb --file:%s --type:jpg
image/jpeg; ~/.mutt/view_mail_attachment.rb --file:%s --type:jpg
image/pjpeg; ~/.mutt/view_mail_attachment.rb --file:%s --type:jpg
image/png; ~/.mutt/view_mail_attachment.rb --file:%s --type:png
image/gif; ~/.mutt/view_mail_attachment.rb --file:%s --type:gif

# PDFs
application/pdf; ~/.mutt/view_mail_attachment.rb --file:%s --type:pdf

# HTML
text/html; ~/.mutt/view_mail_attachment.rb --file:%s --type:html

# Unidentified files
application/octet-stream; ~/.mutt/view_mail_attachment.rb --file:%s --type:"-"

{% endcodeblock %}

Notice that most of this script shells out to a custom ruby script that does the appropriate program launching. Here is that script:

{% codeblock View Mail Attachment - view_mail_attachment.rb %}
#!/usr/bin/env ruby

require 'fileutils'

class Arguments
  attr_accessor :file
  attr_accessor :type
  attr_accessor :open_with
  attr_accessor :temp_dir

  def temp_dir
    @temp_dir ||= "/tempfiles/mutt_attachments"
  end

  def base_file_name
    @base_file_name ||= File.basename(file)
  end

  def base_file_name_without_extension
    File.basename(base_file_name, File.extname(base_file_name))
  end
end

def build_arguments(arguments)
  result = Arguments.new

  arguments.each do|argument|
    pair = argument.split(":")
    name = pair[0].gsub(/-/,"")
    value = pair[1]
    result.send "#{name}=", value
  end
  result
end

arguments = build_arguments(ARGV)

system("mkdir -p #{arguments.temp_dir}")
system("rm -rf #{arguments.temp_dir}/*")


new_file_name = ""
if (arguments.type == "-")
  new_file_name = File.basename(arguments.file)
else
  new_file_name = "#{arguments.base_file_name_without_extension}.#{arguments.type}"
end

new_file_name = File.join(arguments.temp_dir, new_file_name)
FileUtils.cp arguments.file, new_file_name

if (arguments.open_with)
  system("open -a #{arguments.open_with} #{new_file_name}")
else
  system("open #{new_file_name}")
end


{% endcodeblock %}

As you can see, this solution makes the assumption that I write attachments to the following folder : /tempfiles/mutt_attachments

##Conclusion

It took a couple of days for me to tweak my keybindings and customize my setup.  After the initial rampup, I love that I can now compose, read, edit my email in Vim. I can quickly add support for new mime types if I don't currently handle them. I can send encrypted messages, easily add attachments, read my mail fully offline, and I can only not get caught with the noise of notifications etc, as I choose when I explicitly refresh my mail.
