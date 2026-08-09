class profile::dc_promotion (
  String $domain_name = 'localdomain.test',
  String $domain_netbios_name = 'LOCALDOMAIN',
  String $safe_mode_password = 'YourTemporaryPassword123!',
) {
  file { 'C:\ProgramData\PuppetLabs\promote-dc.ps1':
    ensure  => file,
    content => epp('profile/domain_controller/promote-dc.epp', {
        'domain_name'         => $domain_name,
        'domain_netbios_name' => $domain_netbios_name,
        'safe_mode_password'  => $safe_mode_password,
    }),
  }

  exec { 'promote-domain-controller':
    command     => 'C:\Program Files\PowerShell\7\pwsh.exe -NoProfile -File C:\ProgramData\PuppetLabs\promote-dc.ps1',
    refreshonly => true,
    subscribe   => File['C:\ProgramData\PuppetLabs\promote-dc.ps1'],
  }
}
