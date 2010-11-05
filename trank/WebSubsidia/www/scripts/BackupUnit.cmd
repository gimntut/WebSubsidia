@echo on
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

cd ..\..
set UnitFile=..\BACKUP\%~1.WebSubUnit
rar a -ag"eee[dd-mm-yy]nn" -z"www\%files_tmp%\comment.tmp" "%UnitFile%" @"www\%files_tmp%\unit.filelist.txt"
copy "%UnitFile%" "www\%files_download%\%UnitFile%"
del "%UnitFile%"

