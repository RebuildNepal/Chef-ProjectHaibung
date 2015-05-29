# Encoding: utf-8
#
# Cookbook Name:: ProjectHaibung
# Recipe:: api_test
#
# Copyright 2015, Suraj Thapa
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

app_name = 'haibung-test'
app_params = node['Chef-ProjectHaibung']['app'][app_name]

# Create php-fpm pool
template "/etc/php-fpm.d/#{app_name}.conf" do
  source 'php-fpm/config.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(
    'poolname'      => app_name,
    'listen'        => app_params['socket'],
    'listen_user'   => node['nginx']['user'],
    'listen_group'  => node['nginx']['group'],
    'user'          => app_params['user'],
    'group'         => app_params['user']
  )
  notifies :restart, 'service[php-fpm]', :delayed
end

addrs = node[:network][:interfaces][:eth0][:addresses]
public_net = addrs.select { |addr, info| info['family'] == 'inet' }
public_ip = public_net.keys[0]
server_name = "#{app_params['server_name']} #{public_ip}"

template ::File.join(node['nginx']['dir'], 'sites-available/', "#{app_name}.conf") do
  source 'nginx/php-vhost.erb'
  owner node['nginx']['user']
  group node['nginx']['group']
  mode '644'
  variables(
    'server_name' => server_name,
    'app_name' => app_name,
    'app_config' => app_params
  )
  notifies :reload, 'service[nginx]', :delayed
end

application app_name do
  path app_params['root_path']
  owner app_params['user']
  group app_params['user']
  repository app_params['repository']
end

# Create soft link
link ::File.join(node['nginx']['dir'], 'sites-enabled/', "#{app_name}.conf") do
  to ::File.join(node['nginx']['dir'], 'sites-available/', "#{app_name}.conf")
  notifies :reload, 'service[nginx]', :delayed
end
