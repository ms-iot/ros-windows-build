@echo off
pushd c:\colcon_ws
set CMAKE_BUILD_PARALLEL_LEVEL=2
set CMAKE_PREFIX_PATH=C:/opt/rosdeps/x64
set "ROSWIN_COLCON_PACKAGE_UP_TO=--packages-up-to %ROSWIN_METAPACKAGE% %ROSWIN_ADDITIONAL_PACKAGE%"
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
colcon --log-level info test ^
       %ROSWIN_COLCON_PACKAGE_UP_TO% ^
       %ROSWIN_COLCON_PACKAGE_SKIP_BY_DEP% ^
       %ROSWIN_COLCON_PACKAGE_SKIP% ^
       --merge-install --parallel-workers 1 ^
       --event-handlers console_cohesion+ ^
       --install-base "%ROSWIN_CMAKE_INSTALL_PREFIX%"

colcon --log-level info test-result

exit /b 0