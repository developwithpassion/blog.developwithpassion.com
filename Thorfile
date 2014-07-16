require "thor/rake_compat"
require "stringex"

class Default < Thor
  include Thor::RakeCompat
  # desc "build", "Build arrayfu-#{ArrayFu::VERSION}.gem into the pkg directory"
  # def build
  #   Rake::Task["build"].execute
  # end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
  desc 'new_post', "Begin a new post"
  def new_post
    title = ask("What is the title:")
    future = ask("Future post?", limited_to: ['y', 'n']) == 'y'
    categories = ask("Categories?") 
    categories = categories.strip == "" ? "general" : categories
    target_dir = future ? "_drafts" : "source/posts"
    filename = future ? "#{title.to_url}.markdown" : "#{target_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.markdown"
    filename = File.join(target_dir, filename)
    mkdir_p target_dir

    if File.exist?(filename)
      exit if ask("#{filename} already exists. Do you want to overwrite?:", limited_to: ['y', 'n']) == 'n'
    end
    puts "Creating new post: #{filename}"
    body = <<header
---
layout: post
title: \"#{title.gsub(/&/, '&amp;')}\"
date: #{Time.now.strftime('%Y-%m-%d %H:%M')}
comments: true
published: #{!future}
categories: [#{categories}]
---
header
    open(filename, 'w') do |post|
      post.puts body
    end
    system("vim #{filename}")
  end

  desc 'promote a draft to a post', 'Publish a post stored in the drafts folder'
  def promote_draft
    drafts = Dir.glob("_drafts/*.*")
    titles = drafts.map { |draft| get_file_details(draft)[:headers]["title"] }
    post = drafts[pick_from_list(titles, "Which post do you want to publish?:")]
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

    FileUtils.mv post, updated_file_name
  end

  no_commands do
    def get_file_details(file)
      contents = File.read(file).split(/^---\s*$/)
      header = YAML::load("---\n#{contents[1]}")


      { headers: header, body: contents[2] }
    end

    def pick_from_list(list, prompt)
      list.each_with_index do |item, index|
        puts "#{index + 1}: #{item}"
      end

      index = ask(prompt).to_i
      index - 1
    end
  end
end
