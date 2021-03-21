@echo OFF

set ROS_VERSION=2
set "IGNORED_PACKAGES=rttest test_osrf_testing_tools_cpp tlsf pybind11_vendor camera_calibration_parsers rosbag2_storage"

colcon build ^
    --merge-install ^
    --packages-skip-by-dep %IGNORED_PACKAGES% ^
    --packages-skip %IGNORED_PACKAGES% ^
    --install-base %INSTALL_DIR% ^
    --cmake-target install ^
    --cmake-args ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin ^
        -DCMAKE_PDB_OUTPUT_DIRECTORY=%PDB_OUTPUT_DIRECTORY% ^
    2>&1
if errorlevel 1 exit 1

:: fix srdfdom.dll location.
move /Y %INSTALL_DIR%\lib\*.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1
