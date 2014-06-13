comps = ["apr","apr-util","apache2"]


package "tar" do
  action :install
end
package "pcre-devel" do
  action :install
end

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

comps.each{|comp|

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
}




bash 'install' do
  cwd "#{Chef::Config['file_cache_path']}/exp"
  code <<-EOH
    mv apr apache2/srclib/apr
    mv apr-util apache2/srclib/apr-util
    cd apache2
    ./configure --prefix='/usr/local/apache2/' #{node['apache2']['build_options']}
    make&&make install
    cp /usr/local/apache2/bin/apachectl /etc/init.d/httpd
    head -n1 /usr/local/apache2/bin/apachectl >/etc/init.d/httpd
    echo '# chkconfig: 35 85 15'>>/etc/init.d/httpd
    echo '# description: Activates/Deactivates Apache 2.4.6'>>/etc/init.d/httpd
    tail /usr/local/apache2/bin/apachectl -n +2>>/etc/init.d/httpd
    chkconfig --add httpd
    chkconfig httpd on
    service httpd start
    EOH
end