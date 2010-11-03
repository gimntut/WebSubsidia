@echo on
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

cd ..\..
set UnitFile=%~1.WebSubUnit
rar a "%UnitFile%" @"www\%files_tmp%\unit.filelist.txt"
copy "%UnitFile%" "www\%files_download%\%UnitFile%"
del "%UnitFile%"
