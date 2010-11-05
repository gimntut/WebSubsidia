<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include_once 'names.php';
  include_once 'pathes.inc.php'; 
  switch ($_REQUEST["action"]) {
    case 'download':
      foreach ($units as $v) {
        $url=iconv("cp1251","utf-8",$v['Name']);
        // echo "$url <br />";
        if ($url==$_REQUEST["unit"]){
          $s="
set Name = ${v['Name']}
set Description = ${v['Description']}";
          file_put_contents($files_tmp.'/comment.tmp',$s);
          file_put_contents($files_tmp.'/unit.filelist.txt',$v['Files']);
          ` scripts\GenUnit.cmd "${v['Name']}"`;
          unlink($files_tmp.'/unit.filelist.txt');
          unlink($files_tmp.'/comment.tmp');
          $url=rawurlencode($url);
          echo "
            <html>
            <head>
            <title>Перенаправление на закачку...</title>
            <meta http-equiv=Refresh content=\"0; url=/$files_download/$url.WebSubUnit\">
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
      break;
    case 'upload':
      $fileID = 'uploadfile';
      $uploaddir = $files_upload.'/';
      $filename = $uploaddir.basename($_FILES[$fileID]['name']);
      include "getfile.inc.php";
      ` scripts\\GetUnitName.cmd "$filename"`;
      include "NewUnit.inc.php";
      unlink($files_tmp.'/NewUnit.inc.php');
      ` scripts\\WebSubUpload.cmd "$filename"`;
      foreach ($units as $v) {
        $url=iconv("cp1251","utf-8",$NewUnit['Name']);
        // echo "$url <br />";
        if ($url==$_REQUEST["unit"]){
          file_put_contents($files_tmp.'/unit.filelist.txt',$v['Files']);
          ` scripts\BackupUnit.cmd "${v['Name']}"`;
          unlink($files_tmp.'/unit.filelist.txt');
          $url=rawurlencode($url);
        }
      }
      ` scripts\\WebSubUpload.cmd "$filename"`;
      break;
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
      <input type='hidden' name='action' value='upload'>
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
