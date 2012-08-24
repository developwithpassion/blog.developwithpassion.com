#!/usr/bin/env ruby

require 'fileutils'
require 'configatron'

namespace :dwp do
  def delayed
    Configatron::Delayed.new do
      yield
    end
  end

  dev_settings = "#{`whoami`.chomp}.rb"

  task :_load_settings do
    unless File.exists?(dev_settings)
      puts "You need to provide a settings file that contains you ssh user. Run the initialize_dev_settings task and edit the settings file based on your user preferences"
      exit
    end

    load dev_settings if File.exists?(dev_settings)

    configs = {
      :blog_folder => File.join(File.dirname(File.expand_path(__FILE__)),"_generated"),
      :prune_items => %w[drafts],
      :ssh => {
        :host => "slicehost"
      },
      :server_git_repository => delayed{ "#{configatron.ssh.user}@#{configatron.ssh.host}:blog.git" }
    }

    configatron.configure_from_hash configs
  end

  desc "Create a copy of the dev settings file and allow you to update its contents"
  task :initialize_dev_settings do
    `cp dev_settings_template.rb #{dev_settings}` unless File.exists?(dev_settings)
  end

  desc "Update the files that will get pushed to the web server"
  task :refresh_files_for_server => :_load_settings do
    `git clone #{configatron.server_git_repository} #{configatron.blog_folder}` unless File.exist?(configatron.blog_folder)
    Dir.chdir(configatron.blog_folder) do
      `git reset --hard`
      `git pull origin master`
    end
    FileUtils.cp_r "#{configatron.public_dir}/.", configatron.blog_folder
  end

  desc "Create the remote pointing at octopress"
  task :create_octopress_remote do
    `git remote add octopress git://github.com/imathis/octopress.git`
  end

  desc "Update the remote git server"
  task :push_to_server => [:_load_settings,:generate,:refresh_files_for_server] do
    Dir.chdir(configatron.blog_folder) do
      `git add -A`
      `git commit -m "New posts"`
      `git push origin master`
    end
  end
end
