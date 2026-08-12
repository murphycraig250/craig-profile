function Get-LabDomain {
    $computer = Get-CimInstance Win32_ComputerSystem

    [PSCustomObject]@{
        ComputerName = $computer.Name
        Domain       = $computer.Domain
        PartOfDomain = $computer.PartOfDomain
    }
}