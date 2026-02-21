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
