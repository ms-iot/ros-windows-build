@echo OFF

xcopy /Y /S /I .\experimental\ros\%ROS_DISTRO%\pre-patch %INSTALL_DIR%
set PATH=%INSTALL_DIR%\Scripts;%INSTALL_DIR%;%INSTALL_DIR%\bin;%PATH%

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
python -m pip install -U git+https://github.com/ms-iot/rosdep@windows/0.19.0

:: bootstrap rosdep
set ROS_ETC_DIR=%INSTALL_DIR%\etc\ros
rosdep init
rosdep update
