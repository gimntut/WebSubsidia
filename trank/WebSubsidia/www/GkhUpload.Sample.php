<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  // ` scripts\gkh.cmd `;
  // include "lock.txt";
  // if ($LockFIO == "") {
    // ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "full\\kvplat_p.dbf" >$files_log\\prepare.log.txt `;
    // //$num = count($ALCs);}
?>

<?php 
  //Заголовок сайта
  include "Header.inc.php";
?>

<?php

         $inis = ini_get_all();

         print_r($inis[upload_tmp_dir]);        
         $uploaddir = $files_upload.'/';
        // Каталог, в который мы будем принимать файл:
        $uploadfile = $uploaddir.basename($_FILES['uploadfile']['name']);

        // Копируем файл из каталога для временного хранения файлов:
        if (copy($_FILES['uploadfile']['tmp_name'], $uploadfile))
        {
        echo "<h3>Файл успешно загружен на сервер</h3>";
        }
        else { echo "<h3>Ошибка! Не удалось загрузить файл на сервер!</h3>"; exit; }

        // Выводим информацию о загруженном файле:
        echo "<h3>Информация о загруженном на сервер файле: </h3>";
        echo "<p><b>Оригинальное имя загруженного файла: ".$_FILES['uploadfile']['name']."</b></p>";
        echo "<p><b>Mime-тип загруженного файла: ".$_FILES['uploadfile']['type']."</b></p>";
        echo "<p><b>Размер загруженного файла в байтах: ".$_FILES['uploadfile']['size']."</b></p>";
        echo "<p><b>Временное имя файла: ".$_FILES['uploadfile']['tmp_name']."</b></p>";

        ?>
<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>
