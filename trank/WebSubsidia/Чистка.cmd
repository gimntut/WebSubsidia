@echo on
:: if %~d0==C: goto :eof   
if %~d0==D: goto :eof
::if %~d0==W: goto :eof
set /p svn="Напиши 3 буквы: "
if not "%svn%"=="svn" goto :eof
for /f "delims=`" %%I in ('dir /ad /s /b ^|find ".svn"') do (
 if exist "%%I" rd /q /s "%%I"
)
for /f %%I in ('type advanced.clear.list.txt') do del /q %%I
::eof

