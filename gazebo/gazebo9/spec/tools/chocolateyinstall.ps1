$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'bin'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFile    = Join-Path $toolsDir "$packageName.zip"
$destFolder = "C:\opt\rosdeps\x64"

# Unzip the rosdep to the specified folder
Get-ChocolateyUnzip -FileFullPath $zipFile -Destination $destFolder -PackageName $packageName
