@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log


set Musor="..\%files_tmp%\tgesMusor.csv"
set Result="..\%files_tmp%\tgesResult.csv"
CScript.exe -NoLogo tges.xbs %1| toAnsi> %Musor%
find /v "[X]" < %Musor% > %Result%
CScript.exe -NoLogo tgesExcel.xbs
TASKKILL /F /IM EXCEL.EXE
