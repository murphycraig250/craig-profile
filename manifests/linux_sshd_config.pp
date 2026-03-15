# @summary Configures sshd config for linux
# 
# Manages the sshd_config file via template

class profile::linux_sshd_config {
  file { '/etc/ssh/sshd_config':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('profile/sshd_config.erb'),
    notify  => Service['ssh'],
  }

  file { '/etc/ssh/sshd_config.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  service { 'ssh':
    ensure => running,
    enable => true,
  }
}
