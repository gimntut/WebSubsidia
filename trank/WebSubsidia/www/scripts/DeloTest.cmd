@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set LC=%1
set ID=%2

::set ID=M1
::set LC=9000159

set TmpResult=..\%files_tmp%\TestResult.txt

Cscript /Nologo DeloTest.xbs %LC%|ToAnsi >%TmpResult%
