<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  ` scripts\\PrepareDBF.cmd "full\\subsid_p.dbf" "Register.dbf" "SV2.dbf">$files_log\\prepare.log.txt`
  
?>
<?php 
  //Заголовок сайта
  include "Header.inc.php";
  ` scripts\\CheckBank.cmd `;
  include 'BankErrors.txt';
  sort($BankErrors);
  if (count($BankErrors)==0) {
    echo "<h2>Поздравляем!!!<br />В вашей базе нет банковских счётов с ошибками</h2>";
  } else {
    echo "<div class='title'>Список дел</div>";
    AddTitle('BankError','-');
    echo "<table border=\"1\" bordercolor=0 cellspacing=1 width=100%>";
    echo "<tr><th>№ дела</th><th>ФИО заявителя</th><th>Банковский счёт</th></tr>\n";
    foreach ($BankErrors as $v) {
      $i++;
      echo "<tr><td>${v['LC']}</td><td>${v['Family']} ${v['Name']} ${v['Father']}</td><td>${v['NCHETA']}</td></tr>\n";
    }
    echo "</table>";
  }
?>
<?php
  //Подножие сайта
  include "Bottom.inc.php";
?>
