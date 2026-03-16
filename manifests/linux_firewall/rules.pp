# Manages Linux firewall rules for SSH, HTTP, and HTTPS traffic.
#
# This class defines firewall rules that allow incoming connections on ports
# 22 (SSH), 80 (HTTP), and 443 (HTTPS).
class profile::linux_firewall::rules {
  Firewall {
    before  => Class['profile::linux_firewall::post'],
    require => Class['profile::linux_firewall::pre'],
  }

  # 1. Allow SSH (So you don't lock Bradley out again!)
  firewall { '100 allow ssh access':
    dport => 22,
    proto => 'tcp',
    jump  => 'accept',
  }

  # 2. Allow HTTP/HTTPS
  firewall { '101 allow http and https':
    dport => [80, 443],
    proto => 'tcp',
    jump  => 'accept',
  }

  firewall { '110 allow puppet server access':
    dport => 8140,
    proto => 'tcp',
    jump  => 'accept',
  }

  # --- DOCKER SPECIFIC RULES ---
  firewall { '200 block bad actor from containers':
    chain  => 'DOCKER-USER',
    source => '192.168.1.105',
    jump   => 'drop',
    proto  => 'all',
  }
}
