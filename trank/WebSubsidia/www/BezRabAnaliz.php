<?php 
  include 'units.inc.php';
  include 'names.php';
  include 'pathes.inc.php';
  $action = $_REQUEST["action"];
  include "lock.txt";
  if ($LockFIO == "") {
    ` scripts\\PrepareDBF.cmd full\\dohod_p.dbf full\\income_p.dbf >$files_log\\prepare.log.txt`;
  }
?>

<?php
  //��������� �����
  include "Header.inc.php";
  AddTitle('BezRabAnaliz','+');
  // print_r($help);
?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>