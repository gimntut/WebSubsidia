set INI= ..\files\store\Pathes.ini
IniConvertor.exe /php %INI% >..\include\pathes.inc.php
IniConvertor.exe /cmd %INI% >..\scripts\pathes.inc.cmd
IniConvertor.exe /xbs %INI% >..\scripts\pathes.xinc
