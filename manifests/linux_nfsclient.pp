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
