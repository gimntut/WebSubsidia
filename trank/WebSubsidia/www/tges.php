<?php
  include_once 'units.inc.php';
  include_once 'init.inc.php';
  include 'pathes.inc.php';
  print_r($POST);
  include 'names.php';
  $fileID = 'tgesfile';
  $uploaddir = $files_upload.'/';
  $filename = $uploaddir.basename($_FILES[$fileID]['name']);
  $xlsFile = "ТГЭС.xls";
  $SkipRowCount=0;

  include "getfile.inc.php";
  ` scripts\\tges.cmd "$filename"`;
  
  include "lock.txt";
  if ($LockFIO == "") {
    ` scripts\\PrepareDBF.cmd "register.dbf" "full\\subsid_p.dbf" "full\\kvplat_p.dbf" >$files_log\\prepare.log.txt `;
    //$num = count($ALCs);
  }
?>

<?php 
  //Заголовок сайта
  include "Header.inc.php";
?>

    <tr>
      <td>
      <?php 
        $Handle=fopen("$files_tmp/tges.csv",'r');
        $Handle2=fopen("$files_tmp/tges2.csv",'w');
        $row=0;
        $lc="";
        while (($data = fgetcsv($Handle, 1000, ";",'"')) !== FALSE) {
          if ($row<$SkipRowCount) {
            continue;
          }
          if ($data[1]==$lc){
            list($day, $month, $year) = preg_split('/\//', $data2[5]);
            $d1=$year.$month.$day; 
            list($day, $month, $year) = preg_split('/\//', $data[5]);
            $d2=$year.$month.$day;
            
            if ($d1<$d2){
              // echo "12_ $data2[0] ($lc)  $d1<$d2<br />";
              $data2[]=str_replace(".",",",$data[4]); // Сумма оплаты
              $data2[]=$data[5]; // Дата оплаты
            } else {
              // echo "1_3 $data2[0] ($lc)  $d1>=$d2<br />";
              $data[4]=str_replace(".",",",$data[4]);
              array_splice ( $data2, 4, 0, array($data[4],$data[5]) );
            }
              fputcsv($Handle2, $data2, ";", '"');
          }else{
            $lc=$data[1];
            $row++;
            $data2=array();
            $data2[]=$data[1]; // ЛС
            $data2[]=$data[0]; // ЛС предприятия
            $data2[]=$data[2]; // ФИО
            $data2[]=$data[3]; // Адрес
            $data2[]=str_replace(".",",",$data[4]); // Сумма оплаты
            $data2[]=$data[5]; // Дата оплаты
          }
        }
        fclose($Handle);
        fclose($Handle2);
        ` scripts\\tges2.cmd `;
        // copy($files_tmp.'\\'.$xlsFile, $files_download.'\\'.$xlsFile);
        echo "<br /><a href='/download/$xlsFile'>Cкачать список должников</a>";
      ?>
<?php
  //Подножие сайта
  include "Bottom.inc.php";
?>
