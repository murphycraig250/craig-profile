# @summary Provides base configuration for Linux systems
#
# This class provides the foundational configuration common to all Linux systems 
# in the environment. Currently, it simply notifies that the system is a Linux machine.
#
# @example
#   include profile::base_linux
class profile::base_linux {
  notify { 'This is a Linux machine.': }

  exec { 'set-timezone':
    command => '/usr/bin/timedatectl set-timezone Europe/London',
    unless  => '/usr/bin/timedatectl status | grep "Time zone: Europe/London"',
  }
}
