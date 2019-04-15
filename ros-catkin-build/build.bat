@echo off
set BUILD_MERGED_ROS_PACKAGES=%BUILD_ROS_PACKAGE% %BUILD_ROS_ADDITIONAL_PACKAGE%
pushd c:\catkin_ws
copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "c:/opt/ros/melodic/x64" ^
    --use-nmake ^
    --install ^
    --only-pkg-with-deps %BUILD_MERGED_ROS_PACKAGES% ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCMAKE_PREFIX_PATH="C:/opt/ros/melodic/x64;C:/opt/rosdeps/x64" ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DPYTHON_VERSION=2.7 ^
    -DPYTHON_EXECUTABLE=C:\opt\python27amd64\python.exe ^
    -DPYTHON_LIBRARIES=C:\opt\python27amd64\Libs ^
    -DCATKIN_SKIP_TESTING=ON
