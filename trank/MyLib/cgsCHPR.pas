unit cgsCHPR;

interface
uses Windows, Classes, publ,
//, ViewLog,
Dialogs;

const
  mdChpr=0;
  mdCsv=1;
  mdText=2;
type
  TSetOfByte=set of byte;
  TOnCustomFilter = procedure (Sender:TObject; Index:Integer; S:string; var Show:boolean) of object;
  TOnEnum = procedure (Sender:TObject; Index:Integer; S:string) of object;

  TChprList= class(TStringList)
  private
    FFields:TStringList;
    FValues:TStringList;
    FFilling: Boolean;
    FIsTransformed: Boolean;
    FTmpSts:TStringList;
    S: string;
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
    IsSettingText: Boolean;
    FMode: Integer;
    FHead: string;
    isst: Boolean;
    IsAbsIndFilter: Boolean;
    function GetAsTable: TStrings;
    function GetFieldNames: TStrings;
    function GetInnerDelimeter: Char;
    function GetOrder(Index: Integer): Integer;
    function GetValueByName(Index: Integer; FieldName: string): string;
    function GetValues(Index: Integer): TStrings;
    function GetValuesWithNames(Index: Integer): TStrings;
    function GetXValues(Row, Col: Integer): string;
    procedure ColumnSort;
    procedure ExchangeOrder(Index1, Index2: Integer);
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
    procedure SimpleSort;
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
  protected
    function  Compare(Index1, Index2: Integer): Integer;
    function Get(Index: Integer): string; override;
    procedure DoCustomFiltring;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetTextStr(const Value: string); override;
    property XValues[Row,Col:Integer]:string read GetXValues write SetXValues;
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
    procedure Podstava(ChprList:TChprList; x,y,z:Integer);
    procedure ShowAll;
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

function Transform(Strings:TStrings; Delimeter: string=';'; Filling:boolean=false): string;
function GetFieldNames(Strings:TStrings; Delimeter:string=';'):TStrings;
function GetValueByName(Strings: TStrings; RowNum: Integer; FieldName:string; Delimeter: string = ';'):string;
function GetValueByColumn(Strings: TStrings; Row, Col: Integer; Delimeter: string = ';'):string;
function CheckBankNum(st:string):boolean;
procedure PrintToEpson(S:string);
procedure PrintToLaser(S:string);
function Analiz(Text:string;TestLength:Integer):TChprStat;
function CreateIndexForCSV(CSVFile,IndexFile:string; Col:Integer; CBProc:TIntProc=nil; TimeOut:integer=100):boolean; overload;
function CreateIndexForCSV(CSVFile,IndexFile:string; Cols:ai; CBProc:TIntProc=nil; TimeOut:integer=100):boolean; overload;
function CreateIndexForTxt(TxtFile,IndexFile:string; CBProcInt:TIntProc=nil; TimeOut:Integer=100):boolean;

implementation
Uses PublStr, StrUtils, Printers, Graphics, SysUtils, DateUtils, PublFile;
Var
  FieldStrings:TStringList;
  ValueStrings:TStringList;
const
  DebugMode=true;
  
