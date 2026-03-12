# @summary Manages custom Windows registry keys
#
# This class ensures that specific custom registry values are present 
# in the Windows registry for configuration purposes.
#
# @example
#   include profile::reg_windows
class profile::reg_windows {
  registry_value { 'HKLM\Software\Craig':
    ensure => present,
    type   => string,
    data   => 'Hello World',
  }
}
