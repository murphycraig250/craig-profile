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
      unless   => "try { Get-ADOrganizationalUnit -Identity 'OU=${ou_name},${ou_path}' -ErrorAction Stop; exit 0 } catch { exit 1 }",
    }
  }
}
