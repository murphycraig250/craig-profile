define profile::choco_install (
  Optional[String] $version = 'installed',
  Optional[Array[String]] $install_options = undef,
)
{
$exclude_packages = lookup({
    name          => 'packages.exclude',
    value_type    => Array[String],
    default_value => [],
  })

 $is_package_excluded = $title in $exclude_packages
  
  if !$is_package_excluded {
package {$title:
  ensure => $version,
  provider => 'chocolatey',
  install_options => $install_options,
  }
}
}  
