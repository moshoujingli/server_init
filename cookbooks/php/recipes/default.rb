node['php']['packages'].each{|pkg_name|

  package pkg_name  do
    ignore_failure true
    action :install
  end
}

bash 'clean' do
  cwd "#{Chef::Config['file_cache_path']}"
  code <<-EOH
    rm -rf ./exp
    EOH
end

bash 'dev' do
  code <<-EOH
    yum groupinstall -y "development tools"
    EOH
end

#check if we need the comps
if platform?("centos")
  if node['os']['version'].start_with("6")?
    rpms = node['php']['rpms']
    rpms.each{|rpm|
      rpm_full_name = "#{rpm}.#{node['os']['platform']}.rpm"
      rpm_path = "https://s3-ap-northeast-1.amazonaws.com/servercomp/dep_comp/#{node['os']['platform']}/#{rpm_full_name}";
      remote_file "#{Chef::Config['file_cache_path']}/#{rpm_full_name}" do
        source rpm_path
        owner 'root'
        group 'root'
        mode "0644"
      end
      bash 'installrpm' do
        code <<-EOH
          rpm -i #{Chef::Config['file_cache_path']}/#{rpm_full_name}
          EOH
      end
    }
  end
end
#download
comp='php'
remote_file "#{Chef::Config['file_cache_path']}/#{comp}" do
  source node[comp]['src_url'][0]
  owner 'root'
  group 'root'
  mode "0644"
end


extract 'extract #{comp}' do
  dest "#{Chef::Config['file_cache_path']}/exp/#{comp}/"
  src "#{Chef::Config['file_cache_path']}/#{comp}"
end
#install libs



#compile php
# bash 'install' do
#   cwd "#{Chef::Config['file_cache_path']}/exp/#{comp}"
#   code <<-EOH
#     ./configure --prefix='/usr/local/php/' #{node['php']['build_options']}
#     make&&make install
#     service httpd restart
#     EOH
# end