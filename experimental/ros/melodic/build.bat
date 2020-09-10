@echo OFF

set "IGNORED_PACKAGES=stage stage_ros image_view"

copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "%INSTALL_DIR%" ^
    --use-ninja ^
    --install ^
    --ignore-pkg "%IGNORED_PACKAGES%" ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCATKIN_SKIP_TESTING=ON ^
    -DCURL_NO_CURL_CMAKE=ON
