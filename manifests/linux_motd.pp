# @summary Configures the Message of the Day (MOTD)
#
# This class sets up a custom MOTD template that displays the system's 
# FQDN, OS description, and IP address upon login.
#
# @example
#   include profile::linux_motd
class profile::linux_motd {
  $banner_text = "Welcome to \n (\l)\nAuthorized users only!\n\n"

  class { 'motd':
    content => "
      ================================================
      HOSTNAME:  ${facts['networking']['fqdn']}
      OS:        ${facts['os']['distro']['description']}
      IP:        ${facts['networking']['ip']}
      ================================================
    ",
  }

  file { '/etc/issue':
    ensure  => file,
    content => $banner_text,
    owner   => 'root',
    mode    => '0644',
    notify  => Service['ssh'],
  }

  file { '/etc/issue.net':
    ensure  => file,
    content => $banner_text,
    owner   => 'root',
    mode    => '0644',
    notify  => Service['ssh'],
  }
}
