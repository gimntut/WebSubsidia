<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
?>

<?php 
  //Заголовок сайта
  include "Header.inc.php";
  AddTitle('index');
?>

<?php 
        if ($FIO=="" || $ID=="-"){
          echo "<center>
          <form action=\"index.php\" method=\"get\" >
          <select name=\"ID\">";
          foreach ($NAMES as $VALUE => $NAME) {
            echo "<option value=$VALUE>$NAME</option>";
          }
          echo "</select>
          <input class=\"inSubmit\" type=\"SUBMIT\" Value=\"Войти\">
          </form></center>";
        }else{
          echo "Выберите одну из операций:<br>";
          echo "<a href=\"oblogka.php?ID=$ID\">Распечатать обложку</a><BR />
          <a href=\"journal.php?ID=$ID&STOL=$STOL\">Добавить записи в журнал</a><br />
          <a href=\"address.php?ID=$ID\">Проверить адрес</a><BR />";
          echo "<a href=\"Debtor.php?ID=$ID\">Обработать списки УЖКХ</a><BR />";
          echo "<a href=\"GetErrors.php\">Проверить банковские счета</a><BR />";
          echo "<a href=\"OnSBK.php\">Отчёт о делах на сберкассе</a><BR />";
          echo "<a href=\"dossier.php?ID=$ID\">Информация по делу</a><BR />";
          echo "<a href=\"BezRabAnaliz.php?ID=$ID\">ПОИСК БЕЗРАБОТНЫХ</a><hr />";
          // if ($ID=="M1" || $NAMES==null) {
          // }
          echo "<a href=\"admin.php?ID=$ID&STOL=$STOL\">Настроить сайт</a><BR />";
          // if ($ID=="M1" || $ID=="S9") {
          // }
          echo" или <a href=\"gku_help.php?ID=$ID\">посмотреть информацию по правильному заполнению счетов ЖКУ</a><br />
          или <a href=\"index.php?STOL=$STOL\">войти под другим именем</a><br />";
        }
      ?>
<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>
