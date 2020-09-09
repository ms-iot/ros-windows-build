@echo OFF

copy src\catkin\bin\catkin_make_isolated src\catkin\bin\catkin_make_isolated.py
python src\catkin\bin\catkin_make_isolated.py ^
    --install-space "%INSTALL_DIR%" ^
    --use-ninja ^
    --install ^
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
    -DCATKIN_SKIP_TESTING=ON
