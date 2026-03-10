# Manages Linux user accounts using the accounts module.
#
# @param users A hash of user accounts to create, looked up from Hiera.
class profile::linux_user2 (
  Hash $users = lookup ('profile::linux_user2::users', Hash, 'deep', {}),
) {
  include accounts

  create_resources('accounts::user', $users)

  group { 'labadmins':
    ensure => 'present',
    gid    => 2000,
  }

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
