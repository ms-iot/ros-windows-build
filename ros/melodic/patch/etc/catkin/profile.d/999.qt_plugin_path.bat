REM generated from msft_ros_env/env-hooks/msft_ros_qt.bat.in
setlocal

set qt5dir=
for /f "tokens=* USEBACKQ" %%f in (`where qt5core.dll 2^>NUL`) do (
    set qt5dir=%%f
    goto :break
)
:break

if not defined qt5dir (
    goto :eof
)

set basedir=
CALL :getbasedir %qt5dir%

set abspath=
CALL :getabspath %basedir%..\plugins

if not exist %abspath% (
    goto :eof
)

endlocal && set QT_PLUGIN_PATH=%abspath%
goto :eof

:getbasedir
set basedir=%~dp1
goto :eof

:getabspath
set abspath=%~f1
goto :eof
