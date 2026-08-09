class profile::dc_ous (
  Hash $ous = {},
) {
  $ous.each |String $ou_name, Hash $ou_data| {
    exec { "create-ou-${ou_name}":
      command  => "New-ADOrganizationalUnit -Name '${ou_name}' -Path '${ou_data['path']}' -ProtectedFromAccidentalDeletion `${false}",
      provider => powershell,
      unless   => "if (Get-ADOrganizationalUnit -LDAPFilter '(ou=${ou_name})' -SearchBase '${ou_data['path']}' -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }",
    }
  }
}
