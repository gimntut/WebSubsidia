unit cgsCHPR;

interface
uses Windows, Classes, publ,
//ViewLog,
Dialogs;

const
  mdChpr=0;
  mdCsv=1;
  mdText=2;
  /////////////////////////////////
  IntSize = SizeOf(Integer);
  BitsPerInt = IntSize * 8;
  /////////////////////////////////
  ReplaceSpaces = true;
var
  LineSpacing:integer = 30;
type
  TBitEnum = 0..BitsPerInt - 1;
  TBitSet = set of TBitEnum;
  PBitArray = ^TBitArray;
  TBitArray = array[0..4096] of TBitSet;

  TBitsExt=class(TBits)
  private
    FSize: Integer;
    FBits: Pointer;
    procedure Error;
    procedure SetSize(Value: Integer);
    procedure SetBit(Index: Integer; Value: Boolean);
    function GetBit(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function OpenBit: Integer;
    property Bits[Index: Integer]: Boolean read GetBit write SetBit; default;
    property Size: Integer read FSize write SetSize;
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);
  end;
  ///////////////////////// x ///////////////////////////////
  TSetOfByte=set of byte;
  TOnCustomFilter = procedure (Sender:TObject; Index:Integer; S:string; var Show:boolean) of object;
  TOnEnum = procedure (Sender:TObject; Index:Integer; S:string) of object;
  TOnCustomSort = procedure (Sender:TObject; sts:TStrings; Index:Integer; var Value:string) of object;
  TChprList= class(TStringList)
  private
    FFields:TStringList;
    FValues:TStringList;
    FFilling: Boolean;
    FIsTransformed: Boolean;
    FTmpSts:TStringList;
    FIsOEMSource: Boolean;
    FOriginalText: string;
    FTableLength: Integer;
    FFilter: string;
    FSortedField: Integer;
    FOrder:array of Integer;
    FAntiOrder:array of Integer;
    FilterArray:array of Integer;
    FFilterCount: Integer;
    FVisible:TBits;
    FOnCustomFilter: TOnCustomFilter;
    FOnEnum: TOnEnum;
    ValueIndex: Integer;
    FDescending: Boolean;
    FMode: Integer;
    FHead: string;
    FIsAbsIndexMode: Boolean;
    FAutoSplitCells: Boolean;
    FUnique: Boolean;
    S: string;
    FCurrentValue: Integer;
    FShowFields: TStrings;
    FOnCustomSort: TOnCustomSort;
    function GetAsTable: TStrings;
    function GetFieldNames: TStrings;
    function GetInnerDelimeter: Char;
    function GetOrder(Index: Integer): Integer;
    function GetValueByName(Index: Integer; FieldName: string): string;
    function GetValues(Index: Integer): TStrings;
    function GetValuesWithNames(Index: Integer): TStrings;
    function GetXValues(Row, Col: Integer): string;
    procedure ColumnSort;
//    procedure ExchangeOrder(Index1, Index2: Integer);
    procedure FieldsChange(Sender: TObject);
    procedure FineSort;
    procedure GetHead;
    procedure InitFilterCount;
    procedure NeedTmpSts;
    procedure SetDescending(const Value: Boolean);
    procedure SetFilling(const Value: Boolean);
    procedure SetInnerDelimeter(const Value: Char);
    procedure SetIsOEMSource(const Value: Boolean);
    procedure SetIsTransformed(const Value: Boolean);
    procedure SetMode(const Value: Integer);
    procedure SetOnCustomFilter(const Value: TOnCustomFilter);
    procedure SetOnEnum(const Value: TOnEnum);
    procedure SetOrder(Index: Integer; const Value: Integer);
    procedure SetSortedField(const Value: Integer);
    procedure SetTableLength(const Value: Integer);
    procedure SetXValues(Row, Col: Integer; const Value: string);
//    procedure SimpleSort;
    procedure Test;
    procedure ValueChange(Sender: TObject);
    //////////////////////////////////////////
    //////////////////////////////////////////
    procedure SetFilter(const Value: string);
    //////////////////////////////////////////
    procedure SetVisible(Index: Integer; const Value: Boolean);
    function GetVisible(Index: Integer): Boolean;
    //////////////////////////////////////////
    procedure DebugOut(fn:string = '');
    procedure AbsIndFilter;
    procedure RelIndFilter;
    procedure SortFilter;
    procedure SetIsAbsIndexMode(const Value: Boolean);
    procedure SetShowFields(const Value: TStrings);
    procedure SetOnCustomSort(const Value: TOnCustomSort);
  protected
    function  Compare(Index1, Index2: Integer): Integer;
    function Get(Index: Integer): string; override;
    procedure DoCustomFiltring;
    procedure DoCustomSort(sts:TStrings;Index:Integer;var Value:string);
    procedure Put(Index: Integer; const S: string); override;
    procedure SetTextStr(const Value: string); override;
    property XValues[Row,Col:Integer]:string read GetXValues write SetXValues;
    property IsAbsIndexMode: Boolean read FIsAbsIndexMode write SetIsAbsIndexMode;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    property AsTable:TStrings read GetAsTable;
    property FieldNames:TStrings read GetFieldNames;
    property Filling: Boolean read FFilling write SetFilling;
    property InnerDelimeter:Char read GetInnerDelimeter write SetInnerDelimeter default ';';
    property IsOEMSource: Boolean read FIsOEMSource write SetIsOEMSource;
    property IsTransformed: Boolean read FIsTransformed write SetIsTransformed;
    property OriginalText:string read FOriginalText;
    property TableLength: Integer read FTableLength write SetTableLength;
    property ValueByName[Index:Integer; FieldName:string]:string read GetValueByName;
    property Values[Index:Integer]:TStrings read GetValues;
    property ValuesWithNames[Index:Integer]:TStrings read GetValuesWithNames;
    //////////////////////////////////////////
    procedure AutoConfig;
    procedure DoEnum;
    procedure HideAll;
    procedure Podstava(ChprList:TChprList; LookupField,LookupSrc,LookupTrg:Integer);
    procedure ShowAll;
    procedure SaveAsFlat(FileName:string);
    //////////////////////////////////////////
    property Descending:Boolean read FDescending write SetDescending;
    property Filter:string read FFilter write SetFilter;
    property FilterCount: Integer read FFilterCount;
    property Head:string read FHead;
    property Mode:Integer read FMode write SetMode;
    property OnCustomFilter:TOnCustomFilter read FOnCustomFilter write SetOnCustomFilter;
    property OnEnum:TOnEnum read FOnEnum write SetOnEnum;
    property Order[Index:Integer]:Integer read GetOrder write SetOrder;
    property SortedField:Integer read FSortedField write SetSortedField;
    property VisibleItems[Index:Integer]:Boolean read GetVisible write SetVisible;
    property ShowFields:TStrings read FShowFields write SetShowFields;
    property OnCustomSort:TOnCustomSort read FOnCustomSort write SetOnCustomSort;
  end;

  TChprStat=record
    Delimeter:Char;
    IsOEM:Boolean;
    IsChpr:Boolean;
  end;

  TBinInd=record
    Position:Integer;
    Length:Integer;
  end;

  TTransformOptions = record
    Delimeter: string;
    Filling: boolean;
    Unique: boolean;
    AutoSplitCell: boolean;
  end;

  TFastFileStrList=class(TStringList)
  private
    FBaseIndexFile: string;
    FBaseName: string;
    FFilter: string;
    FShowFields: TStrings;
    Chpr: TChprList;
    procedure SetBaseIndexFile(const Value: string);
    procedure SetBaseName(const Value: string);
    procedure SetFilter(const Value: string);
    procedure DoFiltering;
    procedure SetShowFields(const Value: TStrings);
  published
  public
    constructor Create;
    destructor Destroy; override;
    property BaseName:string read FBaseName write SetBaseName;
    property BaseIndexFile:string read FBaseIndexFile write SetBaseIndexFile;
    property Filter:string read FFilter write SetFilter;
    property ShowFields:TStrings read FShowFields write SetShowFields;
    procedure Update;
  end;

  TGlueCSV=class
  private
    FCommonFields: TStrings;
    FSecondFields: TStrings;
    FInput2: string;
    FOutput: string;
    FInput1: string;
    FFirstFields: TStrings;
    procedure SetCommonFields(const Value: TStrings);
    procedure SetFirstFields(const Value: TStrings);
    procedure SetInput1(const Value: string);
    procedure SetInput2(const Value: string);
    procedure SetOutput(const Value: string);
    procedure SetSecondFields(const Value: TStrings);
    procedure OpenCSV(Input: string; var CSV: TChprList);
  published
  public
    property Input1:string read FInput1 write SetInput1;
    property Input2:string read FInput2 write SetInput2;
    property Output:string read FOutput write SetOutput;
    property CommonFields:TStrings read FCommonFields write SetCommonFields;
    property FirstFields:TStrings read FFirstFields write SetFirstFields;
    property SecondFields:TStrings read FSecondFields write SetSecondFields;
    procedure Execute;
  end;

