@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set arg=%*
::set arg=82 2
echo CScript.exe /nologo GetPeoples.xbs %arg% >..\%files_log%\log.log
CScript.exe /nologo GetPeoples.xbs %arg%|ToAnsi > "..\%files_tmp%\Peoples.txt"