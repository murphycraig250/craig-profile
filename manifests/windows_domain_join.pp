class profile::windows_domain_join {
  $domain_dns = '192.168.1.60'
  $domain     = 'localdomain.test'
  $domain_ou = 'OU=Lab Computers,DC=localdomain,DC=test'

  # --------------------------------------------------------------------------
  # Configure DNS to use the domain controller
  # --------------------------------------------------------------------------

  exec { 'configure-domain-dns':
    command  => "Get-NetAdapter | Where-Object { \$_.Status -eq 'Up' } | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex \$_.ifIndex -ServerAddresses '${domain_dns}' }",
    provider => powershell,
  }
  # --------------------------------------------------------------------------
  # Verify that AD DNS is actually responding
  # --------------------------------------------------------------------------

  exec { 'verify-domain-dns':
    command  => "Resolve-DnsName -Name '_ldap._tcp.dc._msdcs.${domain}' -Server '${domain_dns}' -ErrorAction Stop",
    provider => powershell,
    require  => Exec['configure-domain-dns'],
    timeout  => 60,
  }

  # --------------------------------------------------------------------------
  # Join the domain
  # --------------------------------------------------------------------------

  exec { 'join-domain':
    command  => "\$cred = New-Object System.Management.Automation.PSCredential(\"localdomain.test\\vagrant\", (ConvertTo-SecureString \"vagrant\" -AsPlainText -Force)); Add-Computer -DomainName \"${domain}\" -OUPath \"${domain_ou}\" -Credential \$cred -Force -ErrorAction Stop",
    provider => powershell,
    unless   => 'if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { exit 0 } else { exit 1 }',
    require  => Exec['verify-domain-dns'],
    timeout  => 300,
  }

  # --------------------------------------------------------------------------
  # Verify domain membership
  #
  # This is deliberately separate from the join command.
  # If the join fails, Puppet will NOT reboot the machine.
  # --------------------------------------------------------------------------

  exec { 'verify-domain-join':
    command  => "if ((Get-LabDomain).PartOfDomain -and (Get-LabDomain).Domain -eq '${domain}') { Write-Output 'Domain verification successful: joined to ${domain}'; exit 0 } else { Write-Error 'Computer is NOT joined to ${domain}'; exit 1 }",
    provider => powershell,
    require  => Exec['join-domain'],
  }

  # --------------------------------------------------------------------------
  # Reboot ONLY after successful domain membership verification
  # --------------------------------------------------------------------------

  exec { 'reboot-after-domain-join':
    command     => 'shutdown.exe /r /t 10 /c "Rebooting after successful domain join"',
    provider    => powershell,
    path        => ['C:/Windows/System32'],
    refreshonly => true,
    subscribe   => Exec['verify-domain-join'],
  }
}
