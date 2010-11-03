<?php
  include_once 'lib.inc.php';
  include_once 'pathes.inc.php';
  ` scripts\\getallunits.cmd `;
  include 'units.list.php';
  // unlink($files_tmp.'\\units.list.php');
?>