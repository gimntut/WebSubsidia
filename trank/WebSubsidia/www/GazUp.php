<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  include "lock.txt";
?>
<?php 
  //Заголовок сайта
  include "Header.inc.php";
?>
 
       <h2>Загрузка списка Башкиргаз</h2>
       <form action=bashgaz.php method=post enctype=multipart/form-data>
       <?php echo "<input type=\"Hidden\" name=\"ID\" value=\"$ID\">"; ?>
       <input class="inFile" id="filename" type=file name=gazfile><br />
       <input class="inSubmit" type=submit value=Загрузить></form>

<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>
