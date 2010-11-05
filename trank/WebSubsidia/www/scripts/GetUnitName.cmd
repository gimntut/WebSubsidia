@echo on
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set tmpOut=..\%files_tmp%\NewUnit.inc.php

rar cw "..\%~1" >x.cmd
@call x.cmd
del x.cmd
echo ^<?php >%tmpOut%
echo $NewUnit['Name']='%UnitName%';
echo $NewUnit['Description']='%UnitName%';
echo ?^>>%tmpOut%
cmd BackupUnit