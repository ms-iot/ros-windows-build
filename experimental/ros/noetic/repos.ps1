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
        Distro = "noetic"
        Version = "noetic/2020-12-14"
        Packages = @(
            'desktop_full',
            'navigation',
            'moveit',
            'cartographer_ros',
            'rosserial',
            'imu_tools',
            'slam_karto',
            'rosparam_shortcuts',
            'graph_msgs',
            'four_wheel_steering_msgs',
            'rviz_visual_tools',
            'ros_type_introspection',
            'rosbridge_suite',
            'robot_localization'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Noetic repos."
  throw
}
