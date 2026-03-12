# @summary Configures the Message of the Day (MOTD)
#
# This class sets up a custom MOTD template that displays the system's 
# FQDN, OS description, and IP address upon login.
#
# @example
#   include profile::linux_motd
class profile::linux_motd {
  class { 'motd':
    content => "
      ================================================
      HOSTNAME:  ${facts['networking']['fqdn']}
      OS:        ${facts['os']['distro']['description']}
      IP:        ${facts['networking']['ip']}
      ================================================
    ",
  }
}
