@echo off

:: Use Visual Studio 2019
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

:: MSVC is preferred.
set CC=cl.exe
set CXX=cl.exe

pushd %1
shift
mkdir build & pushd build
cmake %~1 ^
    -DCMAKE_BUILD_TYPE=%GAZEBO_CMAKE_BUILD_TYPE% ^
    -DCMAKE_PREFIX_PATH=%GAZEBO_INSTALL_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%GAZEBO_INSTALL_PREFIX% ^
    -DCMAKE_PDB_OUTPUT_DIRECTORY=%GAZEBO_CMAKE_PDB_OUTPUT_DIRECTORY% ^
    -DBUILD_TESTING:BOOL=False ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DCMAKE_PROGRAM_PATH=%GAZEBO_INSTALL_PREFIX%\tools\protobuf ^
    -DCURL_NO_CURL_CMAKE=ON ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    --debug-output ^
    -G "Ninja" ..
ninja install
popd
popd
