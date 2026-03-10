# Manages Linux group accounts and settings.
#
# @summary Manages Linux group accounts and settings
class profile::linux_group {
  include accounts

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
