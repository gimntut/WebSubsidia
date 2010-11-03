@echo on
@cd /d %~dp0
@call pathes.inc.cmd >nul
@call InitVars.cmd >nul
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
::cls
set params=/y
if (%1) == (/fast) (
  set params=/y /d
  shift
)
echo %1 %params%

set lock=..\%files_tmp%\lock.txt
if (%1) == () goto :2
:: Запись информации в файл блокировки
echo ^<?php > %lock%
echo $LockFIO=%FIO%; | ToAnsi >>%lock%
echo ?^> >>%lock%

:Start
set outfile="..\%files_db%\%~nx1"
if NOT Exist %outfile% goto :FileNotExist
xcopy "%BasePath%\%~1" %outfile% %params%
goto :Next
:FileNotExist
echo. > %outfile%
xcopy "%BasePath%\%~1" %outfile% /y||del %outfile%
:Next
shift
if NOT "%~1" == "" goto :Start

:2
echo ^<?php ?^> >%lock%