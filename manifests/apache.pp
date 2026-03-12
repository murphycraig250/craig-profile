# @summary Installs and configures Apache web server
#
# This class installs the Apache package (httpd or apache2 depending on the OS), 
# ensures the service is running and enabled, and manages a basic index.html file 
# with a message that can be customized via Hiera.
#
# @example
#   include profile::apache
class profile::apache {
  $package_name = $facts['os']['family'] ? {
    'Debian' => 'apache2',
    'RedHat' => 'httpd',
  }

  $message = lookup('apache::index_message', { default_value => "Hello from ${facts['networking']['hostname']}!" })

  package { $package_name:
    ensure => 'installed',
  }

  service { $package_name:
    ensure  => running,
    enable  => true,
    require => Package[$package_name],
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<html><body><h1>${message}</h1></body></html/>\n",
    notify  => Service[$package_name],
  }
}
