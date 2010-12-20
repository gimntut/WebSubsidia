@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set OutFile= ..\%files_tmp%\NewNaznErrors.tmp.php
CScript /Nologo CheckNewNazn.xbs|toAnsi > %OutFile%
