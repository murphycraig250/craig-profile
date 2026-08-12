class profile::pwsh_labtools {
  file { 'C:/Program Files/WindowsPowerShell/Modules/LabTools':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/profile/LabTools',
  }
}
