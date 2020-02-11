@echo off
set PYTHONHOME=C:\opt\python37amd64\
set PATH=C:\opt\rosdeps\x64\bin;%PATH%
set PATH=C:\opt\python37amd64\bin;%PATH%
set PATH=C:\opt\python37amd64\Scripts;%PATH%
set PATH=C:\opt\python37amd64;%PATH%
set "PATH=C:\Program Files\Cppcheck;%PATH%"
set PYTHONPATH=

:: unset Boost override
set Boost_ROOT=
set BOOST_ROOT_1_69_0=
set BOOST_ROOT_1_72_0=

:: echo all environment variables
set
