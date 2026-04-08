# @summary Creates Windows Users and Groups
#
# This class automates the creation of Windows users and groups, ensuring that they are properly configured with the specified attributes and permissions.
#
# @example
#   include profile::windows_users
#
class profile::windows_users {
  dsc_adorganizationalunit { 'domain_lab_users':
    dsc_name                 => 'Lab Users',
    dsc_path                 => 'DC=localdomain,DC=test',
    dsc_ensure               => 'present',
    dsc_psdscrunascredential => {
      'user'     => 'LOCALDOMAIN\Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
  }

  dsc_adorganizationalunit { 'domain_lab_devices':
    dsc_name                 => 'Lab Devices',
    dsc_path                 => 'DC=localdomain,DC=test',
    dsc_ensure               => 'present',
    dsc_psdscrunascredential => {
      'user'     => 'LOCALDOMAIN\Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
  }

  dsc_aduser { 'craig':
    dsc_ensure               => 'present',
    dsc_username             => 'Craig',
    dsc_password             => {
      'user'     => 'craig',
      'password' => Sensitive('Th@tch3rs1'),
    },
    dsc_domainname           => 'localdomain.test',
    dsc_path                 => 'OU=Lab_Users,DC=localdomain,DC=test',
    dsc_psdscrunascredential => {
      'user'     => 'LOCALDOMAIN\Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
    require                  => Dsc_adorganizationalunit['domain_lab_users'],
  }
}
