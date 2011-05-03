unit uSpravkaEDK;

interface

uses
  uSpravka, Classes, StdCtrls, cgsCHPR;

type
  TStolbi=set of (std, R1, raz);

  TSpravkaEDK=class(TSpravka)
  private
    TmpSts:TStringList;
    Stolbi:TStolbi;
    Chpr:TChprList;
    Chpr2:TChprList;
    FMemo: TMemo;
    Table2: string;
    procedure SetMemo(const Value: TMemo);
  protected
    procedure DoChangePath(APath:string); override;
    function GetText: string; override;
  public
    constructor Create;
    procedure Show(Sender:TObject; Memo:TMemo); override;
    procedure Generate(Index:integer); override;
    procedure OutFound; override;
    procedure Prepare(s: string); override;

    property Memo:TMemo read FMemo write SetMemo;
  end;

implementation
uses DateIntervalDlg, Controls, StrUtils, DateUtils, PublStr, SysUtils, publ;
var
  FSpravkaEDK:TSpravkaEDK;
const
SpravkaEDK=
'                     УТ и СЗН Минтруда и СЗН РБ в г.Туймазы'#13#10+
#13#10+
'                             Лицевой счет N %s'#13#10+
'                         %s'#13#10+
'                прож. по адресу: %s'#13#10+
'                    Код пенсии(пособия) - %s Источник -  %s'#13#10+
'              История выплаты за период с %s по %s';
Title:array[0..3,0..3] of string=((('-------------------------'),('------------------------'),('-------------'),('--------------------------------------------')),
 (('Месяц        Сумма к     '),('1 раздел    Дата С      '),('Орган        '),('Разовые     С          По          N списка ')),
 (('выплаты      выплате     '),('тек.мес     1-го разд.  '),('выплаты.     '),('выплаты                                     ')),
 (('-------------------------'),('------------------------'),('-------------'),('--------------------------------------------')));

constructor TSpravkaEDK.Create;
begin
  inherited Create('ЕДК');
end;

// Выполнение загрузки/выгрузки файлов
procedure TSpravkaEDK.DoChangePath(APath: string);
begin

end;

// Создание справки на основе выбранной строки
procedure TSpravkaEDK.Generate(Index:Integer);
var
  LC: string;
  Ind: Integer;
begin
  if OutSide(Index, Chpr.Count - 1) then Exit;
  Ind := Integer(Chpr.Objects[Index]);
  if Ind = -1 then Exit;
  LC := Chpr.Values[Ind][10];
  Prepare(LC);
  PeriodDlg.OnChangeInterval:=Show;
  if PeriodDlg.Execute then
  begin
    Show(PeriodDlg,Memo);
  end else begin
//    MemoModeBtn.Down:=false;
//    MemoModeBtn.Click;
  end;
end;

function TSpravkaEDK.GetText: string;
begin

end;

const
  FieldsEDK_DB1: string
                 =( 'FAMILY=Фамилия,NAME=Имя,FATHER=Отчество,PN=Нас.Пункт,'+
                    'ST=Улица,HOUSE=Дом,KORP=Корп,FLAT=Квартира,'+
                    'KODPEN=КодПенс,IST=Источ.,LCHET=Л/С');

procedure TSpravkaEDK.OutFound;
var
  FastBase:TFastFileStrList;
  p:Integer;
  message:string;
  s:string;
begin
//  MemoModeBtn.Down:=false;
//  MemoModeBtn.Click;
  s:=Filter;
  FastBase:=TFastFileStrList.Create;
  try
    FastBase.ShowFields.CommaText:=FieldsEDK_DB1;
    FastBase.BaseName:=Path+'Base2.csv';
    FastBase.BaseIndexFile:=Path+'Base2.Index';
    p:=pos(' ',s);
    if p<2
    then begin
      FastBase.Filter:=s;
      s:='';
    end else begin
      FastBase.Filter:=LeftStr(s,p-1);
      System.Delete(s,1,p);
      s:=PublStr.Trim(s);
    end;
    Chpr.Mode:=mdCsv;
    Chpr.Text:=FastBase.Text;
    if s<>'' then chpr.Filter:=s;
    if length(s)<3
    then message:='Введите фамилию для поиска (не меньше 2х букв)'
    else message:='Ничего не найдено';
