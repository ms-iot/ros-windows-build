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
    New-Item -Path $InstallDir -ItemType directory -Force | Out-Null

    $LegacyRosdep = "C:\opt\rosdeps\x64"
    # Copy Rosdep installed
    $developmentFiles = @(
        '*.pdb',
        '*-debug.cmake'
    )
    Get-ChildItem -Path $LegacyRosdep | ForEach-Object {
        if ("debug" -eq $_) {
            return
        }
        $arguments = @{
            Path = (Join-Path $LegacyRosdep $_)
            Recurse = $True
            Destination = $InstallDir
            Container = $True
            Exclude = $developmentFiles
            Force = $True
        }
        Copy-Item @arguments
    }

    $PythonInstalled = "C:\opt\python27amd64"
    Copy-Item -Path $PythonInstalled -Destination $InstallDir
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
