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
        Distro = "foxy"
        Version = "foxy/2021-09-02"
        Packages = @(
            'navigation2',
            'desktop',
            'random_numbers',
            'joint_state_publisher',
            'octomap_msgs',
            'object_recognition_msgs',
            'turtlebot3_msgs',
            'gazebo_ros_pkgs',
            'realtime_tools',
            'xacro',
            'eigen_stl_containers',
            'control_msgs',
            'urdfdom_py',
            'moveit_core',
            'warehouse_ros'
        )
    }

    & (Join-Path $rootDir "generateRepos.ps1") @arguments
}
catch
{
  Write-Warning "Failed to generate Foxy repos."
  throw
}
