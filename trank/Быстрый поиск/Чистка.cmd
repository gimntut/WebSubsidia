@echo on
if %~d0==c: goto :eof
if %~d0==d: goto :eof
if %~d0==w: goto :eof
set /p svn="����� 3 �㪢�: "
if not "%svn%"=="svn" goto :eof
for /f "delims=$" %%I in ('dir /ad /s /b ^|find ".svn"') do rd /q /s "%%I"
::eof
pause