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
      ����� 1. ��������� ��� ������� �����
      ����� 2. ������� ������ ������� ������ ���������� � ��������� ������� ������
      ����� 3. �������� ����� �������� � ������� �� journal0
    \**************************************************************/
    /* ����� 1 */
    $LCs = $_REQUEST["LCs"];
    $sid = session_id();
    $file=$files_tmp.'\\'.$sid;
    SaveArrayToFile($file,$LCs,'IsValidLC');
    /* ����� 2 */
    ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "sv7_p.dbf">$files_log\\prepare.log.txt`;
    ` scripts\\FastPrepDBF.cmd "street.dbf" "punkt.dbf" "sv7_p.dbf">>$files_log\\prepare.log.txt`;
    ` scripts\\GetInfo.cmd $sid`;
    include "$file.tmp.php";
    /* ����� 3 */
    /* �����������, �������� ���� ������ */
    $link = mysql_connect("localhost", "root", "")
        or die("������ ���������� � �������� : " . mysql_error());
    print "�������� ����������";
    mysql_select_db("websubsidia") or die("��� ����� � ����� ������");
    /* ��������� SQL-������ */
    // $Journal[]=array(
    //'DATEOBR'=>'26.03.10','LCHET'=>9000100,'FIO'=>'�������� ������ ����������',
    //'ADDRESS'=>'������������, ����������, �.10, ��.2','SUMMA'=>0.00,'FACT'=>2931.09,
    //'OTKAZ'=>'��� ��������� ���������� �������');
    foreach ($Journal as $rec){
      $query = "SELECT ${rec['LCHET']} FROM journal0";
      $result = mysql_query($query) or die("������ ������� : " . mysql_error());
      /* if (mysql_num_rows($result)==0) {
        // num - ����������� �� ������ dateobr
        // dateobr - 
        // SpecID - 
        // RecDate - 
        // DossierData - 
        // DossierDataExt - 
        $query = 
        "INSERT 
         INTO journal0 (num,dateobr,SpecID,RecDate,DossierData,DossierDataExt) 
         VALUES(0,${rec['DATEOBR']})";
        $result = mysql_query($query) or die("������ ������� : " . mysql_error());
      } else {
      } */
      /* ������� ���������� � html */
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
    /* ����������� ������ �� ���������� */
    mysql_free_result($result);

    /* ��������� ���������� */
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
    ������� ������ ��� ����� �������:<br />
    <small>�������� ��� ��� 9000015, 9007070 � 9007171 ����� ������ \"15, 7070, 7171\"</small><br>
    <Input id=\"AddBox\" class=\"inText\" type=\"Text\" Name=\"LCs\"><br />
    <Input class=\"inSubmit\" type=\"Submit\" Value=\"�������� ���� � ������\">
    </center>
    </form>";
  }
  include "Bottom.inc.php";
/**************************************************************\
��������:
1. ��������� ����������� ������ ��� �������� ����� �������� � ������
2. ������ ������ ���������, ����� ���� ����� �������� � ������, � ����� ��� ���� � ������
3. ��� ���� ������������ ��� ������� �������� �� ������� ����
\**************************************************************/
?>
