@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set out=..\%files_tmp%\units.list.php
echo.>%out%
echo ^<?php >>%out%
echo $units = array(); >>%out%
echo $pages = array(); >>%out%
echo $help = array(); >>%out%
for /F %%I in ('dir /b ..\%files_units%') do echo include '%%I'; >>%out%
echo ?^> >>%out%
