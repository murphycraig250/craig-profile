# @summary Configures an NFS client and mounts a remote share
#
# This class installs the necessary NFS client packages, creates a local 
# mount point, and ensures a remote NFS share is mounted at boot.
#
# @example
#   include profile::linux_nfsclient
class profile::linux_nfsclient {
  package { 'nfs-common':
    ensure => installed,
  }

  file { '/mnt/network_data':
    ensure => directory,
    owner  => 'root',
    group  => 'labadmins',
    mode   => '0775',
  }

  mount { '/mnt/network_data':
    ensure  => 'mounted',
    device  => 'ubuntu-primary.localdomain:/srv/nfs_share',
    fstype  => 'nfs',
    options => 'defaults,_netdev',
    atboot  => true,
    require => [Package['nfs-common'], File['/mnt/network_data']],
  }
}
