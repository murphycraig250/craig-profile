class profile::linux_packages {

$default_packages = [
  'cmatrix',
]

$extra_packages   = lookup('packages::install', { default_value => [] })
$remove_packages  = lookup('packages::remove',  { default_value => [] })

$final_packages = ($default_packages + $extra_packages).unique - $remove_packages

  package { $final_packages:
    ensure => installed,
  }

  package { $remove_packages:
    ensure => absent,
  }
}
