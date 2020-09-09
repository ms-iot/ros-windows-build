@echo OFF

set "IGNORED_PACKAGES=stage stage_ros"

copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "%IGNORED_PACKAGES%" ^
    --use-ninja ^
    --install ^
    --ignore-pkg "" ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCATKIN_SKIP_TESTING=ON ^
    -DCURL_NO_CURL_CMAKE=ON
