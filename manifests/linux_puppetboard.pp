# @summary Installs and configures Puppetboard
#
# This class sets up Puppetboard to provide a web-based dashboard for 
# PuppetDB, configuring the Python version and secret key automatically.
#
# @example
#   include profile::linux_puppetboard
class profile::linux_puppetboard {
  package { 'python3.10-venv':
    ensure => installed,
  }

  class { 'puppetboard':
    python_version => '3.10',
    secret_key     => stdlib::fqdn_rand_string(32),
    puppetdb_host  => 'ubuntu-primary.localdomain', # your PuppetDB hostname/IP
    require        => Package['python3.10-venv'],
  }
}
