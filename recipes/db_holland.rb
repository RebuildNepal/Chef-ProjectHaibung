# Encoding: utf-8
#
# Cookbook Name:: Chef-ProjectHaibung
# Recipe:: db_holland
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
#

include_recipe 'hollandbackup::default'
include_recipe 'hollandbackup::mysqldump'
include_recipe 'hollandbackup::main'
include_recipe 'hollandbackup::backupsets'

data = Chef::EncryptedDataBagItem.load('haibung', 'secrets')

## add holland user
include_recipe 'database::mysql'
mysql_database_user node['hollandbackup']['mysqldump']['mysql_connection']['user'] do
  connection(
    host: 'localhost',
    username: 'root',
    password: data['db']['password']
  )
  password node['hollandbackup']['mysqldump']['mysql_connection']['password']
  host 'localhost'
  privileges [:usage, :select, :'lock tables', :'show view', :reload, :super, :'replication client']
  retries 2
  retry_delay 2
  action [:create, :grant]
end

cron 'mysql holland backup' do
  minute "#{node['hollandbackup']['schedule']['minute']}"
  hour "#{node['hollandbackup']['schedule']['hour']}"
  day "#{node['hollandbackup']['schedule']['day']}"
  command  '/usr/sbin/holland bk'
  action :create
end
