<?php
/* Секция инициализации данных */
session_start();
if (!isset($_SESSION['counter'])) $_SESSION['counter']=0;
$StartTime=microtime(true);
/******** Конец секции *********/
//////////////////////////////////////////////////////////////////////////////
function ngInclude($IncludeFile,$once=true)
{
  global $onceList;
  if ($once) {
    $s=mb_strtoupper($IncludeFile);
    if ($onceList==null) $onceList=array();
    if (in_array($s,$onceList)) return;
    $onceList[]=$s;
  }
  $text = "<?php ".file_get_contents($IncludeFile)." ?>";
  $text = iconv("cp1251","utf-8",$text);
  if (mb_strpos($text,';')) eval($text);
  return $text;
}
//////////////////////////////////////////////////////////////////////////////
function IsValidLC($s) {
  $v=(int)$s;
  return ($v>=9000000 and $v<10000000);
}
//////////////////////////////////////////////////////////////////////////////
function SaveArrayToFile($filename,$StrList,$CallBackTest)
{
  $StrList = $_REQUEST["LCs"];
  $handle=fopen($filename,'wb');
  $Items = preg_split("/[\s,]+/", $StrList);
  $num = count($Items);
  for ($c=0; $c < $num; $c++) {
    $Item = Trim($Items[$c]);
    if (strlen($Item)<7) {
      $Item = substr("9000000",0,7-strlen($Item)).$Item;
    }
    if (call_user_func($CallBackTest,$Item)) fwrite($handle,$Item."\r\n");
  }
  fclose($handle);
}
//////////////////////////////////////////////////////////////////////////////
// Константы для функции AddHelp
$SimpleHelpFmt="<img class='help' onclick=SwithHelp(\"%1\$s\") src=\"../images/help_small.png\" 
title=\"Кликните на знак вопроса, чтобы вкл/выкл подсказку\">
<div style=\"display:none\" class=\"help\" id=\"%1\$s\">%2\$s";
$SimpleHelpMore="<br /><a class=\"help\" 
target=\"_blank\" href=\"../docs/help.tiddly#%1\$s\">Подробнее...</a>";
//
function AddHelp($id){
  global $help;
  global $SimpleHelpFmt;
  global $SimpleHelpMore;
  echo sprintf($SimpleHelpFmt,$id,$help[$id]["text"]);
  if ($help[$id]["link"]!=''){
    $s=iconv("cp1251","utf-8",$help[$id]["link"]);
    $s=rawurlencode($s);
    // $s=str_replace('+','%20',$s);
    echo sprintf($SimpleHelpMore,$s);
  }
  echo "</div>\n";
}
//////////////////////////////////////////////////////////////////////////////
function AddTitle($id,$cl='+'){
  global $help;
  $s=$help[$id]['title'];
  if ($cl=="-") {
    echo "<div class='subtitle'>$s";
  } else {
    echo "<div class='title'>$s";
  }
  AddHelp($id);
  echo "</div>";
}
//////////////////////////////////////////////////////////////////////////////

?>
