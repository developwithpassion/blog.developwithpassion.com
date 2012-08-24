---
layout: post
title: "Interested in trading in your NAnt builds (a teaser)?"
comments: true
date: 2008-10-30 09:00
categories:
- continuous integration
---

I thought I would demo how I have been using powershell to do my automated build (currently with the help of my own modified version of [PSake](http://code.google.com/p/psake/)). The following script leverages both powershell and PSake and with the power of a full blown scripting language I have consolidated disparate build files into a single PSake script with a lot less verbosity:  
  

{% codeblock powershell %}

includes .\build_utilities.ps1 properties 
{
  $project_name = "nothinbutdotnetstore" 
}
properties
{

#directories $framework_dir = "$env:systemroot\microsoft.net\framework\v2.0.50727"  $base_dir = [System.IO.Directory]::GetParent("$pwd") $build_dir = "$base_dir\build"  $build_tools_dir = "$build_dir\tools"  $build_artifacts_dir = "$build_dir\artifacts"  $config_dir = "$build_dir\config"  $third_party_dir = "$base_dir\thirdparty"  $third_party_tools_dir = "$third_party_dir\tools"  $third_party_lib_dir = "$third_party_dir\lib"  $product_dir = "$base_dir\product" $docs_dir = "$base_dir\docs"  $sql_dir = "$build_dir\sql"  $sql_ddl_dir = "$sql_dir\ddl" $sql_data_dir = "$sql_dir\data" $thirdparty_lib_dir = "$third_party_dir\lib" $docs_dir = "$base_dir\docs" $config_dir = "$build_dir\config" $product_dir = "$base_dir\product"  $product_app_dir = "$product_dir\app" $product_test_dir = "$product_dir\test" $web_ui_dir = "$product_app_dir\nothinbutdotnetstore.web.ui" $coverage_dir = "$build_artifacts_dir\coverage"  $compile_dir = $build_artifacts_dir $deploy_dir = "$build_dir\deploy"  $deploy_web_dir = "$deploy_dir\web"  $deploy_web_app_dir = "$deploy_web_dir\app"  $deploy_web_src_dir = "$deploy_web_dir\source"  $deploy_web_src_dir_bin = "$deploy_web_src_dir\bin"  $deploy_web_src_dir_images = "$deploy_web_src_dir\images" 
}
properties

{

#filesets $all_template_files = get_file_names(get-childitem -path $build_dir -recurse -filter "*.template") $third_party_libraries = get_file_names(get-childitem -path $third_party_lib_dir -recurse -filter *.dll) $third_party_tools = get_file_names(get-childitem -path $third_party_tools_dir -recurse -filter *.dll) $all_third_party_dependencies = $third_party_tools + $third_party_libraries $all_sql_ddl_files = get_file_names(get-childitem -path $sql_ddl_dir -recurse -filter *.sql) $all_sql_data_files = get_file_names(get-childitem -path $sql_data_dir -recurse -filter *.sql) $all_web_images = get_file_names(get-childitem -path $web_ui_dir -recurse -include @("*.jpg","*.gif")) $all_web_code_files = get_file_names(get-childitem -path $web_ui_dir -recurse -include @("*.cs")) $all_web_markup_files = get_file_names(get-childitem -path $web_ui_dir -recurse -include @("*.aspx","*.css","*.master","*.js",
      "*.ascx","*.asax")) 
}
properties
{
#files $studio_app_config = "$product_app_dir\NothinButDotNetStore\bin\debug\NothinButDotNetStore.dll.config" $log4net_config = "$config_dir\log4net.config.xml" $now = [System.DateTime]::Now $project_lib = "$project_name.dll" $db_timestamp = "$sql_dir\db.timestamp" $nant_properties_file = "$build_dir\local_properties.xml" 
}
properties
{
#logging $log_dir = "$build_dir\logs" $log_file_name = "$
  {
    log_dir
  }
  \log.txt" $log_level = "DEBUG" 
}
properties
{
#asp app mapping settings $executable="$framework_dir\aspnet_isapi.dll" $extension = ".store" $verbs = "GET,POST" 
}
properties
{
#transient folders for build process $transient_folders = $build_artifacts_dir, $deploy_web_app_dir, $deploy_web_src_dir, $deploy_web_src_dir_bin, $deploy_web_src_dir_images 
}
properties
{
#machine dependent external properties . $build_dir\local_properties.ps1 $app_config = "$config_dir\$($local_settings.app_config_template.replace(`".template`",[System.String]::empty))";
  $run_url = "http://$env:computername/$($local_settings.virtual_directory_name)/$($local_settings.startup_page)" 
}
task default -depends init task build_db -depends init
{
  if (files_have_changed $all_sql_ddl_files $db_timestamp -eq $true) 
  {
    process_sql_files $all_sql_ddl_files $local_settings.osql_exe $local_settings.osql_connectionstring 
  }
  else 
  {
    "DB is upto date" 
  }
  touch $db_timestamp 
}
task load_data 
{
  process_sql_files $all_sql_data_files $local_settings.osql_exe $local_settings.osql_connectionstring 
}
task init -depends clean
{
  $transient_folders | foreach-object
  {
    make_folder $_ 
  }
  expand_all_template_files $all_template_files $local_settings 
}
task clean
{
  $transient_folders | foreach-object
  {
    drop_folder $_
  }

}
task compile -depends init
{
  $nant = "$build_tools_dir\nant\bin\nant.exe" $build_file = "$build_dir\project_simple.build" $command_line = "-buildfile:$build_file -D:project_lib=$build_artifacts_dir\$project_name.dll -D:project_test_lib=$build_artifacts_dir\$project_name.test.dll compile" exec $nant $command_line 
}
task make_iis_dir
{
  make_iis_dir "nothinbutdotnetstore" "$deploy_web_app_dir" add_iis_mapping "nothinbutdotnetstore" $false $extension $verbs $executable 
}
task test -depends compile
{
  $all_third_party_dependencies | foreach-object 
  {
    copy-item -path $_ -destination $build_artifacts_dir
  }
  copy-item -path $log4net_config -destination $build_artifacts_dir copy-item -path $app_config -destination "$build_artifacts_dir\$project_name.test.dll.config" $xunit = "$third_party_tools_dir\mbunit\bin\MbUnit.Cons.exe" $command_line = "$build_artifacts_dir\$project_name.test.dll $($local_settings.xunit_console_args)" exec $xunit $command_line 
}
task deploy -depends compile,make_iis_dir
{
  $third_party_libraries | foreach-object 
  {
    copy-item -path $_ -destination $deploy_web_src_dir_bin
  }
  copy-item "$build_artifacts_dir\$project_lib" $deploy_web_src_dir_bin copy-item $log4net_config $deploy_web_src_dir copy-item "$app_config" "$deploy_web_src_dir\web.config" $all_web_images | foreach-object
  {
    copy-item -path $_ -destination $deploy_web_src_dir_images
  }
  $all_web_code_files | foreach-object
  {
    copy-item -path $_ -destination $deploy_web_src_dir
  }
  $all_web_markup_files | foreach-object
  {
    copy-item -path $_ -destination $deploy_web_src_dir 
  }
  exec "$framework_dir\aspnet_compiler.exe" "-v /$($local_settings.virtual_directory_name) -u -p $deploy_web_src_dir $deploy_web_app_dir" 
}
task run_web_app -depends deploy
{
  exec "$($local_settings.browser_exe)" "$run_url" 
}
 
{% endcodeblock %}



The prep material for the course is going to be updated with powershell based build scripts also, so all new students of the [Nothin But .Net](http://www.developwithpassion.com/training.oo) course can enjoy getting a glimpse of build automation with powershell.


I am hoping to do some posts on this in the next couple of weeks.


Develop With Passion!!




