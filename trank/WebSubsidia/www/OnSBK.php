<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  ` scripts\\PrepareDBF.cmd "full\\subsid_p.dbf" >$files_log\\prepare.log.txt`
?>
<?php 
  //��������� �����
  include "Header.inc.php";
  ` scripts\\OnSBK.cmd `;
  include 'OnSBK.txt';
  AddTitle('OnSbk');
  echo "<pre>$ResultOnSbk</pre>";
?>
<?php
  //�������� �����
  include "Bottom.inc.php";
?>
