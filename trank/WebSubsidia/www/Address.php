<?php
  //                                                                                             //
  // ����� �� ������.                                                                            //
  // ������ ��� ���������� ������� ������ ���� �� ����� Streets.dbf                              //
  // ���� ������ �������� StreetID, �� ��������� ��� ������ �����, ������� ����������� � �����   //
  // ���� ������ �������� Home, �� ��������� ��� ���� ������� ��������� � ��������� ����         //
  //                                                                                             //
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'names.php';
  include 'pathes.inc.php';
  include "lock.txt";
  ` scripts\\PrepareDBF.cmd register.dbf full\\subsid_p.dbf >$files_log\\prepare.log.txt`;
  ` scripts\\FastPrepDBF.cmd punkt.dbf street.dbf >>$files_log\\prepare.log.txt`;
  $URLStreet=$_REQUEST["Street"];
  $Street = iconv("utf-8","cp1251",$URLStreet);
  $URLStreet=urlencode($URLStreet);
  $StreetID = $_REQUEST["StreetID"];
  $UrlHome = $_REQUEST["Home"];
  $Home = iconv("utf-8","cp1251",$UrlHome);
  $LC = $_REQUEST["LC"];
  $aSV = array("","���������", "��/�����", "�/�������", "�/���������", "����������", "�����", "��������", "������� ���������", "������� ���������", "������� ����.�� �/�");
  $prefix = "adr";
  $FocusedElement="searchbox";
?>

<?php 
  //��������� �����
  include "Header.inc.php";
?>
<?php
  // echo $Street;
  echo "<div class='title'>����� ���� �� ������</div>";
  if ($LC==""){
    if ($Home=="") {
      if ($StreetID==""){
        AddTitle('ChoiceStreet','-');
        ` scripts\\GetStreets.cmd `;
        include "Streets.txt";
        
        $i=0;
        $cnt=count($Streets);
        // $counter=0;
        // $cnt6=$cnt/6 + 1;
        echo" <SCRIPT>
          AdrCnt = $cnt;
        </SCRIPT>
        <INPUT class=\"inText\" type=\"text\" id='searchbox' onkeyup=clickIt(\"$prefix\") onload=ElementLoaded()><br />";
        foreach ($Streets as $v) {
          $StreetName=$v["Name"];
          if ($StreetName=="") continue;
          $URLStreet=urlencode(iconv("cp1251","utf-8",$StreetName));
          $StreetID=$v["ID"];
          $i++;
          echo "<a id=\"$prefix$i\" href=\"address.php?ID=$ID&StreetID=$StreetID&Street=$URLStreet\">$StreetName<br /></a>\n";
          // if ($counter++>$cnt6) {
            // echo "</td><td valign=\"top\">";
            // $counter -= $cnt6;
          // };
        }
        // echo "</td></tr></table>";
      } else {
        //$StreetDos = iconv("cp1251", "cp866", $Street);
        AddTitle('ChoiceHome','-');
        ` scripts\\GetHomes.cmd $StreetID`;
        include "$files_tmp\\Homes.txt";
        // $Homes=array_unique($Homes);
        // print_r($Homes);
        sort($Homes);
        $s="";
        $i=0;
        // $cnt=count($Homes);
        echo "<INPUT class=\"inText\" type=\"text\" id='searchbox' onkeyup=clickIt(\"$prefix\") ><br />";
        foreach ($Homes as $v) {
          $HomeNum=$v["Num"];
          $HomeKorp=strtoupper($v["Korp"]);
          if ($HomeKorp!="") {$HomeKorp="/".$HomeKorp;}
          $Home=$HomeNum.$HomeKorp;
          if ($Home==$s) continue;
          $s=$Home;
          $UrlHome=urlencode(iconv("cp1251","utf-8",$Home));
          $i++;
          echo "<a id=\"$prefix$i\" href=\"address.php?ID=$ID&StreetID=$StreetID&Street=$URLStreet&Home=$UrlHome\">$Street �.$Home<br /></a>\n";
        }
        echo" <SCRIPT>
          AdrCnt = $i;
        </SCRIPT>";
      }
    } else {
      AddTitle('ChoiceFlat','-');
      echo "<h2>�����: <strong>$Street �.$Home $Flat </strong></h2>\n";
      ` scripts\\GetPeoples.cmd $StreetID $Home`;
      include "$files_tmp\\Peoples.txt";
      sort($Peoples);
      echo "�������� ��������: ";
      foreach ($Peoples as $v) {
        $Flat=strtoupper($v["Flat"]);
        if ($Flat!="") {
          echo "<a href='#flat$Flat'>$Flat</a> &nbsp; ";
        }
      }
      echo "<br /><br />";
      $s="";
      foreach ($Peoples as $v) {
        $Flat=strtoupper($v["Flat"]);
        
        if ($Flat!="") {
          echo "<a name='flat$Flat' />";
          $Flat ="��������: "."<strong>".$Flat."</strong><br />";
        }
        $People = "��������� �����: <strong>".$v["PUNKT"]."</strong><br />\n";
        $People = $People.$Flat."���� <a href=\"dossier.php?ID=".$ID."&LC=".$v["LC"]."\">�<strong>".$v["LC"]."</strong></a><br />\n";
        $People = $People."<strong>".$v['Family']." ".$v['Name']." ".$v['Father']."</strong><br />\n";
        // $People = $People."�����: $Street �.$Home $Flat <br />";
        $v[DATEOBR]=str_replace("/",".",$v[DATEOBR]);
        $v[SUB_C]=str_replace("/",".",$v[SUB_C]);
        $v[SUB_PO]=str_replace("/",".",$v[SUB_PO]);
        $People = $People."������ �������: <strong>".$aSV[$v["SV"]]."</strong>. ������: <strong>".$v["SUB_C"]." - ".$v["SUB_PO"]."</strong><br />\n";
        $People = $People."���� ���������: <strong>".$v["DATEOBR"]."</strong>. �����: <strong>".$v["SUBSID"]."</strong><br />";
        $People = $People." <hr />";
        if ($People==$s) continue;
        $s=$People;
        echo $s;
        //echo "<a href=\"address.php?ID=$ID&StreetID=$StreetID&StreetName=$Street&People=$People\">$Street �.$People</a><br />";
      }
    }
  }
?>
<?php
  //�������� ����� 
  include "Bottom.inc.php";
?>
