<?php 
  include_once 'units.inc.php';
  include 'names.php';
  include "Header.inc.php";
  switch ($_REQUEST['action']){
  case 'GetFieldInfo':
    include 'JournalFields.inc.php';
    echo json_encode($JournalFields);
    break;
  case 'GetOnlyNew':
    break;
  case 'add':
    /**************************************************************\
      Часть 1. Сохранить все лицевые счета
      Часть 2. Вызвать скрипт который соберёт информацию о сохранёных лицевых счетах
      Часть 3. Сравнить новые сведения с данными из journal0
    \**************************************************************/
    /* Часть 1 */
    $LCs = $_REQUEST["LCs"];
    $sid = session_id();
    $file=$files_tmp.'\\'.$sid;
    SaveArrayToFile($file,$LCs,'IsValidLC');
    /* Часть 2 */
    ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "sv7_p.dbf">$files_log\\prepare.log.txt`;
    ` scripts\\FastPrepDBF.cmd "street.dbf" "punkt.dbf" "sv7_p.dbf">>$files_log\\prepare.log.txt`;
    ` scripts\\GetInfo.cmd $sid`;
    include "$file.tmp.php";
    /* Часть 3 */
    /* Соединяемся, выбираем базу данных */
    $link = mysql_connect("localhost", "root", "")
        or die("Ошибка соединения с Мускулем : " . mysql_error());
    print "Классное соединение";
    mysql_select_db("websubsidia") or die("Нет связи с базой данных");
    /* Выполняем SQL-запрос */
    // $Journal[]=array(
    //'DATEOBR'=>'26.03.10','LCHET'=>9000100,'FIO'=>'Кузнецов Михаил Николаевич',
    //'ADDRESS'=>'Субханкулово, Нефтяников, д.10, кв.2','SUMMA'=>0.00,'FACT'=>2931.09,
    //'OTKAZ'=>'СДД превышает пожиточный минимум');
    foreach ($Journal as $rec){
      $query = "SELECT ${rec['LCHET']} FROM journal0";
      $result = mysql_query($query) or die("Ошибка запроса : " . mysql_error());
      /* if (mysql_num_rows($result)==0) {
        // num - вычисляется на основе dateobr
        // dateobr - 
        // SpecID - 
        // RecDate - 
        // DossierData - 
        // DossierDataExt - 
        $query = 
        "INSERT 
         INTO journal0 (num,dateobr,SpecID,RecDate,DossierData,DossierDataExt) 
         VALUES(0,${rec['DATEOBR']})";
        $result = mysql_query($query) or die("Ошибка запроса : " . mysql_error());
      } else {
      } */
      /* Выводим результаты в html */
      print "<table>\n";
      while ($line = mysql_fetch_array($result, MYSQL_BOTH)) {
          print "\t<tr>\n";
          foreach ($line as $col_value) {
              print "\t\t<td>$col_value</td>\n";
          }
          print "\t</tr>\n";
      }
      print "</table>\n";
    }
    /* Освобождаем память от результата */
    mysql_free_result($result);

    /* Закрываем соединение */
    mysql_close($link);
    break;
  case 'GetAllList':
    include_once 'units.inc.php';
    if ($_REQUEST["asArray"]=="Yes") {
      include "Stol_T1.inc.php";
      print_r($Journal);
    } else {
      $Journal=array();
      ngInclude('Stol_T1.inc.php');
      $s=json_encode($Journal);
      if ($_SERVER['HTTP_USER_AGENT']=='WebSubsidii'){
        echo $s;
      } else {
        include "Header.inc.php";
        echo "<table>";
        foreach ($Journal as $value) {
          echo "<tr>";
          foreach ($value as $item) {
            $s=iconv("utf-8","cp1251",$item);
            echo "<td>$s</td>";
          }
          echo "</tr>";
        }
        echo "</table>";
        include "Bottom.inc.php";
      }
    }
    break;
  case 'add':

    break;
  default:
   $FocusedElement="AddBox";
    echo "<form action=\"Test.php\"><center>
    <Input type=\"Hidden\" Name=\"ID\" Value=\"$ID\">
    <Input type=\"Hidden\" Name=\"STOL\" Value=\"$STOL\">
    <Input type=\"Hidden\" Name=\"action\" Value=\"add\">
    Введите номера дел через запятую:<br />
    <small>Например для дел 9000015, 9007070 и 9007171 нужно ввести \"15, 7070, 7171\"</small><br>
    <Input id=\"AddBox\" class=\"inText\" type=\"Text\" Name=\"LCs\"><br />
    <Input class=\"inSubmit\" type=\"Submit\" Value=\"Добавить дела в журнал\">
    </center>
    </form>";
  }
  include "Bottom.inc.php";
/**************************************************************\
Алгоритм:
1. Сотрудник перечисляет список дел котрорые нужно добавить в журнал
2. Сервер должен проверить, какие дела нужно добавить в список, а какие уже есть в списке
3. Для всех перечисленых дел берутся сведения из текущей базы
\**************************************************************/
?>
