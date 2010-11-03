<?php 
$units[]=array(
'Name'=>'Поиск банковских ошибок',
'Description'=>'Вывод списка дел, в которых есть банковские счета нуждающихся в исправлении',
'Files'=>"
www\\GetErrors.php
www\\scripts\\Check_sb.xbs
www\\scripts\\CheckBank.cmd
www\\scripts\\CheckBank.inc
www\\files\\units\\bank.unit.php
",
'Settings'=>'',
'Install'=>'',
'Unistall'=>'');
// ================================================================== //
$pages[]=array(
'ID'=>'{A557C2EB-EAC1-4195-8373-F67538E1035}',
'Address'=>'GetErrors.php',
'Name'=>'Проверить банковские счета',
'Parent'=>'{7EFB5BFF-BCB4-40B6-AE5B-1BEF72D895}');
// ================================================================== //
$help["BankError"]=array(
"title"=>"в которых банковские счета имеют ошибки",
"text"=>"Нужно исправить все ошибки через АРМ 'Субсидии', и зайти на эту страницу снова, чтобы убедиться, что все ошибки были исправлены.",
"link"=>"");
 ?>