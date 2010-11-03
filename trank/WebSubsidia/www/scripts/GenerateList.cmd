@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set STOL=%1
:: set ID=%1
:: set LC=%2
:: set FIO=%3
set Tmp0=..\%files_tmp%\Stol_%Stol%.tmp0
set Tmp1=..\%files_tmp%\Stol_%Stol%.tmp
set Tmp2=..\%files_tmp%\Stol_%Stol%.inc.php
set Journal=..\%files_journals%\Stol_%Stol%.list

::set ID=M1
::set LC=9004796
::set FIO="Гимаев Наиль Дамирович"

if not exist %Journal% echo. >%Journal%
for /F "tokens=2 delims=;" %%i IN ('type %tmp0%') DO @echo %%i
find /v "%LC%" < %Journal% >%tmp1%
CScript /Nologo AddToList.xbs |ToAnsi>>%tmp1%
xcopy %tmp1% %Journal% /y
if not exist %ListPath%\Stol_%Stol%.csv echo. >%ListPath%\Stol_%Stol%.csv
xcopy %tmp1% %ListPath%\Stol_%Stol%.csv /y

del %tmp1%
