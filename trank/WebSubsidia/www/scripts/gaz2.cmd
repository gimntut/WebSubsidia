@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set Musor="..\%files_tmp%\BGMusor.csv"
set Result=..\%files_tmp%\BGResult.csv

CScript.exe -NoLogo bashgaz.xbs | toAnsi> %Musor%
find /v "[X]" < %Musor% > %Result%
CScript.exe -NoLogo BGExcel.xbs
TASKKILL /F /IM EXCEL.EXE
