class profile::dc_users (
  Hash $users = {},
  String $default_path = 'OU=lab_users,DC=localdomain,DC=test',
  Boolean $default_enabled = true,
) {
  $users.each |String $username, Hash $user_data| {
    $user_path = $user_data['path'] ? {
      undef   => $default_path,
      default => $user_data['path'],
    }

    $enabled = $user_data['enabled'] ? {
      undef   => $default_enabled,
      default => $user_data['enabled'],
    }

    $given_name = $user_data['given_name'] ? {
      undef   => $username,
      default => $user_data['given_name'],
    }

    $surname = $user_data['surname'] ? {
      undef   => '',
      default => $user_data['surname'],
    }

    $display_name = $user_data['display_name'] ? {
      undef   => "${given_name} ${surname}".strip,
      default => $user_data['display_name'],
    }

    exec { "create-ad-user-${username}":
      command  => "New-ADUser -Name '${display_name}' -SamAccountName '${username}' -UserPrincipalName '${username}@localdomain.test' -GivenName '${given_name}' -Surname '${surname}' -Path '${user_path}' -Enabled \$${enabled}",
      provider => powershell,
      unless   => "try { Get-ADUser -Identity '${username}' -ErrorAction Stop; exit 0 } catch { exit 1 }",
    }

    if $user_data['groups'] {
      $user_data['groups'].each |String $group| {
        exec { "add-${username}-to-${group}":
          command  => "Add-ADGroupMember -Identity '${group}' -Members '${username}'",
          provider => powershell,
          unless   => "try { if (Get-ADGroupMember -Identity '${group}' -ErrorAction Stop | Where-Object { \$_.SamAccountName -eq '${username}' }) { exit 0 } else { exit 1 } } catch { exit 1 }",
          require  => Exec["create-ad-user-${username}"],
        }
      }
    }
  }
}
