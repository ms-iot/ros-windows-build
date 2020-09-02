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
        Version = "noetic/2020-08-31"
        Packages = @(
            'navigation',
            'desktop_full',
            'eigenpy',
            'eigen_stl_containers',
            'geometric_shapes',
            'moveit_msgs',
            'object_recognition_msgs',
            'octomap_msgs',
            'random_numbers',
            'srdfdom',
            'four_wheel_steering_msgs',
            'warehouse_ros',
            'rviz_visual_tools',
            'graph_msgs',
            'imu_tools',
            'rosserial',
            'rosparam_shortcuts'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Noetic repos."
  throw
}
