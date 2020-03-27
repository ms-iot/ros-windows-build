@echo off
setlocal

:: source ROS environments
pushd %~dp0
call "setup.bat"

:: check all required environments are set
if not defined ROS_DISTRO (
    echo ROS_DISTRO should be defined. 1>&2
    exit 1
)

if not defined ROS_ETC_DIR (
    echo ROS_ETC_DIR should be defined. 1>&2
    exit 1
)

if not defined PYTHONHOME (
    echo PYTHONHOME should be defined. 1>&2
    exit 1
)

if not defined ROS_PYTHON_VERSION (
    echo ROS_PYTHON_VERSION should be defined. 1>&2
    exit 1
)

:: use Python from ROS installation
set PATH=%PYTHONHOME%;%PYTHONHOME%\Scripts;%PATH%
set PYTHONPATH=

:: install ROS system dependencies
rosdep init
rosdep update
rosdep install --from-paths c:\opt\ros\%ROS_DISTRO%\x64\share --ignore-src -r -y
if errorlevel 1 exit 1
