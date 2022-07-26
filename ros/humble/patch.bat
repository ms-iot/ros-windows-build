@echo OFF
set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

python -m pip config set global.disable-pip-version-check True
:: Lock pytest to 6.0.0. 
:: When running 6.1.0 or later, pytest fails to load due to a dependency on result log.
:: https://github.com/pytest-dev/pytest-rerunfailures/issues/128
python -m pip install pytest==6.0.0
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.20.0

:: install colcon-make from github due to vs2022 support
python -m pip install --force-reinstall -U git+https://github.com/colcon/colcon-cmake.git

set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update

:: bootstrap vcpkg
powershell .\ros\%ROS_DISTRO%\vcpkg.ps1 -InstallDir "%INSTALL_DIR%"
if errorlevel 1 exit 1
