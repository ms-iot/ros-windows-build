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
    $workingDir = (Join-Path $scriptsDir "working")
    $vcpkgDir = (Join-Path $scriptsDir "vcpkg")
    $wheelsDir = (Join-Path $scriptsDir "wheels")

    Set-Alias python (Join-Path $installDir "python.exe") -Scope Script
    Set-Alias vcpkg (Join-Path $vcpkgDir "vcpkg.exe") -Scope Script

    $workingDir, $installDir, $vcpkgDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    # bootstrap settings
    $requirements = (Join-Path $scriptsDir "requirements.txt")
    $vcpkgInput = (Join-Path $scriptsDir "vcpkg.in")
    $vcpkgTriplet = "x64-windows"

    # download the embedded Python
    $url = "https://www.python.org/ftp/python/3.8.3/python-3.8.3-embed-amd64.zip"
    $embeddedPython = (Join-Path $workingDir "python-3.8.3-embed-amd64.zip")
    Invoke-WebRequest -Uri $url -OutFile $embeddedPython

    # download Get-Pip
    $getpipUrl = "https://bootstrap.pypa.io/get-pip.py"
    $getpip = (Join-Path $workingDir "get-pip.py")
    Invoke-WebRequest -Uri $getpipUrl -OutFile $getpip

    # download Vcpkg
    $vcpkgInstall = (Join-Path $scriptsDir 'installVcpkg.ps1')
    & "$vcpkgInstall" -InstallDir $vcpkgDir

    # install the Python environment
    Expand-Archive -LiteralPath $embeddedPython -DestinationPath $installDir
    Add-Content -Path (Join-Path $installDir "python38._pth") -Value "Lib\site-packages"
    $Env:PATH = "$installDir\Scripts;$Env:PATH"
    python $getpip
    python -m pip install -v -r $requirements --find-links $wheelsDir

    # bootstrap Vcpkg ports
    $Env:VCPKG_DEFAULT_TRIPLET = $vcpkgTriplet
    vcpkg install @$vcpkgInput --x-buildtrees-root=d:\bld

    # Copy Vcpkg installed
    $developmentFiles = @(
        '*.pdb',
        '*-debug.cmake'
    )
    $vcpkgInstalled = (Join-Path $vcpkgDir "installed\$vcpkgTriplet")
    Get-ChildItem -Path $vcpkgInstalled | ForEach-Object {
        if ("debug" -eq $_) {
            return
        }
        $arguments = @{
            Path = (Join-Path $vcpkgInstalled $_)
            Recurse = $True
            Destination = $installDir
            Container = $True
            Exclude = $developmentFiles
            Force = $True
        }
        Copy-Item @arguments
    }

    $compress = @{
        Path = "$installDir\*"
        CompressionLevel = "Fastest"
        DestinationPath = "$scriptsDir\drop.zip"
    }
    Compress-Archive @compress
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
