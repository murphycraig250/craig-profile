class profile::dc_promotion {
  notify { 'Promoting this server to a domain controller':
    message => 'Promoting this server to a domain controller',
  }
}
