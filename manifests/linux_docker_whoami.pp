# Manages Docker whoami service deployment
#
# This profile configures and deploys the whoami Docker application
# with appropriate compose configuration and file permissions.
#
class profile::linux_docker_whoami {
  include profile::linux_docker

  profile::linux_docker_dir { 'whoami':
    app_name    => 'whoami',
    deploy_user => 'craig',
  }

  file { '/srv/whoami/compose.yaml':
    ensure => file,
    source => 'puppet:///modules/profile/docker/whoami-compose.yaml',
    mode   => '0644',
  }

  docker_compose { 'whoami':
    ensure        => present,
    compose_files => ['/srv/whoami/compose.yaml'],
    subscribe     => File['/srv/whoami/compose.yaml'],
  }
}
