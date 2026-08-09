class profile::domain_controller {
  file { 'C:\ProgramData\PuppetLabs\promote-dc.ps1':
    ensure => file,
    source => 'puppet:///modules/profile/domain_controller/promote-dc.ps1',
  }
}
