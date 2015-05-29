# Encoding: utf-8
name 'Chef-ProjectHaibung'
maintainer 'Suraj Thapa'
maintainer_email 'thapa.suraj751@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Chef-ProjectHaibung'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.7.0'

depends 'yum-epel'
depends 'php'
depends 'rackspace_iptables'
depends 'application'
depends 'yum-ius'
depends 'mysql'
depends 'nginx'
