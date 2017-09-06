# class oddjob::mkhomedir
#
# This configures the oddjob-mkhomedir
#
# @param umask
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class oddjob::mkhomedir (
  Simplib::Umask $umask = '0027'
) {
  validate_umask($umask)

  include 'oddjob'

  if $facts['os']['name'] in ['RedHat','CentOS'] {
    $_libdir = '/usr/libexec'
  }
  elsif $facts['os']['name'] in ['Debian','Ubuntu'] {
    if $facts['architecture'] == 'amd64' {
      $_libdir = '/usr/lib/x86_64-linux-gnu'
    }
    else {
      fail("Only 64-bit ${facts['os']['name']} is supported by '${module_name}'")
    }
  }
  else {
    fail("OS '${facts['os']['name']}' not supported by '${module_name}'")
  }

  package { 'oddjob-mkhomedir': ensure => 'latest' }

  file { '/etc/oddjobd.conf.d/oddjobd-mkhomedir.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['oddjobd'],
    content => template('oddjob/etc/oddjobd.conf.d/oddjobd-mkhomedir.conf.erb')
  }
}
