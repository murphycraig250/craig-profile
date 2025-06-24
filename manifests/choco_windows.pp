# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::choco_windows
class profile::choco_windows (
  Array[String] $apps = [],
) {
  include chocolatey

  $apps.each |String $app| {
    package { $app:
      ensure   => 'latest',
      provider => 'chocolatey',
      require  => Class['chocolatey'],
    }
  }
}
