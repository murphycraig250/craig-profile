class profile::windows_dc {

  # Enable long paths
  registry_value { 'HKLM\System\CurrentControlSet\Control\FileSystem\LongPathsEnabled':
    ensure   => 'present',
    data     => [1],
    provider => 'registry',
    type     => 'dword',
  }

  # 1. Install AD-Domain-Services feature
  dsc_resource { 'Install AD-Domain-Services':
    resource_name => 'WindowsFeature',
    module        => 'PSDesiredStateConfiguration',
    properties    => {
      Ensure => 'Present',
      Name   => 'AD-Domain-Services',
    },
  }

  # 2. Promote the domain
  dsc_addomain { 'localdomain':
    dsc_domainname                    => 'localdomain.test',
    dsc_domainnetbiosname             => 'LOCALDOMAIN',
    dsc_credential                    => {
      'user'     => 'Administrator',
      'password' => Sensitive('pw'),
    },
    dsc_safemodeadministratorpassword => {
      'user'     => 'Administrator',
      'password' => Sensitive('pw'),
    },
    require => Dsc_resource['Install AD-Domain-Services'],
    notify  => Reboot['AD_Reboot'],
  }

  # 3. Handle reboot
  reboot { 'AD_Reboot':
    apply => 'finished', # Wait until the rest of the puppet catalog is done
    when  => 'pending',  # Only reboot if the OS actually signals it's needed
  }
}
