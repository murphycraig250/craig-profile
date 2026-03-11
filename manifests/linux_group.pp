# Manages Linux group accounts and settings.
#
# @summary Manages Linux group accounts and settings
#
# @param group_list Hash of group names and their configuration
class profile::linux_group (
  Hash $group_list = {},
) {
  include accounts

  $host_group = "${facts['networking']['hostname']}_group"

  group { $host_group:
    ensure => present,
  }

  create_resources('group', $group_list)

  class { 'sudo':
    config_file_replace => false,
    purge               => true,
    purge_ignore        => [
      'vagrant',
      'README',
    ],
  }

  sudo::conf { 'labadmins':
    priority => 10,
    content  => '%labadmins ALL=(ALL) NOPASSWD: ALL',
  }
}
