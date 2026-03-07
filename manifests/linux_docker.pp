# manifests/linux_docker.pp
class profile::linux_docker {
  package { ['docker.io', 'docker-compose-v2']:
    ensure => installed,
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker.io'],
  }
}
