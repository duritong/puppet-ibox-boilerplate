#!/bin/bash

if [ ! -x /usr/local/bin/motd_gen.sh ]; then
  puppet apply --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ -e 'include motd::puppetmaster' > /dev/null
  puppet resource package rubygem-sqlite3 ensure=installed allow_virtual=false > /dev/null
  puppet resource package activerecord ensure=3.2.19 provider=gem allow_virtual=false > /dev/null
fi
if [ ! -f /etc/puppet/troclarc.yaml ]; then
  puppet apply --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ -e 'include trocla::config' > /dev/null
fi

puppet apply --show_diff --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ --storeconfigs --thin_storeconfigs --dbadapter=sqlite3 --dblocation=/etc/puppet/ibox/storeconfigs.sqlite3 --dbmigrate /etc/puppet/ibox/manifests/ | tee -a /var/log/ibox.log
