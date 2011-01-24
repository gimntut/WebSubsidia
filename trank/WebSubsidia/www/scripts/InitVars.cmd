@cd /d %~dp0
@call pathes.inc.cmd
@call InitExe.cmd
:: @echo [%Date% %Time%] %0 %* | toAnsi >> ..\%files_log%\run.cmd.log

set SettingsFile=..\%files_store%\Settings.ini
set OptionsCmd=Settings.inc.cmd
set OptionsXBS=Settings.xinc

if Not Exist %SettingsFile% echo. >%SettingsFile%
IniConvertor /cmd %SettingsFile% >%OptionsCmd%
IniConvertor /xbs %SettingsFile% >%OptionsXBS%

call %OptionsCmd%