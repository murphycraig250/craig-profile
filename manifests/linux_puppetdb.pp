class profile::linux_puppetdb {
  class { 'puppetdb': }

  class { 'puupetdb::master::config': }
}
