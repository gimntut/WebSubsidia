<?PHP 
` scripts\\checklock.cmd `;
$NAMES['-']='������������';
$NAMES['S15']='�������� ������� ���������';
$NAMES['S10']='����������� ������ ���������';
$NAMES['S14']='��������� ������� ����������';
$NAMES['S3']='������������ ������� ����������';
$NAMES['S6']='���������� ������� ����������';
$NAMES['S2']='����������� ���� �����������';
$NAMES['M1']='������ ����� ���������';
$NAMES['S1']='����������� ������� ���������';
$NAMES['S7']='�������� ������� �������������';
$NAMES['T3']='��������� ���� �����������';
$NAMES['S5']='��������� ������� ���������';
$NAMES['S9']='�������� ���� ����������';
$NAMES['T1']='�������� ������ �������';
$NAMES['S8']='���������� ������ ����������';
$NAMES['T2']='�������� �������� ������������';
$NAMES['S12']='��������� ������� ��������';
$NAMES['S4']='������������ ������ ��������';

$ID = $_REQUEST["ID"];
$FullFIO = $NAMES[$ID];
$AFIO = explode(" ",$FullFIO);
if ($FullFIO != ""){ $FIO = $AFIO[0]." ".$AFIO[1]{0}.".".$AFIO[2]{0}."."; }
$SpecCode=md5(mb_strtoupper($FullFIO));
$STOLS['-']='�������� ����';
$STOLS['T1']='���� �1';
$STOLS['T2']='���� �2';
$STOLS['T3']='���� �3';
$STOLS['T4']='���� �4';

$DefaultSTOLS['T1'] ='T1';
$DefaultSTOLS['S2'] ='T2';
$DefaultSTOLS['S4'] ='T3';
$DefaultSTOLS['S1'] ='T4';

$STOL = $_REQUEST["STOL"];

if ($STOL=="" || $STOL=="-" || $STOL==null)
{
  $STOL=$DefaultSTOLS[$ID];
}
$STOLNAME = $STOLS[$STOL];
if ($STOL=="" || $STOL=="-" || $STOL==null)
{
  $STOLNAME = '��� �����';
}
$LCs = $_REQUEST["LCs"];
$NotLC = $LCs=="" || $STOL=="" || $STOLNAME=="-";
?>
