class profile::dc_ous (
  Hash $ous = {},
  String $default_path = 'DC=localdomain,DC=test',
) {
  $ous.each |String $ou_name, Hash $ou_data| {
    $ou_path = $ou_data['path'] ? {
      undef   => $default_path,
      default => $ou_data['path'],
    }

    exec { "create-ou-${ou_name}":
      command  => "New-ADOrganizationalUnit -Name '${ou_name}' -Path '${ou_path}' -ProtectedFromAccidentalDeletion \$false",
      provider => powershell,
      unless   => "if (Get-ADOrganizationalUnit -Identity 'OU=${ou_name},${ou_path}' -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }",
    }
  }
}
