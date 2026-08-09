class profile::domain_controller (
  String $domain_name = 'localdomain.test',
  String $domain_netbios_name = 'LOCALDOMAIN',
) {
  file { 'C:\ProgramData\PuppetLabs\promote-dc.ps1':
    ensure  => file,
    content => epp('profile/domain_controller/promote-dc.ps1.epp', {
        'domain_name'         => $domain_name,
        'domain_netbios_name' => $domain_netbios_name,
    }),
  }
}
