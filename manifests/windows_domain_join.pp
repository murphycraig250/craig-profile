# @summary Configures a Windows Domain Join
#
# This class automates the setup of a Windows Domain Join.
#
# @example
#   include profile::windows_domain_join
#
class profile::windows_domain_join { # Inside profile::windows_domain_join
  $dc_query = puppetdb_query("resources { type = 'Host' and title = 'dc-dns' }")

  if ! empty($dc_query) {
    $dc_ip = $dc_query[0]['parameters']['ip']

    # 1. Force the DNS change
    exec { 'set_dns_to_dc':
      command  => "Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses '${dc_ip}'",
      unless   => "if ((Get-DnsClientServerAddress -InterfaceAlias 'Ethernet').ServerAddresses -contains '${dc_ip}') { exit 0 } else { exit 1 }",
      provider => 'powershell',
      before   => Dsc_computer['join_to_domain'],
    }

    # 2. Perform the Domain Join
    dsc_computer { 'join_to_domain':
      dsc_name       => $facts['networking']['hostname'],
      dsc_domainname => 'localdomain.test',
      dsc_credential => {
        'user'     => 'Administrator',
        'password' => Sensitive('Vagrant!23'),
      },
      notify         => Reboot['after_join'],
    }
  } else {
    notify { 'Waiting for DC':
      message => 'DC IP not found in PuppetDB yet. Run Puppet on the DC first!',
    }

    reboot { 'after_join':
      apply   => 'finished',
      when    => 'refreshed',
      message => 'Puppet is rebooting the computer to complete the domain join.',
    }
  }
}
