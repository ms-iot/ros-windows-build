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
    $url = "https://github.com/microsoft/vcpkg/archive/2020.07.zip"
    $vcpkgZip = (Join-Path $vcpkgDir "vcpkg-2020.07.zip")
    Invoke-WebRequest -Uri $url -OutFile $vcpkgZip

    # install the Vcpkg
    Expand-Archive -LiteralPath $vcpkgZip -DestinationPath $vcpkgDir
    & "$vcpkgDir\vcpkg-2020.07\bootstrap-vcpkg.bat"

    # copy the Vcpkg into the install layout.
    $arguments = @{
        Path = (Join-Path $vcpkgDir "vcpkg-2020.07")
        Recurse = $True
        Destination = (Join-Path $InstallDir "vcpkg")
        Container = $False
        Force = $True
    }
    Copy-Item @arguments

    # build the required ports
    $vcpkgAnswerFile = (Join-Path $scriptsDir "vcpkg.in")
    & "$vcpkgDir\vcpkg-2020.07\vcpkg.exe" install @$vcpkgAnswerFile

    $vcpkgInstalled = "$vcpkgDir\vcpkg-2020.07\installed\x64-windows"
    $developmentFiles = @(
        '*.pdb',
        '*-debug.cmake'
    )
    Get-ChildItem -Path $vcpkgInstalled | ForEach-Object {
        if ("debug" -eq $_) {
            return
        }
        $arguments = @{
            Path = (Join-Path $vcpkgInstalled $_)
            Recurse = $True
            Destination = $InstallDir
            Container = $True
            Exclude = $developmentFiles
            Force = $True
        }
        Copy-Item @arguments
    }
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
