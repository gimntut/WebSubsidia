<?PHP 
` scripts\\checklock.cmd `;
$NAMES['-']='Представтесь';
$NAMES['S15']='Антонова Альбина Фанисовна';
$NAMES['S10']='Байтерякова Гюзель Фанилевна';
$NAMES['S14']='Биккенова Альбина Абузаровна';
$NAMES['S3']='Богданчикова Надежда Васильевна';
$NAMES['S6']='Габдуллина Альбина Саубановна';
$NAMES['S2']='Гарифуллина Алсу Салаватовна';
$NAMES['M1']='Гимаев Наиль Дамирович';
$NAMES['S1']='Загидуллина Рузалия Камилевна';
$NAMES['S7']='Зайнеева Муслима Миннегалеевна';
$NAMES['T3']='Луганцева Ляля Вильмировна';
$NAMES['S5']='Махмутова Эльвира Газизовна';
$NAMES['S9']='Рахимова Зиля Саубановна';
$NAMES['T1']='Хабирова Регина Римовна';
$NAMES['S8']='Хайруллина Нафиса Фризировна';
$NAMES['T2']='Халимова Гульнара Фирдависовна';
$NAMES['S12']='Хусаинова Гузалия Рауфовна';
$NAMES['S4']='Шайхутдинова Рузана Азифовна';

$ID = $_REQUEST["ID"];
$FullFIO = $NAMES[$ID];
$AFIO = explode(" ",$FullFIO);
if ($FullFIO != ""){ $FIO = $AFIO[0]." ".$AFIO[1]{0}.".".$AFIO[2]{0}."."; }
$SpecCode=md5(mb_strtoupper($FullFIO));
$STOLS['-']='Выберите стол';
$STOLS['T1']='Стол №1';
$STOLS['T2']='Стол №2';
$STOLS['T3']='Стол №3';
$STOLS['T4']='Стол №4';

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
  $STOLNAME = 'Без стола';
}
$LCs = $_REQUEST["LCs"];
$NotLC = $LCs=="" || $STOL=="" || $STOLNAME=="-";
?>
