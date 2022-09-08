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

    # download the Vcpkg
    $url = "https://github.com/ms-iot/vcpkg/archive/refs/heads/humble.zip"
    $vcpkgZip = (Join-Path $vcpkgDir "vcpkg-humble.zip")
    Invoke-WebRequest -Uri $url -OutFile $vcpkgZip

    # install the Vcpkg
    Expand-Archive -LiteralPath $vcpkgZip -DestinationPath $vcpkgDir
    & "$vcpkgDir\vcpkg-humble\bootstrap-vcpkg.bat"

    # copy the Vcpkg into the install layout.
    $arguments = @{
        Path = (Join-Path $vcpkgDir "humble")
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
