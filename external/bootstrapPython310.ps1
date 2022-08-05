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

    Set-Alias python (Join-Path $InstallDir "python.exe") -Scope Script

    $workingDir, $InstallDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    # bootstrap settings
    $requirements = (Join-Path $scriptsDir "requirements.txt")

    # download the Python
    $PythonInstaller = (Join-Path $workingDir "python-3.10.6-amd64.exe")
    if (!(Test-Path $PythonInstaller))
    {
        $url = "https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe"
        Write "Downloading $url to $PythonInstaller"
        Invoke-WebRequest -Uri $url -OutFile $PythonInstaller
    }

    # download Get-Pip
    $getpip = (Join-Path $workingDir "get-pip.py")
    if (!(Test-Path $getpip))
    {
        $getpipUrl = "https://bootstrap.pypa.io/get-pip.py"
        Invoke-WebRequest -Uri $getpipUrl -OutFile $getpip
    }

    # install the Python environment
    $Env:PATH = "$InstallDir\Scripts;$Env:PATH"

    Set-Alias PythonInstaller $PythonInstaller -Scope Script

    $targetDir = "TargetDir=$InstallDir"
    Write "Invoking $PythonInstaller $targetDir /quiet"
    Start-Process $PythonInstaller -ArgumentList "TargetDir=$InstallDir", "/quiet" -wait

    Write "Executing $InstallDir\python.exe $getpip"
    python $getpip
    python -m pip install -r $requirements
    python -m pip install netifaces --find-links $wheelsDir
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
