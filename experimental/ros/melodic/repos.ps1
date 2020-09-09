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
        Distro = "melodic"
        Version = "melodic/2020-08-26"
        Packages = @(
            'desktop'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Melodic repos."
  throw
}
