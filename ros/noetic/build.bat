@echo OFF

xcopy /Y /S /I %Build_SourcesDirectory%\ros\noetic\src src

set "IGNORED_PACKAGES=stage stage_ros image_view theora_image_transport rviz_plugin_tutorials four_wheel_steering_controller moveit_resources_prbt_ikfast_manipulator_plugin cartographer_ros_docs"

pip install sphinx

choco install lua52

set PATH=C:\ProgramData\chocolatey\lib\lua52\tools;%PATH%

colcon build ^
    --merge-install ^
    --packages-skip-by-dep %IGNORED_PACKAGES% ^
    --packages-skip %IGNORED_PACKAGES% ^
    --install-base %INSTALL_DIR% ^
    --cmake-args ^
        -G Ninja ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin ^
    2>&1
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\lib\*.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\gazebo_plugins\gazebo_ros_wheel_slip.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\laser_filters\laser_scan_filters.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\laser_filters\pointcloud_filters.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\nodelet_tutorial_math\nodelet_math.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\pluginlib_tutorials\pluginlib_tutorials.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\filters\increment.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\filters\mean.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\filters\median.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\filters\params.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\filters\transfer_function.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\rviz_imu_plugin\rviz_imu_plugin.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\ackermann_steering_controller\ackermann_steering_controller.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

move /Y %INSTALL_DIR%\Lib\rosparam_shortcuts\rosparam_shortcuts.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1

DEL /F /Q %INSTALL_DIR%\Lib\rosbridge_server\rosbridge_tcp
if errorlevel 1 exit 1

DEL /F /Q %INSTALL_DIR%\Lib\rosbridge_server\rosbridge_udp
if errorlevel 1 exit 1

DEL /F /Q %INSTALL_DIR%\Lib\rosbridge_server\rosbridge_websocket
if errorlevel 1 exit 1

:: run rosdep check
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep check --from-paths "%INSTALL_DIR%\share" --ignore-src 2>&1
exit 0
