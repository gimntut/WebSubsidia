<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  $LC = $_REQUEST["LC"];
  $NotLC = $LC=="" || empty($LC);
  if (!$NotLC) {
    include "lock.txt";
    if ($LockFIO == "") {
      if (strlen($LC)<7) {
        $LC = substr("9000000",0,7-strlen($LC)).$LC;
      `Scripts\\DeloTest.cmd $LC $ID`;
      }
    }
  }
  include "$files_tmp\\TestResult.txt";
?>
