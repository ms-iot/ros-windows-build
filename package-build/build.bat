@echo off
:: seed ROS_DISTRO for the install scripts.
echo set "ROS_DISTRO=%ROS_DISTRO%" >> tools\setup.bat
echo set "ROS_ETC_DIR=%ROS_ETC_DIR%" >> tools\setup.bat
echo set "PYTHONHOME=%PYTHON_LOCATION%" >> tools\setup.bat
echo set "ROS_PYTHON_VERSION=%ROS_PYTHON_VERSION%" >> tools\setup.bat
echo set "VCPKG_ROOT=%VCPKG_ROOT%" >> tools\setup.bat

:: create Chocolatey packages.
copy template.nuspec ros-%ROS_DISTRO%-%ROSWIN_METAPACKAGE%.nuspec
md output
choco pack --trace --out output ros-%ROS_DISTRO%-%ROSWIN_METAPACKAGE%.nuspec name=ros-%ROS_DISTRO%-%ROSWIN_METAPACKAGE% version=%Build_BuildNumber% build_tools=%BUILD_TOOL_PACKAGE% build_tools_version=%BUILD_TOOL_PACKAGE_VERSION%
md output-pre
choco pack --trace --out output-pre ros-%ROS_DISTRO%-%ROSWIN_METAPACKAGE%.nuspec name=ros-%ROS_DISTRO%-%ROSWIN_METAPACKAGE% version=%Build_BuildNumber%-pre build_tools=%BUILD_TOOL_PACKAGE% build_tools_version=%BUILD_TOOL_PACKAGE_VERSION%