function Transform(Strings:TStrings; Delimeter: string; Filling:boolean): string;
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
begin
  Result:='';
  sts:=TStringList.Create;
  sts.Duplicates:=dupError;
  sts.Sorted:=true;
  sep1:=TStringList.Create;
  sep2:=TStringList.Create;
  if Delimeter='' then sep:=';' else sep:=Delimeter[1];
  sep1.Delimiter:=Sep;
  sep2.Delimiter:=Sep;
  sep1.StrictDelimiter:=true;
  sep2.StrictDelimiter:=true;
  For i:=0 to Strings.Count-1 do begin
    s:=PublStr.Trim(Strings[i]);
    L:=length(s);
    if L<3 then Continue;
    if not (((s[1]='|') and (s[L]='|')) or ((s[1]='!') and (s[L]='!'))) then Continue;
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
    s:=AnsiReplaceStr(S,ch,Delimeter);
    Repeat
     l:=length(s);
     s:=AnsiReplaceStr(s,' '+Delimeter,Delimeter);
     s:=AnsiReplaceStr(s,Delimeter+' ',Delimeter);
    Until l=length(s);

    if Filling then begin
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
      sts.Add(s);
      Result:=ContStr(Result,#13#10,s);
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

procedure TChprList.Podstava(ChprList: TChprList; x, y, z: Integer);
var
  I: Integer;
  s:string;
  J: Integer;
  us: Boolean;
begin
  FFields[x]:=ChprList.FieldNames[z];
  NeedTmpSts;
  FTmpSts.Clear;
  for I := 0 to ChprList.Count - 2 do FTmpSts.Add(ChprList.Values[i][y]);
  for I := 0 to Count - 1 do begin
    s:=XValues[I,x];
    us:=false;
    for J := 0 to FTmpSts.Count - 1 do begin
      us:=SameText(s,FTmpSts[J]);
      if not us then Continue;
      XValues[I,X]:=ChprList.Values[J][Z];
      break;
    end;
    if us then Continue;
    XValues[I,X]:='-*-*-*-';
  end;
end;

procedure TChprList.InitFilterCount;
begin
  FFilterCount := Count - 1;
  if FFilterCount = -1 then
    FFilterCount := 0;
end;

procedure TChprList.Put(Index: Integer; const S: string);
var
  Ind: Integer;
begin
  if IsSettingText
  then Ind:=Index
  else Ind:=Order[Index];
  if Ind=MaxInt then Exit;
  inherited Put(Ind,S);
end;

procedure TChprList.Clear;
begin
  inherited;
  Filter:='';
end;

procedure TChprList.ColumnSort;
begin
  if SortedField=-1 then Exit;
    //publ.QuickSort(0,Count-2,Compare,ExchangeOrder);
  FineSort;
  Test;
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
  IsSettingText:=false;
  inherited;
  FFields:=TStringList.Create;
  FValues:=TStringList.Create;
  FFields.OnChange:=FieldsChange;
  FFields.StrictDelimiter:=true;
  FValues.StrictDelimiter:=true;
  FVisible:=TBits.Create;
  FTableLength := 100;
  FSortedField:=-1;
  FDescending:=false;
end;

procedure TChprList.DebugOut(fn: string);
var
  i:integer;
  sts: TStringList;
//  s:string;
  isst:Boolean;
begin
  if not DebugMode then Exit;
  sts := TStringList.Create;
  sts.Add('���������');
  sts.Add('������: '+FFilter);
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* ������� �� ��������� *');
  isst:=IsSettingText;
  IsSettingText:=true;
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': '+Strings[I]);
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* ������ Visible *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+'['+StrUtils.IfThen(FVisible[i],'+','-')+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* ������ FilterArray *');
  for I := 0 to High(FilterArray) do begin
    if I>=FilterCount then break;
    sts.Add(ToZeroStr(I,3)+': ['+ToZeroStr(FilterArray[I],3)+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* ������ Order *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': ['+ToZeroStr(Order[I],3)+']');
  end;
  ////////////////////////////////////////////
  sts.Add('');
  sts.Add('* ������ AntiOrder *');
  for I := 0 to Count - 1 do begin
    sts.Add(ToZeroStr(I,3)+': ['+ToZeroStr(FAntiOrder[I],3)+']');
  end;
  if fn='' then fn:=ProgramPath+'DebugOut.txt';
  sts.SaveToFile(fn);
  sts.Free;
  IsSettingText:=isst;
end;

destructor TChprList.Destroy;
begin
  FFields.Free;
  FValues.Free;
  FVisible.Free;
  inherited;
end;

function TChprList.Get(Index: Integer): string;
var
  Ind: Integer;
