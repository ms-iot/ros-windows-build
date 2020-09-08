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
    Set-Alias ruplacer (Join-Path $scriptsDir "ruplacer\ruplacer.exe") -Scope Script

    New-Item -Path $InstallDir -ItemType directory -Force | Out-Null

    # Copy Rosdep installed
    $LegacyRosdep = "C:\opt\rosdeps\x64"
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
    Get-ChildItem -Path $PythonInstalled | ForEach-Object {
        $arguments = @{
            Path = (Join-Path $PythonInstalled $_)
            Recurse = $True
            Destination = $InstallDir
            Container = $True
            Force = $True
        }
        Copy-Item @arguments
    }

    ruplacer "C:/opt/rosdeps" "C:/opt/ros/melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer1.log")
    ruplacer "c:\opt\rosdeps" "c:\opt\ros\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer2.log")
    ruplacer "C:\opt" "C:\opt\ros\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer3.log")
    ruplacer "C:\\opt" "C:\\opt\ros\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer4.log")
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
