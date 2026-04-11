# Manages Docker whoami service deployment
#
# This profile configures and deploys the whoami Docker application
# with appropriate compose configuration and file permissions.
#
# @param deploy_user The username for deploying the whoami application
# @param deploy_app The name of the application being deployed
#
class profile::linux_docker_whoami (
  String $deploy_user = 'craig',
  String $deploy_app  = 'whoami',
) {
  $app_path     = "/srv/${deploy_app}"
  $compose_file = "${app_path}/compose.yaml"

  profile::linux_docker_dir { $deploy_app:
    app_name    => $deploy_app,
    deploy_user => $deploy_user,
  }

  file { $compose_file:
    ensure => file,
    owner  => $deploy_user,
    group  => 'docker',
    mode   => '0644',
    source => "puppet:///modules/profile/docker/${deploy_app}-compose.yaml",
  }

  docker_compose { $deploy_app:
    ensure        => present,
    compose_files => [$compose_file],
    subscribe     => File[$compose_file],
  }
}
