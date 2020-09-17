@echo OFF

set "PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%"
set "PYTHONWARNINGS=ignore:DEPRECATION"
python -m pip install -U numpy
python -m pip install -U vcstool
python -m pip install -U catkin_pkg
python -m pip install -U rosinstall_generator
python -m pip install -U rosinstall
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.19.0

copy /Y %INSTALL_DIR%\tools\protobuf\protoc.exe %INSTALL_DIR%\bin
xcopy /Y /S /I %~dp0patch %INSTALL_DIR%

:: bootstrap rosdep
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update
rosdep check --from-paths "%WORKSPACE_DIR%\src" --ignore-src 2>&1
exit 0
