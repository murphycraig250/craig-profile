define profile::choco_install (
  Optional[String] $version = 'installed',
  Optional[Array[String]] $install_options = undef,
)
{package {$title:
  ensure => $version,
  provider => 'chocolatey',
  install_options => $install_options,
  }
}
  