begin
  if IsSettingText
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
begin
  DebugOut('do.txt');
  NeedTmpSts;
  LW:=FieldNames.Count;
  SetLength(W,LW);
  for I := 0 to High(W) do W[i]:=Length(FFields[I]);
  TL:=TableLength;
  if TL=0 then TL:=Count;
  if Filter='' then begin
    for I := 1 to Count-1 do begin
      if Assigned(FOnCustomFilter) and not VisibleItems[I] then Continue;
      GetValues(I-1);
      if FValues.Count>LW then begin
        LW:=FValues.Count;
        SetLength(W,LW);
      end;
      for J := 0 to FValues.Count-1 do begin
        L:=Length(FValues[J]);
        if L>W[J] then W[J]:=L;
      end;
    end;
    FTmpSts.Clear;
    S:='';
    for J := 0 to LW - 1 do begin
      if J<FieldNames.Count
      then S:=ContStr(S,'|',format('%-*s',[W[J],FieldNames[j]]))
      else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-1));
    S:='';
    for J := 0 to LW - 1 do begin
      S:=ContStr(S,'|',StringOfChar('-',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    for I := 1 to Count-1 do begin
      if FTmpSts.Count>TL then begin
        S:=format('�������� ������ %d �������',[TL]);
        FTmpSts.AddObject(S,pointer(-2));
        break;
      end;
      if Assigned(FOnCustomFilter) and not VisibleItems[I] then Continue;
      GetValues(I-1);
      S:='';
      for J := 0 to LW - 1 do begin
        if J<FValues.Count
        then S:=ContStr(S,'|',format('%-*s',[W[J],FValues[j]]))
        else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
      end;
      FTmpSts.AddObject(S,pointer(I-1));
    end;
  end else begin
    // ������� ������ ��������
    for I := 0 to FilterCount-1 do begin
      if FTmpSts.Count>TL then break;
      Ind:=FilterArray[I];
      {!}
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind-1);
      if FValues.Count>LW then begin
        LW:=FValues.Count;
        SetLength(W,LW);
      end;
      for J := 0 to FValues.Count-1 do begin
        L:=Length(FValues[J]);
        if L>W[J] then W[J]:=L;
      end;
    end;

    FTmpSts.Clear;
    // ����� ����������
    // * ���������
    S:='';
    for J := 0 to LW - 1 do begin
      if J<FieldNames.Count
      then S:=ContStr(S,'|',format('%-*s',[W[J],FieldNames[j]]))
      else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    // * ����� ��� ����������
    S:='';
    for J := 0 to LW - 1 do begin
      S:=ContStr(S,'|',StringOfChar('-',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    // * �������
    for I := 0 to FilterCount-1 do begin
      if FTmpSts.Count>TL then begin
        S:=format('�������� ������ %d �������',[TL]);
        FTmpSts.AddObject(S,pointer(-2));
        break;
      end;
      {!}
      Ind:=FilterArray[I];
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind-1);
      S:='';
      for J := 0 to LW - 1 do begin
        if J<FValues.Count
        then S:=ContStr(S,'|',format('%-*s',[W[J],FValues[j]]))
        else S:=ContStr(S,'|',StringOfChar(' ',W[J]));
      end;
      FTmpSts.AddObject(S,pointer(Ind));
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
    if (s<>'') and (s[1] in ['|','!']) and (s[length(s)] in ['|','!']) then break;
    FHead:=ContStr(FHead,#13#10,s);
  end;
end;

function TChprList.GetInnerDelimeter: Char;
begin
  Result := FFields.Delimiter;
end;

function TChprList.GetOrder(Index: Integer): Integer;
begin
  Result:=MaxInt;
  if OutSide(Index,high(FOrder)) then Exit;
  Result:=FOrder[Index];
end;

function TChprList.GetValueByName(Index: Integer; FieldName: string): string;
begin
  Result:=cgsCHPR.GetValueByName(self,Index-1,FieldName,InnerDelimeter);
end;

function TChprList.GetValues(Index: Integer): TStrings;
begin
  FValues.OnChange:=nil;
  ValueIndex:=Index+1;
  FValues.DelimitedText:=Strings[ValueIndex];
  FValues.OnChange:=ValueChange;
  Result:=FValues;
end;

function TChprList.GetValuesWithNames(Index: Integer): TStrings;
var
  I: Integer;
  s1, s2:string;
begin
  for I := 0 to max(FieldNames.Count,Values[Index].Count) - 1 do begin
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
  if IsSettingText
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
  isst:=IsSettingText;
  IsSettingText:=true;
  for I := 0 to Count - 1 do begin
    Visible:=VisibleItems[I];
    FOnCustomFilter(self,I,Strings[I],Visible);
    VisibleItems[I]:=Visible;
  end;
  IsSettingText:=isst;
end;

procedure TChprList.DoEnum;
var
  I:integer;
begin
  if not Assigned(FOnEnum) then Exit;
  for I := 0 to Count - 1 do
    FOnEnum(self,I,Strings[I]);
end;

procedure TChprList.ExchangeOrder(Index1, Index2: Integer);
var
  o1,o2:Integer;
begin
  Index1:=Index1+1;
  Index2:=Index2+1;
  o1:=FOrder[Index1];
  o2:=FOrder[Index2];
  FOrder[Index1]:=o2;
  FOrder[Index2]:=o1;
  FAntiOrder[o2]:=Index1;
  FAntiOrder[o1]:=Index2;
end;

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
begin
  AbsIndFilter;
  ist:=IsSettingText;
  IsSettingText:=true;
  sts := TNumStrList.Create;
  sts.CaseSensitive:=false;
  sts.Duplicates:=dupAccept;
  sts.Sorted:=true;
  for I := 0 to Count - 2 do begin
    sts.AddObject(XValues[I,SortedField],pointer(I+1));
  end;
  FOrder[0]:=0;
  FAntiOrder[0]:=0;
  for I := 0 to sts.Count - 1 do begin
    FOrder[I+1]:=Integer(sts.Objects[i]);
    FAntiOrder[FOrder[I+1]]:=I+1;
  end;
  sts.Free;
  IsSettingText:=ist;
  RelIndFilter;
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
  if TmpSts.Count>1 then TmpSts.Delete(0);
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
    for J:=FilterCount-1 downto 0 do begin
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
  for I := 0 to FilterCount-2 do begin
    for J := I+1 to FilterCount-1 do begin
      if FilterArray[I]>FilterArray[J] then begin
        p:=FilterArray[I];
        FilterArray[I]:=FilterArray[J];
        FilterArray[J]:=p;
      end;
    end;
  end;
  HideAll;
  isst:=IsSettingText;
  IsSettingText:=true;
  for I:=0 to FilterCount-1 do VisibleItems[FilterArray[I]]:=true;
  IsSettingText:=isst;
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
begin
  S:='';
  for I:=1 to Length(Value) do
    if Value[I]<>#0 then S:=S+Value[I];
  FOriginalText:=S;
  if IsOEMSource then S:=AsAnsi(S);
  IsSettingText:=true;
  inherited SetTextStr(S);
  SetLength(FOrder,Count);
  for I:=0 to Count-1 do FOrder[I]:=I;
  SetLength(FAntiOrder,Count);
  for I:=0 to Count-1 do FAntiOrder[I]:=I;
  IsSettingText:=false;
  if IsTransformed then begin
    GetHead;
    inherited SetTextStr(Transform(self,InnerDelimeter,FFilling));
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
  if IsSettingText
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

procedure TChprList.AbsIndFilter;
var
  I: Integer;
begin
  if IsAbsIndFilter then Exit;
  IsAbsIndFilter:=True;
  for I := 0 to High(FilterArray) do begin
    FilterArray[I]:=Order[FilterArray[I]];
  end;
end;

procedure TChprList.RelIndFilter;
var
  I: Integer;
  J: Integer;
begin
  if not IsAbsIndFilter then Exit;
  IsAbsIndFilter:=False;
  for I := 0 to High(FilterArray) do begin
    FilterArray[I]:=FAntiOrder[FilterArray[I]];
  end;
  if High(FilterArray)=-1 then Exit;
  for I := 0 to FilterCount-2 do begin
    for J := I+1 to FilterCount - 1 do
      if FilterArray[I]>FilterArray[J] then
        publ.Exchange(FilterArray[I],FilterArray[J]);
  end;
end;

procedure TChprList.SimpleSort;
var
  I: Integer;
  J: Integer;
  s1: string;
  s2: string;
begin
  for I := 0 to Count - 3 do begin
    s1:=XValues[I,FSortedField];
    for J := I+1 to Count - 2 do begin
      s2:=XValues[J,FSortedField];
      if CompNumText(s1,s2)>0 then begin
        ExchangeOrder(I,J);
        s1:=XValues[I,FSortedField];
      end;
    end;
//    if I=100 then break;
  end;

end;

procedure TChprList.Test;
var
  I: Integer;
//  tx:TextFile;
begin
  for I := 0 to High(FOrder) do begin
    if not I=FAntiOrder[FOrder[I]] then begin
      MessageBox('','���� #1 �� �������'#13#10
      +format('I=%d, Order[I]=%d, AntiOrder[%d]=%d',[I,FOrder[I],FOrder[I],FAntiOrder[FOrder[I]]]));
      break;
    end;
  end;

  for I := 0 to Count - 3 do
    if CompNumText(XValues[I,FSortedField],XValues[I+1,FSortedField])>0
      then begin
        MessageBox('','���� #2 �� �������'#13#10
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
  Strings[ValueIndex]:=FValues.DelimitedText;
end;

procedure TChprList.SetIsOEMSource(const Value: Boolean);
begin
  FIsOEMSource := Value;
  SetTextStr(FOriginalText);
end;

procedure TChprList.SetIsTransformed(const Value: Boolean);
begin
  FIsTransformed := Value;
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
begin
  Result:=false;
  if copy(st,6,3)<>'810' then Exit;
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

procedure PrintToEpson(S:string);
var
  I: Integer;
  prn: TextFile;
  sts:TStrings;
begin
  sts:=TStringList.Create;
  sts.Text:=S;
  AssignFile(Prn, 'LPT1');
  Rewrite(Prn);
  Writeln(Prn,#27'@'#27'0'#27'M'#27'x0'#$12);
  for I := 0 to sts.Count - 1 do
    Writeln(Prn, AsOEM(sts[i]));
  CloseFile(Prn);
  sts.Free;
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
 Printer.Title:='������ ��������';
 Printer.BeginDoc;
 DPIc:=Printer.Canvas.Font.PixelsPerInch;
 if PageClientWidth<CharWidth*MaxLength then begin
   DPIc:=DPIc*(CharWidth*MaxLength) div PageClientWidth;
   Printer.Canvas.Font.PixelsPerInch:=DPIc;
   UpdateFont;
 end;
 HighLine:=Printer.Canvas.TextHeight('�');
 LinesPerPage:=PageClientHeight div HighLine;
 K:=Sts.Count/LinesPerPage;
 while (K>1) and (Frac(K)<0.3) do begin
   DPIc:=DPIc+10;
   Printer.Canvas.Font.PixelsPerInch:=DPIc;
   UpdateFont;
   HighLine:=Printer.Canvas.TextHeight('�');
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
  Result.IsChpr:=(sm1=sum) and (sm1>min(Length(Text),TestLength*200) div 150);
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
  DoFiltering;
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
  sts2.Sort;
  if ShwFldCnt>0 then begin
    st:='';
    SetLength(FieldsNum,ShwFldCnt);
    for I:=0 to ShwFldCnt-1 do
      st:=ContStr(st,';',ShowFields.ValueFromIndex[I]);
  end else st:=Chpr.FieldNames.DelimitedText;
//  st:='';
//  for I:=0 to ShowFields.Count-1 do
//    st:=ContStr(st,';',ShowFields.ValueFromIndex[I]);
  sts2.Insert(0,st);
  Assign(sts2);
  // �����
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
  for I := 0 to min(sts1.Count,sts2.Count) - 1 do begin
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
      //todo: ����������� ������ � ������ � OutList
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

initialization
  FieldStrings:=TStringList.Create;
  ValueStrings:=TStringList.Create;
  FieldStrings.StrictDelimiter:=true;
  ValueStrings.StrictDelimiter:=true;
finalization
  FieldStrings.Free;
  ValueStrings.Free;
end.
