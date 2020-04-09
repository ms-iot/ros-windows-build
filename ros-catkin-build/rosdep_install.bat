@echo off
:: ignore the errors from rosdep install
rosdep install --from-paths c:\catkin_ws\src --ignore-src --rosdistro %ROS_DISTRO% -r -y
pip install --upgrade --force-reinstall cmake==3.16.3
exit /b 0