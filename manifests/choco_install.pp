# @summary Installs a Chocolatey package with exclusion support
#
# This resource type installs a Chocolatey package unless it has been explicitly 
# excluded via the 'packages.exclude' Hiera lookup.
#
# @example
#   profile::choco_install { 'git':
#     version => 'latest',
#   }
#
# @param version
#   The desired package state or specific version to install.
#   Defaults to 'installed'.
#
# @param install_options
#   Optional array of additional installation options to pass to Chocolatey.
#   Defaults to undef.
#
define profile::choco_install (
  String $version = 'installed',
  Optional[Array[String]] $install_options = undef,
) { $exclude_packages = lookup (
    {
      name          => 'packages.exclude',
      value_type    => Array[String],
      default_value => [],
  })

  $is_package_excluded = $title in $exclude_packages

  if !$is_package_excluded {
    package { $title:
      ensure          => $version,
      provider        => 'chocolatey',
      install_options => $install_options,
    }
  }
}
