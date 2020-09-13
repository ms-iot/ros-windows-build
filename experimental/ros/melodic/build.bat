@echo OFF

set "IGNORED_PACKAGES=stage stage_ros image_view four_wheel_steering_controller"

copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "%INSTALL_DIR%" ^
    --use-ninja ^
    --install ^
    --ignore-pkg %IGNORED_PACKAGES% ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCATKIN_SKIP_TESTING=ON ^
    -DCURL_NO_CURL_CMAKE=ON

move /Y %INSTALL_DIR%\lib\*.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\laser_filters\laser_scan_filters.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\laser_filters\pointcloud_filters.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\rviz_imu_plugin\rviz_imu_plugin.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\rviz_plugin_tutorials\rviz_plugin_tutorials.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\ackermann_steering_controller\ackermann_steering_controller.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\diagnostic_updater\diagnostic_updater.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\filters\increment.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\filters\mean.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\filters\median.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\filters\params.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\filters\transfer_function.dll %INSTALL_DIR%\bin
move /Y %INSTALL_DIR%\lib\theora_image_transport\theora_image_transport.dll %INSTALL_DIR%\bin
