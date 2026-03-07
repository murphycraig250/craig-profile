# manifests/pihole.pp
class profile::linux_docker_pihole {
# Ensure Docker and Docker Compose are installed
  package { ['docker.io', 'docker-compose-v2']:
    ensure => installed,
  }

# Ensure systemd-resolved stub listener is off
  ini_setting { 'systemd_resolved_stub_listener':
    ensure  => present,
    path    => '/etc/systemd/resolved.conf',
    section => 'Resolve',
    setting => 'DNSStubListener',
    value   => 'no',
    notify  => Service['systemd-resolved'],
  }

  service { 'systemd-resolved':
    ensure => running,
    enable => true,
  }

  file { ['/srv/pihole', '/srv/pihole/etc-pihole', '/srv/pihole/etc-dnsmasq.d']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Read encrypted password from Hiera
  $pi_password = hiera('pihole::web_password', 'changeme')
  notify { "Pi-hole password: ${pi_password}": }
  # Write .env file for Docker Compose
  file { '/srv/pihole/.env':
    ensure  => file,
    content => "WEBPASSWORD=${pi_password}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => File['/srv/pihole'],
    notify  => Exec['deploy_pihole'],
  }

# Copy Docker Compose file from the local files folder to server
  file { '/srv/pihole/docker-compose.yml':
    ensure  => file,
    source  => 'puppet:///modules/profile/docker/pihole-docker-compose.yml',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/srv/pihole'],
    notify  => Exec['deploy_pihole'],
  }

# Bring up Pi-hole container using Docker Compose
  exec { 'deploy_pihole':
    command     => 'docker compose up -d',
    cwd         => '/srv/pihole',
    path        => ['/usr/bin', '/usr/local/bin'],
    refreshonly => true,
    subscribe   => [File['/srv/pihole/docker-compose.yml'], File['/srv/pihole/.env']],
    require     => [Package['docker.io'], Package['docker-compose-v2'], File['/srv/pihole/.env'], File['/srv/pihole/docker-compose.yml']],
  }
}
