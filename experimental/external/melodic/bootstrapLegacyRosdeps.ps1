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

    $chocoPackages = @(
        'ros-python2',
        'sip',
        'eigen',
        'tinyxml2',
        'freeglut',
        'qt5-sdk',
        'lz4',
        'libgraphviz',
        'libompl',
        'cppunit',
        'libccd',
        'libfcl',
        'log4cxx',
        'openssl',
        'boost',
        'gtk2',
        'libopencv',
        'lua',
        'google-mock',
        'libjpeg-turbo',
        'poco',
        'pkg-config',
        'gflags',
        'gazebo9',
        'assimp',
        'sbcl',
        'protobuf',
        'google-test',
        'yaml-cpp',
        'libqglviewer',
        'sdl_image',
        'libflann',
        'urdfdom',
        'pyqt5',
        'pyside2',
        'tinyxml',
        'sdl',
        'console_bridge',
        'libtheora',
        'glog',
        'ceres',
        'suitesparse',
        'clapack',
        'openblas',
        'metis',
        'libpcl',
        'octomap',
        'bzip2',
        'urdfdom_headers',
        'cairo',
        'libogg',
        'libglew',
        'bullet3'
    )

    $chocoPackages | ForEach-Object {
        choco install -y --no-progress $_
    }

    $Env:PATH = "C:\opt\ros\melodic\x64\Scripts;C:\opt\ros\melodic\x64;$Env:PATH"
    Set-Alias python (Join-Path "C:\opt\ros\melodic\x64" "python.exe") -Scope Script
    $requirements = (Join-Path $scriptsDir "requirements.txt")

    python -m pip install -r $requirements
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
