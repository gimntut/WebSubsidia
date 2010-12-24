<?php
  include_once 'units.inc.php';
  include 'pathes.inc.php';
  include 'names.php';
  $uploaddir = $files_upload.'/';
  $uploadfile = $uploaddir.basename($_FILES['uploadfile']['name']);

  // �������� ���� �� �������� ��� ���������� �������� ������:
  if (!copy($_FILES['uploadfile']['tmp_name'], $uploadfile))
  { echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
          <html>
            <head>
              <title>����� ���������� ����������</title>
            </head>
            <body>
              <h3>������! �� ������� ��������� ���� �� ������!</h3>
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
  <title>����� ���������� ����������</title>
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
          // ������� ���������� � ����������� �����:
          echo "<h3>���������� � ����������� �� ������ �����: </h3>";
          echo "<p><b>������������ ��� ������������ �����: ".$_FILES['uploadfile']['name']."</b></p>";
          echo "<p><b>Mime-��� ������������ �����: ".$_FILES['uploadfile']['type']."</b></p>";
          echo "<p><b>������ ������������ ����� � ������: ".$_FILES['uploadfile']['size']."</b></p>";
          echo "<p><b>��������� ��� �����: ".$_FILES['uploadfile']['tmp_name']."</b></p>";
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
            // echo iconv("utf-8", "cp1251", "���� �����: $datefile - �������� �� ���������� ������.");
            echo "���� �����: $datefile - �������� �� ���������� �������.";
          }
          if ($data[0]>0) {
            for ($c=0;$c<13;$c++) {
              $data[$c]=iconv("utf-8", "cp1251", $data[$c]);
            }
            /*
            0  � �/�
            1  �.�.�. ����������-���������� �������� (���������)
            2  ����� �������� ����� ���������� ��������
            3  ����� ����������� ���������� (�����)
            4  ����� �������� ����� �����������
            5  ����������� ����� ��� �������� �����
            6  ����������� ����� �� �������� �����
            7  ����� ��������� ������
            8  ���� ��������� ������
            9  ����� ������������� ������
            10 ���� ������������� ������
            11 ����� �������������, ���.
            */
            $data2=array();
            $data2[]=$data[2]; // ����� �������� ����� ���������� ��������
            $data2[]=$data[1]; // �.�.�. ����������-���������� �������� (���������)
            $data2[]=$data[3]; // ����� ����������� ���������� (�����)
            $data2[]=$data[4]; // ����� �������� ����� �����������
            // $data2[]=str_replace(".",",",$data[5]); // ����������� ����� ��� �������� �����
            // $data2[]=str_replace(".",",",$data[6]); // ����������� ����� �� �������� �����
            $data2[]=str_replace(".",",",$data[7]); // ����� ��������� ������
            list($month, $day, $year) = preg_split('/-/', $data[8]);
            $data2[]=$day."/".$month."/20".$year;   // ���� ��������� ������
            // $data2[]=str_replace(".",",",$data[9]); // ����� ������������� ������
            // list($month, $day, $year) = preg_split ('/-/', $data[10]);
            // $data2[]=$day."/".$month."/20".$year;   // ���� ������������� ������
            $data2[]=str_replace(".",",",$data[11]); // ����� �������������, ���.
            fputcsv($Handle2, $data2, ";", '"');
          }
        }
        fclose($Handle);
        fclose($Handle2);
        ` scripts\\gkh2.cmd `;
        echo "<br /><a href='/download/ugkh.xls'>C������ ������ ���������</a>";
        //include "scripts/tmp/GkhResult.csv";
      ?>
      </td></tr>
  </table>
  <a name="Bottom">
  <a href="#Top">������</a>
</body>
</html>
