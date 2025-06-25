# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::choco_windows
class profile::choco_windows {
$apps = lookup({
  name          => 'packages.chocolatey.include',
  value_type    => Hash,
  default_value => {},
})

create_resources(
  'profile::choco_install',
  $apps,)


#notify {'apps':
#  message => "${apps}",
#}
}
