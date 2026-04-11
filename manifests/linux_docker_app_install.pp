# Installs Docker applications based on package configuration from Hiera.
#
# This class uses Hiera lookups to retrieve default and custom Docker packages,
# merges them together, and creates resources for each application installation.
#
class profile::linux_docker_app_install {
  $default_packages = lookup({
      name          => 'profile::linux_docker::packages.all',
      value_type    => Hash,
      default_value => {},
  })
  $hiera_packages = lookup({
      name          => 'linux_docker.packages.include',
      value_type    => Hash,
      default_value => {},
  })
  $packages = $default_packages + $hiera_packages

  create_resources(
    'profile::linux_docker_app',
    $packages,
    {}
  )
}
