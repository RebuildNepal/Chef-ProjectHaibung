# Encoding: utf-8
#
# Cookbook Name:: Chef-ProjectHaibung
# Recipe:: default
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

data = Chef::EncryptedDataBagItem.load('haibung', 'secrets')

default['Chef-ProjectHaibung']['packages'] = %w(
  git
  vim
  php55u-fpm
  php55u-common
  php55u-mcrypt
  php55u-pear
  php55u-cli
  php55u-curl
  php55u-fpm
  php55u-gd
  php55u-imap
  php55u-json
  php55u-mongo
  php55u-readline
  php55u-xmlrpc
  php55u-pdo
  php55u-mysql
)
default['nginx']['default_site_enabled'] = false
default['Chef-ProjectHaibung']['app']['haibung'] = {
  user: data['user']['name'],
  root_path: '/var/www/haibung',
  port: '80',
  branch: 'devel',
  server_name: 'ProjectHaibung.com',
  repository: 'https://github.com/RebuildNepal/ProjectHaibung.git',
  socket: '/var/run/php-fpm-haibung.sock'
}
