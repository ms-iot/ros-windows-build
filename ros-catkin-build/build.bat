@echo off
set CMAKE_BUILD_PARALLEL_LEVEL=2
set "ROSWIN_CATKIN_PACKAGE_SKIP=--ignore-pkg %ROSWIN_PACKAGE_SKIP%"
if "%ROSWIN_PACKAGE_SKIP%"=="" (
    set ROSWIN_CATKIN_PACKAGE_SKIP=
)

set BUILD_MERGED_ROS_PACKAGES=%ROSWIN_METAPACKAGE% %ROSWIN_ADDITIONAL_PACKAGE%
pushd c:\catkin_ws
copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "c:/opt/ros/melodic/x64" ^
    --use-nmake ^
    --install ^
    --only-pkg-with-deps %BUILD_MERGED_ROS_PACKAGES% ^
    %ROSWIN_CATKIN_PACKAGE_SKIP% ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCMAKE_PREFIX_PATH="%ROSWIN_CMAKE_PREFIX_PATH%" ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DCMAKE_PROGRAM_PATH="%ROSWIN_CMAKE_PROGRAM_PATH%" ^
    -DPYTHON_VERSION=2.7 ^
    -DPYTHON_EXECUTABLE=C:\opt\python27amd64\python.exe ^
    -DPYTHON_LIBRARIES=C:\opt\python27amd64\Libs ^
    -DCATKIN_SKIP_TESTING=ON
