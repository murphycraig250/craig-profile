# @summary Installs and configures the Nginx web server
#
# This class installs the Nginx package, ensures the service is running, 
# and manages a basic "Managed by Puppet" index.html file.
#
# @example
#   include profile::linux_nginx
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
