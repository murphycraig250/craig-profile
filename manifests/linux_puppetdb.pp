# @summary Installs and configures PuppetDB
#
# This class handles the installation and basic configuration of PuppetDB 
# and integrates it with the Puppet Master.
#
# @example
#   include profile::linux_puppetdb
class profile::linux_puppetdb {
  class { 'puppetdb': }

  class { 'puppetdb::master::config': }
}
