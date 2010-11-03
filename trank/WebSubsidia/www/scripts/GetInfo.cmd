@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set Tmp=..\%files_tmp%\%1.tmp.php

CScript /Nologo GetInfo.xbs %1|ToAnsi|ToUtf8>%Tmp%
