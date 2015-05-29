#!/bin/bash

LOGFILE="/var/log/bootstrap.log.$$"
CHEF_CLIENT_VERSION="12"
organization=""

date > $LOGFILE
echo "Starting bootstrap" >> $LOGFILE
echo "organization parameter: %organization%" >> $LOGFILE
echo "run_list parameter: %run_list%" >> $LOGFILE

CHEFSERVERURL='%chef_server_url%'
if [ -n $CHEFSERVERURL ]; then
  echo "chef_server_url parameter: not passed" >> $LOGFILE
  CHEFSERVERURL="https://api.opscode.com/organizations/%organization%"
else
  echo "chef_server_url parameter: $CHEFSERVERURL" >> $LOGFILE
  CHEFSERVERURL="%chef_server_url%"
fi

echo "Storing validation key in /etc/chef/validator.pem"
mkdir /etc/chef /var/log/chef &>/dev/null
cat >/etc/chef/validator.pem <<EOF
%validation_key%
EOF

echo "Storing validation key in /etc/chef/encrypted_data_bag_secret"
cat >/etc/chef/encrypted_data_bag_secret <<EOF
%encryption_key%
EOF

echo "Creating a minimal /etc/chef/client.rb" >> $LOGFILE
touch /etc/chef/client.rb
cat >/etc/chef/client.rb <<EOF
  log_level        :info
  log_location     STDOUT
  chef_server_url  "$CHEFSERVERURL"
  validation_key         "/etc/chef/validator.pem"
  validation_client_name "%organization%-validator"
  environment   "%environment%"
EOF

echo "Creating a minimal /etc/chef/first-boot.json" >> $LOGFILE
touch /etc/chef/first-boot.json
cat >/etc/chef/first-boot.json <<EOF
{"run_list":[%run_list%]}
EOF

if [ ! -f /usr/bin/chef-client ]; then
  echo "Installing chef using omnibus installer" >> $LOGFILE
  # adjust to install the latest vs. a particular version
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v $CHEF_CLIENT_VERSION -- &>$LOGFILE
  echo "Installation of chef complete" >> $LOGFILE
fi

/usr/bin/chef-client -j /etc/chef/first-boot.json >> $CHEFRUNLOGFILE

service chef-client restart

date >> $LOGFILE

exit 0
