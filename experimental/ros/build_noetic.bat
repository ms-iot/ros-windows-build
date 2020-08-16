@echo OFF

colcon build ^
    --continue-on-error ^
    --merge-install ^
    --packages-up-to desktop_full ^
    --packages-skip-by-dep stage stage_ros image_view theora_image_transport rviz_plugin_tutorials ^
    --packages-skip stage stage_ros image_view theora_image_transport rviz_plugin_tutorials ^
    --install-base C:\opt\ros\foxy\x64 ^
    --cmake-args ^
        -G Ninja ^
        -DCMAKE_BUILD_TYPE=Release ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DCATKIN_SKIP_TESTING=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=c:\opt\ros\foxy\x64\tools\protobuf;c:\opt\ros\foxy\x64\tools\qt5\bin
