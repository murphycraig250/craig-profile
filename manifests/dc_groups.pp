class profile::dc_groups (
  Hash $groups = {},
  String $default_path = 'OU=Groups,DC=localdomain,DC=test',
  String $default_scope = 'Global',
  String $default_category = 'Security',
) {
  $groups.each |String $group_name, Hash $group_data| {
    $group_path = $group_data['path'] ? {
      undef   => $default_path,
      default => $group_data['path'],
    }

    $group_scope = $group_data['scope'] ? {
      undef   => $default_scope,
      default => $group_data['scope'],
    }

    $group_category = $group_data['category'] ? {
      undef   => $default_category,
      default => $group_data['category'],
    }

    exec { "create-ad-group-${group_name}":
      command  => "New-ADGroup -Name '${group_name}' -SamAccountName '${group_name}' -GroupScope '${group_scope}' -GroupCategory '${group_category}' -Path '${group_path}'",
      provider => powershell,
      unless   => "if (Get-ADGroup -Identity '${group_name}' -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }",
    }
  }
}
