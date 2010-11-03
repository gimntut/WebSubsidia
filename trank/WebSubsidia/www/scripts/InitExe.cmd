@cd /d %~dp0
@call pathes.inc.cmd
if (%1)==() goto :CallSelf
set path=%path%;"%~f1"
:: set path
goto :eof
:CallSelf
call %~nx0 ..\%files_exe%
