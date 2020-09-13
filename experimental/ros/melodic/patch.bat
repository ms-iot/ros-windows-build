@echo OFF

set "PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%"
set "PYTHONWARNINGS=ignore:DEPRECATION"
python -m pip install -U numpy
python -m pip install -U vcstool
python -m pip install -U catkin_pkg
python -m pip install -U rosinstall_generator
python -m pip install -U rosinstall

copy /Y %INSTALL_DIR%\tools\protobuf\protoc.exe %INSTALL_DIR%\bin
xcopy /Y /S /I %~dp0patch %INSTALL_DIR%
