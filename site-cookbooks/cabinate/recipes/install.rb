php_conf = <<-EOF
<IfModule mod_php5.c>
    <FilesMatch "\.php$">
        SetHandler application/x-httpd-php-source
    </FilesMatch>
</IfModule>
EOF
conf_file = "#{node['apache']['location']}/conf/httpd.conf"
bash 'link httpd with php' do
  code <<-EOF
    echo '#{php_conf}'>>#{conf_file}
    EOF
end