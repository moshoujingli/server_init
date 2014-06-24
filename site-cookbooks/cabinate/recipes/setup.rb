user_account node['pref']['user'] do
  home      "/home/#{node['pref']['user']}"
end

directory "/home/#{node['pref']['user']}/cabinate/" do
  owner node['pref']['user']
  group node['pref']['user']
  mode 00644
  action :create
end