//function Transform(Strings:TStrings; Delimeter: string=';'; Filling:boolean=false): string;
function Transform(Strings: TStrings; TransformOptions: TTransformOptions): string;
function GetFieldNames(Strings:TStrings; Delimeter:string=';'):TStrings;
function GetValueByName(Strings: TStrings; RowNum: Integer; FieldName:string; Delimeter: string = ';'):string;
function GetValueByColumn(Strings: TStrings; Row, Col: Integer; Delimeter: string = ';'):string;
function CheckBankNum(st:string):boolean;
procedure PrintToEpson(Sts:TStringList; IgnorePageBreak:Boolean=true);
procedure PrintToLaser(S:string);
procedure PrintToLaser2(Sts:TStrings; Title:string='Без названия'; FontName:string='Courier New');
function Analiz(Text:string;TestLength:Integer):TChprStat;
function CreateIndexForCSV(CSVFile,IndexFile:string; Col:Integer; CBProc:TIntProc=nil; TimeOut:integer=100):boolean; overload;
function CreateIndexForCSV(CSVFile,IndexFile:string; Cols:ai; CBProc:TIntProc=nil; TimeOut:integer=100):boolean; overload;
function CreateIndexForTxt(TxtFile,IndexFile:string; CBProcInt:TIntProc=nil; TimeOut:Integer=100):boolean;

resourcestring
  SBitsIndexError = 'Bits index out of range';

implementation
uses PublStr, Math, StrUtils, Printers, Graphics, SysUtils, DateUtils, PublFile;
var
  FieldStrings:TStringList;
  ValueStrings:TStringList;

var
  DebugMode:boolean=1=10;

type
  MaxIntArr = array[0..MaxInt-1] of Byte;

//function Transform(Strings:TStrings; Delimeter: string; Filling:boolean): string;
function Transform(Strings: TStrings; TransformOptions: TTransformOptions): string;
var
  s, st: string;
  sep1,sep2:TStringList;
  p: Integer;
  i, j, l: Integer;
  sts:TStringList;
  ch : char;
  Sep: Char;
  us: Boolean;
  si: Integer;
  Header: string;
