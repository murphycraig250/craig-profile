class profile::linux_puppetboard {
  class { 'puppetboard':
    python_version => '3.10',
    secret_key     => stdlib::fqdn_rand_string(32),
    puppetdb_host  => 'ubuntu-primary.localdomain', # your PuppetDB hostname/IP
  }
}
