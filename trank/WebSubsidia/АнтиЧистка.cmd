if (%1)="restart" goto :restart
@echo on
if %~d0==C: goto :eof
if %~d0==D: goto :eof
::if %~d0==W: goto :eof
set /p svn="Напиши 3 буквы: "
if not "%svn%"=="svn" goto :eof
for /f %%I in ('dir *.?* /s /b ^|find /v "svn" ^|find /v "ист"') do del /q /s %%I
exit
:restart
call %~f0 > %~n0.log