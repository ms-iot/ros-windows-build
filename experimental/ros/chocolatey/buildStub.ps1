[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$True)][string]$PackageName,
    [Parameter(Mandatory=$True)][string]$PackageVersion,
    [Parameter(Mandatory=$True)][string]$DepPackageName,
    [Parameter(Mandatory=$True)][string]$DepPackageVersion
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
    $workingDir = (Join-Path $scriptsDir "working")
    $toolsDir = (Join-Path $workingDir "tools")
    $outputDir = (Join-Path $scriptsDir "output")
    $templateNuspec = (Join-Path $scriptsDir "stub.nuspec")
    $packageNuspec = (Join-Path $workingDir "$PackageName.nuspec")

    $workingDir, $outputDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "Cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    Copy-Item -Force -Path $templateNuspec -Destination $packageNuspec

    $filetext = @"
`$stubPackageName= '$PackageName'
`$realPackageName= '$DepPackageName'

Write-Warning "Subpackage `$stubPackageName is going to be deprecated soon. Install `$realPackageName in the future for the same features."
"@

    New-Item -Path $toolsDir -ItemType directory -Force | Out-Null

    Out-File -filepath (Join-Path $toolsDir "chocolateyinstall.ps1") -inputobject $filetext

    choco pack --trace --out $outputDir $packageNuspec name=$PackageName version=$PackageVersion dep_name=$DepPackageName dep_version=$DepPackageVersion
}
catch
{
  Write-Warning "Failed to build Chocolatey packages."
  throw
}
