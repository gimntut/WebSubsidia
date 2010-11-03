<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  $LC = $_REQUEST["LC"];
  $NotLC = $LC=="" || empty($LC);
  if (!$NotLC) {
    include "lock.txt";
    if ($LockFIO == "") {
      ` scripts\\PrepareDBF.cmd "full\\dohod_p.dbf">$files_log\\prepare.log.txt`;
      if (strlen($LC)<7) {
        $LC = substr("9000000",0,7-strlen($LC)).$LC;}
      ` scripts\\Dossier.cmd $LC $ID`;
    }
  }
  $FocusedElement="Number";
?>
<?php include "Header.inc.php" ?>
      <?php 
        if (""=="1"){
          echo "<center>
          <form action=\"dossier.php\" method=\"Get\" >
          <select name=\"STOL\">";
          foreach ($STOLS as $VALUE => $NAME) {
            echo "<option value=$VALUE>$NAME</option>";
          }
          echo "<input type=\"HIDDEN\" Name=\"ID\" Value=\"$ID\">
          <input class=\"inSubmit\" type=\"SUBMIT\" Value=\"Войти\">
          </form></center>";
        }else{
          AddTitle('jobless','+');
          echo "</div>
          <form action=\"dossier.php\"><center>
          <Input type=\"Hidden\" Name=\"ID\" Value=\"$ID\">
          Введите номер дела:<br />
          <Input id='Number' class=\"inText\" type=\"Text\" Name=\"LC\"><br />
          <Input class=\"inSubmit\" type=\"Submit\" Value=\"Получить информацию\">
          </center>
          </form>";
          if (!$NotLC){
            echo "Дело №$LC:";
            include "D-$ID-$LC.tmp";
          }
        };
      ?>
<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>
