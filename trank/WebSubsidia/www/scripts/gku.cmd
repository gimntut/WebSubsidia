@echo off
set SendFileToICQ="c:\program files\siq\siqcmd.exe" localhost 5191 MSGF 2001
set ResultFile="Žè¨¡ª¨ áç¥â®¢ †Š“.txt"
set LogFile=GKU.log

set tableIN1=d:\’ã©¬ §ë\dbfsoz\full\subsid_p.dbf
set tableIN2=d:\’ã©¬ §ë\dbfsoz\Register.dbf
set tableIN3=d:\’ã©¬ §ë\dbfsoz\full\KvPlat_p.dbf

set tableOUT1=sub_gku.dbf
set tableOUT2=Reg_gku.dbf
set tableOUT3=Plat_gku.dbf

echo %DATE% >>%LogFile%
echo Íà÷àëî = %Time% >>%LogFile%

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
echo …†…„…‚€Ÿ Ž‚…Š€ ŽŒ…Ž‚ ‘—…’Ž‚ †Š“ |toAnsi> %%I_%ResultFile%
echo Š®¯¨î ®âçñâ  ¬®¦­® ­ ©â¨ ¢ ä ©«¥ H:\‘¯¨áª¨\Žè¨¡ª¨\%%I_%ResultFile% |toAnsi>>%%I_%ResultFile%
find "_ %%I" <%ResultFile% >> %%I_%ResultFile%
type "®¤áª §ª¨.txt" > D:\’ã©¬ §ë\‘¯¨áª¨\Žè¨¡ª¨\%%I_%ResultFile%
type %%I_%ResultFile% >> D:\’ã©¬ §ë\‘¯¨áª¨\Žè¨¡ª¨\%%I_%ResultFile%
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
echo Êîíåö = %Time% >> %LogFile%
echo . >> %LogFile%
