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

    $workingDir, $installDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    # bootstrap settings
    $requirements = (Join-Path $scriptsDir "requirements.txt")

    # download the Python
    $url = "https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe"
    $PythonInstaller = (Join-Path $workingDir "python-3.10.6-amd64.exe")
    Invoke-WebRequest -Uri $url -OutFile $PythonInstaller

    # download Get-Pip
    $getpipUrl = "https://bootstrap.pypa.io/get-pip.py"
    $getpip = (Join-Path $workingDir "get-pip.py")
    Invoke-WebRequest -Uri $getpipUrl -OutFile $getpip

    # install the Python environment
    $Env:PATH = "$installDir\Scripts;$Env:PATH"
    $PythonInstaller TargetDir="$installDir" /quiet 
    python $getpip
    python -m pip install -r $requirements
    python -m pip install netifaces --find-links $wheelsDir
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
