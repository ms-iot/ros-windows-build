@echo OFF

colcon build ^
    --merge-install ^
    --parallel-workers 1 ^
    --packages-up-to desktop_full ^
    --packages-skip-by-dep stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --packages-skip stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --install-base %INSTALL_DIR% ^
    --cmake-args ^
        -G Ninja ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin

colcon build ^
    --merge-install ^
    --parallel-workers 1 ^
    --packages-up-to moveit ^
    --packages-skip-by-dep stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --packages-skip stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --install-base %INSTALL_DIR% ^
    --cmake-args ^
        -G Ninja ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin

colcon build ^
    --merge-install ^
    --parallel-workers 1 ^
    --packages-skip-by-dep stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --packages-skip stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller ^
    --install-base %INSTALL_DIR% ^
    --cmake-args ^
        -G Ninja ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin
