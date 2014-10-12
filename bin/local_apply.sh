#!/bin/bash

[ -x /usr/local/bin/motd_gen.sh ] || puppet apply --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ -e 'include motd::puppetmaster'
puppet resource package rubygem-sqlite3 ensure=installed > /dev/null
puppet resource package activerecord ensure=3.2.19 provider=gem > /dev/null

puppet apply --show_diff --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ --storeconfigs --thin_storeconfigs --dbadapter=sqlite3 --dblocation=/etc/puppet/ibox/storeconfigs.sqlite3 --dbmigrate /etc/puppet/ibox/manifests/site.pp
