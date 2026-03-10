# Manages Linux user accounts using the accounts module.
#
# @param users A hash of user accounts to create, looked up from Hiera.
class profile::linux_user2 (
  Hash $users = lookup ('profile::linux_user2::users', Hash, 'deep', {}),
) {
  create_resources('accounts::user', $users)
}
