[CmdletBinding()]
param(
    $badParam
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
    $rootDir = split-path -parent $scriptsDir

    $arguments = @{
        Distro = "melodic"
        Version = "melodic/2020-10-12"
        Packages = @(
            'desktop_full',
            'navigation',
            'moveit',
            'moveit_visual_tools',
            'cartographer_ros',
            'rosserial',
            'teleop_twist_joy',
            'imu_tools',
            'slam_karto',
            'rosparam_shortcuts',
            'slam_gmapping',
            'robot_localization',
            'ros_type_introspection',
            'rosbridge_suite'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Melodic repos."
  throw
}
