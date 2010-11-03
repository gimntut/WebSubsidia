<?php
  if (1==2){
    // Выводим информацию о загруженном файле:
    echo "<h3>Информация о загруженном на сервер файле: </h3>";
    echo "<p><b>Оригинальное имя загруженного файла: ".$_FILES[$fileID]['name']."</b></p>";
    echo "<p><b>Mime-тип загруженного файла: ".$_FILES[$fileID]['type']."</b></p>";
    echo "<p><b>Размер загруженного файла в байтах: ".$_FILES[$fileID]['size']."</b></p>";
    echo "<p><b>Временное имя файла: ".$_FILES[$fileID]['tmp_name']."</b></p>";
  }
  // Копируем файл из каталога для временного хранения файлов:
  if (!copy($_FILES[$fileID]['tmp_name'], $filename))
  { echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
          <html>
            <head>
              <title>Центр управления субсидиями</title>
            </head>
            <body>
              <h3>Ошибка! Не удалось загрузить файл на сервер!</h3>
           </body>
          </html>';
    exit; 
  }
?>