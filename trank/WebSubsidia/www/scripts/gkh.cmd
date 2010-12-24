@echo off
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
xlHtml -csv -xp:0 -xc:0-6 "..\%~1" 1>"..\%files_tmp%\gkh.csv"
