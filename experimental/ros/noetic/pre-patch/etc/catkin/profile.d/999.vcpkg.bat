@echo off

:: initialize Vcpkg environments
set VCPKG_ROOT=c:\opt\ros\noetic\x64\tools\vcpkg
set VCPKG_DEFAULT_TRIPLET=x64-windows

:: add Vcpkg.exe to PATH
set PATH=%PATH:C:\opt\ros\noetic\x64\tools\vcpkg;=%
set "PATH=C:\opt\ros\noetic\x64\tools\vcpkg;%PATH%"

:: add the installed bin to PATH
set PATH=%PATH:C:\opt\ros\noetic\x64\tools\vcpkg\installed\x64-windows\bin;=%
set "PATH=C:\opt\ros\noetic\x64\tools\vcpkg\installed\x64-windows\bin;%PATH%"

:: add the installed root for CMake
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH:C:\opt\ros\noetic\x64\tools\vcpkg\installed\x64-windows;=%
set "CMAKE_PREFIX_PATH=C:\opt\ros\noetic\x64\tools\vcpkg\installed\x64-windows;%CMAKE_PREFIX_PATH%"
