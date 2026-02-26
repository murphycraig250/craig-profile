class profile::linux_puppetboard {
  class { 'puppetboard':
    python_version => '3.9',
    secret_key     => fqdn_rand_string(32),
    listen_address => '0.0.0.0',  # binds to all VM network interfaces
    listen_port    => 5000,
    puppetdb_host  => 'ubuntu-primary.localdomain', # your PuppetDB hostname/IP
  }
}
