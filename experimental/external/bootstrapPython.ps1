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
    $wheelsDir = (Join-Path $scriptsDir "wheels")

    Set-Alias python (Join-Path $installDir "python.exe") -Scope Script

    $workingDir, $installDir, $vcpkgDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    # bootstrap settings
    $requirements = (Join-Path $scriptsDir "requirements.txt")

    # download the embedded Python
    $url = "https://www.python.org/ftp/python/3.8.3/python-3.8.3-embed-amd64.zip"
    $embeddedPython = (Join-Path $workingDir "python-3.8.3-embed-amd64.zip")
    Invoke-WebRequest -Uri $url -OutFile $embeddedPython

    # download Get-Pip
    $getpipUrl = "https://bootstrap.pypa.io/get-pip.py"
    $getpip = (Join-Path $workingDir "get-pip.py")
    Invoke-WebRequest -Uri $getpipUrl -OutFile $getpip

    # install the Python environment
    Expand-Archive -LiteralPath $embeddedPython -DestinationPath $installDir
    Add-Content -Path (Join-Path $installDir "python38._pth") -Value "Lib\site-packages"
    $Env:PATH = "$installDir\Scripts;$Env:PATH"
    python $getpip
    python -m pip install -r $requirements
    python -m pip install netifaces --find-links $wheelsDir
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
