<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  $LC = $_REQUEST["LC"];
  $NotLC = $LC=="" || empty($LC);
  if (!$NotLC) {
    if (strlen($LC)<7) {
      $LC = substr("9000000",0,7-strlen($LC)).$LC;
    }
    include "lock.txt";
    if ($LockFIO==""){
      ` scripts\\PrepareDBF.cmd "full\\subsid_p.dbf" "full\\dohod_p.dbf">$files_log\\prepare.log.txt`;
      ` scripts\\PrepareDBF.cmd "register.dbf" "Punkt.dbf" "street.dbf">>$files_log\\prepare.log.txt`;
      // ` scripts\FastPrepDBF "Punkt.dbf" "street.dbf">>files\\log\\prepare.log.txt`;
      if (strlen($LC)<7) {
        $LC = substr("9000000",0,7-strlen($LC)).$LC;
      }  
      ` scripts\\GenerateBlank.cmd $ID $LC "$FIO"`;
      ` scripts\\Dossier.cmd $LC $ID`;
    }
  }
?>
<?php 
  //Заголовок сайта
  include "Header.inc.php";
?>
        <?php if ($NotLC)
        { echo '<form action="oblogka.php" method="get">';
          echo 'Введите номер дела:';
          echo '<input class="inText" type="text" name="LC" value="">';
          echo "<input type=\"hidden\" name=\"ID\" value=\"$ID\">";
          echo '<input class="inSubmit" type="Submit" value="Создать обложку"></form>';
          echo "<hr>а ещё можно:<br>";
          echo "<a href=\"index.php?ID=$ID\">вернуться к выбору операций</a><br>";
          echo "<a href=\"index.php\">войти под другим именем</a><br>";
        }
        else
        { if ($LockFIO=="") {
          echo "Обложка создана, теперь её можно открыть<br>
          <a href=\"/download/Oblogka_$LC-$ID.rtf\"> Открыть обложку №$LC</a><br>";
          if ($LC != ""){
            include "D-$ID-$LC.tmp";
          }
          } else {
            echo "В данный момент обложку делает <b>$LockFIO</b><br>
            Нажмите F5, чтобы ещё раз попробовать создать обложку<hr>";
          }
          echo "или <a href=\"oblogka.php?ID=$ID\">выбрать другое дело</a><br>
          или <a href=\"index.php?ID=$ID\">вернуться к выбору операций</a><br>
          или <a href=\"index.php\">войти под другим именем</a><br>";
        };?>
<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>