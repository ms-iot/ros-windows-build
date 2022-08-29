if (GAZEBO_CONFIG_INCLUDED)
  return()
endif()
set(GAZEBO_CONFIG_INCLUDED TRUE)
set(GAZEBO_VERSION 10.2)
set(GAZEBO_MAJOR_VERSION 10)

set(GAZEBO_PLUGIN_PATH "$ENV{GAZEBO_RESOURCE_PATH}/plugins")

# The media path contains the location on disk where images,
# materials scripts, shaders, and other related resources are stored.
set(GAZEBO_MEDIA_PATH "$ENV{GAZEBO_RESOURCE_PATH}/media")

# The model path contains the location on disk where models are stored.
set(GAZEBO_MODEL_PATH "$ENV{GAZEBO_RESOURCE_PATH}/models")

# Set whether Gazebo was built with Bullet support
set (GAZEBO_HAS_BULLET FALSE)

# Set whether Gazebo was built with Simbody support
set (GAZEBO_HAS_SIMBODY FALSE)

# Set whether Gazebo was built with Simbody support
set (GAZEBO_HAS_DART FALSE)
set (GAZEBO_DART_MIN_REQUIRED_VERSION 6.6)
set (GAZEBO_HAS_DART_BULLET )

# Set whether Gazebo was built with Ignition Fuel Tools support
set (GAZEBO_HAS_IGNITION_FUEL_TOOLS OFF)

include (FindPkgConfig)

#################################################
# GAZEBO_PROTO_PATH, GAZEBO_PROTO_INCLUDE_DIRS, and
# GAZEBO_PROTO_LIBRARIES
#
# These three variables allow Gazebo messages to be used in other projects.
#
# The following examples are for demonstration purposes and are
# incomplete. The first example shows how to use a Gazebo message in a
# custom  proto file. The second example shows how to run 'protoc' against
# custom proto files that make use Gazebo message definitions. The third
# example shows how to include the correct directory when compiling a library
# or executable that uses your custom messages.
#
# 1. Use a Gazebo message in a custom proto file:
#
# package my.msgs;
# import "vector3d.proto";
#
# message MyMessage
# {
#   required gazebo.msgs.Vector3d p = 1;
# }
#
# 2. Run protoc from a CMakeLists.txt to generate your message's
#    header and source files:
#
#  add_custom_command(
#    OUTPUT
#      "${proto_filename}.pb.cc"
#      "${proto_filename}.pb.h"
#    COMMAND protoc
#    ARGS --proto_path ${GAZEBO_PROTO_PATH} ${proto_file_out}
#    COMMENT "Running C++ protocol buffer compiler on ${proto_filename}"
#    VERBATIM)
#
# 3. When compiling your library or executable, make sure to use the following
#    in the CMakeLists.txt file:
#
# include_directories(GAZEBO_PROTO_INCLUDE_DIRS)
# target_link_libraries(your_package GAZEBO_PROTO_LIBRARIES)
#
set(GAZEBO_PROTO_PATH
  "$ENV{GAZEBO_RESOURCE_PATH}/gazebo/msgs/proto")
find_library(gazebo_proto_msgs_lib gazebo_msgs
  PATHS $ENV{GAZEBO_LIB_PATH} NO_DEFAULT_PATH)
list(APPEND GAZEBO_PROTO_LIBRARIES ${gazebo_proto_msgs_lib})
list(APPEND GAZEBO_PROTO_INCLUDE_DIRS
  "$ENV{GAZEBO_RESOURCE_PATH}/gazebo/msgs")
# End GAZEBO_PROTO_PATH, GAZEBO_PROTO_INCLUDE_DIRS, and
# GAZEBO_PROTO_LIBRARIES

list(APPEND GAZEBO_INCLUDE_DIRS $ENV{GAZEBO_INCLUDE_PATH})
list(APPEND GAZEBO_INCLUDE_DIRS $ENV{GAZEBO_INCLUDE_PATH}/gazebo-10)

