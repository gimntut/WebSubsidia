@echo off
@cd /d %~dp0
:: @call pathes.inc.cmd
@call InitExe.cmd
:: @echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set MetaIni=..\%files_store%\MetaSetting.ini
set SetIni=..\%files_store%\Settings.ini
set MetaPhp=..\%files_tmp%\MetaSetting.inc.php
set SetPhp=..\%files_tmp%\Settings.inc.php

metaConvertor %MetaIni% >%MetaPhp%
if not exist %SetIni% echo. >%SetIni%
IniConvertor /php %SetIni% >%SetPhp%