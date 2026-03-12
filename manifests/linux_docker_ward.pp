# @summary Deploys Ward server monitoring via Docker
#
# This class manages the deployment of Ward, a server monitoring tool, 
# using Docker Compose. It ensures the necessary directories and compose 
# files are in place before deploying the container.
#
# @example
#   include profile::linux_docker_ward
class profile::linux_docker_ward {
  include 'docker'

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
  # exec { 'deploy_ward':
  #   command     => 'docker compose up -d --force-recreate',
  #   cwd         => '/srv/ward',
  #   path        => ['/usr/bin', '/usr/local/bin'],
  #   refreshonly => true,
  #   require     => [Package['docker.io'], Package['docker-compose-v2'], File['/srv/ward/docker-compose.yml']],
  # }

  docker_compose { 'ward':
    ensure        => present,
    compose_files => ['/srv/ward/docker-compose.yml'],
    require       => File['/srv/ward/docker-compose.yml'],
  }
}