begin
  Result:='';
  sts:=TStringList.Create;
  sts.Duplicates:=dupError;
  sts.Sorted:=true;
  sep1:=TStringList.Create;
  sep2:=TStringList.Create;
  if TransformOptions.Delimeter='' then sep:=';' else sep:=TransformOptions.Delimeter[1];
  sep1.Delimiter:=Sep;
  sep2.Delimiter:=Sep;
  sep1.StrictDelimiter:=true;
  sep2.StrictDelimiter:=true;
  For i:=0 to Strings.Count-1 do begin
    s:=PublStr.Trim(Strings[i]);
    s:=AnsiReplaceStr(s,'¦','|');
    s:=AnsiReplaceStr(s,#$B3,'|');
    s:=AnsiReplaceStr(s,#$BA,'|');
    L:=length(s);
    if L<3 then Continue;
    if not ((s[1]in ['|','!']) and (s[1]=s[L])) then Continue;
    ch:=s[1];
    s:=copy(s,2,L-2);
    s:=PublStr.Trim(s);
    if (s<>'') and (s=StringOfChar(s[1],length(s))) then Continue;
    us:=true;
    for si := 1 to length(s) do begin
      us:=s[si] in [' ','|','!','=','-','_','+'];
      if not us then break;
    end;
    if us then Continue;
    if (s<>'') and (s=StringOfChar(s[1],length(s))) then Continue;
    s:=AnsiReplaceStr(S,ch,TransformOptions.Delimeter);
    Repeat
     l:=length(s);
     s:=AnsiReplaceStr(s,' '+TransformOptions.Delimeter,TransformOptions.Delimeter);
     s:=AnsiReplaceStr(s,TransformOptions.Delimeter+' ',TransformOptions.Delimeter);
    Until l=length(s);
    if ReplaceSpaces then
      Repeat
       l:=length(s);
       s:=AnsiReplaceStr(s,'  ',' ');
      Until l=length(s);
    if TransformOptions.Filling then begin
      st:=Sep2.text;
      for ch := '0' to '9' do
        if pos(ch,st)>1 then begin
          sep1.DelimitedText:=S;
          for j:=0 to sep1.Count-1 do
            if sep1[j]='' then begin
              if sep2.Count<=j then break;
              sep1[j]:=sep2[j];
            end else break;
          S:=sep1.DelimitedText;
          break;
        end;
      for ch := '0' to '9' do
        if pos(ch,S)>1 then begin
          sep2.DelimitedText:=S;
          break;
        end;
    end;

    try
      //      sts.Add(s);
      if S<>Header
      then Result:=ContStr(Result,#13#10,s);
      if Header=''
      then Header:=S;
    except
    end;
  end;
  sts.Free;
  sep1.Free;
  sep2.Free;
  l:=length(Result);
  p:=-1;
  While p<>0 do begin
   if p=-1 then p:=0;
   p:=PosEx('.',Result,p+1);
   if p=0 then break;
   if p<2 then Continue;
   if not (Result[p-1] in ['0'..'9']) then Continue;
   if p=l then Continue;
   if not (Result[p+1] in ['0'..'9']) then Continue;
   if (p<l-2) and (Result[p+3]='.') then Continue;
   if (p>3) and (Result[p-3]='.') then Continue;
   Result[p]:=DecimalSeparator;
  end;
end;

function GetFieldNames(Strings:TStrings; Delimeter:string=';'):TStrings;
begin
  if Delimeter=''
  then FieldStrings.Delimiter:=';'
  else FieldStrings.Delimiter:=Delimeter[1];
  if Strings.Count=0 then FieldStrings.Text:='';
  FieldStrings.DelimitedText:=Strings[0];
  Result:=FieldStrings;
end;

function GetValueByName(Strings: TStrings; RowNum: Integer; FieldName:string; Delimeter: string = ';'):string;
var
  ind:Integer;
begin
  Result:='';
  if Strings=nil then Exit;
  inc(RowNum);
  if OutSide(RowNum,Strings.Count-1) then Exit;
  GetFieldNames(Strings,Delimeter);
  Ind:=FieldStrings.IndexOf(FieldName);
  if Delimeter=''
  then ValueStrings.Delimiter:=';'
  else ValueStrings.Delimiter:=Delimeter[1];
  ValueStrings.DelimitedText:=Strings[RowNum];
  if OutSide(Ind,ValueStrings.Count-1) then Exit;
  Result:=ValueStrings[Ind];
end;

function GetValueByColumn(Strings: TStrings; Row, Col: Integer; Delimeter: string = ';'):string;
begin
  Result:='';
  if Strings=nil then Exit;
  inc(Row);
  if OutSide(Row,Strings.Count-1) then Exit;
  if Delimeter=''
  then ValueStrings.Delimiter:=';'
  else ValueStrings.Delimiter:=Delimeter[1];
  ValueStrings.DelimitedText:=Strings[Row];
  if OutSide(Col,ValueStrings.Count-1) then Exit;
  Result:=ValueStrings[Col];
end;

{ TChprList }

{ TChprList }

procedure TChprList.AutoConfig;
var
  X:TChprStat;
begin
  X:=Analiz(FOriginalText,FTableLength);
  FIsTransformed:=x.IsChpr;
  FIsOEMSource:=x.IsOEM;
  if not FIsTransformed then InnerDelimeter:=X.Delimeter;
  SetTextStr(FOriginalText);
end;

procedure TChprList.NeedTmpSts;
begin
  if FTmpSts = nil then
    FTmpSts := TStringList.Create;
end;

procedure TChprList.Podstava(ChprList: TChprList; LookupField, LookupSrc, LookupTrg: Integer);
var
  I: Integer;
  s:string;
  J: Integer;
  us: Boolean;
begin
  FFields[LookupField]:=ChprList.FieldNames[LookupTrg];
  NeedTmpSts;
  FTmpSts.Clear;
  for I := 0 to ChprList.Count - 2 do FTmpSts.Add(ChprList.Values[i][LookupSrc]);
  for I := 0 to Count - 1 do begin
    s:=XValues[I,LookupField];
    us:=false;
    for J := 0 to FTmpSts.Count - 1 do begin
      us:=SameText(s,FTmpSts[J]);
      if not us then Continue;
      XValues[I,LookupField]:=ChprList.Values[J][LookupTrg];
      break;
    end;
    if us then Continue;
    XValues[I,LookupField]:='-*-*-*-';
  end;
end;

procedure TChprList.InitFilterCount;
begin
  // было FFilterCount := Count - 1;
  // стало:
  FFilterCount := Count;
  if FFilterCount = -1 then
    FFilterCount := 0;
end;

procedure TChprList.Put(Index: Integer; const S: string);
var
  Ind: Integer;
begin
  if IsAbsIndexMode
  then Ind:=Index
  else Ind:=Order[Index];
  if Ind=MaxInt then Exit;
  inherited Put(Ind,S);
end;

procedure TChprList.Clear;
begin
  inherited;
  Filter:='';
  ShowFields.Clear;
end;

procedure TChprList.ColumnSort;
begin
  if SortedField=-1 then Exit;
    //publ.QuickSort(0,Count-2,Compare,ExchangeOrder);
  FineSort;
  if not Assigned(FOnCustomSort) then Test;
end;

function TChprList.Compare(Index1, Index2: Integer): Integer;
var
  s1,s2:string;
begin
  s1:=XValues[Index1,SortedField];
  s2:=XValues[Index2,SortedField];
  Result:=publStr.CompNumText(s1,s2);
  if FDescending then Result:=-Result;
end;

constructor TChprList.Create;
begin
  IsAbsIndexMode:=false;
  inherited;
  FFields:=TStringList.Create;
  FValues:=TStringList.Create;
  FShowFields:=TStringList.Create;
  FFields.OnChange:=FieldsChange;
  FFields.StrictDelimiter:=true;
  FValues.StrictDelimiter:=true;
  FVisible:=TBits.Create;
  FAutoSplitCells := true;
  FUnique := true;
  FTableLength := 100;
  FSortedField:=-1;
  FDescending:=false;
  FCurrentValue:=-1;
end;

procedure TChprList.DebugOut(fn: string);
var
  i:integer;
  sts: TStringList;
  s:string;
  isst:Boolean;
begin
  if not DebugMode then Exit;
  sts := TStringList.Create;
  sts.Add('Параметры');
  sts.Add('Фильтр: '+FFilter);
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Порядок по умолчанию *');
  isst:=IsAbsIndexMode;
  IsAbsIndexMode:=true;
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': '+Strings[I]);
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Массив Visible *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+'['+StrUtils.IfThen(FVisible[i],'+','-')+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Массив FilterArray *');
  for I := 0 to High(FilterArray) do begin
    if I>=FilterCount then break;
    s := format ('%s: [%s]->[%s]',[ToZeroStr(I,3),ToZeroStr(FilterArray[I],3),ToZeroStr(Order[FilterArray[I]],3)]);
    sts.Add(s);
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Массив Order *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': ['+ToZeroStr(Order[I],3)+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Массив AntiOrder *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': ['+ToZeroStr(FAntiOrder[I],3)+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* Текст AsTable *');
  ////////////////////////////////////////////
  IsAbsIndexMode:=isst;
  ////////////////////////////////////////////
  DebugMode:=false;
  sts.AddStrings(AsTable);
  DebugMode:=true;
  ////////////////////////////////////////////
  if fn='' then fn:=ProgramPath+'DebugOut.txt';
  sts.SaveToFile(fn);
  sts.Free;
end;

destructor TChprList.Destroy;
begin
  FFields.Free;
  FValues.Free;
  FVisible.Free;
  FTmpSts.Free;
  FShowFields.Free;
  inherited;
end;

function TChprList.Get(Index: Integer): string;
var
  Ind: Integer;
begin
  if IsAbsIndexMode
  then Ind:=Index
  else Ind:=Order[Index];
  Result:='';
  if Ind=MaxInt then Exit;
  Result:=inherited Get(Ind);
end;

function TChprList.GetAsTable: TStrings;
var
  I,J,L:Integer;
  W:array of Integer;
  LW:Integer;
  TL:Integer;
  Ind:Integer;
  N: Integer;
  V:string;
  fs:string;
  W2: Integer;
  ShwFldCnt: Integer;
  FieldsNum: array of Integer;
  IsExternalFields: Boolean;
  FiN: string;
  cnt: Integer;

  function GetV(JJ:integer):string;
  begin
    if IsExternalFields
    then JJ:=FieldsNum[JJ];
    Result:=FValues[JJ];
  end;

  function GetF(JJ:integer):string;
  begin
    if IsExternalFields
    then Result := ShowFields.ValueFromIndex[JJ]
    else Result := FieldNames[JJ];
  end;

begin
  FCurrentValue:=-1;
  DebugOut('do.txt');
  NeedTmpSts;
  LW:=FieldNames.Count;
  IsExternalFields:=ShowFields.Count>0;
  if IsExternalFields then begin
    ShwFldCnt:=ShowFields.Count;
    if ShwFldCnt>0 then begin
      SetLength(FieldsNum,ShwFldCnt);
      for I:=0 to ShwFldCnt-1 do
        FieldsNum[I]:=self.FieldNames.IndexOf(ShowFields.Names[I]);
    end;
  end else ShwFldCnt:=LW;
  SetLength(W,ShwFldCnt);

  for I := 0 to High(W) do W[i]:=Length(GetF(I));
  TL:=TableLength;
  if TL=0 then TL:=Count;
  if Filter='' then begin
    for I := 1 to Count-1 do begin
      if Assigned(FOnCustomFilter) and not VisibleItems[I] then Continue;
      GetValues(I-1);
      if (FValues.Count>ShwFldCnt) and not IsExternalFields then begin
        ShwFldCnt:=FValues.Count;
        SetLength(W,ShwFldCnt);
      end;

      if IsExternalFields
      then cnt:=ShwFldCnt
      else cnt:=FValues.Count;

      for J := 0 to cnt-1 do begin
        L:=Length(GetV(J));
        if L>W[J] then W[J]:=L;
      end;
    end;
    FTmpSts.Clear;
    S:='';

    for J := 0 to ShwFldCnt-1 do begin
      if not OutSide(J,FieldNames.Count-1)
      then begin
        FiN := GetF(J);
        L:=length(FiN);
        W2:=(W[J]-L) div 2;
        S:=ContStr(S,'|',format('%*s%-*s',[W2,'',W[J]-W2,FiN]));
      end else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-1));
    S:='';
    for J := 0 to ShwFldCnt-1 do begin
      S:=ContStr(S,'|',StringOfChar('-',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    for I := 1 to Count-1 do begin
      if FTmpSts.Count>TL then begin
        S:=format('Показаны только %d записей',[TL]);
        FTmpSts.AddObject(S,pointer(-2));
        break;
      end;
      if Assigned(FOnCustomFilter) and not VisibleItems[I] then Continue;
      GetValues(I-1);
      S:='';
    for J := 0 to ShwFldCnt-1 do begin
      if not OutSide(J,FValues.Count-1)
        then begin
          V:=GetV(J);
          if IsNumber(V)
          then fs:='%*s'
          else fs:='%-*s';
          S:=ContStr(S,'|',format(fs,[W[J],V]));
        end else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
      end;
      FTmpSts.AddObject(S,pointer(I-1));
    end;
  end else begin
    // Подсчёт ширины столбцов
    N:=0;
    for I := 1 to FilterCount-1 do begin
      if N>TL then break;
      Ind:=FilterArray[I];
      {!}
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind-1);
      if (FValues.Count>ShwFldCnt) and not IsExternalFields then begin
        ShwFldCnt:=FValues.Count;
        SetLength(W,ShwFldCnt);
      end;

      if IsExternalFields
      then cnt:=ShwFldCnt
      else cnt:=FValues.Count;

      for J := 0 to cnt-1 do begin
        L:=Length(GetV(J));
        if L>W[J] then W[J]:=L;
      end;

      inc(N);
    end;

    FTmpSts.Clear;
    // Вывод результата
    // * Заголовок
    S:='';
    for J := 0 to ShwFldCnt-1 do begin
      if not OutSide(J,FieldNames.Count-1)
      then begin
        FiN := GetF(J);
        L:=length(FiN);
        W2:=(W[J]-L) div 2;
        S:=ContStr(S,'|',format('%*s%-*s',[W2,'',W[J]-W2,FiN]));
      end else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    // * Линия под заголовком
    S:='';
    for J := 0 to ShwFldCnt-1 do begin
      S:=ContStr(S,'|',StringOfChar('-',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    // * Таблица
    for I := 1 to FilterCount-1 do begin
      if FTmpSts.Count>TL then begin
        S:=format('Показаны только %d записей',[TL]);
        FTmpSts.AddObject(S,pointer(-2));
        break;
      end;
      {!}
      Ind:=FilterArray[I];
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind-1);
      S:='';
    for J := 0 to ShwFldCnt-1 do begin
      if not OutSide(J,FValues.Count-1)
        then S:=ContStr(S,'|',format('%-*s',[W[J],GetV(j)]))
        else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
      end;
      FTmpSts.AddObject(S,pointer(Ind-1));
    end;
  end;
  Result:=FTmpSts;
end;

function TChprList.GetFieldNames: TStrings;
begin
  Result:=FFields;
end;

procedure TChprList.GetHead;
var
  I:Integer;
  s:string;
begin
  for I := 0 to Count - 1 do begin
    s:=PublStr.Trim(Strings[i]);
    if (s<>'') and (s[1] in ['|','!']) and (s[length(s)] = s[1]) then break;
    FHead:=ContStr(FHead,#13#10,s);
  end;
end;

function TChprList.GetInnerDelimeter: Char;
begin
  Result := FFields.Delimiter;
  FCurrentValue:=-1;
end;

function TChprList.GetOrder(Index: Integer): Integer;
begin
  Result:=MaxInt;
  if OutSide(Index,high(FOrder)) then Exit;
  Result:=FOrder[Index];
end;

function TChprList.GetValueByName(Index: Integer; FieldName: string): string;
begin
  Result:=cgsCHPR.GetValueByName(self,Index,FieldName,InnerDelimeter);
end;

function TChprList.GetValues(Index: Integer): TStrings;
begin
  Result:=FValues;
  FValues.OnChange:=nil;
  ValueIndex:=Index+1;
  if OutSide(Index,Count-2) then begin
    FValues.DelimitedText:=StringOfChar(FValues.Delimiter,0);
    FValues.OnChange:=ValueChange;
    Exit;
  end;
  if Index=FCurrentValue then Exit;
  FValues.DelimitedText:=Strings[ValueIndex];
  FValues.OnChange:=ValueChange;
  FCurrentValue:=Index;
end;

function TChprList.GetValuesWithNames(Index: Integer): TStrings;
var
  I: Integer;
  s1, s2:string;
begin
  for I := 0 to math.max(FieldNames.Count,Values[Index].Count) - 1 do begin
    s1:='';
    s2:='';
    if I<FFields.Count then s1:=FFields[I];
    if I<FValues.Count then s2:=FValues[I];
    FValues[I]:=format('%s=%s',[s1,s2]);
  end;
  Result:=FValues;
end;

function TChprList.GetVisible(Index: Integer): Boolean;
var
  Ind:Integer;
begin
  Result:=false;
  if IsAbsIndexMode
  then Ind:=Index
  else begin
    if OutSide(Index,Count-1) then Exit;
    Ind:=FOrder[Index];
    if Ind=MaxInt then Exit;
  end;
  Result:=FVisible[Ind];
end;

function TChprList.GetXValues(Row, Col: Integer): string;
begin
  result:='';
  if OutSide(Row,Count-2) then Exit;
  if OutSide(Col,Values[Row].Count-1) then Exit;
  Result:=Values[Row][Col];
end;

procedure TChprList.HideAll;
var
  I:Integer;
begin
  for I := 0 to Count - 1 do
    FVisible[I]:=false;
end;

procedure TChprList.DoCustomFiltring;
var
  I:integer;
  Visible:Boolean;
  isst:Boolean;
begin
  if not Assigned(FOnCustomFilter) then Exit;
  isst:=IsAbsIndexMode;
  IsAbsIndexMode:=true;
  for I := 1 to Count - 1 do begin
    Visible:=VisibleItems[I];
    FOnCustomFilter(self,I-1,Strings[I],Visible);
    VisibleItems[I]:=Visible;
  end;
  IsAbsIndexMode:=isst;
end;

procedure TChprList.DoCustomSort(sts: TStrings; Index: Integer;
  var Value: string);
begin
  if Assigned(FOnCustomSort) then OnCustomSort(self,sts,Index,value);
end;

procedure TChprList.DoEnum;
var
  I:integer;
begin
  if not Assigned(FOnEnum) then Exit;
  for I := 0 to Count - 1 do
    FOnEnum(self,I,Strings[I]);
end;

//procedure TChprList.ExchangeOrder(Index1, Index2: Integer);
//var
//  o1,o2:Integer;
//begin
//  Index1:=Index1+1;
//  Index2:=Index2+1;
//  o1:=FOrder[Index1];
//  o2:=FOrder[Index2];
//  FOrder[Index1]:=o2;
//  FOrder[Index2]:=o1;
//  FAntiOrder[o2]:=Index1;
//  FAntiOrder[o1]:=Index2;
//end;

procedure TChprList.FieldsChange(Sender: TObject);
begin
  if Count=0 then Exit;
  Strings[0]:=FFields.DelimitedText;
end;

procedure TChprList.FineSort;
var
  I:Integer;
  sts: TNumStrList;
  ist:Boolean;
  s:string;
begin
  ist:=IsAbsIndexMode;
  IsAbsIndexMode:=true;
  sts := TNumStrList.Create;
  sts.CaseSensitive:=false;
  sts.Duplicates:=dupAccept;
  sts.Sorted:=true;
  for I := 0 to Count - 2 do begin
    s:=XValues[I,SortedField];
    DoCustomSort(Values[I],I,s);
    sts.AddObject(s,pointer(I+1));
  end;
//  log('FineSort');
//  log(sts.Text);
  FOrder[0]:=0;
  FAntiOrder[0]:=0;
  for I := 0 to sts.Count - 1 do begin
    FOrder[I+1]:=Integer(sts.Objects[i]);
    FAntiOrder[FOrder[I+1]]:=I+1;
  end;
  sts.Free;
  IsAbsIndexMode:=ist;
end;

procedure TChprList.SaveAsFlat(FileName: string);
var
  I: Integer;
  FileStream:TFileStream;
  crlf:string;
  S,upS: string;
  nsts:TNumStrList;
  J: Integer;
  MemoryStream: TMemoryStream;
  Bits:TBitsExt;
begin
  nsts := TNumStrList.Create;
  nsts.Sorted := True;
  nsts.Duplicates := dupIgnore;
  Insert(0,'');
  crlf:=#13#10;
  MemoryStream := TMemoryStream.Create;
  Bits:=TBitsExt.Create;
  for I := 0 to Count-2 do begin
    GetValues(I);
    S:=FValues.CommaText;
    upS:=AnsiUpperCase(S);
    Bits.Size:=Length(S);
    for J := 1 to Length(S) do
      Bits[J]:=S[J]<>upS[J];
    Bits.SaveToStream(MemoryStream);
    GetValues(I);
    for J := 0 to FValues.Count - 1 do begin
      nsts.Add(FValues[I])
    end;
  end;
  MemoryStream.Free;
  FileStream:=TFileStream.Create(FileName,fmCreate);
  FileStream.Free;
  Bits.Free;
  nsts.Free;
end;

procedure TChprList.SetDescending(const Value: Boolean);
begin
  FDescending := Value;
  ColumnSort;
end;

procedure TChprList.SetFilling(const Value: Boolean);
begin
  FFilling := Value;
  SetTextStr(FOriginalText);
end;

function MinusCompare(List: TStringList; Index1, Index2: Integer): Integer;
var
  s1,s2:string;
begin
  s1:=List[Index1];
  s2:=List[Index2];
  if s1='' then s1:=#255;
  if s2='' then s2:=#255;
  if s1[1]='-' then s1:=#1+s1;
  if s2[1]='-' then s2:=#1+s2;
  if not (s1[1] in [#1,#255]) then s1:=#2+s1;
  if not (s2[1] in [#1,#255]) then s2:=#2+s2;
  Result:=CompareText(s1,s2);
end;

procedure TChprList.SetFilter(const Value: string);
var
  TmpSts:TStringList;
  SepSts:TStringList;
  I, L: Integer;
  s1,s2:string;
  J: Integer;
  Ind: Integer;
  p: Integer;
  IsEq:Boolean;
  IsNot:Boolean;
begin
  FFilter := Value;
  InitFilterCount;
  if Value='' then begin
    SetLength(FilterArray,0);
    ShowAll;
    Exit;
  end else FOnCustomFilter:=nil;
  SetLength(FilterArray,FilterCount);
  SepSts:=TStringList.Create;
  SepSts.Delimiter:=' ';
  SepSts.DelimitedText:=Value;
  SepSts.CustomSort(MinusCompare);
  TmpSts:=TStringList.Create;
  TmpSts.Assign(self);
//  if TmpSts.Count>1 then TmpSts.Delete(0);
//  isst:=IsAbsIndexMode;
//  IsAbsIndexMode:=true;
  for I:=0 to FilterCount-1 do FilterArray[I]:=I;
  for I:=0 to SepSts.Count-1 do begin
    s1:=AnsiUpperCase(SepSts[i]);
    if s1='' then Continue;
    if s1='-' then Continue;
    IsNot:=s1[1]='-';
    if IsNot then System.Delete(s1,1,1);
    IsEq:=(s1<>'') and (s1[1]='=');
    if IsEq then begin
     System.Delete(s1,1,1);
     L:=Length(s1);
     if InnerDelimeter<>#0 then s1:=InnerDelimeter+s1+InnerDelimeter;
    end else L:=Length(s1);
    for J:=FilterCount-1 downto 1 do begin
      Ind:=FilterArray[J];
      try
        s2:=AnsiUpperCase(TmpSts[Ind]);
        s1:=AnsiReplaceStr(s1,'_',' ');
        p:=pos(s1,s2);
        if (p>0) xor IsNot then begin
         if IsEq
         then p:=p+1;
         system.Delete(s2,p,L);
         TmpSts[Ind]:=s2;
        end else begin
          {+}
          FilterArray[J]:=FilterArray[FilterCount-1];
          Dec(FFilterCount);
        end;
      except
        MessageBox('',format('Ind=%d, J=%d, FilterCount=%d',[Ind,J,FilterCount]));
        raise;
      end;
    end;
  end;
  TmpSts.Free;
  SepSts.Free;
  SortFilter;
  HideAll;
  for I:=0 to FilterCount-1 do begin
    Ind:=FilterArray[I];
//    Ind:=Order[Ind];
    VisibleItems[Ind]:=true;
  end;
//  IsAbsIndexMode:=isst;
  DebugOut;
end;

procedure TChprList.SetInnerDelimeter(const Value: Char);
var
  S:string;
begin
  S:=FFields.DelimitedText;
  FFields.Delimiter := Value;
  FFields.DelimitedText:=S;
  FValues.Delimiter := Value;
end;

procedure TChprList.SetTableLength(const Value: Integer);
begin
  FTableLength := Value;
end;

procedure TChprList.SetTextStr(const Value: string);
var
  S:string;
  I: Integer;
  N: Integer;
  TransformOptions:TTransformOptions;
begin
  FCurrentValue:=-1;
  SetLength(S,Length(Value));
  N:=1;
  I:=0;
  while I<Length(Value) do begin
    inc(I);
    if Value[I]=#0 then Continue;
    if Value[I]=#27 then begin
      inc(I);
      case Value[I] of
        'G','H','@': Continue;
      end;
    end;
    S[N]:=Value[I];
    inc(N);
  end;
  SetLength(S,N-1);
  FOriginalText:=S;
  if IsOEMSource then S:=AsAnsi(S);
  IsAbsIndexMode:=true;
  inherited SetTextStr(S);
  SetLength(FOrder,Count);
  for I:=0 to Count-1 do FOrder[I]:=I;
  SetLength(FAntiOrder,Count);
  for I:=0 to Count-1 do FAntiOrder[I]:=I;
  IsAbsIndexMode:=false;
  if IsTransformed then begin
    GetHead;
    TransformOptions.Filling:=FFilling;
    TransformOptions.Delimeter:=InnerDelimeter;
    inherited SetTextStr(Transform(self,TransformOptions));
  end;
  if Count>0
  then FFields.DelimitedText:=Strings[0]
  else FFields.Text:='';
  FVisible.Size:=Count;
  ShowAll;
  FSortedField:=-1;
  FDescending:=false;
  InitFilterCount;
end;

procedure TChprList.SetVisible(Index: Integer; const Value: Boolean);
var
  Ind: Integer;
begin
  if IsAbsIndexMode
  then Ind:=Index
  else begin
    if OutSide(Index,Count-1) then Exit;
    Ind:=FOrder[Index];
    if Ind=MaxInt then Exit;
  end;
  FVisible[Ind]:=Value;
end;

procedure TChprList.SetXValues(Row, Col: Integer; const Value: string);
begin
  if OutSide(Row,Count-2) then Exit;
  if OutSide(Col,Values[Row].Count-1) then Exit;
  Values[Row][Col]:=Value;
end;

procedure TChprList.ShowAll;
var
  I:Integer;
begin
  for I := 0 to Count - 1 do
    FVisible[I]:=false;
end;

procedure TChprList.SortFilter;
var
  I: Integer;
  J: Integer;
  p: Integer;
begin
  for I := 0 to FilterCount - 2 do
  begin
    for J := I + 1 to FilterCount - 1 do
    begin
      if FilterArray[I] > FilterArray[J] then
      begin
        p := FilterArray[I];
        FilterArray[I] := FilterArray[J];
        FilterArray[J] := p;
      end;
    end;
  end;
end;

procedure TChprList.AbsIndFilter;
var
  I: Integer;
begin
  if IsAbsIndexMode then Exit;
  for I := 0 to High(FilterArray) do begin
    FilterArray[I]:=Order[FilterArray[I]];
  end;
end;

procedure TChprList.RelIndFilter;
var
  I: Integer;
begin
  if not IsAbsIndexMode then Exit;
  for I := 0 to High(FilterArray) do begin
    FilterArray[I]:=FAntiOrder[FilterArray[I]];
  end;
  if High(FilterArray)=-1 then Exit;
  SortFilter;
end;

//procedure TChprList.SimpleSort;
//var
//  I: Integer;
//  J: Integer;
//  s1: string;
//  s2: string;
//begin
//  for I := 0 to Count - 3 do begin
//    s1:=XValues[I,FSortedField];
//    for J := I+1 to Count - 2 do begin
//      s2:=XValues[J,FSortedField];
//      if CompNumText(s1,s2)>0 then begin
//        ExchangeOrder(I,J);
//        s1:=XValues[I,FSortedField];
//      end;
//    end;
////    if I=100 then break;
//  end;
//
//end;

procedure TChprList.Test;
var
  I: Integer;
//  tx:TextFile;
begin
  for I := 0 to High(FOrder) do begin
    if not I=FAntiOrder[FOrder[I]] then begin
      MessageBox('','Тест #1 не пройден'#13#10
      +format('I=%d, Order[I]=%d, AntiOrder[%d]=%d',[I,FOrder[I],FOrder[I],FAntiOrder[FOrder[I]]]));
      break;
    end;
  end;

  for I := 0 to Count - 3 do
    if CompNumText(XValues[I,FSortedField],XValues[I+1,FSortedField])>0
      then begin
        MessageBox('','Тест #2 не пройден'#13#10
        +format('V[%d]=%s; V[%d]=%s',[I,XValues[I,FSortedField],I+1,XValues[I+1,FSortedField]]));
        break;
      end;
//  AssignFile(tx,'d:\!test\test.chpr.text');
//  Rewrite(tx);
//  for I := 0 to Count - 1 do begin
//    Writeln(tx,XValues[I,FSortedField]);
//  end;
//  CloseFile(tx);
end;

procedure TChprList.ValueChange(Sender: TObject);
begin
  if OutSide(ValueIndex,Count-1) then Exit;
  //GetValues(ValueIndex-1);
  Strings[ValueIndex]:=FValues.DelimitedText;
end;

procedure TChprList.SetIsOEMSource(const Value: Boolean);
begin
  FIsOEMSource := Value;
  SetTextStr(FOriginalText);
end;

procedure TChprList.SetIsAbsIndexMode(const Value: Boolean);
begin
  if Value
    then AbsIndFilter
    else RelIndFilter;
  FIsAbsIndexMode := Value;
end;

procedure TChprList.SetIsTransformed(const Value: Boolean);
begin
  FIsTransformed := Value;
  if InnerDelimeter=#0 then InnerDelimeter:=';';
  SetTextStr(FOriginalText);
end;

procedure TChprList.SetMode(const Value: Integer);
begin
  FMode := Value;
  case FMode of
    mdChpr: begin
      FIsTransformed:=true;
      FIsOEMSource:=true;
      InnerDelimeter:=';';
      SetTextStr(FOriginalText);
    end;
    mdCsv: begin
      FIsTransformed:=false;
      FIsOEMSource:=false;
      InnerDelimeter:=';';
      SetTextStr(FOriginalText);
    end;
    mdText: begin
      FIsTransformed:=false;
      FIsOEMSource:=false;
      InnerDelimeter:=#9;
      SetTextStr(FOriginalText);
    end;
  end;
end;

procedure TChprList.SetOnCustomFilter(const Value: TOnCustomFilter);
begin
  FOnCustomFilter := Value;
  if Assigned(Value) then begin
    FFilter:='';
    ShowAll;
    DoCustomFiltring;
  end;
end;

procedure TChprList.SetOnCustomSort(const Value: TOnCustomSort);
begin
  FOnCustomSort := Value;
end;

procedure TChprList.SetOnEnum(const Value: TOnEnum);
begin
  FOnEnum := Value;
end;

procedure TChprList.SetOrder(Index: Integer; const Value: Integer);
var
//  ao:Integer;
  o,av: Integer;
begin
  if OutSide(Index,high(FOrder)) then Exit;
  o:=FOrder[Index];
//  ao:=FAntiOrder[o];
  av:=FAntiOrder[Value];
  FOrder[Index]:=Value;
  FAntiOrder[Value]:=Index;
  FOrder[av]:=o;
  FAntiOrder[o]:=av;
end;

procedure TChprList.SetShowFields(const Value: TStrings);
begin
  FShowFields.Assign(Value);
end;

procedure TChprList.SetSortedField(const Value: Integer);
begin
  FSortedField := Value;
  ColumnSort;
  DebugOut;
end;

function CheckBankNum(st:string):boolean;
Var
  v:Integer;
  I:Integer;
  c,sum: Integer;
  S5: string;
  US: Boolean;
begin
  Result:=false;
  if copy(st,6,3)<>'810' then Exit;
  S5:=copy(ST,1,5);
  US :=(S5='42307')or(S5='42306')or(S5='42301')or(S5='40817');
  if not US then Exit;
  sum:=0;
  for I := 1 to Length(st) do begin
    val(st[i],v,c);
    if (i<=20) and (c>0) then Exit;
    if (i>20) and (c=0) then Exit;
    if (i=21) and (c>0) then Break;
    case I mod 3 of
     0: c:=3;
     1: c:=7;
     2: c:=1;
    end;
//    if I=9 then sv[i]:=0 else
    sum:=sum+v*c;
  end;
  Result:=5=(sum*3) mod 10;
end;

procedure PrintToEpson(Sts:TStringList; IgnorePageBreak:Boolean=true);
var
  I: Integer;
  prn: TextFile;
  st:string;
begin
  AssignFile(Prn, 'LPT1');
  Rewrite(Prn);
  Writeln(Prn,#27'@'#27'0'#27'M'#27'x0'#$12#27'3'+chr(LineSpacing));
  for I := 0 to sts.Count - 1 do begin
    st:=AsOEM(sts[i]);
    if IgnorePageBreak then st:=AnsiReplaceStr(St,#12,'');
    if LeftStr(st,5)='-----' then st:=st+#13#10;
    Writeln(Prn,st);
  end;
  CloseFile(Prn);
end;

procedure UpdateFont;
begin
  Printer.Canvas.Pixels[0,0]:=clWhite;
end;

procedure PrintToLaser(S:string);
Var
  I:integer;
  MaxLength,CharWidth,DPIc,PageWidth,HighLine:Integer;
  PageClientWidth,PageClientHeight,LinesPerPage:Integer;
  n: Integer;
  sts:TStringList;
  K: Real;
begin
 if S='' then Exit;
 sts:=TStringList.Create;
 Sts.Text:=S;
 For i:=Sts.Count-1 downto 0 do
   if PublStr.Trim(Sts[I])='' then sts.Delete(I) else break;
 MaxLength:=0;
 For i:=0 to Sts.Count-1 do begin
   Sts[i]:=TrimRight(Sts[i]);
   if length(Sts[i])>MaxLength then MaxLength:=length(Sts[i]);
 end;
 if MaxLength=0 then Exit;
 Printer.Canvas.Font.Name:='Courier New';
 Printer.Canvas.Font.Pitch:=fpFixed;
 Printer.Canvas.Font.Size:=10;
 CharWidth:=Printer.Canvas.TextWidth('W');
 PageWidth:=Printer.PageWidth;
 PageClientWidth:=PageWidth*9 div 10;
 PageClientHeight:=Printer.PageHeight*9 div 10;
 Printer.Title:='Расчёт субсидий';
 Printer.BeginDoc;
 DPIc:=Printer.Canvas.Font.PixelsPerInch;
 if PageClientWidth<CharWidth*MaxLength then begin
   DPIc:=DPIc*(CharWidth*MaxLength) div PageClientWidth;
   Printer.Canvas.Font.PixelsPerInch:=DPIc;
   UpdateFont;
 end;
 HighLine:=Printer.Canvas.TextHeight('рЁ');
 LinesPerPage:=PageClientHeight div HighLine;
 K:=Sts.Count/LinesPerPage;
 while (K>1) and (Frac(K)<0.3) do begin
   DPIc:=DPIc+10;
   Printer.Canvas.Font.PixelsPerInch:=DPIc;
   UpdateFont;
   HighLine:=Printer.Canvas.TextHeight('рЁ');
   LinesPerPage:=PageClientHeight div HighLine;
   K:=Sts.Count/LinesPerPage;
 end;
 n:=0;
 For i:=0 to Sts.Count-1 do begin
   Printer.Canvas.TextOut(PageWidth div 20, PageClientHeight div 18 + n*HighLine,Sts[i]);
   Cycle(n,LinesPerPage);
   if n=0 then Printer.NewPage;
 end;
 Printer.EndDoc;
end;

function PrintStringsToLaser(FontName: string; var sts: TStrings; StartLine:Integer=0; LastLine:Integer=-2):boolean;
var
  I: Integer;
  PageClientHeight: Integer;
  HighLine: Integer;
  LinesPerPage: Integer;
  n: Integer;
  S:string;
begin
  if LastLine=-2 then LastLine:=sts.Count-1;
  Result:=LastLine-StartLine>=0;
  if not Result then Exit;
  n := 0;
  PageClientHeight := Printer.PageHeight * 9 div 10;
  HighLine := Printer.Canvas.TextHeight('рЁ');
  LinesPerPage := PageClientHeight div HighLine;
  for i := StartLine to LastLine do
  begin
    if OutSide(i,sts.Count-1) then break;
    S := Sts[i];
    if (S<>'') and (S[1]=#12) then S:='---------------------- Линия отрыва -----------------------------';
    Printer.Canvas.TextOut(Printer.PageWidth div 20, PageClientHeight div 18 + n * HighLine, S);
    Cycle(n, LinesPerPage);
    if (n = 0) and (I<LastLine) then
      Printer.NewPage;
  end;
end;

procedure UpdateDPI(DPI:Integer);
begin
  Printer.Canvas.Font.PixelsPerInch := DPI;
  UpdateFont;
end;

function GetDPI(FontName: string; var sts: TStrings; out LinesPerPage:Integer; StartDPI:Integer=96; StartLine:Integer=0; LastLine:Integer=-2):Integer;
var
  I: Integer;
  MaxLength: Integer;
  CharWidth: Integer;
  PageWidth: Integer;
  PageClientWidth: Integer;
  PageClientHeight: Integer;
  DPIc: Integer;
  oDPIc: Integer;
  HighLine: Integer;
  oLinesPerPage: Integer;
  LineCount: Integer;
  K: Real;
  MaxLineCount: Integer;
begin
  MaxLength := 0;
  if LastLine=-2 then LastLine:=sts.Count-1;
  for i := StartLine to LastLine do
  begin
    if OutSide(i,sts.Count-1) then break;
    Sts[i] := TrimRight(Sts[i]);
    if length(Sts[i]) > MaxLength then
      MaxLength := length(Sts[i]);
  end;
  Result:=StartDPI;
  if MaxLength=0 then Exit;
  MaxLineCount:=ifthen(Printer.Orientation=poPortrait,100,55);
  Printer.Canvas.Font.Name := FontName;
  Printer.Canvas.Font.Pitch := fpFixed;
  Printer.Canvas.Font.Size := 10;
  Printer.Canvas.Font.PixelsPerInch:=StartDPI;
  DPIc := Printer.Canvas.Font.PixelsPerInch;
  oDPIc := DPIc;
  UpdateFont;
  CharWidth := Printer.Canvas.TextWidth('W');
  PageWidth := Printer.PageWidth;
  PageClientWidth := PageWidth * 9 div 10;
  PageClientHeight := Printer.PageHeight * 9 div 10;
  if PageClientWidth < CharWidth * MaxLength then
  begin
    DPIc := DPIc * (CharWidth * MaxLength) div PageClientWidth;
    oDPIc := DPIc;
    UpdateDPI(DPIc);
  end;
  HighLine := Printer.Canvas.TextHeight('рЁ');
  LinesPerPage := (PageClientHeight div HighLine) +1;
  oLinesPerPage := LinesPerPage;
  LineCount:=LastLine-StartLine+1;
  K := LineCount / LinesPerPage;
  while (K > 1) and (Frac(K) < 0.3) and (LinesPerPage<MaxLineCount) do
  begin
    oDPIc := DPIc;
    oLinesPerPage := LinesPerPage;
    DPIc := DPIc + 10;
    UpdateDPI(DPIc);
    HighLine := Printer.Canvas.TextHeight('рЁ');
    LinesPerPage := PageClientHeight div HighLine;
    K := LineCount / LinesPerPage;
  end;
  if LinesPerPage>MaxLineCount then begin
    DPIc:=oDPIc;
    LinesPerPage:=oLinesPerPage;
//    UpdateDPI(DPIc);
  end;
  result:=DPIc;
end;

procedure PrintToLaser2(Sts:TStrings; Title:string='Без названия'; FontName:string='Courier New');
Var
  IsFirstPage:boolean;
  I: Integer;
  StartLine: Integer;
  StartLine2: Integer;
  IsPrinted: Boolean;
  IsBreakLine: Boolean;
  DPI: Integer;
  LinesPerPage:Integer;
begin
  if sts=nil then Exit;
  if sts.Text='' then Exit;
  for i := Sts.Count - 1 downto 0 do
    if PublStr.Trim(Sts[I]) = '' then
      sts.Delete(I)
    else
      break;
  IsFirstPage:=true;
  StartLine:=0;
  Printer.Title := Title;
  Printer.BeginDoc;
  IsPrinted:=false;
  DPI := Printer.Canvas.Font.PixelsPerInch;
  // Подбор плотности печати
  for I := 0 to sts.Count - 1 do begin
    if (I<=sts.Count-1) and not((sts[i]<>'') and (sts[i][1]=#12)) then Continue;
    DPI:=GetDPI(FontName, sts, LinesPerPage, DPI, StartLine, I-1);
    StartLine:=I+1;
  end;
  DPI:=GetDPI(FontName, sts, LinesPerPage, DPI, StartLine);
  // Печать текста
  StartLine:=0;
  StartLine2:=0;
  for I := 0 to sts.Count - 1 do begin
    IsBreakLine:=(sts[i]<>'') and (sts[i][1]=#12);
    if not IsBreakLine then Continue;
    if IsFirstPage then begin
      Printer.Canvas.Font.PixelsPerInch := DPI;
      UpdateFont;
      IsFirstPage:=false;
    end;
    if I-StartLine>=LinesPerPage then begin
      if IsPrinted then Printer.NewPage;
      IsPrinted:=PrintStringsToLaser(FontName, sts, StartLine, StartLine2-2);
      StartLine:=StartLine2;
    end;
    StartLine2:=I+1
    //if IsPrinted then Printer.NewPage;
  end;
  if StartLine2>StartLine then begin
    if IsPrinted then Printer.NewPage;
    IsPrinted:=PrintStringsToLaser(FontName, sts, StartLine, StartLine2-2);
    StartLine:=StartLine2;
  end;
  if IsPrinted then Printer.NewPage;
  IsFirstPage:=not PrintStringsToLaser(FontName, sts, StartLine);
  if not IsFirstPage then Printer.EndDoc else Printer.Abort;
end;

function Analiz(Text:string;TestLength:Integer):TChprStat;
var
  I:Integer;
  sum,L,n:Integer;
  sm1,sm2,sm3:Integer;
  sm4: Integer;
begin
  sum:=0; sm1:=0; sm2:=0; sm3:=0; sm4:=0;
  n:=0;
  L:=0;
  For I:=1 to Length(Text) do begin
    if I=TestLength*200 then break;
    inc(L);
    if Text[I] in [#$80..#$BF,#$F0..#$FF] then begin
      sum:=sum+ord(Text[I]);
      inc(n);
    end;
    if Text[I]='|' then inc(sm1);
    if Text[I]=';' then inc(sm2);
    if Text[I]=',' then inc(sm3);
    if Text[I]=#9 then inc(sm4);
  end;
  if n>0 then Result.IsOEM:=(sum div n)<212;
  sum:=sm1;
  Result.Delimeter:=';';
  if sm2>sum then sum:=sm2;
  if sm3>sum then begin
    Result.Delimeter:=',';
    sum:=sm3;
  end;
  if sm4>sum then begin
    Result.Delimeter:=#9;
    sum:=sm4;
  end;
  if sum<(L div 100) then Result.Delimeter:=#0;
  Result.IsChpr:=(sm1=sum) and (sm1>Math.Min(Length(Text),TestLength*200) div 150);
end;

function CreateIndexForCSV(CSVFile,IndexFile:string; Col:Integer; CBProc:TIntProc=nil; TimeOut:Integer=100):boolean;
var
  tx:TextFile;
  sts:TStringList;
  sts2:TStringList;
  sepSts:TStringList;
  s:string;
  I:Integer;
  Old: string;
  tm: TDateTime;
  tmOut: TDateTime;
  sz: Integer;
  P: Integer;
begin
  sts:=TStringList.Create;
  sts.Sorted:=true;
  sts.Duplicates:=dupAccept;
  sepSts:=TStringList.Create;
  sepSts.Delimiter:=';';
  sepSts.StrictDelimiter:=false;
  AssignFile(tx,CSVFile);
  Reset(tx);
  sz:=Windows.GetFileSize(TTextRec(tx).handle,nil);
  I:=0;
  tm:=Now;
  tmOut:=TimeOut*OneMillisecond;
  While not eof(tx) do begin
    Readln(tx,s);
    sepSts.DelimitedText:=s;
    if sepSts.Count<=Col then s:='' else s:=AnsiUpperCase(sepSts[Col]);
    s:=format('%s``%d',[s,I]);
    sts.Add(s);
    inc(I);
    if not Assigned(CBProc) then Continue;
    if Now-tm<tmOut then Continue;
    P:=FileSeek(TTextRec(tx).handle,0,1);
    //if not Assigned(CBProc) then
    CBProc(P,sz);
    tm:=Now;
  end;
  CloseFile(tx);
  sts.SaveToFile(IndexFile);
  sts2:=TStringList.Create;
  Old:='``';
  for I:=0 to sts.Count-1 do begin
    s:=sts[i];
    s:=Copy(s,1,pos('``',s)-1);
    if Old=s then Continue;
    sts2.Add(s+'``'+IntToStr(I));
    Old:=S;
  end;
  sts2.SaveToFile(IndexFile+'!');
  sts2.Free;
  sepSts.Free;
  sts.Free;
  Result:=true;
end;

function CreateIndexForCSV(CSVFile,IndexFile:string; Cols:ai; CBProc:TIntProc=nil; TimeOut:Integer=100):boolean;
var
  tx:TextFile;
  sts:TStringList;
  sts2:TStringList;
  sepSts:TStringList;
  s:string;
  I, J:Integer;
  Old: string;
  sz: Cardinal;
  tm: Extended;
  tmOut: Extended;
  P: Integer;
begin
  if High(Cols)=0 then begin
    SetLength(Cols,1);
    Cols[0]:=0;
  end;
  sts:=TStringList.Create;
  sts.Sorted:=true;
  sts.Duplicates:=dupAccept;
  sepSts:=TStringList.Create;
  sepSts.Delimiter:=';';
  sepSts.StrictDelimiter:=false;
  AssignFile(tx,CSVFile);
  Reset(tx);
  sz:=Windows.GetFileSize(TTextRec(tx).handle,nil);
  I:=0;
  tm:=Now;
  tmOut:=TimeOut*OneMillisecond;
  While not eof(tx) do begin
    Readln(tx,s);
    sepSts.DelimitedText:=AnsiUpperCase(s);
    s:='';
    for J := 0 to High(Cols) do begin
      if sepSts.Count>Cols[j] then
        if j=0
        then s:=sepSts[Cols[j]]
        else s:=s+';'+sepSts[Cols[j]];
    end;
    s:=format('%s``%d',[s,I]);
    sts.Add(s);
    inc(I);
    if not Assigned(CBProc) then Continue;
    if Now-tm<tmOut then Continue;
    P:=FileSeek(TTextRec(tx).handle,0,1);
    if not Assigned(CBProc) then CBProc(P,sz);
    tm:=Now;
  end;
  CloseFile(tx);
  sts.SaveToFile(IndexFile);

  sts2:=TStringList.Create;
  Old:='``';
  for I:=0 to sts.Count-1 do begin
    s:=sts[i];
    s:=Copy(s,1,pos('``',s)-1);
    if Old=s then Continue;
    sts2.Add(s+'``'+IntToStr(I));
    Old:=S;
  end;
  sts2.SaveToFile(IndexFile+'!');
  sts2.Free;
  sepSts.Free;
  sts.Free;
  Result:=true;
end;

function CreateIndexForTxt(TxtFile,IndexFile:string; CBProcInt:TIntProc=nil; TimeOut:Integer=100):boolean;
var
  I:Integer;
  fs: TFileStream;
  ch:char;
  tf:file of TBinInd;
  BinInd:TBinInd;
  flag: boolean;
  tm, tmOut: Extended;
begin
  AssignFile(tf,IndexFile);
  Rewrite(tf);
  fs:=TFileStream.Create(TxtFile,fmOpenRead);
  BinInd.Position:=0;
  flag:=false;
  tm:=Now;
  tmOut:=TimeOut*OneMillisecond;
  for I := 0 to fs.Size - 1 do begin
    fs.Read(ch,1);
    if ch=#10 then begin
      flag:=true;
      BinInd.Length:=I-BinInd.Position-1;
      Continue;
    end;
    if ch=#13 then Continue;
    if not flag then Continue;
    Write(tf,BinInd);
    BinInd.Position:=I;
    flag:=false;
    if not Assigned(CBProcInt) then Continue;
    if Now-tm<tmOut then Continue;
    //if not Assigned(CBProcInt) then
    CBProcInt(fs.Position,fs.Size);
    tm:=Now;
  end;
  Write(tf,BinInd);
  CloseFile(tf);
  fs.Free;
  Result:=true;
end;

{ FastFileStrList }

procedure TFastFileStrList.SetBaseIndexFile(const Value: string);
begin
  FBaseIndexFile := Value;
end;

procedure TFastFileStrList.SetBaseName(const Value: string);
begin
  FBaseName := Value;
end;

procedure TFastFileStrList.SetFilter(const Value: string);
begin
  FFilter := AnsiUpperCase(PublStr.Trim(Value));
  Update;
end;

procedure TFastFileStrList.SetShowFields(const Value: TStrings);
begin
  FShowFields := Value;
end;

procedure TFastFileStrList.Update;
begin
  DoFiltering;
end;

constructor TFastFileStrList.Create;
begin
  FShowFields:=TStringList.Create;
  Chpr:=TChprList.Create;
end;

destructor TFastFileStrList.Destroy;
begin
  FShowFields.Free;
  Chpr.Free;
  inherited;
end;

procedure TFastFileStrList.DoFiltering;
var
  tf: file of TBinInd;
  BinInd: TBinInd;
  fs: TFileStream;
  sts:TStringList;
  sts2:TStringList;
  I, L, II: Integer;
  tx:TextFile;
  st:string;
  FieldsNum: array of Integer;
  J: Integer;
  ShwFldCnt: Integer;
begin
  if length(FFilter)<2 then Exit;
  sts:=TStringList.Create;
  sts.LoadFromFile(BaseIndexFile+'!');
  L:=Length(FFilter);
  II:=-1;
  for I := 0 to sts.Count - 1 do begin
    if LeftStr(sts[I],L)<>FFilter then Continue;
    II:=StrToInt(copy(Sts[I],pos('``',Sts[I])+2,MaxInt));
    break;
  end;
  AssignFile(tx,BaseIndexFile);
  Reset(tx);
  sts2:=TStringList.Create;
  for I:=1 to II do Readln(tx);
  Readln(tx,st);
  While LeftStr(st,L)=FFilter do begin
    sts2.add(st);
    Readln(tx,st);
  end;
  CloseFile(tx);
  AssignFile(tf,ChangeFileExt(BaseName,'.BIndex'));
  Reset(tf);
  fs:=TFileStream.Create(BaseName,fmOpenRead);
  for I:=0 to sts2.Count-1 do begin
    II:=StrToInt(copy(Sts2[I],pos('``',Sts2[I])+2,MaxInt));
    Seek(tf,II);
    Read(tf,BinInd);
    fs.Position:=BinInd.Position;
    SetLength(st,BinInd.Length);
    fs.Read(st[1],BinInd.Length);
    sts2[I]:=st;
  end;
  Seek(tf,0);
  Read(tf,BinInd);
  fs.Position:=BinInd.Position;
  SetLength(st,BinInd.Length);
  fs.Read(st[1],BinInd.Length);
  sts2.Insert(0,st);
  Chpr.Mode:=mdCsv;
  Chpr.Text:=sts2.Text;
  ShwFldCnt:=ShowFields.Count;
  if ShwFldCnt>0 then begin
    SetLength(FieldsNum,ShwFldCnt);
    for I:=0 to ShwFldCnt-1 do
      FieldsNum[i]:=chpr.FieldNames.IndexOf(ShowFields.Names[I]);
  end;
  sts2.Clear;
  for I:=0 to chpr.Count-2 do begin
    if ShwFldCnt>0 then begin
      st:='';
      for J:=0 to High(FieldsNum) do
        if chpr.Values[I][FieldsNum[J]]=''
        then st:=st+';'
        else st:=ContStr(st,';',chpr.Values[I][FieldsNum[J]]);
    end else st:=chpr.Values[I].DelimitedText;
    sts2.Add(st);
  end;
  if ShwFldCnt>0 then begin
    st:='';
    SetLength(FieldsNum,ShwFldCnt);
    for I:=0 to ShwFldCnt-1 do
      st:=ContStr(st,';',ShowFields.ValueFromIndex[I]);
  end else st:=Chpr.FieldNames.DelimitedText;
  sts2.Insert(0,st);
  Assign(sts2);
  // Финал
  fs.Free;
  sts2.Free;
  sts.Free;
  CloseFile(tf);
end;

{ TGlueCSV }
procedure FillFieldNums(sts:TStrings;Fields:TStrings;var Arr:ai);
var
  I: Integer;
  n: Integer;
  v: Integer;
begin
  SetLength(Arr,Fields.Count);
  n:=0;
  for I := 0 to sts.Count - 1 do begin
    v:=Fields.IndexOf(sts[i]);
    if v=-1 then Continue;
    Arr[n]:=v;
    inc(n);
  end;
  SetLength(Arr,n);
end;

procedure FillFieldNums2(sts1, sts2:TStrings;Fields:TStrings;var Arr1,Arr2:ai);
var
  I: Integer;
  n: Integer;
  v1, v2: Integer;
begin
  SetLength(Arr1,Fields.Count);
  SetLength(Arr2,Fields.Count);
  n:=0;
  for I := 0 to Math.Min(sts1.Count,sts2.Count) - 1 do begin
    v1:=Fields.IndexOf(sts1[i]);
    v2:=Fields.IndexOf(sts2[i]);
    if v1=-1 then Continue;
    if v2=-1 then Continue;
    Arr1[n]:=v1;
    Arr2[n]:=v2;
    inc(n);
  end;
  SetLength(Arr1,n);
  SetLength(Arr2,n);
end;

procedure TGlueCSV.Execute;
var
  Csv1,Csv2:TChprList;
  Arr1,Arr2:ai;
  ArrLeft,ArrRight:ai;
  Tmp1,Tmp2:TStringList;
  I,J: Integer;
  OutList:TStringList;
begin
  OpenCSV(Input1, Csv1);
  OpenCSV(Input2, Csv2);
  Tmp1:=TStringList.Create;
  Tmp2:=TStringList.Create;
  FillFieldNums(FirstFields,Csv1.FieldNames,Arr1);
  FillFieldNums(SecondFields,Csv2.FieldNames,Arr2);
  for I := 0 to CommonFields.Count - 1 do begin
    Tmp1.Add(CommonFields.Names[I]);
    Tmp2.Add(CommonFields.ValueFromIndex[I]);
  end;
  FillFieldNums2(Tmp1,Tmp2,Csv1.FieldNames,ArrLeft,ArrRight);
  OutList:=TChprList.Create;
  for I := 0 to Csv1.Count - 1 do begin
    for J := 0 to Csv2.Count - 1 do begin
      //todo: объединение данных и запись в OutList
    end;
  end;
  OutList.Free;
  Csv1.Free;
  Csv2.Free;
  Tmp1.Free;
  Tmp2.Free;
end;

procedure TGlueCSV.OpenCSV(Input: string; var CSV: TChprList);
begin
  CSV := TChprList.Create;
  CSV.LoadFromFile(Input);
end;

procedure TGlueCSV.SetCommonFields(const Value: TStrings);
begin
  FCommonFields := Value;
end;

procedure TGlueCSV.SetFirstFields(const Value: TStrings);
begin
  FFirstFields := Value;
end;

procedure TGlueCSV.SetInput1(const Value: string);
begin
  FInput1 := Value;
end;

procedure TGlueCSV.SetInput2(const Value: string);
begin
  FInput2 := Value;
end;

procedure TGlueCSV.SetOutput(const Value: string);
begin
  FOutput := Value;
end;

procedure TGlueCSV.SetSecondFields(const Value: TStrings);
begin
  FSecondFields := Value;
end;

{ TBitsExt }

destructor TBitsExt.Destroy;
begin
  SetSize(0);
  inherited Destroy;
end;

procedure TBitsExt.Error;
begin
  raise EBitsError.CreateRes(@SBitsIndexError);
end;

function TBitsExt.GetBit(Index: Integer): Boolean;
asm
        CMP     Index,[EAX].FSize
        JAE     TBits.Error
        MOV     EAX,[EAX].FBits
        BT      [EAX],Index
        SBB     EAX,EAX
        AND     EAX,1
end;

procedure TBitsExt.LoadFromStream(Stream: TStream);
var
  cnt:Integer;
  Sz: byte;
begin
  Size:=0;
  Stream.Read(Sz,1);
  Size:=Sz;
  Stream.Read(cnt,4);
  Stream.Read(FBits^,cnt);
end;

function TBitsExt.OpenBit: Integer;
var
  I: Integer;
  B: TBitSet;
  J: TBitEnum;
  E: Integer;
begin
  E := (Size + BitsPerInt - 1) div BitsPerInt - 1;
  for I := 0 to E do
    if PBitArray(FBits)^[I] <> [0..BitsPerInt - 1] then
    begin
      B := PBitArray(FBits)^[I];
      for J := Low(J) to High(J) do
      begin
        if not (J in B) then
        begin
          Result := I * BitsPerInt + J;
          if Result >= Size then Result := Size;
          Exit;
        end;
      end;
    end;
  Result := Size;
end;

procedure TBitsExt.SaveToStream(Stream: TStream);
var
  cnt:Integer;
  Sz: byte;
begin
  Sz:=Size;
  Stream.Write(Sz,1);
  cnt:=(Size+7) div 8;
  Stream.Write(cnt,4);
  Stream.Write(FBits^,cnt);
end;

procedure TBitsExt.SetBit(Index: Integer; Value: Boolean);
asm
        CMP     Index,[EAX].FSize
        JAE     @@Size

@@1:    MOV     EAX,[EAX].FBits
        OR      Value,Value
        JZ      @@2
        BTS     [EAX],Index
        RET

@@2:    BTR     [EAX],Index
        RET

@@Size: CMP     Index,0
        JL      TBits.Error
        PUSH    Self
        PUSH    Index
        PUSH    ECX {Value}
        INC     Index
        CALL    TBits.SetSize
        POP     ECX {Value}
        POP     Index
        POP     Self
        JMP     @@1
end;

procedure TBitsExt.SetSize(Value: Integer);
var
  NewMem: Pointer;
  NewMemSize: Integer;
  OldMemSize: Integer;

  function Min(X, Y: Integer): Integer;
  begin
    Result := X;
    if X > Y then Result := Y;
  end;

begin
  if Value <> Size then
  begin
    if Value < 0 then Error;
    NewMemSize := ((Value + BitsPerInt - 1) div BitsPerInt) * SizeOf(Integer);
    OldMemSize := ((Size + BitsPerInt - 1) div BitsPerInt) * SizeOf(Integer);
    if NewMemSize <> OldMemSize then
    begin
      NewMem := nil;
      if NewMemSize <> 0 then
      begin
        GetMem(NewMem, NewMemSize);
        FillChar(NewMem^, NewMemSize, 0);
      end;
      if OldMemSize <> 0 then
      begin
        if NewMem <> nil then
          Move(FBits^, NewMem^, Min(OldMemSize, NewMemSize));
        FreeMem(FBits, OldMemSize);
      end;
      FBits := NewMem;
    end;
    FSize := Value;
  end;
end;

initialization
  FieldStrings:=TStringList.Create;
  ValueStrings:=TStringList.Create;
  FieldStrings.StrictDelimiter:=true;
  ValueStrings.StrictDelimiter:=true;
finalization
  FieldStrings.Free;
  ValueStrings.Free;
end.

