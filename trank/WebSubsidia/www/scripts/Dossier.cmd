@echo off
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log
set LC=%1
set ID=%2

::set ID=M1
::set LC=9000159
set Changes=..\%files_tmp%\chs%LC%for%ID%.txt
if Exist %Changes% goto :Continue
set Changes=..\%files_store%\chsNull.txt
:continue
set TmpDoss=..\%files_tmp%\D-%ID%-%LC%.tmp

Cscript /Nologo Dossier.xbs %LC%|ToAnsi >%TmpDoss%+

SimpleChanger %TmpDoss%+ %Changes% %TmpDoss%
del %TmpDoss%+