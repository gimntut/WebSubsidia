<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
?>
<?php 
  //��������� �����
  include "Header.inc.php";
?>

<h2>�������� ������ ���</h2>
       <form action=gkh.php method=post enctype=multipart/form-data>
       <?php echo "<input type=\"Hidden\" name=\"ID\" value=\"$ID\">"; ?>
       <input class="inFile" id="filename" type=file name=uploadfile>
       <input class="inSubmit"type=submit value=���������></form>
       <hr>
       <h2>�������� ������ ���������</h2>
       <form action=bashgaz.php method=post enctype=multipart/form-data>
       <?php echo "<input type=\"Hidden\" name=\"ID\" value=\"$ID\">"; ?>
       <input class="inFile" id="filename" type=file name=gazfile>
       <input class="inSubmit" type=submit value=���������></form>
       <hr>
       <h2>�������� ������ ����</h2>
       <form action=tges.php method=post enctype=multipart/form-data>
       <?php echo "<input type=\"Hidden\" name=\"ID\" value=\"$ID\">"; ?>
       <input class="inFile" id="filename" type=file name=tgesfile>
       <input class="inSubmit" type=submit value=���������></form>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>
