# Manages Docker application directory structure
#
# @param app_name The name of the application
# @param deploy_user The user that will own the application files
# @param base_dir The base directory where the app_name directory will be created
#
# @example
#   profile::docker_dir { 'myapp':
#     app_name   => 'myapp',
#     deploy_user => 'appuser',
#     base_dir   => '/srv',
#   }
define profile::docker_dir (
  String $app_name,
  String $deploy_user,
  String $base_dir = '/srv',
) {
  $app_path = "${base_dir}/${app_name}"

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

  file { "${app_path}/compose.yaml":
    ensure => file,
    owner  => $deploy_user,
    group  => 'docker',
    mode   => '0644',
  }
}
