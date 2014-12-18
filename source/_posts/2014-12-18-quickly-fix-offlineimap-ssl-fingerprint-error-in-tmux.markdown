---
layout: post
title: "Quickly fix offlineimap ssl fingerprint error in tmux"
date: 2014-12-18 10:52
comments: true
published: true
categories: [tmux, bash, automation]
---
I've been using [mutt and offlineimap](http://blog.developwithpassion.com/2013/05/02/getting-up-and-running-with-a-sane-mutt-setup/) as a killer combo for terminal based email management for almost 2 years now. Everyone once in while offlineimap will go to sync my mail and I'll be presented with this awesome error message:

```bash
Account sync jp_developwithpassion_gmail:
 *** Processing account jp_developwithpassion_gmail
  Establishing connection to imap.gmail.com:993
  Folder INBOX [acc: jp_developwithpassion_gmail]:
   Skipping INBOX (not changed)
   Account sync jp_developwithpassion_gmail:
    Calling hook: notmuch new
     Hook stdout: No new mail.

     Hook stderr:

      Hook return code: 0
       *** Finished account 'jp_developwithpassion_gmail' in 0:01
       OfflineIMAP 6.5.5
         Licensed under the GNU GPL v2+ (v2 or any later version)
         Account sync jp_developwithpassion_gmail:
          *** Processing account jp_developwithpassion_gmail
           Establishing connection to imap.gmail.com:993
            ERROR: Server SSL fingerprint 'cf79537f0a504c116ee3cfb854bd58a70089edc0' for hostname 'imap.gmail.com' does not match configured fingerprint(s) ['d6b90ffd06292b1724e0644563299fffc9878780'].  Please verify and set 'cert_fingerprint' accordingly if not set yet.
             *** Finished account 'jp_developwithpassion_gmail' in 0:00
             ERROR: Exceptions occurred during the run!
             ERROR: Server SSL fingerprint 'cf79537f0a504c116ee3cfb854bd58a70089edc0' for hostname 'imap.gmail.com' does not match configured fingerprint(s) ['d6b90ffd06292b1724e0644563299fffc9878780'].  Please verify and set 'cert_fingerprint' accordingly if not set yet.

             ......

             Mailbox is unchanged.
```
The most important lines in this message are the following
                                                             
```bash
ERROR: Server SSL fingerprint 'cf79537f0a504c116ee3cfb854bd58a70089edc0' for hostname 'imap.gmail.com' does not match configured fingerprint(s) ['d6b90ffd06292b1724e0644563299fffc9878780'].  Please verify and set 'cert_fingerprint' accordingly if not set yet.
```

In your offlineimap configuration file there is a line that looks like this:

```bash
cert_fingerprint = cf79537f0a504c116ee3cfb854bd58a70089edc0
```

The simple fix is to quickly edit your offlineimap configuration file, change the cert fingerprint to match the new one that google is using, and you are off to the races. If you are using tmux, one way you can automate this task it to save the following script somewhere in your PATH, mark it executable and let it do the work for you:

```ruby
#!/usr/bin/env ruby
# encoding: utf-8
                   
pattern = /ERROR:.*fingerprint\s'(.*)'.for/
buffer_file = '/tmp/current_tmux_buffer'
imap_file = '~/.offlineimaprc'

`tmux capture-pane`
`tmux save-buffer #{buffer_file}`

contents = IO.readlines(buffer_file).join(' ')

exit unless pattern =~ contents

finger_print = pattern.match(contents)[1]
system("sed 's/cert_fingerprint =.*/cert_fingerprint = #{finger_print}/' #{imap_file} | tee #{imap_file}")
```
This simple ruby script just does the following:

1. Write the current contents of the tmux pane I am in, to a file that can be worked with:
  ```ruby
  `tmux capture-pane`
  `tmux save-buffer #{buffer_file}`
  ```
2. Find the new ssl fingerprint that should be used:
  ```ruby
  contents = IO.readlines(buffer_file).join(' ')

  exit unless pattern =~ contents

  finger_print = pattern.match(contents)[1]
  ```
3. Update the contents of the current configuration file with the new fingerprint:
  ```ruby
  system("sed 's/cert_fingerprint =.*/cert_fingerprint = #{finger_print}/' #{imap_file} | tee #{imap_file}")
  ```

In the last line I am just shelling out to sed to do the transform on the config file and then tee'ing the output stream back to the config file itself.

Yes this can all be done with bash scripting, personally I tend to favour python or ruby for most of my scripting needs, hence the mish mash of bash and ruby!

From now on, whenever you get that fingerprint error for google when running offlineimap sync, rerun this command and offlineimap should work again the next time you check for mail!

[Develop With Passion®](http://www.developwithpassion.com)
