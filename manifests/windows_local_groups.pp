class profile::windows_local_groups (
  Hash[String, Array[String]] $groups = {},
) {
  $groups.each |String $group, Array[String] $members| {
    group { $group:
      ensure  => present,
      members => $members,
    }
  }
}
