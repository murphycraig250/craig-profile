# Configures pre-firewall rules for Linux systems.
#
# This class sets up default firewall rules that are applied before
# other firewall rules, including rules for ICMP, loopback interface,
# and connection state tracking.
#
# @summary Configures pre-firewall rules for Linux systems
class profile::linux_firewall::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto => 'icmp',
    jump  => 'accept',
  }
  -> firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    jump    => 'accept',
  }
  -> firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    jump        => 'reject',
  }
  -> firewall { '003 accept related established rules':
    proto => 'all',
    state => ['RELATED', 'ESTABLISHED'],
    jump  => 'accept',
  }
}
