# Puppet Standalone Monitoring Module

# == Class sensu
#
# Full description of class example_class here.
#
# === Parameters
#
# Document parameters here.
#
# [*ntp_servers*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*enc_ntp_servers*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { 'example_class':
#    ntp_servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name author@example.com
# 
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class sensuclient (
  $monitor_diskspace = false,
  $monitor_cpu = false,
  $monitor_cpu_warning = 90,
  $monitor_cpu_critical = 97,
) {

  class { 'sensu':}
  
  file { "empty_git_temp":
    path => '/tmp/sensu-git-plugins',
    ensure => absent,
    recurse => true,
    backup => false,
    force => true,
  }

  vcsrepo { '/tmp/sensu-git-plugins':
    ensure => latest,
    provider => 'git',
    force => true,
    source => 'https://github.com/sensu/sensu-plugin/',
    require => File['empty_git_temp'],
  }

  file { 'empty_sensu_plugin':
    path => '/etc/sensu/plugins/sensu-plugin',
    ensure => absent,
    recurse => true,
    backup => false,
    force => true,
    require => Vcsrepo['/tmp/sensu-git-plugins'],
  }

  exec {"move_sensu_pluings":
    command => '/bin/mv /tmp/sensu-git-plugins/lib/* /etc/sensu/plugins/',
    require => File['empty_sensu_plugin']
  }

  create_resources( 'sensuclient::check_service', hiera('sensuclient::check_service',[]) )
}