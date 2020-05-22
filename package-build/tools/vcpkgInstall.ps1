$ErrorActionPreference = 'Stop';

$Uri = 'https://github.com/Microsoft/vcpkg.git'
$RootDir = 'C:\opt'
$InstallDir = "$RootDir\vcpkg"
$VcpkgVersion = "2020.04"

New-Item -ItemType Directory -Path $RootDir -Force | Out-Null

Write-Host 'Deploying vcpkg...'
if (-Not (Test-Path -Path "$InstallDir\vcpkg.exe" -PathType Leaf)) {
  if (-Not (Test-Path -Path $InstallDir -PathType Container)) {
    git clone --depth=1 $Uri $InstallDir -q -b $VcpkgVersion
    Invoke-Expression "$InstallDir\bootstrap-vcpkg.bat"
  } else {
    throw "remove $InstallDir and reinstall again."
  }
}

Write-Host 'Validating vcpkg...'
Invoke-Expression "$InstallDir\vcpkg.exe version"

Write-Host 'Deploying vcpkg... done.'
