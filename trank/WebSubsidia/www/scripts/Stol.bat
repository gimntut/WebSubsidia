@echo off

set ResultFile=Result.Stol.txt
set LogFile=Stol.log
@call InitVars.cmd

echo ��砫� = %Time% >>%LogFile%

%~d0
cd %~p0

echo off>subsid.dbf
echo off>Reg.dbf
set client=%1 
if "%client%"==" " set client=1000
xcopy /y d:\�㩬���\dbfsoz\full\subsid_p.dbf .\subsid.dbf
xcopy /y d:\�㩬���\dbfsoz\Register.dbf .\Reg.dbf
CScript .\xbs_scripts\Stol2.xbs|find /i "_"|toAnsi >%ResultFile%
::CScript .\xbs_scripts\Stol.xbs>%ResultFile%
"c:\program files\siq\siqcmd" localhost 5191 MSGF 2001 %client% %ResultFile%
::pause

del .\subsid.dbf
del .\Reg.dbf
del %ResultFile%
echo ����� = %Time% >> %LogFile%
echo . >> %LogFile%