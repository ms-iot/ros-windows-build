@echo OFF

set ROS_VERSION=2

colcon build ^
    --continue-on-error ^
    --merge-install ^
    --install-base %INSTALL_DIR% ^
    --cmake-target install ^
    --cmake-args ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin
