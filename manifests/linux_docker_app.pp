# Manages Docker application directory structure and composition.
#
# This defined type creates the necessary directory structure for a Docker application,
# manages the docker-compose configuration file, and handles container lifecycle.
#
# @param deploy_user The user that will own the application files
# @param base_dir The base directory path where applications are deployed
# @param port Optional port number for the application
# @param extra_params Additional parameters for future extensibility
#
# @example
#   profile::linux_docker_app { 'myapp':
#     deploy_user = 'craig',
#     base_dir = '/srv',
#     port = '8080',
#   }
define profile::linux_docker_app (
  String $deploy_user = 'craig',
  String $base_dir = '/srv',
  Optional[String] $port = undef,
  Optional[Variant[String, Sensitive[String]]] $docker_user     = undef,
  Optional[Variant[String, Sensitive[String]]] $docker_password = undef,
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
    group  => 'docker',
    mode   => '0755',
  }

  file { "${app_path}/data":
    ensure => directory,
    owner  => $deploy_user,
    group  => 'docker',
    mode   => '0775',
  }

  file { "${app_path}/config":
    ensure => directory,
    owner  => $deploy_user,
    group  => 'docker',
    mode   => '0775',
  }

  # ----------------------------
  # 2. Compose file
  # ----------------------------
  file { $compose_file:
    ensure  => file,
    owner   => $deploy_user,
    group   => 'docker',
    mode    => '0600',
    content => epp("profile/docker/${app_name}-docker-compose.epp", {
        'docker_user'     => $docker_user =~ Sensitive ? { true => $docker_user.unwrap,     default => $docker_user },
        'docker_password' => $docker_password =~ Sensitive ? { true => $docker_password.unwrap, default => $docker_password },
    }),
  }

  # ----------------------------
  # 3. Container lifecycle
  # ----------------------------
  docker_compose { $app_name:
    ensure        => present,
    compose_files => [$compose_file],
    subscribe     => File[$compose_file],
  }
}
