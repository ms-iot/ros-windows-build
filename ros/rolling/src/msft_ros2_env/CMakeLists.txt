cmake_minimum_required(VERSION 3.5)
project(msft_ros2_env NONE)
find_package(ament_cmake_core REQUIRED)

set(ROS_LOCALHOST_ONLY "0")
set(ROS_VERSION "2")
set(ROS_PYTHON_VERSION "3")

# allow overriding the distro name
if(DEFINED ENV{ROS_DISTRO_OVERRIDE})
  set(ROS_DISTRO $ENV{ROS_DISTRO_OVERRIDE})
else()
  set(ROS_DISTRO "rolling")
endif()

set(ROS_ETC_DIR "${CMAKE_INSTALL_PREFIX}/etc/ros")
file(TO_NATIVE_PATH "${ROS_ETC_DIR}" ROS_ETC_DIR)

set(
  hooks
  "999.ros_etc_dir"
)
set(shells "dsv")
if(CMAKE_HOST_UNIX)
  list(APPEND shells "sh")
else()
  list(APPEND shells "bat")
endif()
foreach(hook ${hooks})
  foreach(shell ${shells})
    ament_environment_hooks(
      "${CMAKE_CURRENT_SOURCE_DIR}/env-hooks/${hook}.${shell}.in")
  endforeach()
endforeach()

ament_package()
