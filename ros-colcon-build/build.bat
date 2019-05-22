@echo off
pushd c:\colcon_ws
set CMAKE_PREFIX_PATH=C:/opt/rosdeps/x64
set "ROSWIN_COLCON_PACKAGE_UP_TO=--packages-up-to %ROSWIN_METAPACKAGE%"
if "%ROSWIN_METAPACKAGE%"=="ALL" (
    set ROSWIN_COLCON_PACKAGE_UP_TO=
)
set "ROSWIN_COLCON_PACKAGE_SKIP_BY_DEP=--packages-skip-by-dep %ROSWIN_PACKAGE_SKIP%"
if "%ROSWIN_PACKAGE_SKIP%"=="" (
    set ROSWIN_COLCON_PACKAGE_SKIP_BY_DEP=
)
set "ROSWIN_COLCON_PACKAGE_SKIP=--packages-skip %ROSWIN_PACKAGE_SKIP%"
if "%ROSWIN_PACKAGE_SKIP%"=="" (
    set ROSWIN_COLCON_PACKAGE_SKIP=
)
:: workaround has_target assert failure in colcon-cmake
set ROSWIN_COLCON_CMAKE_TARGET=
if "%ROS_DISTRO%"=="melodic" (
    set "ROSWIN_COLCON_CMAKE_TARGET=--cmake-target install"
)
colcon --log-level info build ^
       %ROSWIN_COLCON_PACKAGE_UP_TO% ^
       %ROSWIN_COLCON_PACKAGE_SKIP_BY_DEP% ^
       %ROSWIN_COLCON_PACKAGE_SKIP% ^
       --merge-install --parallel-workers 1 ^
       --event-handlers console_cohesion+ ^
       --install-base "%ROSWIN_CMAKE_INSTALL_PREFIX%" ^
       --catkin-skip-building-tests ^
       %ROSWIN_COLCON_CMAKE_TARGET% ^
       --catkin-cmake-args ^
        -DCATKIN_LOG=3 ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DCMAKE_PREFIX_PATH="%ROSWIN_CMAKE_INSTALL_PREFIX%;C:/opt/rosdeps/x64" ^
       --cmake-args ^
        -DCMAKE_BUILD_TYPE=Release ^
        -DCMAKE_VERBOSE_MAKEFILE=ON ^
        -DPYTHON_VERSION=3.7 ^
        -DPYTHON_EXECUTABLE=C:\opt\python37amd64\python.exe ^
        -DPYTHON_LIBRARIES=C:\opt\python37amd64\Libs
