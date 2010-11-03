@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set OutFile= ..\%files_tmp%\OnSBK.txt
CScript /Nologo OnSbk.xbs|toAnsi > %OutFile%
