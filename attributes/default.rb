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

default['Chef-ProjectHaibung']['vhost']['staging'] = {
  port: '80',
  branch: 'devel',
  server_name: 'ProjectHaibung.com'
}

default['Chef-ProjectHaibung']['vhost']['production'] = {
  port: '80',
  branch: 'master',
  server_name: 'ProjectHaibung.org'
}
