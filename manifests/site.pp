#### defaults
# don't distribute version control metadata
File {
  ignore => ['.svn', '.git', 'CVS', '.git_placeholder' ],
  backup => false,
}

# take default path
Exec { path => '/sbin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin', }

# https://ask.puppetlabs.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/
if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

Gitosis::Repostorage{
  password  => 'trocla',
  logmode   => 'anonym'
}


#### nodes
node default {
  include ibox
}
