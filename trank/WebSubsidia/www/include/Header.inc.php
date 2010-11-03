<?php include_once 'lib.inc.php'; ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Центр управления субсидиями</title>
  <link rel="stylesheet" href="../style.css" type="text/css" media="screen">
  <link rel="stylesheet" href="../print.css" type="text/css" media="print">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="GENERATOR" content="xlhtml">
  <script language="JavaScript" src="..\Hidder.js"></script>
</head>
<?php echo "<body onload=SetFocus(\"$FocusedElement\")>";?>
  <a name="Top"></a>
  <table align="center" width="100%">
    <tr>
      <td class="emblem">
<?php 
      echo "<a title=\"Перейти на главную страницу\" href=\"index.php?ID=$ID\">
      <img border=0 src=\"../Images/Emblem.png\" /></a>
      </td></tr>
      <tr><td>
      <table><tr><td>
      <a title=\"Войти под другим именем\" href=\"index.php\">$FIO</a>";
      if ($FIO!='') {AddHelp("fio");}
      echo "</td><td><a title=\"Выбрать другой стол\" href=\"journal.php?ID=$ID\">
      <font color=silver>[$STOLNAME]</font></a>";
      AddHelp("table");
?>
    </td></tr></table>
    </td></tr>
    <tr><td>
<?php ?>
