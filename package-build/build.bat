@echo off
copy template.nuspec ros-%ROS_DISTRO%-%BUILD_ROS_PACKAGE%.nuspec
md output
choco pack --trace --out output ros-%ROS_DISTRO%-%BUILD_ROS_PACKAGE%.nuspec name=ros-%ROS_DISTRO%-%BUILD_ROS_PACKAGE% version=%Build_BuildNumber%
md output-pre
choco pack --trace --out output-pre ros-%ROS_DISTRO%-%BUILD_ROS_PACKAGE%.nuspec name=ros-%ROS_DISTRO%-%BUILD_ROS_PACKAGE% version=%Build_BuildNumber%-pre
