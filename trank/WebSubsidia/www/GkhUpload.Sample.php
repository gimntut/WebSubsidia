<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  // ` scripts\gkh.cmd `;
  // include "lock.txt";
  // if ($LockFIO == "") {
    // ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "full\\kvplat_p.dbf" >$files_log\\prepare.log.txt `;
    // //$num = count($ALCs);}
?>

<?php 
  //��������� �����
  include "Header.inc.php";
?>

<?php

         $inis = ini_get_all();

         print_r($inis[upload_tmp_dir]);        
         $uploaddir = $files_upload.'/';
        // �������, � ������� �� ����� ��������� ����:
        $uploadfile = $uploaddir.basename($_FILES['uploadfile']['name']);

        // �������� ���� �� �������� ��� ���������� �������� ������:
        if (copy($_FILES['uploadfile']['tmp_name'], $uploadfile))
        {
        echo "<h3>���� ������� �������� �� ������</h3>";
        }
        else { echo "<h3>������! �� ������� ��������� ���� �� ������!</h3>"; exit; }

        // ������� ���������� � ����������� �����:
        echo "<h3>���������� � ����������� �� ������ �����: </h3>";
        echo "<p><b>������������ ��� ������������ �����: ".$_FILES['uploadfile']['name']."</b></p>";
        echo "<p><b>Mime-��� ������������ �����: ".$_FILES['uploadfile']['type']."</b></p>";
        echo "<p><b>������ ������������ ����� � ������: ".$_FILES['uploadfile']['size']."</b></p>";
        echo "<p><b>��������� ��� �����: ".$_FILES['uploadfile']['tmp_name']."</b></p>";

        ?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>
