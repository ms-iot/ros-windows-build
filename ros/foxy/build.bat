@echo OFF

xcopy /Y /S /I %Build_SourcesDirectory%\ros\foxy\src src

set ROS_VERSION=2
set "IGNORED_PACKAGES=rttest test_osrf_testing_tools_cpp tlsf gripper_controllers"

:: workaround for pybind11_vendor which has hardcoded python lib location
mkdir %INSTALL_DIR%\libs
xcopy %INSTALL_DIR%\Lib\Python38.lib %INSTALL_DIR%\libs\

set CMAKE_WINDOWS_KITS_10_DIR=C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\

colcon build ^
    --event-handlers=console_direct+ ^
    --merge-install ^
    --packages-skip-by-dep %IGNORED_PACKAGES% ^
    --packages-skip %IGNORED_PACKAGES% ^
    --install-base %INSTALL_DIR% ^
    --cmake-target install ^
    --cmake-args ^
        -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
        -DCURL_NO_CURL_CMAKE=ON ^
        -DBUILD_TESTING:BOOL=False ^
        -DCMAKE_PROGRAM_PATH=%INSTALL_DIR%\tools\protobuf;%INSTALL_DIR%\tools\qt5\bin ^
        -DCMAKE_PDB_OUTPUT_DIRECTORY=%PDB_OUTPUT_DIRECTORY% ^
        -DCMAKE_SYSTEM_VERSION=10.0.19041.0 ^
    2>&1
if errorlevel 1 exit 1

xcopy /Y /S /I %~dp0patch %INSTALL_DIR%

:: fix srdfdom.dll location.
move /Y %INSTALL_DIR%\lib\*.dll %INSTALL_DIR%\bin
if errorlevel 1 exit 1
