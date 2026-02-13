class profile::windows_dc {
  registry_value { 'HKLM\System\CurrentControlSet\Control\FileSystem\LongPathsEnabled':
    ensure   => 'present',
    data     => [1],
    provider => 'registry',
    type     => 'dword',
  }
  # 1. FROM MODULE: dsc-psdscresources
  $features = ['ADDS_Feature','RSAT-AD-AdminCenter']
  $features.each | String $feature | {
    dsc_windowsfeature { $feature :
      dsc_ensure => 'Present',
      dsc_name   => $feature,
    }
  }
# 2. FROM MODULE: dsc-activedirectorydsc
  dsc_addomain { 'localdomain':
    dsc_domainname                    => 'localdomain.test',
    dsc_domainnetbiosname             => 'LOCALDOMAIN',
    dsc_credential                    => {
      'user'     => 'Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
    dsc_safemodeadministratorpassword => {
      'user'     => 'Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
    # Wait for the feature to install, then tell the reboot resource to fire
    require                           => Dsc_windowsfeature['ADDS_Feature'],
    notify                            => Reboot['AD_Reboot'],
  }

# 3. FROM MODULE: puppetlabs-reboot
  reboot { 'AD_Reboot':
    apply => 'finished', # Wait until the rest of the puppet catalog is done
    when  => 'pending',  # Only reboot if the OS actually signals it's needed
  }
}
