class profile::linux_shell {
  file { '/etc/profile.d/puppet_shortcuts.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOF)
      # Add Puppet to PATH
      export PATH="$PATH:/opt/puppetlabs/bin"

      # Function: pl <key>
      # Usage: pl profile::linux_user::user_list
      pl() {
        if [ -z "$1" ]; then
          echo "Usage: pl <lookup_key>"
        else
          /opt/puppetlabs/bin/puppet lookup "$1" --environment production --explain
        fi
      }

      # Shortcuts
      alias p='/opt/puppetlabs/bin/puppet'
      alias pa='/opt/puppetlabs/bin/puppet agent -t'
      alias pcd='cd /etc/puppetlabs/code/environments/production/modules'
      alias pd='sudo /opt/puppetlabs/bin/r10k deploy environment production -p -v'
    | EOF
  }
}