//    OutTable(message);
  finally
    FastBase.Free;
  end;
end;

procedure TSpravkaEDK.Prepare(s: string);
var
  FastBase: TFastFileStrList;
begin
  FastBase := TFastFileStrList.Create;
  try
    FastBase.BaseName := Path + Table2 + '.csv';
    FastBase.BaseIndexFile := Path + Table2 +'.Index';
    FastBase.Filter := s;
    Chpr2.Clear;
    Chpr2.Mode := mdCsv;
    Chpr2.Text := {ResultStr;} FastBase.Text;
  finally
    FastBase.Free;
  end;
end;

procedure TSpravkaEDK.SetMemo(const Value: TMemo);
begin
  FMemo := Value;
end;

procedure TSpravkaEDK.Show(Sender: TObject; Memo: TMemo);
var
  LC:string;
  Adres:string;
  FIO:string;
  Pens:string;
  Ist:string;
  C:string;
  Po:string;
  RSts:TStringList;
  ResultStr:string;
  I: Integer;
  DateVipl,SumVipl,Bank,R1Sum,R1Date,RazSum, RazFrom, RazTo, RazNum:string;
  DateV:TDate;
  J: Integer;
  L: Integer;
  IntervalDlg:TPeriodDlg;
  ChprTmp: TChprList;
  Sum, SV, SR1, SRaz:Currency;
  SumR1, SumRaz:Currency;
  bbb,eee:TDate;
  TotalSum:Currency;

  procedure OutPeriod;
  var
    s, sy:string;
    sb,se:string;
  begin
    sy:=Float2Str(YearOf(bbb),0);
    sb:=AnsiReplaceStr(DateToStr(bbb),'.'+sy,'');
    se:=AnsiReplaceStr(DateToStr(eee),'.'+sy,'');
    RSts.Add(format('%s (%s-%s):',[sy,sb,se]));
    S:=format('%24.2f',[Sum]);
    if R1 in Stolbi then
      S:=S+format('%12.2f %11s',[SumR1,'']);
    S:=S+format('%12s ',['']);
    if raz in Stolbi then
      S:=S+format('%12.2f',[SumRaz]);
    TotalSum:=TotalSum+Sum+SumR1+SumRaz;
    RSts.Add(s);
  end;

