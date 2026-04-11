# Manages Docker whoami service deployment
#
# This profile configures and deploys the whoami Docker application
# with appropriate compose configuration and file permissions.
#
class profile::linux_docker_whoami {
  include profile::linux_docker

  profile::docker_app { 'whoami':
    app_name    => 'whoami',
    deploy_user => 'craig',
  }

  file { '/srv/whoami/compose.yaml':
    ensure => file,
    owner  => 'craig',
    group  => 'docker',
    mode   => '0644',
    source => 'puppet:///modules/profile/docker/whoami-compose.yaml',
  }
}
