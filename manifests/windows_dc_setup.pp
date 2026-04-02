# @summary Configures a Windows Domain Controller
#
# This class automates the setup of a Windows Domain Controller, including 
# enabling long paths, installing Active Directory Domain Services (ADDS), 
# promoting the domain, and managing necessary reboots.
#
# @example
#   include profile::windows_dc_setup
#
class profile::windows_dc_setup {
  registry_value { 'HKLM\System\CurrentControlSet\Control\FileSystem\LongPathsEnabled':
    ensure   => 'present',
    data     => 1,
    provider => 'registry',
    type     => 'dword',
  }

  windowsfeature { 'AD-Domain-Services':
    ensure => present,
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
#   require                           => Dsc_windowsfeature['ADDS_Feature'],
    notify                            => Reboot['after_AD-Domain-Services'],
    require                           => Windowsfeature['AD-Domain-Services'],
  }

# 3. FROM MODULE: puppetlabs-reboot
  reboot { 'after_AD-Domain-Services':
    apply => 'finished', # Wait until the rest of the puppet catalog is done
    when  => 'refreshed',  # Only reboot if the OS actually signals it's needed
  }
}
