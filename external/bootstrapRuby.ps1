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

    Set-Alias Ruby (Join-Path $InstallDir "ruby.exe") -Scope Script

    $workingDir, $InstallDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    # download Ruby
    $RubyInstaller = (Join-Path $workingDir "Ruby-3.10.6-amd64.exe")
    if (!(Test-Path $RubyInstaller))
    {
        $url = "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.2-1/rubyinstaller-3.1.2-1-x64.exe"
        Write "Downloading $url to $RubyInstaller"
        Invoke-WebRequest -Uri $url -OutFile $RubyInstaller
    }

    $RubyLicense = (Join-Path $InstallDir "ruby-license.txt")
    if (!(Test-Path $RubyInstaller))
    {
        $url = "https://www.ruby-lang.org/en/about/license.txt"
        Write "Downloading $url to $RubyLicense"
        Invoke-WebRequest -Uri $url -OutFile $RubyLicense
    }
    

    # install the Ruby environment
    $Env:PATH = "$InstallDir\Scripts;$Env:PATH"

    Set-Alias RubyInstaller $RubyInstaller -Scope Script

    $targetDir = "TargetDir=$InstallDir"
    Write "Invoking $RubyInstaller $targetDir /quiet"
    Start-Process $RubyInstaller -ArgumentList "/dir=$InstallDir", "/verysilent /tasks=noridkinstall,noassocfiles,nomodpath" -wait
}
catch
{
  Write-Warning "Bootstrapping ROS Ruby Dependency failed."
  throw
}
