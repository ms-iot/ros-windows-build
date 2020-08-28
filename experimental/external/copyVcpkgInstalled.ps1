[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$True)][string]$InstallDir,
    [Parameter(Mandatory=$True)][string]$VcpkgInstalled
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
    # Copy Vcpkg installed
    $developmentFiles = @(
        '*.pdb',
        '*-debug.cmake'
    )
    Get-ChildItem -Path $VcpkgInstalled | ForEach-Object {
        if ("debug" -eq $_) {
            return
        }
        $arguments = @{
            Path = (Join-Path $VcpkgInstalled $_)
            Recurse = $True
            Destination = $installDir
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
