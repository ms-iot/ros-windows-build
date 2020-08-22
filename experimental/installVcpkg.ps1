[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$False)][string]$InstallDir = "install"
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
# Powershell2-compatible way of forcing named-parameters
if ($badParam)
{
    throw "Only named parameters are allowed"
}

$Uri = 'https://github.com/seanyen/vcpkg.git'

try
{
    $Env:GIT_REDIRECT_STDERR="2>&1"
    git clone $Uri $InstallDir -q -b "seanyen/2020.08.21" | Out-Null
    & "$InstallDir\bootstrap-vcpkg.bat"

    Write-Host 'Validating vcpkg...'
    & "$InstallDir\vcpkg.exe" version
    & "$InstallDir\vcpkg.exe" list

    Write-Host 'Deploying vcpkg... done.'
}
catch
{
  Write-Warning "Vcpkg is not installed properly."
  Write-Warning "Visit https://github.com/microsoft/vcpkg for more help."
  throw
}
