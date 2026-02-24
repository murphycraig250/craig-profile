class profile::linux_nfsserver {
  package { 'nfs-kernel-server':
    ensure => installed,
  }

  service { 'nfs-kernel-server':
    ensure  => running,
    enable  => true,
    require => Package['nfs-kernel-server'],
  }

  file { '/srv/nfs_share':
    ensure  => directory,
    owner   => 'root',
    group   => 'labadmins',
    mode    => '0775',
    require => Package['nfs-kernel-server'],
  }

  file_line { 'nfs_export_config':
    path    => '/etc/exports',
    line    => '/srv/nfs_share  *(rw,sync,no_subtree_check)',
    notify  => Exec['update_nfs_exports'],
    require => File['/srv/nfs_share'],
  }

  exec { 'update_nfs_exports':
    command     => '/usr/sbin/exportfs -a',
    refreshonly => true,
    subscribe   => Service['nfs-kernel-server'],
  }
}
