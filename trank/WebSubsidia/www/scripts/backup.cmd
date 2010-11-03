@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
cd /d %~dp0\..\..
set UnitFile="Копия №.rar"
rar.exe a -r -xBACKUP "-ageee dd-mm-yyyy (nn)" BACKUP\%UnitFile% *.*
