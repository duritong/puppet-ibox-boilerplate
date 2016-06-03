#!/bin/bash

# https://tickets.puppetlabs.com/browse/FACT-1289
grep -q 'when /virtualbox/i' /usr/share/ruby/vendor_ruby/facter/virtual.rb
if [ $? -gt 0 ]; then
 pushd /
 patch -p 0 <<END
--- /usr/share/ruby/vendor_ruby/facter/virtual.rb_old 2015-12-21 17:42:05.909487491 +0100
+++ /usr/share/ruby/vendor_ruby/facter/virtual.rb 2015-12-21 17:40:43.533994750 +0100
@@ -256,6 +256,8 @@
         'xenu'
       when /ibm_systemz/i
         'zlinux'
+      when /virtualbox/i
+        'virtualbox'
       else
         output.to_s.split("\n").last
       end
END
 popd
fi

if [ ! -d /var/lib/puppetdb ]; then
  [ -f /etc/yum.repos.d/puppetlabs.repo ] || rpm -Uvh http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm
  # setup puppetdb & other things for local apply
  puppet apply --parser=future --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/ec/puppet/ibox/modules/ibox/ <<EOF | tee -a /var/log/ibox.log
Exec { path => '/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin', }
exec{'generate_certs':
  command => 'puppet master --masterport 8141; sleep 10; kill \`cat /var/run/puppet/master.pid\`',
  creates => "/var/lib/puppet/ssl/certs/\${::fqdn}.pem",
  before  => Package['puppetdb'],
}
class{'puppetdb::globals':
  version => '2.3.8-1.el7'
}
class{'::puppetdb':
  database        => 'embedded',
  manage_dbserver => false,
  manage_firewall => false,
} -> package {'puppetdb-terminus':
  ensure => installed,
} -> file{'/etc/puppet/puppetdb.conf':
  content => "[main]\nserver = \${::fqdn}\nport = 8081\n",
  notify  => Service['puppetdb'],
} -> file{'/etc/puppet/routes.yaml':
  content => '---
apply:
  catalog:
    terminus: compiler
    cache: puppetdb
  facts:
    terminus: facter
    cache: puppetdb_apply
',
}
include ::motd::puppetmaster
include ::trocla::yaml
include ::trocla::master::hiera
include ::iuid::config
EOF
fi

puppet apply --parser=future --show_diff --hiera_config=/etc/puppet/ibox/hieradata/config.yaml --modulepath=/etc/puppet/ibox/modules/public/:/etc/puppet/ibox/modules/ibox/ --storeconfigs --storeconfigs_backend=puppetdb --report --reports=puppetdb /etc/puppet/ibox/manifests/ $@ | tee -a /var/log/ibox.log