begin{ TODO -oНаиль : Убрать привязку ЛистБокс1 }
  IntervalDlg:=TPeriodDlg(Sender);
  LC:=TmpSts[10];
  FIO:=format('%s %s %s',[TmpSts[0],TmpSts[1],TmpSts[2]]);
  Adres:=format('%s ул.%s, д.%s',[TmpSts[3],TmpSts[4],ContStr(ContStr(TmpSts[5],'/',TmpSts[6]),' кв.',TmpSts[7])]);
  Pens:=TmpSts[8];
  Ist:=TmpSts[9];
  ChprTmp:= TChprList.Create;
  ChprTmp.Mode:=mdCSv;
  ChprTmp.Text:=//ResultStr;
  Chpr2.Text;
  C:=DateToStr(IntervalDlg.StartInterval);
  Po:=DateToStr(EndOfTheMonth(IntervalDlg.EndInterval));
  ResultStr:=format(SpravkaEDK,[LC,FIO,Adres,Pens,Ist,C,Po]);
  RSts:=TStringList.Create;
  RSts.Add('');
  Stolbi:=[std];
  for I := 0 to ChprTmp.Count - 2 do begin
    DateVipl:=ChprTmp.Values[i][1];
    DateV:=StrToDate(DateVipl);
    if not ((DateV>IntervalDlg.StartInterval-0.5) and (DateV<IntervalDlg.EndInterval+0.5))
    then Continue;
    RSts.Add(Float2Str(DateV,0)+ChprTmp[i+1]);
    if (ChprTmp.Values[i][3]<>'0.00') or (ChprTmp.Values[i][4]<>'') then Stolbi:=Stolbi+[R1];
    if (ChprTmp.Values[i][8]<>'0.00') or (ChprTmp.Values[i][10]<>'') or (ChprTmp.Values[i][11]<>'0') then Stolbi:=Stolbi+[raz];
  end;
  RSts.Sort;
  for I:=0 to RSts.Count-1 do
    RSts[i]:=Copy(RSts[i],6,MaxInt);
  ChprTmp.Text:=RSts.Text;
  RSts.Clear;
  ResultStr:=ResultStr+#13#10;
  for I := 0 to 3 do begin
    for J := 0 to 3 do begin
      case J of
        1: if [R1]*Stolbi=[] then Continue;
        3: if [raz]*Stolbi=[] then Continue;
      end;
      ResultStr:=ResultStr+Title[I,J];
    end;
    ResultStr:=ResultStr+#13#10;
  end;
  Sum:=0;
  SumR1:=0;
  SumRaz:=0;
  bbb:=-1;
  DateV := -1;
  TotalSum:=0;
  for I := 0 to ChprTmp.Count - 2 do begin
    DateVipl:=ChprTmp.Values[I][1];
    DateV := StrToDate(DateVipl);
    SumVipl:=ChprTmp.Values[I][2];
    SV:=StrToCurr(AnsiReplaceStr(SumVipl,'.',DecimalSeparator));
    SR1:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][3],'.',DecimalSeparator));
    SRaz:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][8],'.',DecimalSeparator));
    Bank:=ChprTmp.Values[I][7];
    if bbb<>-1 then
      if YearOf(DateV)<>YearOf(bbb) then begin
        eee:=StartOfTheMonth(DateV)-1;
        OutPeriod;
        bbb:=-1;
      end;
    Sum:=Sum+SV;
    SumR1:=SumR1+SR1;
    SumRaz:=SumRaz+SRaz;
    if bbb=-1 then begin
      Sum:=SV;
      SumR1:=SR1;
      SumRaz:=SRaz;
      bbb:=StartOfTheMonth(DateV);
    end;
    ResultStr:=ResultStr+format('%s %13s ',[DateVipl,SumVipl]);
    if R1 in Stolbi then begin
      R1Sum:=ChprTmp.Values[I][3];
      R1Date:=ChprTmp.Values[I][4];
      ResultStr:=ResultStr+format('%11s %-11s ',[R1Sum,R1Date]);
    end;
    ResultStr:=ResultStr+format('%-12s ',[Bank]);
    if raz in Stolbi then begin
      RazSum:=ChprTmp.Values[I][8];
      RazFrom:=ChprTmp.Values[I][9];
      RazTo:=ChprTmp.Values[I][10];
      RazNum:=ChprTmp.Values[I][12];
      if RazNum='' then RazNum:=ChprTmp.Values[I][11]
      else repeat
        L:=Length(RazNum);
        RazNum:=AnsiReplaceStr(RazNum,'  ',' ');
      until Length(RazNum)=L;
      ResultStr:=ResultStr+format('%11s %-10s %-11s %-15s',[RazSum,RazFrom,RazTo,RazNum]);
    end;
    ResultStr:=ResultStr+#13#10;
  end;
  if bbb<>-1 then begin
    eee:=EndOfTheMonth(DateV);
    OutPeriod;
  end;
  if RSts.Count>0 then
    ResultStr := ResultStr +#13#10'Суммы по периодам:'#13#10+ RSts.Text;
  if RSts.Count>1 then
    ResultStr := ResultStr+format(#13#10'ИТОГО: %.2f'#13#10,[TotalSum]);
//  MemoModeBtn.Down:=true;
//  Panel4.Visible:=false;
  Memo.Text:=ResultStr;
  RSts.Free;
end;

initialization
  FSpravkaEDK:=TSpravkaEDK.Create;
  FSpravkaEDK.Path:='D:\Списки\ЕДК\';
finalization
  FSpravkaEDK.Free;
end.
