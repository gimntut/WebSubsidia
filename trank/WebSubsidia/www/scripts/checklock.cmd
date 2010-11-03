@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set lock=..\%files_tmp%\lock.txt
if not exist %lock% exit;
echo ^<?php ?^> >%lock%