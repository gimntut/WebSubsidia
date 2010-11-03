<?php
  $uploaddir = $files_upload;
  $uploadfile = $uploaddir.basename($_FILES['uploadfile']['name']);

  // Копируем файл из каталога для временного хранения файлов:
  if (!copy($_FILES['uploadfile']['tmp_name'], $uploadfile))
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