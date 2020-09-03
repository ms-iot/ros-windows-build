[CmdletBinding()]
param(
    $badParam
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
# Powershell2-compatible way of forcing named-parameters
if ($badParam)
{
    throw "Only named parameters are allowed"
}

try
{
    $scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
    $rootDir = split-path -parent $scriptsDir

    $arguments = @{
        Distro = "eloquent"
        Version = "64031e38a3d0ed3516e17f97d5ea7696d7dac369" # eloquent/2020-08-13
        Packages = @(
            'desktop'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Eloquent repos."
  throw
}
