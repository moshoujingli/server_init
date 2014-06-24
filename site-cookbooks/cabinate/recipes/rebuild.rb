#
# Cookbook Name:: cabinate
# Recipe:: rebuild
#
# Copyright 2014, Bixiaopeng
#
# All rights reserved - Do Not Redistribute
#

#replace paraments

node.override['apache']['dir']=  "#{node['apache']['location']}/";
node.override['apache']['log_dir']=  "#{node['apache']['location']}/logs/";
node.override['apache']['pid_file']=  "#{node['apache']['log_dir']}/httpd.pid";
node.override['apache']['error_log']=  'error.log';
node.override['apache']['access_log']=  'access.log';
node.override['apache']['user']=  node['pref']['user'];
node.override['apache']['group']=  node['pref']['user'];
node.override['apache']['binary']=  "#{node['apache']['location']}/bin/httpd";
node.override['apache']['cache_dir']= "#{node['apache']['location']}/cache/";
node.override['apache']['lib_dir']     = "#{node['apache']['location']}/lib/"
node.override['apache']['libexecdir']  = "#{node['apache']['location']}/modules/"

node.override['mysql']['server_root_password']= node['pref']['passwd'];
node.override['mysql']['root_network_acl']= node['pref']['root_network_acl']||node['mysql']['root_network_acl'];

node.override['memcached']['user']= node['pref']['user'];

node.override['php']['extra_option'] = %W{                                          
                                          --enable-shared 
                                          --with-libxml-dir 
                                          --enable-opcache 
                                          --enable-mysqlnd 
                                          --enable-zip 
                                          --with-zlib-dir 
                                          --with-pdo-mysql 
                                          --with-jpeg-dir 
                                          --with-freetype-dir 
                                          --with-curl
                                        };

include_recipe "cabinate::setup"
# include_recipe "apache2"
# include_recipe "mysql::server"
# include_recipe "memcached"
# include_recipe "php"
# include_recipe "cabinate::install"