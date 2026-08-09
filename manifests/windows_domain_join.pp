class profile::windows_domain_join {
  exec { 'join-domain':
    command  => "${cred} = New-Object System.Management.Automation.PSCredential(''DOMAIN\vagrant'', (ConvertTo-SecureString ''vagrant'' -AsPlainText -Force)); Add-Computer -DomainName ''localdomain.test'' -OUPath ''OU=Lab Computers,DC=localdomain,DC=test'' -Credential ${cred} -Force'",
    provider => powershell,
    unless   => 'try { if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { exit 0 } catch { exit 1 }',
    timeout  => 300,
    notify   => Exec['reboot-after-domain-join'],
  }

  exec { 'reboot-after-domain-join':
    command     => 'shutdown.exe /r /t 5 /c "Rebooting after domain join"',
    refreshonly => true,
    path        => ['C:/Windows/System32'],
  }
}
