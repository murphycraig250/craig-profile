# Configures firewall rules to drop all traffic as a final catch-all rule.
#
# This class sets up the final firewall rule that drops all packets not
# explicitly allowed by earlier firewall rules.
#
# @summary Configures post-firewall rules for Linux systems
#
class profile::linux_firewall::post {
  firewall { '999 drop all':
    proto  => 'all',
    jump   => 'drop',
    before => undef,
  }
}
