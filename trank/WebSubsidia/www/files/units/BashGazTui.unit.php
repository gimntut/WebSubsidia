<?php 
$units[]=array(
'Name'=>'Башкиргаз-Туймазы',
'Description'=>'Приём списка получателей субсидии в формате Башкиргаз-Туймазы.<br />
Выявление должников в полученом списке.',
'Files'=>"
www\\bashgaz.php
www\\files\\store\\gazHead.xls
www\\GazUp.php
www\\scripts\\bashgaz.xbs
www\\scripts\\BGExcel.xbs
www\\scripts\\gaz.cmd
www\\scripts\\gaz2.cmd
www\\files\\units\\BashGazTui.unit.php
",
'Settings'=>'',
'Install'=>'',
'Unistall'=>'');
// ================================================================== //
$pages[]=array(
'ID'=>'{FF4EBA5E-A2E6-4F45-AFE7-DCCA4336C5}',
'Address'=>'bashgaz.php',
'Name'=>'Башкиргаз-Туймазы',
'Parent'=>'{D4750C70-69B0-4C79-91A9-71108FEE7E4}');
// ================================================================== //
?>