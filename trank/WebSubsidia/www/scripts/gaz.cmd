@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
echo %1>>..\%files_log%\log.log
echo xlHtml -csv -xp:0 -xc:0-12 "..\%~1" >>..\%files_log%\log.log
xlHtml -csv -xp:0 -xc:0-12 "..\%~1" 1>"..\%files_tmp%\bashgaz.csv" 2>>..\%files_log%\log.log
