class profile::linux_nginx {
  package { 'nginx':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<h1>Managed by Puppet</h1>\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => Package['nginx'],
  }
}
