@echo OFF

set "PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%"
set "PYTHONWARNINGS=ignore:DEPRECATION"
python -m pip install -U numpy
python -m pip install -U vcstool
python -m pip install -U catkin_pkg
python -m pip install -U rosinstall_generator
python -m pip install -U rosinstall
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.19.0

:: lock the ninja version to 1.8.2
:: since Visual Studio 16.9, the inbox Ninja has been upgraded to v1.10
:: and it appears to break many legacy code.
:: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes#summary-of-whats-new-in-this-release-of-visual-studio-2019-version-1690
python -m pip install -U ninja==1.8.2

copy /Y %INSTALL_DIR%\tools\protobuf\protoc.exe %INSTALL_DIR%\bin
xcopy /Y /S /I %~dp0patch %INSTALL_DIR%

:: patch suitesparse CMake Config files
xcopy /Y /S /I %INSTALL_DIR%\share\suitesparse\suitesparse-5.1.2 %INSTALL_DIR%\share\suitesparse
echo set(SuiteSparse_FOUND TRUE) >> %INSTALL_DIR%\share\suitesparse\suitesparse-config.cmake

:: remove OMPL old files
DEL /F /Q %INSTALL_DIR%\bin\ompl_benchmark_statistics.py
RD /S /Q %INSTALL_DIR%\include\ompl
DEL /F /Q %INSTALL_DIR%\lib\pkgconfig\ompl.pc
DEL /F /Q %INSTALL_DIR%\lib\ompl.lib
RD /S /Q %INSTALL_DIR%\share\ompl
DEL /F /Q %INSTALL_DIR%\share\man\man1\ompl_benchmark_statistics.1
DEL /F /Q %INSTALL_DIR%\share\man\man1\plannerarena.1

:: bootstrap rosdep
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update

:: add CATKIN_IGNORE to reduce the search space and save time
echo > %INSTALL_DIR%\tools\CATKIN_IGNORE
