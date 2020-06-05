$ErrorActionPreference = 'Stop';

$Uri = 'https://github.com/Microsoft/vcpkg.git'
$RootDir = 'C:\opt'
$InstallDir = "$RootDir\vcpkg"
$VcpkgVersion = "2020.04"

try
{
  New-Item -ItemType Directory -Path $RootDir -Force | Out-Null

  # shadow the Vcpkg environment variables which could break the deployment.
  if (Test-Path env:VCPKG_ROOT)
  {
    Write-Warning "%VCPKG_ROOT% is defined. Removing from current session."
    Remove-Item env:VCPKG_ROOT
  }

  Write-Host 'Deploying vcpkg...'
  if (-Not (Test-Path -Path "$InstallDir\vcpkg.exe" -PathType Leaf))
  {
    if (-Not (Test-Path -Path $InstallDir -PathType Container))
    {
      $Env:GIT_REDIRECT_STDERR="2>&1"
      git clone $Uri $InstallDir -q -b $VcpkgVersion | Out-Null
      & "$InstallDir\bootstrap-vcpkg.bat"
    }
    else
    {
      throw "Found incomplete Vcpkg installation. Remove $InstallDir and reinstall again."
    }
  }
  else
  {
    Write-Host "Vcpkg.exe is found. Upgrading it to '$VcpkgVersion'."
    Write-Host "Checking any uncommitted changes under '$InstallDir'."

    $gitStatus = & git "--git-dir=$InstallDir\.git" "--work-tree=$InstallDir" status --porcelain
    if (-not ([string]::IsNullOrEmpty($gitStatus)))
    {
      Write-Warning $gitStatus
      Write-Warning "Uncommitted changes are found."
      Write-Warning "Revert or commit the changes and retry again."
      throw "Uncommitted changes are found."
    }

    Write-Host 'Pulling vcpkg ...'
    $Env:GIT_REDIRECT_STDERR="2>&1"
    & git "--git-dir=$InstallDir\.git" "--work-tree=$InstallDir" fetch
    & git "--git-dir=$InstallDir\.git" "--work-tree=$InstallDir" checkout $VcpkgVersion

    Write-Host 'Bootstraping vcpkg ...'
    & "$InstallDir\bootstrap-vcpkg.bat"

    Write-Host 'Upgrading vcpkg installed ports ...'
    & "$InstallDir\vcpkg.exe" upgrade --no-dry-run
  }

  Write-Host 'Validating vcpkg...'
  & "$InstallDir\vcpkg.exe" version
  & "$InstallDir\vcpkg.exe" list

  Write-Host 'Deploying vcpkg... done.'
}
catch
{
  Write-Warning "Vcpkg is not installed or upgraded properly."
  Write-Warning "Visit https://github.com/microsoft/vcpkg for more help."
  throw
}
