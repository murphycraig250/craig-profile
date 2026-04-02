# @summary Manages Chocolatey installations on Windows (module not 2025 compatible)
#
# This class orchestrates the installation of Chocolatey using powershell

# @example
#   include profile::choco_setup
class profile::choco_setup {
  exec { 'install_chocolatey_official':
    command  => 'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://community.chocolatey.org/install.ps1"))',
    onlyif   => 'if (Test-Path "$env:ProgramData\chocolatey\bin\choco.exe") { exit 1 } else { exit 0 }',
    provider => 'powershell',
    timeout  => 600,
  }
}
