# Manages Linux user accounts and sudo configuration for lab administrators.
#
# This class configures user accounts (bradley, lucas, theo), creates the labadmins
# group, and sets up sudo privileges for lab administrators.
class profile::linux_user {
  include accounts
}
