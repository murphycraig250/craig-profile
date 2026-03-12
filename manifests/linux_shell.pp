# lint:ignore:strict_indent
# @summary Configures shell shortcuts and environment for Linux
#
# This class adds Puppet binaries to the system PATH and creates a 
# collection of helpful shell aliases and functions (like 'pl' for 
# Puppet lookup) to improve the CLI experience.
#
# @example
#   include profile::linux_shell
class profile::linux_shell {
  file { '/etc/profile.d/puppet_shortcuts.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOF),
      # Add Puppet to PATH
      export PATH="$PATH:/opt/puppetlabs/bin"

      # Function: pl <key>
      # Usage: pl profile::linux_user::user_list
      pl() {
        if [ -z "$1" ]; then
          echo "Usage: pl <lookup_key>"
        else
          sudo /opt/puppetlabs/bin/puppet lookup "$1" \
          --codedir /etc/puppetlabs/code \
          --environment production \
          --explain
        fi
      }

      # Shortcuts
      alias p='sudo /opt/puppetlabs/bin/puppet'
      alias pa='sudo /opt/puppetlabs/bin/puppet agent --test'
      alias pcd='cd /etc/puppetlabs/code/environments/production/modules'
      alias pd='sudo /opt/puppetlabs/puppet/bin/r10k deploy environment production -p -v'
    | EOF
  }
}
# lint:endignore
