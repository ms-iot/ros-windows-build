@echo OFF

set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%
python -m pip config set global.disable-pip-version-check True

copy /Y %INSTALL_DIR%\tools\protobuf\protoc.exe %INSTALL_DIR%\bin
