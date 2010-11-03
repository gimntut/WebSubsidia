<?php 
$units[]=array(
'Name'=>'Поиск должников',
'Description'=>'Загрузка файлов поставщиков ЖКУ и выгрузка списков должников',
'Files'=>"
www\\scripts\\DefineDebtor.xinc
www\\scripts\\DefineExcel.xinc
www\\scripts\\FindDebtor.xinc
www\\scripts\\MakeExcel.xinc
www\\scripts\\MakeExcel_v2.xinc
www\\Debtor.php
www\\files\\units\\dolgnik.unit.php
",
'Install'=>'',
'Unistall'=>'');
// ================================================================== //
$pages[]=array(
'ID'=>'{3F1D801D-71FD-4C92-83A4-2D3E14D1C652}',
'Address'=>'Debtor.php',
'Name'=>'Обработать списки УЖКХ',
'Parent'=>'{7EFB5BFF-BCB4-40B6-AE5B-1BEF72D895}');
// ================================================================== //
$help["gku"]=array(
"title"=>"Поиск должников",
"text"=>"Не рекомендуется пользоваться ",
"link"=>"");
// ================================================================== //
?>