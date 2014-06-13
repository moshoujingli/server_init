define :build_dev, :dest=>"#{Chef::Config['file_cache_path']}/",:src =>nil,:mod_name=>nil,:lib_path=>nil do
    params[:mod_name]||=params[:name]
    if params[:src] == nil || params[:mod_name] == nil ||params[:lib_path] == nil 
        log "build_dev not set src or name" do
            level :error
        end
    else
        src = params[:src];
        dest = params[:dest];
        mod_name = params[:mod_name];
        lib_path = params[:lib_path];
        remote_file "#{dest}/#{mod_name}" do
            source src
            owner 'root'
            group 'root'
            mode "0644"
        end
        extract 'extract #{mod_name}' do
            dest "#{dest}/#{mod_name}.dir/"
            src  "#{dest}/#{mod_name}"
        end
        bash 'isntall module' do
            cwd "#{dest}/#{mod_name}.dir/"
            code <<-EOH
                rm #{dest}/#{mod_name}
                make clean
                ./configure --prefix=#{dest}/#{mod_name}
                make&&make install
                cd #{dest}/#{mod_name} && [ ! -d lib ] && [ -d lib64 ] && ln -s lib64 lib
                [ -d "#{dest}/#{mod_name}/lib" ] && export LD_LIBRARY_PATH=#{dest}/#{mod_name}/lib:$LD_LIBRARY_PATH
                [ -d "#{dest}/#{mod_name}/bin" ] && export PATH=#{dest}/#{mod_name}/bin:$PATH
            EOH
        end
        if node['os']['platform']=='x86_64'
                    bash 'isntall module' do
            cwd "#{dest}/#{mod_name}.dir/"
            code <<-EOH
                if [ -s "$dir/lib/" ] && [ ! -s  "$dir/lib64/" ];then
                    cd $dir
                    ln -s lib lib64
                fi  
            EOH
        end
        else
            
        end
    end
end