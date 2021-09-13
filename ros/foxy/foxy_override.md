# Override Log
All notable package overrides will be explained and documented here.

## [20201211.0.0]
| Package | Original Repo                          |Original Version| Override Repo                          | Override Branch/Version/Commit | Reason                                            |
|---------|----------------------------------------|----------------|----------------------------------------|------------------|---------------------------------------------------|
| fastcdr |https://github.com/eProsima/Fast-CDR.git|    1.0.13      |https://github.com/eProsima/Fast-CDR.git|     v1.0.13      |Appending a "v" to maintain consistency with GitHub|
| fastrtps|https://github.com/eProsima/Fast-DDS.git|     2.0.2      |https://github.com/eProsima/Fast-DDS.git|     v2.0.2       |Appending a "v" to maintain consistency with GitHub|
| foonathan_memory_vendor |https://github.com/eProsima/foonathan_memory_vendor.git|    1.0.0      |https://github.com/eProsima/foonathan_memory_vendor.git|     v1.0.0      |Appending a "v" to maintain consistency with GitHub|
| geometry2|https://github.com/ros2/geometry2.git|     0.13.10      |https://github.com/ms-iot/geometry2.git|     windows/0.13.10     |Added a workaround for NO_ERROR name collision|
| rviz|https://github.com/eProsima/Fast-DDS.git|     2.0.2      |https://github.com/ms-iot/rviz.git|     windows/8.2.2       |Clean up Ogre, add symbol visibility to interactive marker |
|yaml_cpp_vendor|https://github.com/ros2/yaml_cpp_vendor.git|     7.0.2      |https://github.com/ros2/yaml_cpp_vendor.git|     b11d00fbbe2cd8c8888f8c11ff172e84fdea9adc      |Use system installed yaml-cpp 0.6 if available |
| behaviortree_cpp |https://github.com/BehaviorTree/BehaviorTree.CPP.git|     3.5.6      |https://github.com/ms-iot/BehaviorTree.CPP.git|     windows/3.5.6       |Fix type comparison and export symbols|
| cartographer_ros |Not included |     N/A      |https://github.com/ms-iot/cartographer_ros.git|     1.0.9001/windows    | Not included in foxy.repos, its being included because its universally used|
| navigation2 |Not included |     N/A      |https://github.com/ms-iot/navigation2.git|     windows/0.4.5    |Fixing tests and port fixes including type changes and making sleep functionality compatible with windows|
| vision_opencv |https://github.com/ros-perception/vision_opencv.git |  2.2.1   |https://github.com/ms-iot/vision_opencv.git|     windows/2.2.1    |Fixes for windows such as install location and boost version |
| moveit |https://github.com/ros-planning/moveit2.git |  2.1.4   |https://github.com/ros-planning/moveit2.git|  cdd25871fe0519f1869e42490c1f801e55d1e8db  |Window fixes are upstream but not in latest tag. |
| ros2_control |Not included |  N/A  |https://github.com/ros-controls/ros2_control.git|  8018f45e291801408ceac955d04504cb011e4f23    |Not included in foxy.repos, this is the latest commit on master |
| ros2_controllers |Not included |  N/A  |https://github.com/ros-controls/ros2_controllers.git|  0.4.1    |Not in foxy.repos, 0.4.1 is latest version and has Windows fixes |
| geometric_shapes |https://github.com/ros-planning/geometric_shapes.git |  2.1.0  |https://github.com/ros-planning/geometric_shapes.git|  2e809db4377ed99f598480e4b3b48471ff3c0667    |Windows fix is upstream but not included in version 2.1.0, override is pinned to a later commit until next release|
| warehouse_ros |https://github.com/ros-planning/warehouse_ros.git |  2.0.1  |https://github.com/ros-planning/warehouse_ros.git|  2.0.3    |Fixes for Windows not in 2.0.1 |
| control_toolbox |https://github.com/ros-planning/warehouse_ros.git |  2.0.1  |https://github.com/ros-controls/control_toolbox.git|  2.0.2   |Not included in foxy.repos, required for building moveit2 |
| control_toolbox |Not included |  N/A  |https://github.com/ros-controls/control_toolbox.git|  2.0.2   |Not included in foxy.repos, required for building moveit2 |
| rosbag2 |https://github.com/ros2/rosbag2.git |  0.3.7  |https://github.com/ms-iot/rosbag2.git|  windows/0.3.7  |Replaced patch with git apply: Changed patch to git apply to build on Windows, ms-iot/rosbag2@03271a8 (github.com) |
| joystick_drivers |https://github.com/ros-drivers/joystick_drivers.git |  3.0.0  |https://github.com/ms-iot/joystick_drivers.git|  windows/3.0.0  |Added colcon ignore for wiimote package because of the missing bluetooth dependency |
| srdfdom | https://github.com/ros-planning/srdfdom.git | 2.0.2 | https://github.com/ros-planning/srdfdom.git | cadab16ca1ecf93e29ecb5b8e14505ccae080ebb | Windows fixes not in 2.0.2 can remove override in future release |
