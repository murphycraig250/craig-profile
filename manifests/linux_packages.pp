# @summary Manages system packages on Linux
#
# This class handles the installation and removal of system packages. It 
# includes platform-specific defaults and allows for further customization 
# through Hiera-based include and exclude lists.
#
# @example
#   include profile::linux_packages
class profile::linux_packages {
  $default_packages = $facts['os']['family'] ? {
    'Debian' => ['cmatrix'],
  'RedHat' => ['epel-release'], }

  $extra_packages   = lookup('packages::install', { default_value => [] })
  $remove_packages  = lookup('packages::remove', { default_value => [] })

  $final_packages = ($default_packages + $extra_packages).unique - $remove_packages

  package { $final_packages:
    ensure => installed,
  }

  package { $remove_packages:
    ensure => absent,
  }
}
