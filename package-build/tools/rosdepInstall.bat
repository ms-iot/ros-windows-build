@echo off
setlocal

pushd c:\opt\ros\melodic\x64
rosdep init
rosdep update
rosdep install --from-paths . --ignore-src -r -y