<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include_once 'names.php';
  include_once 'pathes.inc.php'; 
  if ($_REQUEST["action"]=='download') {
    // echo "${_REQUEST["unit"]}<br />";
    foreach ($units as $v) {
      $url=iconv("cp1251","utf-8",$v['Name']);
      // echo "$url <br />";
      if ($url==$_REQUEST["unit"]){
        file_put_contents($files_tmp.'/unit.filelist.txt',$v['Files']);
        ` scripts\GenUnit.cmd "${v['Name']}"`;
        unlink($files_tmp.'/unit.filelist.txt');
        $url=rawurlencode($url);
        echo "
          <html>
          <head>
          <title>Перенаправление на закачку...</title>
          <meta http-equiv=Refresh content=\"0; url=/files/download/$url.WebSubUnit\">
          </head>
          <body>
            <a href=\"/$url.WebSubUnit\">Ссылка на закачивание </a>
          </body>
          </html>
        ";
        break;
      }
    }
    exit;
  }
  $FocusedElement="searchbox";
?>
<?php 
  //Заголовок сайта
  include "Header.inc.php";
  AddTitle('SetUnits');
  echo "
  <div class='download'>
    <form action='units.php' method=post enctype=multipart/form-data>
      <input type='hidden' name='ID' value='$ID'>
      <input type='hidden' name='STOL' value='$STOL'>
      <input class='inFile' id='filename' type='file' name='uploadfile'><br />
      <input class='inSubmit' type='submit' value='Загрузить'>
    </form>
  </div>
  <table border=\"1\" bordercolor=0 cellspacing=1 width=100%>
  <tr>
    <th>Название модуля</th>
    <th>Описание модуля</th>
    <th>Ссылка на скачивание</th>
  </tr>
  ";
  foreach ($units as $v) {
    $UnitName=iconv("cp1251","utf-8",$v['Name']);
    $UnitName=rawurlencode($UnitName);
    echo "<tr>
    <th>${v['Name']}</th>
    <td>${v['Description']}</td>
    <td>
      <a href='units.php?action=download&unit=$UnitName&ID=$ID&STOL=$STOL'>Скачать</a>";
      if ($v['Settings']!='') {
        echo "<br /><a href='${v['Settings']}?ID=$ID&STOL=$STOL'>Настроить</a>";
      }
    echo "</td>
    </tr>";
  }
  echo "</table>"
?>
<?php
  //Подножие сайта
  include "Bottom.inc.php";
?>
