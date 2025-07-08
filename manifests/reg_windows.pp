class profile::reg_windows {
  registry_value { 'HKLM\Software\Craig':
    ensure => present,
    type   => string,
    data   => 'Hello World',
  }
}
