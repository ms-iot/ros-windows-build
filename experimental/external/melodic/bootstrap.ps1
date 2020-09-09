[CmdletBinding()]
param(
    $badParam,
    [Parameter(Mandatory=$True)][string]$InstallDir
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
    Set-Alias ruplacer (Join-Path $scriptsDir "ruplacer\ruplacer.exe") -Scope Script

    # Bootstrap legacy rosdeps.
    $chocoPackages = @(
        'ros-python2',
        # 'sip',
        # 'eigen',
        'tinyxml2',
        # 'freeglut',
        # 'qt5-sdk',
        # 'lz4',
        # 'libgraphviz',
        # 'libompl',
        # 'cppunit',
        # 'libccd',
        # 'libfcl',
        # 'log4cxx',
        # 'openssl',
        # 'boost',
        # 'gtk2',
        # 'libopencv',
        # 'lua',
        # 'google-mock',
        # 'libjpeg-turbo',
        # 'poco',
        # 'pkg-config',
        # 'gflags',
        # 'gazebo9',
        # 'assimp',
        # 'sbcl',
        # 'protobuf',
        # 'google-test',
        # 'yaml-cpp',
        # 'libqglviewer',
        # 'sdl_image',
        # 'libflann',
        # 'urdfdom',
        # 'pyqt5',
        # 'pyside2',
        # 'tinyxml',
        # 'sdl',
        # 'console_bridge',
        # 'libtheora',
        # 'glog',
        # 'ceres',
        # 'suitesparse',
        # 'clapack',
        # 'openblas',
        # 'metis',
        # 'libpcl',
        # 'octomap',
        # 'bzip2',
        # 'urdfdom_headers',
        # 'cairo',
        # 'libogg',
        # 'libglew',
        # 'bullet3',
        'vcpython27'
    )

    $chocoPackages | ForEach-Object {
        choco install -y --no-progress $_
    }

    New-Item -Path $InstallDir -ItemType directory -Force | Out-Null

    # Copy Rosdep installed
    $LegacyRosdep = "C:\opt\rosdeps\x64"
    $developmentFiles = @(
        '*.pdb',
        '*-debug.cmake'
    )
    Get-ChildItem -Path $LegacyRosdep | ForEach-Object {
        if ("debug" -eq $_) {
            return
        }
        $arguments = @{
            Path = (Join-Path $LegacyRosdep $_)
            Recurse = $True
            Destination = $InstallDir
            Container = $True
            Exclude = $developmentFiles
            Force = $True
        }
        Copy-Item @arguments
    }

    $PythonInstalled = "C:\opt\python27amd64"
    Get-ChildItem -Path $PythonInstalled | ForEach-Object {
        $arguments = @{
            Path = (Join-Path $PythonInstalled $_)
            Recurse = $True
            Destination = $InstallDir
            Container = $True
            Force = $True
        }
        Copy-Item @arguments
    }

    # Bootstrap Python dependencies.
    $Env:PATH = "C:\opt\ros\melodic\x64\Scripts;C:\opt\ros\melodic\x64;$Env:PATH"
    Set-Alias python (Join-Path "C:\opt\ros\melodic\x64" "python.exe") -Scope Script
    $requirements = (Join-Path $scriptsDir "requirements.txt")
    $Env:PYTHONWARNINGS="ignore:DEPRECATION"

    python -m pip install --upgrade pip setuptools --disable-pip-version-check --no-cache-dir 2>&1
    $global:lastexitcode = 0
    python -m pip install -U -r $requirements --disable-pip-version-check --no-cache-dir 2>&1
    $global:lastexitcode = 0

    # Fix-up all hard-coded paths.
    ruplacer "c:/opt/rosdeps" "c:/opt/ros/melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer0.log")
    ruplacer "C:/opt/rosdeps" "C:/opt/ros/melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer1.log")
    ruplacer "c:\opt\rosdeps" "c:\opt\ros\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer2.log")
    ruplacer "C:\opt\rosdeps" "C:\opt\ros\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer3.log")
    ruplacer "C:\\opt\\rosdeps" "C:\\opt\\ros\\melodic" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer4.log")
    ruplacer "c:/opt/python27amd64" "c:/opt/ros/melodic/x64" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer5.log")
    ruplacer "C:/opt/python27amd64" "C:/opt/ros/melodic/x64" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer6.log")
    ruplacer "c:\opt\python27amd64" "c:\opt\ros\melodic\x64" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer7.log")
    ruplacer "C:\opt\python27amd64" "C:\opt\ros\melodic\x64" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer8.log")
    ruplacer "C:\\opt\\python27amd64" "C:\\opt\\ros\\melodic\\x64" "$InstallDir" --no-regex --color never --go | Out-File -FilePath (Join-Path $InstallDir "ruplacer9.log")
}
catch
{
  Write-Warning "Bootstrapping ROS dependencies failed."
  throw
}
