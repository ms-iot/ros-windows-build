[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$True)][string]$InstallDir
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
    $vcpkgDir = (join-Path $scriptsDir "vcpkg")
    $Env:VCPKG_DEFAULT_TRIPLET = "x64-windows"

    $vcpkgDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }
    
    $versionDate = '2022-03-30'

    # download the Vcpkg
    $url = "https://github.com/microsoft/vcpkg-tool/releases/download/$versionDate/vcpkg.exe"
    $vcpkgExe = (Join-Path $vcpkgDir "vcpkg.exe")
    Invoke-WebRequest -Uri $url -OutFile $vcpkgExe

    # copy the Vcpkg into the install layout.
    $arguments = @{
        Path = (Join-Path $vcpkgDir "vcpkg.exe")
        Recurse = $True
        Destination = (Join-Path $InstallDir "tools\vcpkg")
        Container = $False
        Force = $True
    }
    Copy-Item @arguments
}
catch
{
  Write-Warning "Bootstrapping Vcpkg failed."
  throw
}
