# Override Log
All notable package overrides will be explained and documented here.

## [20201211.0.0]
| Package | Original Repo                          |Original Version| Override Repo                          | Override Branch/Version/Commit | Reason                                            |
|---------|----------------------------------------|----------------|----------------------------------------|------------------|---------------------------------------------------|
| fastcdr |https://github.com/eProsima/Fast-CDR.git|    1.0.13      |https://github.com/eProsima/Fast-CDR.git|     v1.0.13      |Appending a "v" to maintain consistency with GitHub|
| fastrtps|https://github.com/eProsima/Fast-DDS.git|     2.0.2      |https://github.com/eProsima/Fast-DDS.git|     v2.0.2       |Appending a "v" to maintain consistency with GitHub|
| foonathan_memory_vendor |https://github.com/eProsima/foonathan_memory_vendor.git|    1.0.0      |https://github.com/eProsima/foonathan_memory_vendor.git|     v1.0.0      |Appending a "v" to maintain consistency with GitHub|
| geometry2|https://github.com/ros2/geometry2.git|     0.13.11      |https://github.com/ms-iot/geometry2.git|     windows/0.13.11     |The NO_ERROR collision is fixed by https://github.com/ros2/geometry2/commit/72558c95808e569ada26848395edb011c87bc976, not yet in latest Foxy tag|
| rviz|https://github.com/ros2/rviz.git|     8.2.3      |https://github.com/ms-iot/rviz.git|     windows/8.2.3   |Clean up Ogre, add symbol visibility to interactive marker |
|yaml_cpp_vendor|https://github.com/ros2/yaml_cpp_vendor.git|     7.0.2      |https://github.com/ros2/yaml_cpp_vendor.git|     b11d00fbbe2cd8c8888f8c11ff172e84fdea9adc      |Use system installed yaml-cpp 0.6 if available |
| behaviortree_cpp |https://github.com/BehaviorTree/BehaviorTree.CPP.git|     3.5.6      |https://github.com/ms-iot/BehaviorTree.CPP.git|     windows/3.5.6       |Fix type comparison and export symbols, added ZMQ lib dependency|
| cartographer_ros |Not included |     N/A      |https://github.com/ms-iot/cartographer_ros.git|     1.0.9001/windows    | Not included in foxy.repos, its being included because its universally used|
| navigation2 |Not included |     N/A      |https://github.com/ms-iot/navigation2.git|     windows/0.4.7    |Fixing tests and port fixes including type changes and making sleep functionality compatible with windows, Windows fixes are now upstreamed but not in this tag.|
| vision_opencv |https://github.com/ros-perception/vision_opencv.git |  2.2.1   |https://github.com/ms-iot/vision_opencv.git|     windows/2.2.1    |Fixes for windows such as install location and boost version |
| moveit |https://github.com/ros-planning/moveit2.git |  2.1.4   |https://github.com/ros-planning/moveit2.git|  ed844d4b46f70ed6e97d0c1f971ab2b9a45f156d  |Window fixes are upstream but not in latest tag. |
| moveit_resources |https://github.com/ros-planning/moveit_resources.git |  2.0.2   |https://github.com/ros-planning/moveit_resources.git|  2.0.3  | Changes to panda_arm not in 2.0.2. |
| ros2_control |Not included |  N/A  |https://github.com/ros-controls/ros2_control.git|  0.8.1    |Not included in foxy.repos |
| ros2_controllers |Not included |  N/A  |https://github.com/ros-controls/ros2_controllers.git|  0.5.1    |Not in foxy.repos, 0.5.1 is latest version and has Windows fixes |
| geometric_shapes |https://github.com/ros-planning/geometric_shapes.git |  2.1.0  |https://github.com/ros-planning/geometric_shapes.git|  2e809db4377ed99f598480e4b3b48471ff3c0667    |Windows fix is upstream but not included in version 2.1.0, override is pinned to a later commit until next release|
| control_toolbox |Not included |  N/A  |https://github.com/ros-controls/control_toolbox.git|  2.0.2   |Not included in foxy.repos, required for building moveit2 |
| rosbag2 |https://github.com/ros2/rosbag2.git |  0.3.8  |https://github.com/ms-iot/rosbag2.git|  windows/0.3.8  |Changed patch to git apply to build on Windows, fix is upstream but not in tag: https://github.com/ros2/rosbag2/commit/759ec2768455d4f36e4692ca2c06f682ba6d44ae|
| joystick_drivers |https://github.com/ros-drivers/joystick_drivers.git |  3.0.0  |https://github.com/ms-iot/joystick_drivers.git|  windows/3.0.0  |Added colcon ignore for wiimote package because of the missing bluetooth dependency |
| srdfdom | https://github.com/ros-planning/srdfdom.git | 2.0.2 | https://github.com/ros-planning/srdfdom.git | cadab16ca1ecf93e29ecb5b8e14505ccae080ebb | Windows fixes not in 2.0.2 can remove override in future release |
| image_transport_plugins | https://github.com/ros-perception/image_transport_plugins | foxy-devel | https://github.com/ms-iot/image_transport_plugins.git | foxy-devel | Contains Window fixes that have not been upstreamed yet |