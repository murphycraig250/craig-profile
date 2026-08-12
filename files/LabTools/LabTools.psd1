@{
    RootModule        = 'LabTools.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '9d6e8d7e-2e5c-4f45-9e8d-123456789abc'
    Author            = 'Lab'
    Description       = 'PowerShell functions for the Windows lab'

    FunctionsToExport = @(
        'Test-LabTools'
        'Get-LabDomainMembership'
    )
}