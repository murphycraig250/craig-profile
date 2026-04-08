# @summary Provides base configuration for Windows systems
#
# This class provides the foundational configuration common to all Windows systems 
# in the environment. Currently, it simply notifies that the system is a Windows machine.
#
# @example
#   include profile::base_windows
class profile::base_windows {
  notify { 'This is a Windows machine.': }

  group { 'Administrators':
    ensure  => 'present',
    members => ['LOCALDOMAIN\Craig'],
    require => Dsc_aduser['craig'],
  }
}
