@echo on
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

cd ..\..
set UnitFile=www\%files_download%\%~1.WebSubUnit
del "%UnitFile%"
rar a -z"www\%files_tmp%\comment.tmp" "%UnitFile%" @"www\%files_tmp%\unit.filelist.txt"
