---
layout: post
title: "Expanding template files in Ruby (for builds)"
comments: true
date: 2009-09-09 09:00
categories:
- productivity
---

When doing builds with Ruby and Rake, one of the things I often like to be able to do is expanding a set of template files to a set of corresponding files with the appropriate tokenized settings replaced.   
Here is an example of a tokenized app.config file (only the important section of the file has been included for brevity):   
<connectionStrings>   
 <add name="App"    
 connectionString="@config_connectionstring@"    
 providerName="System.Data.SqlClient"/>    
</connectionStrings>   
Notice that the only interesting thing to look at here is the @config_connectionstring@ value. This is a value that should be swapped out during the build process with settings specific to the machine the build is taking place on. The place where these settings are defined is in a build specific file named local_properties.rb. Here is a small section of one these files:   
require "project.rb"   
class LocalSettings    
 attr_reader :settings    
 def initialize    
 @settings = {    
 :app_config_template => "app.config.xp.template" ,    
 #app_config_template = "app.config.vista.template" ;   
 :osql_connectionstring => "-E",   
 :path_to_runtime_log4net_config => "artifacts\log4net.config.xml",    
 :initial_catalog => "#{Project.name}",    
 :database_provider => "System.Data.SqlClient" ,    
 :database_path => "C:\\databases"    
}    
@settings[:config_connectionstring] = "data source=(local);Integrated Security=SSPI;Initial Catalog=#{@settings[:initial_catalog]}"   
Notice that the goal of this class is to just define a dictionary. These settings indicate values that will be used specific to each machine that is performing a build (which means each machine potentially gets its own different set of settings. To take a file and have it expand out into a file with all the tokens replaced, I wrote a quick ruby class named TemplateFile that looks like the following:   
class TemplateFile   
 attr_reader :template_file_name    
 attr_reader :output_file_name   
 def initialize(template_file_name)   
 @template_file_name = template_file_name    
 @output_file_name = template_file_name.gsub('.template','')    
 end   
 def generate(settings_dictionary)   
 generate_to(@output_file_name,settings_dictionary)    
 end   
 def generate_to_directory(output_directory,settings_dictionary)   
 generate_to(File.join(output_directory,File.basename(@output_file_name)),settings_dictionary)    
 end   
 def generate_to_directories(output_directories,settings_dictionary)   
 output_directories.each do |directory|    
 generate_to_directory(directory,settings_dictionary)    
 end    
 end   
 def generate_to(output_file,settings_dictionary)   
 File.delete?(output_file)   
 File.open_for_write(output_file) do|generated_file|   
 File.open_for_read(@template_file_name) do|template_line|    
 settings_dictionary.each_key do|key|    
 template_line = template_line.gsub("@#{key}@","#{settings_dictionary[key]}")    
 end    
 generated_file.puts(template_line)    
 end    
 end    
 end   
 def to_s()   
 "Template File- Template:#{@template_file_name} : Output:#{@output_file_name}"    
 end   
end   
The goal of this class is to just take a named template file and generate it out to one or more locations while making the variable substitution from a provided dictionary of settings. All of these things come together during the build process as follows:   
template_files = TemplateFileList.new('**/*.template')   
desc 'expands all of the template files in the project'   
task :expand_all_template_files do    
 template_files.generate_all_output_files(local_settings.settings)    
end   
All of the template files in the project are grabbed into an array and the expansion happens during the generate_all_output_files method. For special files you can also create a TemplateFile to specifically point at that file and generate it to multiple locations:   
#configuration files   
config_files = FileList.new(File.join('product','config','*.template')).select{|fn| ! fn.include?('app.config')}    
app_config = TemplateFile.new(File.join('product','config',local_settings[:app_config_template]))   
task :from_ide do   
 app_config.generate_to(File.join(project_startup_dir,"#{Project.startup_config}"),local_settings.settings)    
 app_config.generate_to(File.join(project_test_dir,"#{Project.tests_dir}.dll.config"),local_settings.settings)   
 config_files.each do |file|   
 TemplateFile.new(file).generate_to_directories([project_startup_dir,project_test_dir],local_settings.settings)    
 end    
end   
This makes it a snap to add new project specific configuration files as long as I follow a convention that all new "config" files go into the product/config folder (a build specific folder) with a .[extension].template extension. This way, the new file will get picked up without issue and can have tokenized values in the file easily replaced with machine specific settings.   
Develop With Passion




