# manifests/ward.pp
class profile::linux_docker_ward {
# Ensure Docker and Docker Compose are installed
  package { ['docker.io', 'docker-compose-v2']:
    ensure => installed,
  }

  file { '/srv/ward':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

# Copy Docker Compose file from the local files folder to server
  file { '/srv/ward/docker-compose.yml':
    ensure  => file,
    source  => 'puppet:///modules/profile/docker/ward-docker-compose.yml',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/srv/ward'],
    notify  => Exec['deploy_ward'],
  }

# Bring up Pi-hole container using Docker Compose
  exec { 'deploy_ward':
    command     => 'docker compose up -d --force-recreate',
    cwd         => '/srv/ward',
    path        => ['/usr/bin', '/usr/local/bin'],
    refreshonly => true,
    subscribe   => File['/srv/ward/docker-compose.yml'],
    require     => [Package['docker.io'], Package['docker-compose-v2'], File['/srv/ward/docker-compose.yml']],
  }
}
