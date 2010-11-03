@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set ResultFile="..\%files_tmp%\BankErrors.txt"
CScript /Nologo Check_sb.xbs|toAnsi >%ResultFile%
