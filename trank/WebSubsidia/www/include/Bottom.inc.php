<?php ?>
  </td></tr>
  </table>
  <a name="Bottom">
  <br /><a href="#Top"><img src="../images/nl-up-0.gif" border="0" /></a><br /><hr color="blue"/>
<?php 
$WorkTime=round(microtime(true)-$StartTime,2);
echo "<font size=\"2\" color=\"silver\">�������� c����������� �� $WorkTime ���<BR />";
echo "�� �������� ��� �������� ".$_SESSION['counter']++." ���. ";
echo "<br />".session_name().'='.session_id()."</font>";
?>
</body>
</html>
<?php ?>