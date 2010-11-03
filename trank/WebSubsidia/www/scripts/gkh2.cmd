@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set Musor="..\%files_tmp%\GkhMusor.csv"
set Result="..\%files_tmp%\GkhResult.csv"
CScript.exe -NoLogo gkh.xbs | toAnsi> %Musor%
find /v "[X]" <%Musor% >%Result%
CScript.exe -NoLogo gkh2.xbs | toAnsi> %Musor%
find /v "[X]" <%Musor% >%Result%
CScript.exe -NoLogo GkhExcel.xbs
TASKKILL /F /IM EXCEL.EXE
