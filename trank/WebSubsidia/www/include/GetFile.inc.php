<?php
  if (1==2){
    // ������� ���������� � ����������� �����:
    echo "<h3>���������� � ����������� �� ������ �����: </h3>";
    echo "<p><b>������������ ��� ������������ �����: ".$_FILES[$fileID]['name']."</b></p>";
    echo "<p><b>Mime-��� ������������ �����: ".$_FILES[$fileID]['type']."</b></p>";
    echo "<p><b>������ ������������ ����� � ������: ".$_FILES[$fileID]['size']."</b></p>";
    echo "<p><b>��������� ��� �����: ".$_FILES[$fileID]['tmp_name']."</b></p>";
  }
  // �������� ���� �� �������� ��� ���������� �������� ������:
  if (!copy($_FILES[$fileID]['tmp_name'], $filename))
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
?>