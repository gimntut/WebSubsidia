<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  $LCs = $_REQUEST["LCs"];
  $NotLC = $LCs=="" || $STOL=="" || $STOLNAME=="-";
  if (!$NotLC) {
    $ALCs = explode(",",$LCs);
    include "lock.txt";
    if ($LockFIO == "") {
      `scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "sv7_p.dbf">$files_log\\prepare.log.txt`;
      $num = count($ALCs);
      for ($c=0; $c < $num; $c++) {
        $LC = Trim($ALCs[$c]);
        if (strlen($LC)<7) {
          $LC = substr("9000000",0,7-strlen($LC)).$LC;
        }
        include "Stol_$STOL.inc.php";
        if ($LockFIO==""){` scripts\\GenerateList.cmd $STOL`;}
      }
    }
  }
?>

<?php 
  //Заголовок сайта
  $FocusedElement="AddBox";
  include "Header.inc.php";
  AddTitle('journal');
?>

  <?php 
        if ($STOL=="" || $STOLNAME=="-"){
          echo "<center>
          <form action=\"journal.php\" method=\"Get\" >
          <select name=\"STOL\">";
          foreach ($STOLS as $VALUE => $NAME) {
            echo "<option value=$VALUE>$NAME</option>";
          }
          echo "<input type=\"HIDDEN\" Name=\"ID\" Value=\"$ID\">
          <input class=\"inSubmit\" type=\"SUBMIT\" Value=\"Войти\">
          </form></center>";
        }else{
          echo "<form action=\"journal.php\"><center>
          <Input type=\"Hidden\" Name=\"ID\" Value=\"$ID\">
          <Input type=\"Hidden\" Name=\"STOL\" Value=\"$STOL\">
          Введите номера дел через запятую:<br />
          <small>Например для дел 9000015, 9007070 и 9007171 нужно ввести \"15, 7070, 7171\"</small><br>
          <Input id=\"AddBox\" class=\"inText\" type=\"Text\" Name=\"LCs\"><br />
          <Input class=\"inSubmit\" type=\"Submit\" Value=\"Добавить дела в журнал\">
          </center>
          </form>
          <a href=\"#Bottom\">Перейти к концу журнала <img src=\"../images/down.gif\" /></a>";
          
          if (file_exists($files_journal."/stol_$STOL.csv")) {
            $Handle=fopen($files_journal."/stol_$STOL.csv",'r');
            if (($data = fgetcsv($Handle, 1000, ";",'"')) !== FALSE) {
              $num = count($data);
              $row++;
              echo "<table border=\"1\" bordercolor=0 cellspacing=1 width=100%>";
              echo "<thead><tr>";
              for ($c=0; $c < $num; $c++) {
                echo "<th>$data[$c]</th>";
              }
              echo "</tr></thead>";
            }
          } else {
            $Handle=fopen($files_journal."/stol_$STOL.csv",'x');
            $data=array("Дата","№ Дела","ФИО","Адрес","Сумма субсидии","Причина отказа","ФИО специалиста");
            fputcsv($Handle,$data,';','"');
          }
          
          
          while (($data = fgetcsv($Handle, 1000, ";",'"')) !== FALSE) {
            $num = count($data);
            $row++;
              echo "<tr>";
              for ($c=0; $c < $num; $c++) {
                echo "<td>$data[$c]</td>";
              }
              echo "</tr>";
          }
          echo "</table>";
          fclose($Handle);
        };
      ?>
<?php
  //Подножие сайта
  include "Bottom.inc.php";
?>