list(APPEND GAZEBO_LIBRARY_DIRS $ENV{GAZEBO_LIB_PATH})
list(APPEND GAZEBO_LIBRARY_DIRS $ENV{GAZEBO_LIB_PATH}/OGRE)
list(APPEND GAZEBO_LIBRARY_DIRS $ENV{GAZEBO_LIB_PATH}/gazebo-10/plugins)

list(APPEND GAZEBO_CFLAGS -I$ENV{GAZEBO_INCLUDE_PATH})
list(APPEND GAZEBO_CFLAGS -I$ENV{GAZEBO_INCLUDE_PATH}/gazebo-10)

if (GAZEBO_HAS_BULLET)
  if (PKG_CONFIG_FOUND)
    pkg_check_modules(BULLET bullet>=2.82)
    if (NOT BULLET_FOUND)
       pkg_check_modules(BULLET bullet2.82>=2.82)
    endif()

    if (BULLET_FOUND)
      add_definitions(-DLIBBULLET_VERSION=${BULLET_VERSION})
    else()
      message(FATAL_ERROR "Error: Bullet > 2.82 not found, please install libbullet2.82-dev.")
    endif()

    if (BULLET_VERSION VERSION_GREATER 2.82)
      add_definitions(-DLIBBULLET_VERSION_GT_282)
    endif()

    list(APPEND GAZEBO_INCLUDE_DIRS ${BULLET_INCLUDE_DIRS})
    list(APPEND GAZEBO_LIBRARY_DIRS ${BULLET_LIBRARY_DIRS})
    list(APPEND GAZEBO_LIBRARIES ${BULLET_LIBRARIES})
  else()
    message(FATAL_ERROR "Error: pkg-config not found.")
  endif()
endif()

if (GAZEBO_HAS_SIMBODY)
  find_package(Simbody REQUIRED)
  list(APPEND GAZEBO_INCLUDE_DIRS ${Simbody_INCLUDE_DIR})
  list(APPEND GAZEBO_LIBRARIES ${Simbody_LIBRARIES})
endif()

if (GAZEBO_HAS_DART)
  find_package(DART ${GAZEBO_DART_MIN_REQUIRED_VERSION} REQUIRED CONFIG)
  list(APPEND GAZEBO_INCLUDE_DIRS ${DART_INCLUDE_DIRS})
  list(APPEND GAZEBO_LIBRARIES ${DART_LIBRARIES})
endif()

# Visual Studio enables c++11 support by default
if (NOT MSVC)
  list(APPEND GAZEBO_CXX_FLAGS -std=c++11)
endif()
if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND
    "${CMAKE_SYSTEM_NAME}" MATCHES "Darwin")
  set(GAZEBO_CXX_FLAGS "${GAZEBO_CXX_FLAGS} -stdlib=libc++")
endif ()

foreach(lib gazebo;gazebo_client;gazebo_gui;gazebo_sensors;gazebo_rendering;gazebo_physics;gazebo_ode;gazebo_transport;gazebo_msgs;gazebo_util;gazebo_common;gazebo_gimpact;gazebo_opcode;gazebo_opende_ou)
  set(onelib "${lib}-NOTFOUND")
  find_library(onelib ${lib}
    PATHS "C:/opt/ros/foxy/x64/lib"
    NO_DEFAULT_PATH
    )
  if(NOT onelib)
    message(FATAL_ERROR "Library '${lib}' in package GAZEBO is not installed properly")
  endif()
  list(APPEND GAZEBO_LIBRARIES ${onelib})
endforeach()

# Get the install prefix for OGRE
execute_process(COMMAND ${PKG_CONFIG_EXECUTABLE} --variable=prefix OGRE
  OUTPUT_VARIABLE OGRE_INSTALL_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)

# Add the OGRE cmake path to CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH
  "${OGRE_INSTALL_PREFIX}/share/OGRE/cmake/modules;${OGRE_INSTALL_PREFIX}/lib/OGRE/cmake;${OGRE_INSTALL_PREFIX}/CMake;${CMAKE_MODULE_PATH}")

# Find boost
find_package(Boost 1.40.0 REQUIRED thread system
  filesystem program_options regex iostreams date_time)
