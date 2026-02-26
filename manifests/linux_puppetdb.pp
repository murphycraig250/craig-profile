class profile::linux_puppetdb {
  class { 'puppetdb': }

  class { 'puppetdb::master::config': }
}
