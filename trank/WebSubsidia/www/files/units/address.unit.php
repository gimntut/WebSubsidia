<?php
// ================================================================== //
$units[]=array(
'Name'=>'Поиск дел по адресу',
'Description'=>'Проверка наличия дел относящихся к некоторому адресу',
'Files'=>"
www\\Address.php
www\\scripts\\GetHomes.cmd
www\\scripts\\GetHomes.xbs
www\\scripts\\GetPeoples.cmd
www\\scripts\\GetPeoples.xbs
www\\scripts\\GetStreets.cmd
www\\scripts\\GetStreets.xbs
www\\files\\units\\address.unit.php
",
'Settings'=>'',
'Install'=>'',
'Unistall'=>'');
// ================================================================== //
$pages[]=array(
'ID'=>'{FC5FAD18-A235-4A74-8D9F-33849C71B8A}',
'Address'=>'Address.php',
'Name'=>'Проверить адрес',
'Parent'=>'{7EFB5BFF-BCB4-40B6-AE5B-1BEF72D895}');
// ================================================================== //
$help["ChoiceStreet"]=array(
"title"=>"Выбор улицы",
"text"=>"Наберите в строке поиска фрагмент названия улицы, а потом кликните 
мышью по её названию под строкой поиска.",
"link"=>"");
$help["ChoiceHome"]=array(
"title"=>"Выбор дома",
"text"=>"Наберите в строке поиска номер дома, а потом кликните 
мышью по адресу под строкой поиска.",
"link"=>"");
$help["ChoiceFlat"]=array("title"=>"Выбор квартиры","text"=>"Если по данному адресу слишком много квартир, то нажмите по номеру нужной 
квартиры напротив слов <font color=navy>Найденые квартиры:</font>.","link"=>"");
// ================================================================== // 
?>