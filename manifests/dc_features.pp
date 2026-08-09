# @summary Configures features on a Windows Domain Controller
#
# This class installs necessary features on a Windows Domain
# Controller, such as the Remote Server Administration Tools
# (RSAT) for Active Directory.
#
# @example
#   include profile::dc_features
#
class profile::dc_features {
  $iis_features = ['RSAT-AD-PowerShell', 'RSAT-Role-Tools', 'AD-Domain-Services']

  windowsfeature { $iis_features:
    ensure => present,
  }
}
