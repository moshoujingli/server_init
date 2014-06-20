#
# Cookbook Name:: cabinate
# Recipe:: rebuild
#
# Copyright 2014, Bixiaopeng
#
# All rights reserved - Do Not Redistribute
#

#replace paraments
node.override['apache']['location']||= "${node['pref']['prefix']}/apache2/";

node.override['apache']['dir']=  "${node['apache']['location']}/conf/";
node.override['apache']['log_dir']=  "${node['apache']['location']}/logs/";
node.override['apache']['error_log']=  node['apache']['log_dir'];
node.override['apache']['access_log']=  node['apache']['log_dir'];
node.override['apache']['user']=  node['pref']['user'];
node.override['apache']['group']=  node['pref']['user'];
node.override['apache']['binary']=  "${node['apache']['location']}/bin/";
node.override['apache']['cache_dir']= "${node['apache']['location']}/cache/";

node.override['mysql']['server_root_password']= node['pref']['passwd'];
node.override['mysql']['root_network_acl']= node['pref']['root_network_acl']||node['mysql']['root_network_acl'];

node.override['memcached']['user']= node['pref']['user'];

node.override['php']['configure_options'] = ["--with-apxs2=#{node['apache']['binary']}/apxs"];

include_recipe "cabinate::setup"
# include_recipe "apache2"
# include_recipe "mysql::server"
# include_recipe "memcached"
# include_recipe "php"
# include_recipe "cabinate::install"