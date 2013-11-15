define sensuclient::check_service(
  $check_name = $title,
  $handlers = 'default',
  $subscribers = 'check_service',
  $service_name = undef,
  $interval = 60,
) {
  
  #$check_script = '/etc/sensu/plugins/check_procs.rb'
  $check = "/etc/sensu/plugins/check-procs.rb -p ${service_name} -C 1"
  # notify { $check:}
  if !defined(File['/etc/sensu/plugins/check-procs.rb']) {
    file { '/etc/sensu/plugins/check-procs.rb':
      ensure => present,
      source => 'puppet:///modules/sensuclient/plugins/processes/check-procs.rb',
    }
  }
  
  
  sensu::check { $check_name:
    handlers => $handlers,
    command => $check,
    subscribers => subscribers,
    interval => $interval,
  }
}