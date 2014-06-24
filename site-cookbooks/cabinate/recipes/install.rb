php_conf = <<-EOF
    LoadModule php5_module modules/libphp5.so
    <FilesMatch \\.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>
EOF
conf_file = "#{node['apache']['location']}/conf/httpd.conf"
bash 'link httpd with php' do
  code <<-EOF
    echo '#{php_conf}'>>#{conf_file}
    EOF
end
#add a sub site at /home/greal/cabinate.com


bash 'init test page' do
  code <<-EOF
        echo '<?php phpinfo();?>'>/home/#{node['pref']['user']}/cabinate.com/index.php
        chown #{node['pref']['user']}:#{node['pref']['user']} /home/#{node['pref']['user']}/cabinate.com/index.php
        chmod a+x /home/#{node['pref']['user']}/cabinate.com
    EOF
end

web_app "cabinate" do
    server_name 'cabinate.com'
    docroot "/home/#{node['pref']['user']}/cabinate.com"
    application_name 'cabinate'
    server_aliases ['test.cabinate.com']
end

bash 'restart server' do
  code <<-EOF
    #{node['apache']['binary']} -k restart
    EOF
end