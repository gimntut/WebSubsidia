<?php 
  include_once 'units.inc.php';
  include 'names.php';
  include 'pathes.inc.php';
  $action = $_REQUEST["action"];  
?>
<?php 
  //Заголовок сайта
  include "Header.inc.php";
  AddTitle('settings','+');
  switch ($action) {
    case "save":
      $tempfile=fopen("$files_tmp\\temp.ini",'wt');
      fwrite($tempfile,"[settings]\n");
      foreach ($_POST as $key=>$value) {
        if ($key=="action") continue;
        // $v=stripslashes($value);
        $v=$value;
        fwrite($tempfile,"$key=$v\n");
        // echo "$key=$v<br />\n";
      }
      fclose($tempfile);
      ` $files_exe\\MergeIni.exe $files_store\\settings.ini $files_tmp\\temp.ini `;
      unlink("$files_tmp\\temp.ini");
      // print_r($_POST);
      echo "<h2>Настройки сохранены</h2><br /><a href=\"index.php?ID=$ID\">Вернуться на главную страницу</a><hr />";
    default:
  }
  include_once 'init.inc.php';
  echo "<form action=\"\" method=post>\n
  <input type=\"hidden\" name=\"action\" value=\"save\">
  <table><colgroup><col width=30% /><col /></colgroup>";
  foreach ($MetaSetting as $Meta) {
     // echo "${Meta["name"]}[${$Meta["name"]}]-[$ListPath]";
    
    if (${$Meta["name"]}==null) {
      ${$Meta["name"]}=$Meta["default"];
    }
    echo "<tr><td align=\"right\"><strong>${Meta["description"]}</strong></td>\n<td>";
    switch ($Meta["type"]) {
      case "text":
        echo "&nbsp;&nbsp;&nbsp;<input class=\"inText\" type=\"text\" name=\"${Meta["name"]}\" value=\"${$Meta["name"]}\">";
    }
    echo "</td></tr>\n";
  }
  echo "</table>\n<input class=\"inSubmit\" type=\"submit\" value=\"Сохранить\"><br /></form>\n";
  // print_r($MetaSetting);
?>

<?php
  //Подножие сайта 
  include "Bottom.inc.php";
?>
