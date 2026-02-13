class profile::choco_windows {
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
