<?php 
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  $LC = $_REQUEST["LC"];
  $NotLC = $LC=="" || empty($LC);
  if (!$NotLC) {
    if (strlen($LC)<7) {
      $LC = substr("9000000",0,7-strlen($LC)).$LC;
    }
    include "lock.txt";
    if ($LockFIO==""){
      ` scripts\\PrepareDBF.cmd "full\\subsid_p.dbf" "full\\dohod_p.dbf">$files_log\\prepare.log.txt`;
      ` scripts\\PrepareDBF.cmd "register.dbf" "Punkt.dbf" "street.dbf">>$files_log\\prepare.log.txt`;
      // ` scripts\FastPrepDBF "Punkt.dbf" "street.dbf">>files\\log\\prepare.log.txt`;
      if (strlen($LC)<7) {
        $LC = substr("9000000",0,7-strlen($LC)).$LC;
      }  
      ` scripts\\GenerateBlank.cmd $ID $LC "$FIO"`;
      ` scripts\\Dossier.cmd $LC $ID`;
    }
  }
?>
<?php 
  //��������� �����
  include "Header.inc.php";
?>
        <?php if ($NotLC)
        { echo '<form action="oblogka.php" method="get">';
          echo '������� ����� ����:';
          echo '<input class="inText" type="text" name="LC" value="">';
          echo "<input type=\"hidden\" name=\"ID\" value=\"$ID\">";
          echo '<input class="inSubmit" type="Submit" value="������� �������"></form>';
          echo "<hr>� ��� �����:<br>";
          echo "<a href=\"index.php?ID=$ID\">��������� � ������ ��������</a><br>";
          echo "<a href=\"index.php\">����� ��� ������ ������</a><br>";
        }
        else
        { if ($LockFIO=="") {
          echo "������� �������, ������ � ����� �������<br>
          <a href=\"/download/Oblogka_$LC-$ID.rtf\"> ������� ������� �$LC</a><br>";
          if ($LC != ""){
            include "D-$ID-$LC.tmp";
          }
          } else {
            echo "� ������ ������ ������� ������ <b>$LockFIO</b><br>
            ������� F5, ����� ��� ��� ����������� ������� �������<hr>";
          }
          echo "��� <a href=\"oblogka.php?ID=$ID\">������� ������ ����</a><br>
          ��� <a href=\"index.php?ID=$ID\">��������� � ������ ��������</a><br>
          ��� <a href=\"index.php\">����� ��� ������ ������</a><br>";
        };?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>