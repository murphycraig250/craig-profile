# @summary Creates Windows Users and Groups
#
# This class automates the creation of Windows users and groups, ensuring that they are properly configured with the specified attributes and permissions.
#
# @example
#   include profile::windows_users
#
class profile::windows_users {
  dsc_aduser { 'craig':
    userName   => 'Craig',
    password   => 'Craig!23',
    domainName => 'localdoman.test',
    path       => 'CN=Users,DC=localdoman,DC=test',
  }
}
