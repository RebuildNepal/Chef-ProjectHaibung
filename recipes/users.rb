# Encoding: utf-8
#
# Cookbook Name:: Chef-ProjectHaibung
# Recipe:: users
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

data = Chef::EncryptedDataBagItem.load('vault', 'secrets')

user data['user']['name'] do
  home data['user']['home']
  action :create
end

directory "#{data['user']['home']}/.ssh" do
  owner data['user']['name']
end

# Suraj ssh key
file "#{data['user']['home']}/.ssh/authorized_keys" do
  action :create
  owner data['user']['name']
  mode '0600'
  content data['authorized_keys'].join("\n")
end

template '/etc/sudoers' do
  source '/sudo/sudoers.erb'
  owner 'root'
  group 'root'
  mode '440'
  variables(
    'user'     => data['user']['name']
  )
end
