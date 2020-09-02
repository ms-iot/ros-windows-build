@echo OFF

set ROS_VERSION=2

colcon build ^
    --merge-install ^
    --packages-skip-by-dep rttest test_osrf_testing_tools_cpp tlsf ^
    --packages-skip rttest test_osrf_testing_tools_cpp tlsf ^
    --install-base %INSTALL_DIR% ^
    --cmake-target install ^
    --cmake-args ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin ^
        -DCMAKE_PDB_OUTPUT_DIRECTORY=%PDB_OUTPUT_DIRECTORY%
