#!/bin/bash

test -x /usr/local/bin/motd_gen.sh || puppet apply --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ -e 'include motd::puppetmaster'
puppet apply --show_diff --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ /etc/puppet/ibox/manifests/site.pp
