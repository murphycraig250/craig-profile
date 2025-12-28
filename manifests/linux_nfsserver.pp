class profile::linux_nfsserver {

  package { 'nfs-kernel-server':
    ensure => installed,
  }

  file { '/srv/nfs_share':
    ensure => directory,
    owner  => 'root',
    group  => 'labadmins',
    mode   => '0775',
  }

  file { '/srv/nfs_share/index.html':
  ensure  => file,
  owner   => 'bradley',
  group   => 'labadmins',
  mode    => '0664',
  content => "<html><body><h1>Hello from the NFS Share!</h1><p>Managed by Puppet</p></body></html>",
  require => [
    User['bradley'],
    Group['labadmins'],
    File['/srv/nfs_share'],
  ],
}

  file_line { 'nfs_export_config':
    path   => '/etc/exports',
    line   => '/srv/nfs_share  *(rw,sync,no_subtree_check)',
    notify => Exec['update_nfs_exports'],
  }

  exec { 'update_nfs_exports':
    command     => '/usr/sbin/exportfs -a',
    refreshonly => true,
    subscribe   => Package['nfs-kernel-server'],
  }
}
