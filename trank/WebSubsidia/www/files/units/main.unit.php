<?php 
$units[]=array(
'Name'=>'Базовая часть сайта',
'Description'=>'Набор файлов необходимых для работы сайта',
'Files'=>"
www\\.htaccess
www\\docs\\.htaccess
www\\favicon.ico
www\\Hidder.js
www\\jquery.js
www\\jquery-ui.js
www\\index.php
www\\php.ini
www\\print.css
www\\style.css
www\\files\\download\\.htaccess
www\\files\\exe\\dbf.exe
www\\files\\exe\\IniConvertor.exe
www\\files\\exe\\MergeIni.exe
www\\files\\exe\\metaConvertor.exe
www\\files\\exe\\Rar.exe
www\\files\\exe\\SimpleChanger.exe
www\\files\\exe\\taskkill.exe
www\\files\\exe\\tasklist.exe
www\\files\\exe\\toANSI.exe
www\\files\\exe\\toOEM.exe
www\\files\\exe\\xlhtml.exe
www\\files\\exe\\xlRowCount.exe
www\\files\\store\\MetaSetting.ini
www\\files\\store\\pathes.ini
www\\files\\units\\basic.unit.php
www\\Images\\bgEmblem.png
www\\Images\\down.gif
www\\Images\\Emblem.png
www\\Images\\help_small.gif
www\\Images\\help_small.PNG
www\\Images\\nl-next-0.gif
www\\Images\\nl-next-1.gif
www\\Images\\nl-prev-0.gif
www\\Images\\nl-prev-1.gif
www\\Images\\nl-up-0.gif
www\\Images\\nl-up-1.gif
www\\Images\\question_icon.jpg
www\\include\\Bottom.inc.php
www\\include\\Header.inc.php
www\\include\\lib.inc.php
www\\include\\init.inc.php
www\\include\\upload.inc.php
www\\include\\GetFile.inc.php
www\\scripts\\AnsiOem.xinc
www\\scripts\\backup.cmd
www\\scripts\\FastPrepDBF.cmd
www\\scripts\\GenUnit.cmd
www\\scripts\\getIni.cmd
www\\scripts\\InitExe.cmd
www\\scripts\\InitPatches.cmd
www\\scripts\\InitVars.cmd
www\\scripts\\PrepareDBF.cmd
www\\files\\units\\main.unit.php
",
'Settings'=>'',
'Install'=>'',
'Unistall'=>'');
// ================================================================== //
$pages[]=array(
'ID'=>'{7EFB5BFF-BCB4-40B6-AE5B-1BEF72D895}',
'Address'=>'index.php',
'Name'=>'Главная страница',
'Parent'=>'');
// ================================================================== //
$help["index"]=array(
"title"=>"Главная страница",
"text"=>"На этой странице перечислены все операции, которые доступны на данный момент. Список операций может меняться в зависмости от специалиста. <br />ВНИМАНИЕ! <br />Перейти на эту страницу всегда можно кликнув на эмблеме сайта в центральной верхней части любой страницы.",
"link"=>"");
/**/
$help["fio"]=array(
"title"=>"",
"text"=>"Если кликнуть по фамилии, то можно войти в систему под другим именем.<br />
Это бывает необходимо в том случае, если Вы сидите не за своим компьютером.",
"link"=>"[[Войти под другим именем]]");
/**/
$help["table"]=array(
"title"=>"",
"text"=>"Если кликнуть по номеру стола, то можно выбрать другой стол.<br />
Для разделения документации между отдельно стоящими столами, каждому специалисту
необходимо указывать стол, к которому относиться документация.",
"link"=>"[[Сменить стол]]");
// ================================================================== //
?>