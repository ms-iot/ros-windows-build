cmake_minimum_required(VERSION 2.8.3)
project(msft_ros_env)
find_package(catkin REQUIRED)

catkin_package()

set(ROS_VERSION "1")
set(ROS_PYTHON_VERSION "3")
set(ROS_DISTRO "noetic")

set(
  hooks
  "sdformat"
  "vcpkg"
)
foreach(hook ${hooks})
  catkin_add_env_hooks("${hook}" SHELLS "bat" DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/env-hooks)
endforeach()
