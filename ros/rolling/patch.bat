@echo OFF

:: copy all patch files to the installation
xcopy /Y /S /I %~dp0patch %INSTALL_DIR%

set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

:: install required Python modules
python -m pip config set global.disable-pip-version-check True
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.20.0

:: bootstrap rosdep
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update

