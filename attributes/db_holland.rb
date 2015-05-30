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

default['hollandbackup']['backupsets']['default']['plugin'] = 'mysqldump'
default['hollandbackup']['backupsets']['default']['backups_to_keep'] = 24
default['hollandbackup']['backupsets']['default']['auto-purge-failures'] = 'yes'
default['hollandbackup']['backupsets']['default']['purge-policy'] = 'after-backup'
default['hollandbackup']['backupsets']['default']['estimated-size-factor'] = '1.0'

default['hollandbackup']['mysqldump']['file_per_database'] = 'yes'
default['hollandbackup']['mysqldump']['lock_method'] = 'auto-detect'
default['hollandbackup']['mysqldump']['filtering']['databases'] = '"*"'
default['hollandbackup']['mysqldump']['filtering']['tables'] = '"*"'
default['hollandbackup']['mysqldump']['stop_slave'] = 'yes'
default['hollandbackup']['schedule'] = {
  minute: '0',
  hour: '*',
  day: '*'
}
