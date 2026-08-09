class profile::dc_network (
  String $interface_alias = 'Ethernet',
  String $ip_address = '192.168.1.60',
  Integer $prefix_length = 24,
  String $gateway = '192.168.1.1',
  String $dns_server = '192.168.1.60',

) {
  file { 'C:\ProgramData\PuppetLabs\configure-network.ps1':
    ensure  => file,
    content => epp('profile/domain_controller/configure-network.epp', {
        'interface_alias' => $interface_alias,
        'ip_address'      => $ip_address,
        'prefix_length'   => $prefix_length,
        'gateway'         => $gateway,
        'dns_server'      => $dns_server,
    }),
  }

  exec { 'configure-domain-controller-network':
    command     => 'C:\Program Files\PowerShell\7\pwsh.exe -NoProfile -File C:\ProgramData\PuppetLabs\configure-network.ps1',
    refreshonly => true,
    subscribe   => File['C:\ProgramData\PuppetLabs\configure-network.ps1'],
  }
}
