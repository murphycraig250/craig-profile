function Join-LabDomain {
    param(
        [Parameter(Mandatory)]
        [string]$DomainName,

        [Parameter(Mandatory)]
        [pscredential]$Credential
    )

    Add-Computer `
        -DomainName $DomainName `
        -Credential $Credential `
        -Restart
}