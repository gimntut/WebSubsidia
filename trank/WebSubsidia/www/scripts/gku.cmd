@echo off
set SendFileToICQ="c:\program files\siq\siqcmd.exe" localhost 5191 MSGF 2001
set ResultFile="�訡�� ��⮢ ���.txt"
set LogFile=GKU.log

set tableIN1=d:\�㩬���\dbfsoz\full\subsid_p.dbf
set tableIN2=d:\�㩬���\dbfsoz\Register.dbf
set tableIN3=d:\�㩬���\dbfsoz\full\KvPlat_p.dbf

set tableOUT1=sub_gku.dbf
set tableOUT2=Reg_gku.dbf
set tableOUT3=Plat_gku.dbf

echo %DATE% >>%LogFile%
echo ������ = %Time% >>%LogFile%

cd /d %~dp0

set client=%1 
if "%client%"==" " set client=1000

echo off>%tableOUT1%
xcopy /y %tableIN1% %tableOUT1%

echo off>%tableOUT2%
xcopy /y %tableIN2% %tableOUT2%

echo off>%tableOUT3%
xcopy /y %tableIN3% %tableOUT3%
::CScript .\xbs_scripts\gku.xbs|find /i "_" >%ResultFile%
CScript .\xbs_scripts\gku.xbs|find /i "_"|toAnsi|Sort >%ResultFile%
for /L %%I in (1,1,4) do (
echo ���������� �������� ������� ������ ��� |toAnsi> %%I_%ResultFile%
echo ����� ����� ����� ���� � 䠩�� H:\���᪨\�訡��\%%I_%ResultFile% |toAnsi>>%%I_%ResultFile%
find "_ %%I" <%ResultFile% >> %%I_%ResultFile%
type "���᪠���.txt" > D:\�㩬���\���᪨\�訡��\%%I_%ResultFile%
type %%I_%ResultFile% >> D:\�㩬���\���᪨\�訡��\%%I_%ResultFile%
)

%SendFileToICQ% 1000 %ResultFile%
%SendFileToICQ% 1011 1_%ResultFile%
%SendFileToICQ% 1013 2_%ResultFile%
%SendFileToICQ% 1012 3_%ResultFile%
%SendFileToICQ% 1009 4_%ResultFile%

::pause

del %tableOUT1%
del %tableOUT2%
del %tableOUT3%

del %ResultFile%
for /L %%I in (1,1,4) do del %%I_%ResultFile%
echo ����� = %Time% >> %LogFile%
echo . >> %LogFile%
