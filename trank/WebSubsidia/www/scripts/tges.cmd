@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
echo.>..\%files_log%\log.log
echo sort "..\%~1" 1>>..\%files_log%\log.log
sort "..\%~1" 1>"..\%files_tmp%\tges.csv" 2>>..\%files_log%\log.log
