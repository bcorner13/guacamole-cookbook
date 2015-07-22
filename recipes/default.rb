#
# Cookbook Name:: guacamole
# Recipe:: default
#
# Copyright (c) 2015 Matt Stratton, Licensed under the Apache License, Version 2.0

# Install package dependencies

# Core dependencies

%w[gcc gcc-c++ cairo-devel libpng-devel uuid-devel].each do |package|
  package package do
    action :install
  end
end

# Optional dependencies

%w[freerdp-devel pango-devel libssh2-devel openssl-devel]

remote_file "#{Chef::Config[:file_cache_path]}/guacamole-server-#{node['guacamole']['version']}.tar.gz" do
  source "http://tcpdiag.dl.sourceforge.net/project/guacamole/current/source/guacamole-server-#{node['guacamole']['version']}.tar.gz"
  mode '0644'
end

bash "build-and-install-guacamole" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf guacamole-server-#{node['guacamole']['version']}.tar.gz
    (cd guacamole-server-#{node['guacamole']['version']} && ./configure --with-init-dir=/etc/init.d)
    (cd guacamole-server-#{node['guacamole']['version']} && make && make install)
    (cd guacamole-server-#{node['guacamole']['version']} && ldconfig)
  EOF
end

service 'guacd' do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

# This is where we configure the guacamole-client. May need to refactor into a separate recipe later

include_recipe 'tomcat::default'

directory '/etc/guacamole'

directory '/var/lib/guacamole'

directory "#{node['tomcat']['home']}/.guacamole"

remote_file "/var/lib/guacamole/guacamole.war" do
  source "http://iweb.dl.sourceforge.net/project/guacamole/current/binary/guacamole-#{node['guacamole']['version']}.war"
  mode '0644'
end

template '/etc/guacamole/guacamole.properties' do
  source 'guacamole.properties.erb'
  mode '0644'
  notifies :restart, 'service[tomcat_service]'
end

template '/etc/guacamole/user-mapping.xml' do
  source 'user-mapping.xml.erb'
  mode '0644'
  notifies :restart, 'service[tomcat_service]'
end

link "#{node['tomcat']['webapp_dir']}/guacamole.war" do
  to '/var/lib/guacamole/guacamole.war'
end

link "#{node['tomcat']['home']}/.guacamole/guacamole.properties" do
  to '/etc/guacamole/guacamole.properties'
end

service 'tomcat_service' do
  service_name node['tomcat']['base_instance']
  supports :restart => true
  action :nothing
end
