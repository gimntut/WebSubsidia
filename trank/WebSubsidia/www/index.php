<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
?>

<?php 
  //��������� �����
  include "Header.inc.php";
  AddTitle('index');
?>

<?php 
        if ($FIO=="" || $ID=="-"){
          echo "<center>
          <form action=\"index.php\" method=\"get\" >
          <select name=\"ID\">";
          foreach ($NAMES as $VALUE => $NAME) {
            echo "<option value=$VALUE>$NAME</option>";
          }
          echo "</select>
          <input class=\"inSubmit\" type=\"SUBMIT\" Value=\"�����\">
          </form></center>";
        }else{
          echo "�������� ���� �� ��������:<br>";
          echo "<a href=\"oblogka.php?ID=$ID\">����������� �������</a><BR />
          <a href=\"journal.php?ID=$ID&STOL=$STOL\">�������� ������ � ������</a><br />
          <a href=\"address.php?ID=$ID\">��������� �����</a><BR />";
          echo "<a href=\"Debtor.php?ID=$ID\">���������� ������ ����</a><BR />";
          echo "<a href=\"GetErrors.php\">��������� ���������� �����</a><BR />";
          echo "<a href=\"OnSBK.php\">����� � ����� �� ���������</a><BR />";
          echo "<a href=\"dossier.php?ID=$ID\">���������� �� ����</a><BR />";
          echo "<a href=\"BezRabAnaliz.php?ID=$ID\">����� �����������</a><hr />";
          // if ($ID=="M1" || $NAMES==null) {
          // }
          echo "<a href=\"admin.php?ID=$ID&STOL=$STOL\">��������� ����</a><BR />";
          // if ($ID=="M1" || $ID=="S9") {
          // }
          echo" ��� <a href=\"gku_help.php?ID=$ID\">���������� ���������� �� ����������� ���������� ������ ���</a><br />
          ��� <a href=\"index.php?STOL=$STOL\">����� ��� ������ ������</a><br />";
        }
      ?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>
