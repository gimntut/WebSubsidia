<?php
  include_once 'units.inc.php';
  include 'pathes.inc.php';
  include 'names.php';
  $uploaddir = $files_upload.'/';
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
  ` scripts\\gkh.cmd "$uploadfile"`;
  include "lock.txt";
  if ($LockFIO == "") {
    ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "full\\kvplat_p.dbf" >$files_log\\prepare.log.txt `;
    //$num = count($ALCs);
  }
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Центр управления субсидиями</title>
  <link rel="stylesheet" href="../style.css" type="text/css" media="screen">
  <link rel="stylesheet" href="../print.css" type="text/css" media="print">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="GENERATOR" content="xlhtml"></head>
<body>
  <a name="Top">
  <table align="center" width="100%">
    <?php include "Header.inc.php" ?>
    <tr>
      <td>
      <?php //include "scripts/tmp/gkh.txt" ?>
      <?php 
        if (1==2){
          // Выводим информацию о загруженном файле:
          echo "<h3>Информация о загруженном на сервер файле: </h3>";
          echo "<p><b>Оригинальное имя загруженного файла: ".$_FILES['uploadfile']['name']."</b></p>";
          echo "<p><b>Mime-тип загруженного файла: ".$_FILES['uploadfile']['type']."</b></p>";
          echo "<p><b>Размер загруженного файла в байтах: ".$_FILES['uploadfile']['size']."</b></p>";
          echo "<p><b>Временное имя файла: ".$_FILES['uploadfile']['tmp_name']."</b></p>";
        }
        $Handle=fopen("$files_tmp/gkh.csv",'r');
        $Handle2=fopen("$files_tmp/gkh2.csv",'w');
        $SkipRowCount=10;
        $ColumnCount=11;
        $row=0;
        while (($data = fgetcsv($Handle, 1000, ",",'"')) !== FALSE) {
          $row++;
          if ($row<$SkipRowCount) continue;
          if ($row==$SkipRowCount) {
            $datefile=$data[2];
            // echo iconv("utf-8", "cp1251", "Дата файла: $datefile - записать на распечатку вручну.");
            echo "Дата файла: $datefile - записать на распечатку вручную.";
          }
          if ($data[0]>0) {
            for ($c=0;$c<13;$c++) {
              $data[$c]=iconv("utf-8", "cp1251", $data[$c]);
            }
            /*
            0  № п/п
            1  Ф.И.О. гражданина-получателя субсидии (полностью)
            2  Номер лицевого счета получателя субсидии
            3  Место регистрации гражданина (адрес)
            4  Номер лицевого счета плательщика
            5  Начисленная сумма без приборов учета
            6  Начисленная сумма по приборам учета
            7  Сумма последней оплаты
            8  Дата последней оплаты
            9  Сумма предпоследней оплаты
            10 Дата предпоследней оплаты
            11 Сумма задолженности, руб.
            */
            $data2=array();
            $data2[]=$data[2]; // Номер лицевого счета получателя субсидии
            $data2[]=$data[1]; // Ф.И.О. гражданина-получателя субсидии (полностью)
            $data2[]=$data[3]; // Место регистрации гражданина (адрес)
            $data2[]=$data[4]; // Номер лицевого счета плательщика
            // $data2[]=str_replace(".",",",$data[5]); // Начисленная сумма без приборов учета
            // $data2[]=str_replace(".",",",$data[6]); // Начисленная сумма по приборам учета
            $data2[]=str_replace(".",",",$data[7]); // Сумма последней оплаты
            list($month, $day, $year) = preg_split('/-/', $data[8]);
            $data2[]=$day."/".$month."/20".$year;   // Дата последней оплаты
            // $data2[]=str_replace(".",",",$data[9]); // Сумма предпоследней оплаты
            // list($month, $day, $year) = preg_split ('/-/', $data[10]);
            // $data2[]=$day."/".$month."/20".$year;   // Дата предпоследней оплаты
            $data2[]=str_replace(".",",",$data[11]); // Сумма задолженности, руб.
            fputcsv($Handle2, $data2, ";", '"');
          }
        }
        fclose($Handle);
        fclose($Handle2);
        ` scripts\\gkh2.cmd `;
        echo "<br /><a href='/download/ugkh.xls'>Cкачать список должников</a>";
        //include "scripts/tmp/GkhResult.csv";
      ?>
      </td></tr>
  </table>
  <a name="Bottom">
  <a href="#Top">Наверх</a>
</body>
</html>
