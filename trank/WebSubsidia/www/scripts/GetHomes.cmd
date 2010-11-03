@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set arg=%1
REM set arg=39
echo CScript.exe /nologo GetHomes.xbs %arg% >..\%files_log%\log.log
CScript.exe /nologo GetHomes.xbs %arg%|ToAnsi > "..\%files_tmp%\Homes.txt"