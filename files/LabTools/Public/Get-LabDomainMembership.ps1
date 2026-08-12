function Get-LabDomainMembership {
    Get-CimInstance Win32_ComputerSystem |
        Select-Object Name, Domain, PartOfDomain
}