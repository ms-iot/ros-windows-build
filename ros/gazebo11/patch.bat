set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

:: why does gazebo require ruby?
choco install ruby

pip install psutil