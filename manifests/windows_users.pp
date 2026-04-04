# @summary Creates Windows Users and Groups
#
# This class automates the creation of Windows users and groups, ensuring that they are properly configured with the specified attributes and permissions.
#
# @example
#   include profile::windows_users
#
class profile::windows_users {
  dsc_aduser { 'craig':
    dsc_username             => 'Craig',
    dsc_password             => {
      'user'     => 'craig',
      'password' => Sensitive('Th@tch3rs1'),
    },
    dsc_domainname           => 'localdomain.test',
    dsc_path                 => 'CN=Users,DC=localdomain,DC=test',
    dsc_psdscrunascredential => {
      'user'     => 'Administrator',
      'password' => Sensitive('Vagrant!23'),
    },
    require                  => Dsc_addomain['localdomain'],
  }
}
