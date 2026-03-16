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

  $local_issue = "Welcome to \\n (\\l)\nAuthorized users only!\n\n"

  file { '/etc/issue':
    ensure  => file,
    content => $local_issue,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  $network_issue = "**********************************************************\n* Authorized Access Only!                                *\n* This system is monitored. Disconnect if unauthorized.  *\n**********************************************************\n"

  file { '/etc/issue.net':
    ensure  => file,
    content => $network_issue,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
