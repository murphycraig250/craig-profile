# @summary Manages Chocolatey package installations on Windows
#
# This class orchestrates the installation of Chocolatey packages by combining 
# default packages with those specified in Hiera and then calling profile::choco_install.
#
# @example
#   include profile::choco_windows
class profile::choco_windows {
  #include chocolatey
  $default_packages = lookup({
      name          => 'profile::choco_windows::packages.chocolatey',
      value_type    => Hash,
      default_value => {},
  })
  $hiera_packages = lookup({
      name          => 'packages.include',
      value_type    => Hash,
      default_value => {},
  })
  $packages = $default_packages + $hiera_packages

  create_resources(
    'profile::choco_install',
    $packages,
    {}
  )
}
