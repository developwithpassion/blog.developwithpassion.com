require "thor/rake_compat"
require "stringex"
require "fileutils"
require 'ostruct'

class PostTemplates
  class << self
    def post(options)
      options = OpenStruct.new(options)
      body = <<header
---
layout: post
title: \"#{options.title.gsub(/&/, '&amp;')}\"
date: #{Time.now.strftime('%Y-%m-%d %H:%M')}
comments: true
published: #{!options.future}
categories: [#{options.categories}]
---
header
      end
    end
end

class Default < Thor
  include Thor::RakeCompat

  desc 'new_post', "Begin a new post"
  def new_post
    title = ask("What is the title:")
    future = ask("Future post?", limited_to: ['y', 'n']) == 'y'
    categories = ask("Categories?") 
    categories = categories.strip == "" ? "general" : categories
    target_dir = future ? "_drafts" : "source/_posts"
    filename = future ? "#{title.to_url}.markdown" : "#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.markdown"
    filename = File.join(target_dir, filename)

    if File.exist?(filename)
      exit if ask("#{filename} already exists. Do you want to overwrite?:", limited_to: ['y', 'n']) == 'n'
    end
    puts "Creating new post: #{filename}"
    open(filename, 'w') do |post|
      post.puts PostTemplates.post({
        title: title,
        future: future,
        categories: categories
      })
    end
    system("vim #{filename}")
  end

  desc 'promote a draft to a post', 'Publish a post stored in the drafts folder'
  def promote_draft
    current_drafts = Dir.glob("_drafts/*.*")
    post = pick_from_list(drafts, title_mapper, "Which post do you want to publish?:")
    publication_date = Time.now
    long_date = publication_date.strftime("%Y-%m-%d %H:%M")
    short_date = publication_date.strftime("%Y-%m-%d")
    updated_file_name = "source/_posts/#{short_date}-#{File.basename(post)}"

    details = get_file_details(post)
    headers = details[:headers]
    headers["date"] = long_date
    headers["published"] = true

    File.open(post, 'w+') do |file|
      file.puts YAML::dump(headers)
      file.puts "---\n"
      file.puts details["body"]
      file.puts "\n"
    end

    FileUtils.cp post, updated_file_name
  end

  desc 'edit_draft', 'Edit an existing draft'
  def edit_draft
    file = pick_from_list(drafts, title_mapper, "Which draft do you want to edit")
    system("vim #{file}")
  end

  desc 'delete_draft', 'Edit an existing draft'
  def delete_draft
    file = pick_from_list(drafts, title_mapper, "Which draft do you want to edit")
    FileUtils.rm file
  end

  no_commands do
    def get_file_details(file)
      contents = File.read(file).split(/^---\s*$/)
      header = YAML::load("---\n#{contents[1]}")


      { headers: header, body: contents[2] }
    end

    def drafts
      Dir.glob("_drafts/*.*")
    end

    def pick_from_list(list, mapper, prompt)
      list.each_with_index do |item, index|
        puts "#{index + 1}: #{mapper.call(item)}"
      end

      index = ask(prompt).to_i
      list[index - 1]
    end

    def title_mapper
      return -> (post) { get_file_details(post)[:headers]["title"] }
    end
  end
end
