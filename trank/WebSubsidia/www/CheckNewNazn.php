<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  ` scripts\\PrepareDBF.cmd "subs\\arxsub.dbf" >$files_log\\prepare.log.txt`
?>
<?php 
  //��������� �����
  include "Header.inc.php";
  ` scripts\\CheckNewNazn.cmd `;
  include 'NewNaznErrors.tmp.php';
  AddTitle('NewNaznErrors');
  echo "<pre>$NewNaznErrors</pre>";
?>
<?php
  //�������� �����
  include "Bottom.inc.php";
?>