list(APPEND GAZEBO_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARIES ${Boost_LIBRARIES})

# Find protobuf
find_package(Protobuf REQUIRED CONFIG)
list(APPEND GAZEBO_INCLUDE_DIRS ${PROTOBUF_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARIES ${PROTOBUF_LIBRARIES})

# Find SDFormat
find_package(SDFormat REQUIRED)
list(APPEND GAZEBO_INCLUDE_DIRS ${SDFormat_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARIES ${SDFormat_LIBRARIES})

# Find OGRE
find_package(OGRE REQUIRED COMPONENTS Terrain Paging)
if(NOT OGRE_FOUND)
  unset(OGRE_FOUND CACHE)
  find_package(OGRE REQUIRED COMPONENTS Terrain Paging CONFIG)
endif()
list(APPEND GAZEBO_INCLUDE_DIRS ${OGRE_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARIES ${OGRE_LIBRARIES})
# When including OGRE, also include the Terrain and Paging components
list(APPEND GAZEBO_INCLUDE_DIRS
  ${OGRE_Terrain_INCLUDE_DIRS}
  ${OGRE_Paging_INCLUDE_DIRS}
  ${OGRE-Terrain_INCLUDE_DIRS}
  ${OGRE-Paging_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARIES
  ${OGRE_Terrain_LIBRARIES}
  ${OGRE_Paging_LIBRARIES}
  ${OGRE-Terrain_LIBRARIES}
  ${OGRE-Paging_LIBRARIES})

# Find Ignition Math
find_package(ignition-math4 REQUIRED)
list(APPEND GAZEBO_INCLUDE_DIRS ${IGNITION-MATH_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARY_DIRS ${IGNITION-MATH_LIBRARY_DIRS})
list(APPEND GAZEBO_LIBRARIES ${IGNITION-MATH_LIBRARIES})

# Find Ignition Transport
find_package(ignition-transport4 REQUIRED)
list(APPEND GAZEBO_INCLUDE_DIRS ${IGNITION-TRANSPORT_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARY_DIRS ${IGNITION-TRANSPORT_LIBRARY_DIRS})
list(APPEND GAZEBO_LIBRARIES ${IGNITION-TRANSPORT_LIBRARIES})

# Find Ignition Msgs
find_package(ignition-msgs1 REQUIRED)
list(APPEND GAZEBO_INCLUDE_DIRS ${IGNITION-MSGS_INCLUDE_DIRS})
list(APPEND GAZEBO_LIBRARY_DIRS ${IGNITION-MSGS_LIBRARY_DIRS})
list(APPEND GAZEBO_LIBRARIES ${IGNITION-MSGS_LIBRARIES})

if (GAZEBO_HAS_IGNITION_FUEL_TOOLS)
  find_package(ignition-common1 REQUIRED)
  list(APPEND GAZEBO_INCLUDE_DIRS ${ignition-common1_INCLUDE_DIRS})
  list(APPEND GAZEBO_LIBRARY_DIRS ${ignition-common1_LIBRARY_DIRS})
  list(APPEND GAZEBO_LIBRARIES ${ignition-common1_LIBRARIES})

  find_package(ignition-fuel_tools1 REQUIRED)
  list(APPEND GAZEBO_INCLUDE_DIRS ${IGNITION-FUEL_TOOLS_INCLUDE_DIRS})
  list(APPEND GAZEBO_LIBRARY_DIRS ${IGNITION-FUEL_TOOLS_LIBRARY_DIRS})
  list(APPEND GAZEBO_LIBRARIES ${IGNITION-FUEL_TOOLS_LIBRARIES})
endif()

list(APPEND GAZEBO_LDFLAGS -Wl,-rpath,C:/opt/ros/foxy/x64/lib/gazebo-10/plugins)
list(APPEND GAZEBO_LDFLAGS -LC:/opt/ros/foxy/x64/lib)
list(APPEND GAZEBO_LDFLAGS -LC:/opt/ros/foxy/x64/lib/gazebo-10/plugins)
