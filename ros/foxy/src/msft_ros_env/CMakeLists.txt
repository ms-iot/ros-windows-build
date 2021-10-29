cmake_minimum_required(VERSION 3.15.3)
project(msft_ros_env)
find_package(ament_cmake REQUIRED)

ament_environment_hooks("env-hooks/vcpkg.bat.in")

ament_package()
