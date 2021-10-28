@echo OFF

:: remove Vcpkg python38.dll to avoid conflicts
DEL /F /Q %INSTALL_DIR%\bin\python38.dll

:: bootstrap vcpkg
powershell .\ros\%ROS_DISTRO%\vcpkg.ps1 -InstallDir "%INSTALL_DIR%"
if errorlevel 1 exit 1
