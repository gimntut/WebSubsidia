@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

CScript.exe /nologo GetStreets.xbs|ToAnsi > "..\%files_tmp%\Streets.txt"