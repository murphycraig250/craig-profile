class profile::windows_domain_join {

  # AD/DNS server
  $domain_dns = '192.168.1.60'
  $domain     = 'localdomain.test'
  $domain_ou = 'OU=Lab Computers,DC=localdomain,DC=test'

  # Make sure the Windows machine uses the AD DNS server.
  exec { 'configure-domain-dns':
    command  => "Get-NetAdapter | Where-Object { \$_.Status -eq 'Up' } | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex \$_.ifIndex -ServerAddresses '${domain_dns}' }",
    provider => powershell,
    unless   => "Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { \$_.ServerAddresses -contains '${domain_dns}' }",
  }

  # Wait until the AD DNS server is reachable before attempting the join.
  exec { 'verify-domain-dns':
    command  => "if (-not (Resolve-DnsName -Name '_ldap._tcp.dc._msdcs.${domain}' -Server '${domain_dns}' -ErrorAction SilentlyContinue)) { exit 1 }",
    provider => powershell,
    require  => Exec['configure-domain-dns'],
    timeout  => 60,
  }

  # Join the machine to the domain.
  exec { 'join-domain':
    command  => "\$cred = New-Object System.Management.Automation.PSCredential(\"DOMAIN\\vagrant\", (ConvertTo-SecureString \"vagrant\" -AsPlainText -Force)); Add-Computer -DomainName \"${domain}\" -OUPath \"${domain_ou}\" -Credential \$cred -Force",
    provider => powershell,
    unless   => 'if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { exit 0 } else { exit 1 }',
    require  => Exec['verify-domain-dns'],
    timeout  => 300,
    notify   => Exec['reboot-after-domain-join'],
  }

  # Reboot only when Puppet has actually changed the domain membership.
  exec { 'reboot-after-domain-join':
    command     => 'shutdown.exe /r /t 5 /c "Rebooting after domain join"',
    refreshonly => true,
    path        => ['C:/Windows/System32'],
  }
}
