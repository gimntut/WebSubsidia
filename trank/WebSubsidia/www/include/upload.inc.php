<?php
  $uploaddir = $files_upload;
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
?>