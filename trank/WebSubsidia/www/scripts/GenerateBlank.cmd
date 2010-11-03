@echo on
@cd /d %~dp0
@call pathes.inc.cmd
@call InitVars.cmd
@echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set ID=%1
set LC=%2
set FIO=%3

::set ID=M1
::set LC=9000159
::set FIO=ГНД

set Changes=..\%files_tmp%\chs%LC%for%ID%.txt
set RTF="..\%files_download%\Oblogka_%LC%-%ID%.rtf"
set TmpDoss=..\%files_tmp%\D-%ID%-%LC%.tmp
rem берём свежие файлы базы

type ..\%files_store%\Changes0.txt>%Changes%
echo Begin^|End = @@@^|@@@>>%Changes%
echo Org = %Organization%|ToAnsi>>%Changes%
CScript /Nologo Oblogka.xbs %ID% %LC% %FIO% |ToAnsi>>%Changes%
::2>>log\ErrorOblogka.log
SimpleChanger ..\%files_store%\Blank.rtf %Changes% %RTF%
