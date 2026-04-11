# @summary Configures the Message of the Day (MOTD)
#
# This class sets up a custom MOTD template that displays the system's 
# FQDN, OS description, and IP address upon login.
#
# @example
#   include profile::linux_motd
class profile::linux_laptop {
  file { '/etc/systemd/logind.conf.d':
  ensure => directory,
  mode   => '0755',
  owner  => 'root',
  group  => 'root',
}

  file { '/etc/systemd/logind.conf.d/99-lid.conf':
    ensure  => file,
    mode    => '0644',
    content => @("EOF"),
      [Login]
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
      | EOF
    notify  => Service['systemd-logind'],
  }

  service { 'systemd-logind':
    ensure => running,
  }
}
