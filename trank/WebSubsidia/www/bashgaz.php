<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'pathes.inc.php';
  // print_r($POST);
  include 'names.php';
  $fileID = 'gazfile';
  $uploaddir = $files_upload.'/';
  $filename = $uploaddir.basename($_FILES[$fileID]['name']);
  include "getfile.inc.php";
  ` scripts\\gaz.cmd "$filename" `;
  
  include "lock.txt";
  if ($LockFIO == "") {
    ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "full\\kvplat_p.dbf" >$files_log\\prepare.log.txt `;
    //$num = count($ALCs);
  }
?>
<?php 
  //��������� �����
  include "Header.inc.php";
        $Handle=fopen("$files_tmp/bashgaz.csv",'r');
        $Handle2=fopen("$files_tmp/bashgaz2.csv",'w');
        $row=0;
        while (($data = fgetcsv($Handle, 1000, ",",'"')) !== FALSE) {
          $row++;
          if ($row<2) continue;
          if ($row==-10) {
            $datefile=$data[2];
            echo "���� �����: $datefile - �������� �� ���������� �������.";
          }
          for ($c=0;$c<13;$c++) {
            $data[$c]=iconv("utf-8", "cp1251", $data[$c]);
          }
          $data2=array();
          $data2[]=$data[1]; // ��
          $data2[]=$data[0]; // �� �����������
          $data2[]=$data[2]." ".substr($data[3],0,1).".".substr($data[4],0,1)."."; // ���
          $data2[]=$data[5]; // �����
          $data2[]=$data[6]; // ���������� ������ �����
          $data2[]=str_replace(".",",",$data[7]); // ������ 1 ���
          $data2[]=str_replace(".",",",$data[8]); // ������ 2 ���
          $data2[]=str_replace(".",",",$data[9]); // ���������� �� ����� �����
          list($month, $day, $year) = preg_split('/-/', $data[10]);
          $data2[]=$day."/".$month."/20".$year; // ���� ���� ������
          $data2[]=str_replace(".",",",$data[11]); // ����
          fputcsv($Handle2, $data2, ";", '"');
        }
        fclose($Handle);
        fclose($Handle2);
        ` scripts\\gaz2.cmd `;
        // copy($files_tmp."/bashgaz.xls", $files_download."/bashgaz.xls");
        echo "<br /><a href='/download/bashgaz.xls'>C������ ������ ���������</a>";
      ?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>
