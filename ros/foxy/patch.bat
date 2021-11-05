@echo OFF
set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

xcopy /Y /S /I .\ros\foxy\patch %INSTALL_DIR%

:: remove Vcpkg python38.dll to avoid conflicts
DEL /F /Q %INSTALL_DIR%\bin\python38.dll

python -m pip config set global.disable-pip-version-check True
:: Lock pytest to 6.0.0. 
:: When running 6.1.0 or later, pytest fails to load due to a dependency on result log.
:: https://github.com/pytest-dev/pytest-rerunfailures/issues/128
python -m pip install pytest==6.0.0
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.20.0

:: bootstrap vcpkg
powershell .\ros\%ROS_DISTRO%\vcpkg.ps1 -InstallDir "%INSTALL_DIR%"
if errorlevel 1 exit 1
