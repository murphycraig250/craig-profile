# Manages Docker application directory structure and composition.
#
# This defined type creates the necessary directory structure for a Docker application,
# manages the docker-compose configuration file, and handles container lifecycle.
#
# @param deploy_user The user that will own the application files
# @param deploy_group The group that will own the application files
# @param base_dir The base directory path where applications are deployed
# @param port Optional port number for the application
# @param docker_user Optional Docker registry username
# @param docker_password Optional Docker registry password
# @param up_args Optional arguments to pass to docker-compose up
#
# @example
#   profile::linux_docker_app { 'myapp':
#     deploy_user = 'craig',
#     base_dir = '/srv',
#     port = '8080',
#   }
define profile::linux_docker_app (
  String $deploy_user = '1050',
  String $deploy_group = '1050',
  String $base_dir = '/srv',
  Optional[String] $port = undef,
  Optional[Variant[String, Sensitive[String]]] $docker_user     = undef,
  Optional[Variant[String, Sensitive[String]]] $docker_password = undef,
  Optional[String] $up_args = undef,
  Optional[String] $depends_on = '',
) {
  $app_name     = $title
  $app_path     = "${base_dir}/${app_name}"
  $compose_file = "${app_path}/docker-compose.yml"

  # ----------------------------
  # 1. Base directory structure
  # ----------------------------
  file { $app_path:
    ensure => directory,
    owner  => $deploy_user,
    group  => $deploy_group,
    mode   => '0770',
  }

  file { "${app_path}/data":
    ensure  => directory,
    owner   => $deploy_user,
    group   => $deploy_group,
    mode    => '0770',
    recurse => true,
  }

  file { "${app_path}/config":
    ensure => directory,
    owner  => $deploy_user,
    group  => $deploy_group,
    mode   => '0770',
  }

  # ----------------------------
  # 2. Compose file
  # ----------------------------
  file { $compose_file:
    ensure  => file,
    owner   => $deploy_user,
    group   => $deploy_group,
    mode    => '0600',
    content => epp("profile/docker/${app_name}-docker-compose.epp", {
        'docker_user'     => $docker_user =~ Sensitive ? { true => $docker_user.unwrap,     default => $docker_user },
        'docker_password' => $docker_password =~ Sensitive ? { true => $docker_password.unwrap, default => $docker_password },
    }),
    require => File[$app_path],
  }

  # ----------------------------
  # 3. Container lifecycle
  # ----------------------------
  $base_requirements = [
    File[$compose_file],
    File["${app_path}/data"],
    File["${app_path}/config"]
  ]

  $docker_deps = $depends_on ? {
    ''      => $base_requirements,
    default => $base_requirements + [Docker_compose[$depends_on]],
  }

  docker_compose { $app_name:
    ensure        => present,
    compose_files => [$compose_file],
    up_args       => $up_args,
    subscribe     => File[$compose_file],
    require       => $docker_deps,
  }

  # ----------------------------
  # 4. Force recreate if unhealthy
  # ----------------------------
  exec { "force_recreate_${app_name}_if_unhealthy":
    path    => ['/usr/bin', '/usr/local/bin'],
    command => "docker compose up -d --force-recreate ${app_name}",
    cwd     => $app_path,
    onlyif  => "docker inspect --format='{{.State.Health.Status}}' ${app_name} | grep unhealthy",
    require => Docker_compose[$app_name],
  }
}
