[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$True)][string]$PackageName,
    [Parameter(Mandatory=$True)][string]$PackageVersion,
    [Parameter(Mandatory=$True)][string]$SetupProgram
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
    $toolsDir = (Join-Path $workingDir "tools")
    $outputDir = (Join-Path $scriptsDir "output")
    $templateNuspec = (Join-Path $scriptsDir "template.nuspec")
    $packageNuspec = (Join-Path $workingDir "$PackageName.nuspec")

    $workingDir, $outputDir | ForEach-Object {
        Remove-Item $_ -Force -Recurse -ErrorAction SilentlyContinue
        if (Test-Path $_ -PathType Container) {
            throw "Cannot remove $_"
        }

        New-Item -Path $_ -ItemType directory -Force | Out-Null
    }

    Copy-Item -Force -Path $templateNuspec -Destination $packageNuspec

    $filetext = @"
`$packageName= '$PackageName'
`$toolsDir   = "`$(Split-Path -Parent `$MyInvocation.MyCommand.Definition)"
`$fileLocation = Join-Path `$toolsDir 'setup.exe'

`$packageArgs = @{
  packageName   = `$packageName
  fileType      = 'exe'
  file          = `$fileLocation
  silentArgs    = "/VERYSILENT"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
"@

    New-Item -Path $toolsDir -ItemType directory -Force | Out-Null

    Out-File -filepath (Join-Path $toolsDir "chocolateyinstall.ps1") -inputobject $filetext

    Copy-Item -Force -Path $SetupProgram -Destination (Join-Path $toolsDir "setup.exe")

    choco pack --trace --out $outputDir $packageNuspec name=$PackageName version=$PackageVersion
}
catch
{
  Write-Warning "Failed to build Chocolatey packages."
  throw
}
