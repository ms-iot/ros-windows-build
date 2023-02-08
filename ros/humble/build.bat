::@echo OFF

xcopy /Y /S /I %Build_SourcesDirectory%\ros\humble\src src

set ROS_VERSION=2
set "IGNORED_PACKAGES=rttest test_osrf_testing_tools_cpp tlsf gripper_controllers"

xcopy /Y /S /I %~dp0patch %INSTALL_DIR%

set Python3_EXECUTABLE=%INSTALL_DIR%\python3.exe
set Python3_EXECUTABLE=%Python3_EXECUTABLE:\=/%

colcon build ^
    --event-handlers=console_cohesion+ ^
    --merge-install ^
    --packages-skip-by-dep %IGNORED_PACKAGES% ^
    --packages-skip %IGNORED_PACKAGES% ^
    --install-base %INSTALL_DIR% ^
    --cmake-target install ^
    --cmake-args ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DBUILD_DOCS:BOOL=False ^
        -DTHIRDPARTY_Asio=FORCE ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin ^
        -DCMAKE_PDB_OUTPUT_DIRECTORY=%PDB_OUTPUT_DIRECTORY% ^
        -DPython3_EXECUTABLE=%Python3_EXECUTABLE% ^
    2>&1
if errorlevel 1 exit 1
