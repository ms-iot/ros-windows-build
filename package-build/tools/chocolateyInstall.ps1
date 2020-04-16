$ErrorActionPreference = 'Stop';

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'drop.zip'
$destination = 'c:\opt\ros'

$packageArgs = @{
  packageName   = $packageName
  destination   = $destination
  fileFullPath64  = $fileLocation
}

$migrationArray = @( 
  "rqt_moveit-0.5.7-py2.7.egg-info",
  "rqt_robot_monitor-0.5.9-py2.7.egg-info",
  "rqt_rviz-0.6.0-py2.7.egg-info"
)

# As part of a noetic migration, these have been changed to directories. 
# During unpacking, chocolatey will see this as an error.

# delete these files from old deployment, so the new deployment unpacks correctly
$migrationPackagesPath = Join-Path $destination 'melodic\x64\lib\site-packages' 

foreach ($migrationFile in $migrationArray) {
  $migration = Join-Path $migrationPackagesPath $migrationFile
  if (Test-Path -Path $migration -PathType leaf) {
    Remove-Item $migration
  }
}

# - https://chocolatey.org/docs/helpers-get-chocolatey-unzip
Get-ChocolateyUnzip @packageArgs

Write-Host 'running rosdep...'
$ErrorActionPreference = 'SilentlyContinue';
$rosdepInstall = Join-Path $toolsDir 'rosdepInstall.bat'
$p = Start-Process -PassThru -FilePath "$env:comspec" -Wait -NoNewWindow -ArgumentList "/c", $rosdepInstall
If($p.Exitcode -ne 0)
{
  Throw "rosdepInstall.bat failed."
}
