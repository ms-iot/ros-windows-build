@echo OFF

xcopy /Y /S /I .\experimental\ros\%ROS_DISTRO%\pre-patch %INSTALL_DIR%
set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

set INCLUDE=C:\opt\ros\noetic\x64\include\python3.8
set LIB=C:\opt\ros\noetic\x64\Lib

:: remove Vcpkg python38.dll to avoid conflicts
DEL /F /Q %INSTALL_DIR%\bin\python38.dll

:: install required Python modules
python -m pip config set global.disable-pip-version-check True
python -m pip install -U pycryptodomex==3.9.8
python -m pip install -U gnupg==2.3.1
python -m pip install -U pydot==1.4.1
python -m pip install -U paramiko==2.7.2
python -m pip install -U wxPython==4.1.0
python -m pip install -U matplotlib==3.3.1
python -m pip install -U PyOpenGL==3.1.5
python -m pip install -U pyassimp==4.1.4
python -m pip install -U Sphinx==3.2.1
python -m pip install -U cairocffi==1.1.0
python -m pip install -U pyserial==3.4
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.19.0

:: rosbridge related dependencies
:: https://github.com/RobotWebTools/rosbridge_suite/issues/198
:: python -m pip install -U bson==0.5.10
python -m pip install -U pymongo==3.11.0
python -m pip install -U pyproj==2.6.1.post1
python -m pip install -U twisted==20.3.0
python -m pip install -U autobahn==20.7.1
python -m pip install -U pyOpenSSL==19.1.0
python -m pip install -U service-identity==18.1.0
python -m pip install -U tornado==6.0.4

:: bootstrap rosdep
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update

:: bootstrap vcpkg
powershell .\experimental\ros\%ROS_DISTRO%\vcpkg.ps1 -InstallDir "%INSTALL_DIR%"
if errorlevel 1 exit 1

:: add CATKIN_IGNORE to reduce the search space and save time
echo > %INSTALL_DIR%\tools\CATKIN_IGNORE
