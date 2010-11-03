unit cgsCHPR2;

interface
Uses Windows, Classes, publ, Dialogs, ZLib;
type
  TOnCustomFilter = procedure (Sender:TObject; Index:Integer; S:string; var Show:boolean) of object;
  TOnEnum = procedure (Sender:TObject; Index:Integer; S:string) of object;

  TCell = record
    Index:Integer;
    ID:Integer;
  end;

  TChprList= class;

  TSortList = class (TStringList)
  private
    FParent:TChprList;
  public
    constructor Create(AParent:TChprList);
    procedure Sort; override;
    procedure ExChangeRef(Ind1,Ind2:Integer);
  end;

  TChprList= class(TStrings)
  private
    FFields:TStringList;
    FValues:TStringList;
    FFilling: Boolean;
    FIsTransformed: Boolean;
    FTmpSts:TStringList;
    S: string;
    FIsOEMSource: Boolean;
    //FOriginalText: string;
    //FOriginalStream:TCompressionStream;
    FTableLength: Integer;
    FFilter: string;
    FSortedField: Integer;
    FOrder:array of Integer;
    FAntiOrder:array of Integer;
    FilterArray:array of Integer;
    FilterCount: Integer;
    FVisible:TBits;
    FOnCustomFilter: TOnCustomFilter;
    FOnEnum: TOnEnum;
    ValueIndex: Integer;
    FDescending: Boolean;
    IsSettingText: Boolean;
    TmpFile: string;
    Cells:array of array of Integer;
    //AntiCells:array of array of Integer;
    Texts:TSortList;
    FIsShuffle: boolean;
    Refs:array of Integer;
    function GetValueByName(Index: Integer; FieldName: string): string; {+}
    function GetValues(Index: Integer): TStrings; {-}
    function GetFieldNames: TStrings;
    procedure SetInnerDelimeter(const Value: Char); {+}
    function GetInnerDelimeter: Char; {+}
    function GetAsTable: TStrings; {+}
    procedure SetIsTransformed(const Value: Boolean); {+}
    procedure SetIsOEMSource(const Value: Boolean); {+}
    procedure SetFilling(const Value: Boolean); {+}
    procedure SetTableLength(const Value: Integer); {+}
    procedure SetFilter(const Value: string); {+}
    function GetOrder(Index: Integer): Integer; {+}
    procedure SetOrder(Index: Integer; const Value: Integer);{+}
    procedure SetSortedField(const Value: Integer); {+}
    function GetVisible(Index: Integer): Boolean; {+}
    procedure SetVisible(Index: Integer; const Value: Boolean); {+}
    procedure SetOnCustomFilter(const Value: TOnCustomFilter); {+}
    procedure NeedTmpSts; {+}
    procedure SetOnEnum(const Value: TOnEnum); {+}
//    procedure ValueChange(Sender: TObject); {+}
//    procedure FieldsChange(Sender: TObject); {!}
    procedure ColumnSort;{+}
    //procedure SimpleSort;{-}
    procedure SetDescending(const Value: Boolean); {+}
    //procedure ExchangeOrder(Index1, Index2: Integer); {+}
    //function  Compare(Index1, Index2: Integer): Integer; {-}
    procedure Test;
    function GetXValues(Col, Row: Integer): string;
    procedure SetXValues(Col, Row: Integer; const Value: string);
    procedure InitCols(Col: Integer);
    procedure InitRow(Row: Integer);
    function GetOriginalText:string;
    procedure SetIsShuffle(const Value: boolean);
    function TransformLine(s:string):string;
    procedure CreateDelimitedList(var sep1: TStringList);
    procedure AddNewLine(s:string);
  protected
    procedure SetTextStr(const Value: string); override;
    function Get(Index: Integer): string; override;
    procedure Put(Index: Integer; const S: string); override;
    function GetCount: Integer; override;

    procedure DoCustomFiltring;
    function GetColCount: Integer;
    property IsShuffle:boolean read FIsShuffle write SetIsShuffle;
    property _XValues[Col,Row:Integer]:string read GetXValues write SetXValues;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;

    property FieldNames:TStrings read GetFieldNames;
    property Values[Index:Integer]:TStrings read GetValues;
    property ValueByName[Index:Integer; FieldName:string]:string read GetValueByName;
    property InnerDelimeter:Char read GetInnerDelimeter write SetInnerDelimeter default ';';
    property Filling: Boolean read FFilling write SetFilling;
    property IsTransformed: Boolean read FIsTransformed write SetIsTransformed;
    property AsTable:TStrings read GetAsTable;
    property IsOEMSource: Boolean read FIsOEMSource write SetIsOEMSource;
    property TableLength: Integer read FTableLength write SetTableLength;
    property ColCount:Integer read GetColCount;
    //////////////////////////////////////////
    property Filter:string read FFilter write SetFilter;
    property SortedField:Integer read FSortedField write SetSortedField;
    property Order[Index:Integer]:Integer read GetOrder write SetOrder;
    property VisibleItems[Index:Integer]:Boolean read GetVisible write SetVisible;
    property OnCustomFilter:TOnCustomFilter read FOnCustomFilter write SetOnCustomFilter;
    property OnEnum:TOnEnum read FOnEnum write SetOnEnum;
    property Descending:Boolean read FDescending write SetDescending;
    procedure ShowAll;
    procedure HideAll;
    procedure AutoConfig;
    procedure DoEnum;
    //procedure Podstava(ChprList:TChprList; x,y,z:Integer);
  end;

  TChprStat=record
    Delimeter:Char;
    IsOEM:Boolean;
    IsChpr:Boolean;
  end;

function Transform(Strings:TStrings; Delimeter: string=';'; Filling:boolean=false): string;
function GetFieldNames(Strings:TStrings; Delimeter:string=';'):TStrings;
function GetValueByName(Strings: TStrings; RowNum: Integer; FieldName:string; Delimeter: string = ';'):string;
function GetValueByColumn(Strings: TStrings; Row, Col: Integer; Delimeter: string = ';'):string;
function Check(st:string):boolean;
procedure PrintToEpson(S:string);
procedure PrintToLaser(S:string);
function Analiz(Text:string;TestLength:Integer=-1):TChprStat;

implementation
Uses PublStr, PublFile, StrUtils, Printers, Graphics, SysUtils;
Var
  FieldStrings:TStringList;
  ValueStrings:TStringList;
  ImpossibleIndex:Integer=Low(Integer);

function Transform(Strings:TStrings; Delimeter: string; Filling:boolean): string;
var
  s, st: string;
  sep1,sep2:TStringList;
  p: Integer;
  i, j, l: Integer;
  sts:TStringList;
  ch : char;
  Sep: Char;
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
  if OutSide(Ind,ValueStrings.Count-1) then Exit;
  ValueStrings.DelimitedText:=Strings[0];
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

procedure TChprList.AddNewLine(s: string);
var
  I:Integer;
  Ind: Integer;
begin
  NeedTmpSts;
  FTmpSts.Delimiter:=InnerDelimeter;
  if IsOEMSource then
    FTmpSts.DelimitedText:=AsAnsi(s)
  else
    FTmpSts.DelimitedText:=s;
  Ind:=Count;
  for I := 0 to FTmpSts.Count - 1 do _XValues[I,Ind]:=FTmpSts[I];
end;

procedure TChprList.AutoConfig;
var
  X:TChprStat;
  OriginalText:string;
begin
  { TODO : FOriginalText }
  OriginalText:=GetOriginalText;
  X:=Analiz(OriginalText,FTableLength);
  FIsTransformed:=x.IsChpr;
  FIsOEMSource:=x.IsOEM;
  if not FIsTransformed then InnerDelimeter:=X.Delimeter;
  SetTextStr(OriginalText);
end;

procedure TChprList.NeedTmpSts;
begin
  if FTmpSts = nil then
    FTmpSts := TStringList.Create;
end;

{ TODO -cВозврат : Вернуть Подставу на родину }
//procedure TChprList.Podstava(ChprList: TChprList; x, y, z: Integer);
//var
//  I: Integer;
//  s:string;
//  J: Integer;
//  us: Boolean;
//begin
//  FFields[x]:=ChprList.FieldNames[z];
//  NeedTmpSts;
//  FTmpSts.Clear;
//  for I := 0 to ChprList.Count - 2 do FTmpSts.Add(ChprList.Values[i][y]);
//  for I := 0 to Count - 1 do begin
//    s:=XValues[I,x];
//    us:=false;
//    for J := 0 to FTmpSts.Count - 1 do begin
//      us:=SameText(s,FTmpSts[J]);
//      if not us then Continue;
//      XValues[I,X]:=ChprList.Values[J][Z];
//      break;
//    end;
//    if us then Continue;
//    XValues[I,X]:='-*-*-*-';
//  end;
//end;

procedure TChprList.InitCols(Col: Integer);
begin
  if ColCount<=Col then SetLength(Cells,Col+1);
end;

procedure TChprList.InitRow(Row: Integer);
var
  OldLength: Integer;
  I: Integer;
  J: Integer;
begin
  for I := 0 to High(Cells) do begin
    OldLength:=Length(Cells[I]);
    if High(Cells[I])<Row then SetLength(Cells[I],Row+1);
    for J := OldLength to High(Cells[I]) do Cells[I,J]:=ImpossibleIndex;
  end;
end;

procedure TChprList.Insert(Index: Integer; const S: string);
var
  I, L: Integer;
begin
  L:=Count;
  if Index<L then
    for I := 0 to High(Cells) do begin
      SetLength(Cells[I],L+1);
      System.move(Cells[I,Index],Cells[I,Index+1],sizeof(Integer)*(L-Index));
      Cells[I,Index]:=ImpossibleIndex;
    end;
  FValues.DelimitedText:=S;
  for I := 0 to FValues.Count - 1 do _XValues[I,Index]:=FValues[I];
end;

procedure TChprList.Put(Index: Integer; const S: string);
begin
  Exception.Create('Класс TChprList предназначен только для чтения');
end;

procedure TChprList.Clear;
begin
  SetLength(Cells,0);
end;

procedure TChprList.ColumnSort;
begin
  if SortedField=-1 then Exit;
  { TODO : Что-то из 2х сортировок нужно вернуть на родину }
    //publ.QuickSort(0,Count-2,Compare,ExchangeOrder);
//  SimpleSort;
  Test;
end;

//function TChprList.Compare(Index1, Index2: Integer): Integer;
//var
//  s1,s2:string;
//begin
//  s1:=XValues[Index1,SortedField];
//  s2:=XValues[Index2,SortedField];
//  Result:=publStr.CompNumText(s1,s2);
//  if FDescending then Result:=-Result;
//end;

constructor TChprList.Create;
begin
  IsSettingText:=false;
  FIsShuffle:=false;
  Texts:=TSortList.Create(self);
  Texts.Sorted:=true;
  Texts.Duplicates:=dupIgnore;
  Texts.Sorted:=true;
  inherited;
  Randomize;
  TmpFile:=TempPath+format('%dx%d',[Random(10000),Random(10000)]);
  FFields:=TStringList.Create;
  FValues:=TStringList.Create;
//  FFields.OnChange:=FieldsChange;
  FFields.StrictDelimiter:=true;
  FValues.StrictDelimiter:=true;
  FVisible:=TBits.Create;
  FTableLength := 100;
  FSortedField:=-1;
  FDescending:=false;
end;

procedure TChprList.Delete(Index: Integer);
var
  I, L: Integer;
begin
  L:=Count;
  if Index<L then
    for I := 0 to High(Cells) do begin
      System.move(Cells[I,Index+1],Cells[I,Index],sizeof(Integer)*(L-Index-1));
      SetLength(Cells[I],L-1);
    end;
end;

destructor TChprList.Destroy;
begin
  SysUtils.DeleteFile(TmpFile);
  FFields.Free;
  FValues.Free;
  FVisible.Free;
  inherited;
end;

function TChprList.Get(Index: Integer): string;
var
  Ind: Integer;
  I: Integer;
begin
  Result:='';
  Ind:=Order[Index];
  if Ind=ImpossibleIndex then Exit;
  for I := 0 to ColCount - 1 do Result:=ContStr(Result,InnerDelimeter,_XValues[I,Ind]);
//  Result:=inherited Get(Ind);
end;

function TChprList.GetAsTable: TStrings;
var
  I,J,L:Integer;
  W:array of Integer;
  LW:Integer;
  TL:Integer;
  Ind:Integer;
begin
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
        S:=format('Показаны только %d записей',[TL]);
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
    for I := 0 to FilterCount-1 do begin
      if I>TL then break;
      Ind:=FilterArray[I];
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind);
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
    FTmpSts.AddObject(S,pointer(-2));
    S:='';
    for J := 0 to LW - 1 do begin
      S:=ContStr(S,'|',StringOfChar('-',W[J]));
    end;
    FTmpSts.AddObject(S,pointer(-2));
    for I := 0 to FilterCount-1 do begin
      if I>TL then begin
        S:=format('Показаны только %d записей',[TL]);
        FTmpSts.AddObject(S,pointer(-2));
        break;
      end;
      Ind:=FilterArray[I];
      if not VisibleItems[Ind] then Continue;
      GetValues(Ind);
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

function TChprList.GetColCount: Integer;
begin
  Result:=Length(Cells);
end;

function TChprList.GetCount: Integer;
begin
  Result:=0;
  if ColCount=0 then Exit;
  Result:=Length(Cells[0]);
end;

function TChprList.GetFieldNames: TStrings;
begin
  Result:=FFields;
end;

function TChprList.GetInnerDelimeter: Char;
begin
  Result := FFields.Delimiter;
end;

function TChprList.GetOrder(Index: Integer): Integer;
var
  Ind: Integer;
begin
  if not FIsShuffle or IsSettingText then begin
    Result:=Index;
    Exit;
  end;
  Result:=ImpossibleIndex;
  if OutSide(Index,high(FOrder)) then Exit;
  if Index<0 then begin
    Ind:=Texts.IndexOfObject(pointer(-Result));
    if Ind=-1 then Exit;

  end;

  Result:=FOrder[Index];
end;

function TChprList.GetOriginalText: string;
begin
  Result:=LoadStrFromFile(TmpFile);
end;

function TChprList.GetValueByName(Index: Integer; FieldName: string): string;
begin
  cgsCHPR2.GetValueByName(self,Index,FieldName,InnerDelimeter);
end;

function TChprList.GetValues(Index: Integer): TStrings;
begin
  FValues.OnChange:=nil;
  ValueIndex:=Index+1;
  FValues.DelimitedText:=Strings[ValueIndex];
//  FValues.OnChange:=ValueChange;
  Result:=FValues;
end;

function TChprList.GetVisible(Index: Integer): Boolean;
var
  Ind:Integer;
begin
  Result:=false;
  if OutSide(Index,Count-1) then Exit;
  Ind:=FOrder[Index];
  if Ind=-1 then Exit;
  Result:=FVisible[Ind];
end;

function TChprList.GetXValues(Col, Row: Integer): string;
var
  Ind: Integer;
begin
  result:='';
  if OutSide(Col,ColCount-1) then Exit;
  if OutSide(Row,Count-1) then Exit;
  Ind:=Cells[Col,Row];
  Result:=Texts[Ind];
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
begin
  if not Assigned(FOnCustomFilter) then Exit;
  for I := 0 to Count - 1 do begin
    Visible:=VisibleItems[I];
    FOnCustomFilter(self,I,Strings[I],Visible);
    VisibleItems[I]:=Visible;
  end;
end;

procedure TChprList.DoEnum;
var
  I:integer;
begin
  if not Assigned(FOnEnum) then Exit;
  for I := 0 to Count - 1 do
    FOnEnum(self,I,Strings[I]);
end;

procedure TChprList.CreateDelimitedList(var sep1: TStringList);
begin
  sep1 := TStringList.Create;
  sep1.StrictDelimiter := true;
  sep1.Delimiter := InnerDelimeter;
end;

function TChprList.TransformLine(s:string):string;
var
  ch: Char;
  j: Integer;
  p: Integer;
  L: Integer;
  st: string;
  sep1,sep2:TStringList;
  sts:TStringList;
begin
  Result:=s;
  if not IsTransformed then Exit;
  sts:=TStringList.Create;
  sts.Duplicates:=dupError;
  sts.Sorted:=true;
  CreateDelimitedList(sep1);
  CreateDelimitedList(sep2);
  L := length(s);
  if L<3 then Exit;
  if not ((s[1] in ['|','!']) and (s[L]=s[1])) then Exit;
  ch := s[1];
  s := copy(s, 2, L - 2);
  s := PublStr.Trim(s);
  s := AnsiReplaceStr(S, ch, InnerDelimeter);
  repeat
    l := length(s);
    s := AnsiReplaceStr(s, ' ' + InnerDelimeter, InnerDelimeter);
    s := AnsiReplaceStr(s, InnerDelimeter + ' ', InnerDelimeter);
  until l = length(s);
  if Filling then
  begin
    st := Sep2.text;
    for ch := '0' to '9' do
      if pos(ch, st) > 1 then
      begin
        sep1.DelimitedText := S;
        for j := 0 to sep1.Count - 1 do
          if sep1[j] = '' then
          begin
            if sep2.Count <= j then
              break;
            sep1[j] := sep2[j];
          end
          else
            break;
        S := sep1.DelimitedText;
        break;
      end;
    for ch := '0' to '9' do
      if pos(ch, S) > 1 then
      begin
        sep2.DelimitedText := S;
        break;
      end;
  end;
  p:=-1;
  While p<>0 do begin
   if p=-1 then p:=0;
   p:=PosEx('.',s,p+1);
   if p=0 then break;
   if p<2 then Continue;
   if not (s[p-1] in ['0'..'9']) then Continue;
   if p=l then Continue;
   if not (s[p+1] in ['0'..'9']) then Continue;
   if (p<l-2) and (s[p+3]='.') then Continue;
   if (p>3) and (s[p-3]='.') then Continue;
   s[p]:=DecimalSeparator;
  end;
  sts.Free;
  sep1.Free;
  sep2.Free;
  Result:=S;
end;

{ TODO -cВозврат : Вернуть Смену порядка на родину }
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

//procedure TChprList.FieldsChange(Sender: TObject);
//begin
//  if Count=0 then Exit;
//  Strings[0]:=FFields.DelimitedText;
//end;

procedure TChprList.SetDescending(const Value: Boolean);
begin
  FDescending := Value;
  ColumnSort;
end;

procedure TChprList.SetFilling(const Value: Boolean);
Var
  FOriginalText:string;
begin
  FFilling := Value;
  FOriginalText:=LoadStrFromFile(TmpFile);
  SetTextStr(FOriginalText);
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
  if Value=''
  then FilterCount:=0
  else begin
   FilterCount:=Count-1;
   FOnCustomFilter:=nil;
  end;
  if FilterCount<1 then begin
    SetLength(FilterArray,FilterCount);
    ShowAll;
    Exit;
  end;
  SetLength(FilterArray,FilterCount);
  SepSts:=TStringList.Create;
  SepSts.Delimiter:=' ';
  SepSts.DelimitedText:=Value;
  TmpSts:=TStringList.Create;
  TmpSts.Assign(self);
  TmpSts.Delete(0);
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
     s1:=InnerDelimeter+s1+InnerDelimeter;
    end else L:=Length(s1);
    for J:=FilterCount-1 downto 0 do begin
      Ind:=FilterArray[J];
      try
        s2:=AnsiUpperCase(TmpSts[Ind]);
        p:=pos(s1,s2);
        if (p>0) xor IsNot then begin
         if IsEq
         then p:=p+1;
         system.Delete(s2,p,L);
         TmpSts[Ind]:=s2;
        end else begin
          FilterArray[J]:=FilterArray[FilterCount-1];
          Dec(FilterCount);
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
  for I:=0 to FilterCount-1 do FVisible[FilterArray[I]]:=true;
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
  P, Start: PChar;
  S: string;
begin
  SaveStrToFile(Value,TmpFile);
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    if P <> nil then
    begin
      // This is a lot faster than using StrPos/AnsiStrPos when
      // LineBreak is the default (#13#10)
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in [#10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        AddNewLine(TransformLine(S));
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
    end
  finally
    EndUpdate;
  end;
end;


{procedure TChprList.SetTextStr(const Value: string);
var
  S:string;
  I: Integer;
begin
  S:='';
  for I:=1 to Length(Value) do
    if Value[I]<>#0 then S:=S+Value[I];
  SaveStrToFile(S,TmpFile);
  if IsOEMSource then S:=AsAnsi(S);
  IsSettingText:=true;
  inherited SetTextStr(S);
  SetLength(FOrder,Count);
  for I:=0 to Count-1 do FOrder[I]:=I;
  SetLength(FAntiOrder,Count);
  for I:=0 to Count-1 do FAntiOrder[I]:=I;
  IsSettingText:=false;
  if IsTransformed then inherited SetTextStr(Transform(self,InnerDelimeter,FFilling));
  if Count>0
  then FFields.DelimitedText:=Strings[0]
  else FFields.Text:='';
  FVisible.Size:=Count;
  ShowAll;
  FSortedField:=-1;
  FDescending:=false;
end;
}

procedure TChprList.SetVisible(Index: Integer; const Value: Boolean);
var
  Ind: Integer;
begin
  if OutSide(Index,Count-1) then Exit;
  Ind:=FOrder[Index];
  if Ind=-1 then Exit;
  FVisible[Ind]:=Value;
end;

procedure TChprList.SetXValues(Col, Row: Integer; const Value: string);
var
  Ind: Integer;
begin
  InitCols(Col);
  InitRow(Row);
  if not Texts.Find(Value,Ind) then begin
   Ind:=Texts.Add(Value);
   SetLength(Refs,Length(Refs)+1);
   Texts.Objects[Ind]:=pointer(High(Refs));
   Refs[High(Refs)]:=Ind;
  end;
  Cells[Col,Row] := Integer(Texts.Objects[Ind]);
end;

procedure TChprList.ShowAll;
var
  I:Integer;
begin
  for I := 0 to Count - 1 do
    FVisible[I]:=false;
end;

{ TODO -cВозврат : Вернуть Сортировку на родину }
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
  //tx:TextFile;
begin
  for I := 0 to High(FOrder) do begin
    if not I=FAntiOrder[FOrder[I]] then begin
      MessageBox('','Тест #2 не пройден'#13#10
      +format('I=%d, Order[I]=%d, AntiOrder[%d]=%d',[I,FOrder[I],FOrder[I],FAntiOrder[FOrder[I]]]));
      break;
    end;

  end;
  {$REGION 'Проверка сортировки'}
    { TODO -cВозврат : Вернуть Часть проверки на родину }
//    for I := 0 to Count - 2 do
//      if CompNumText(XValues[I,FSortedField],XValues[I+1,FSortedField])>0
//        then begin
//          MessageBox('','Тест #2 не пройден'#13#10
//          +format('V[%d]=%s; V[%d]=%s',[I,XValues[I,FSortedField],I+1,XValues[I+1,FSortedField]]));
//          break;
//        end;
  {$ENDREGION}
//  AssignFile(tx,'d:\!test\test.chpr.text');
//  Rewrite(tx);
//  for I := 0 to Count - 1 do begin
//    Writeln(tx,XValues[I,FSortedField]);
//  end;
//  CloseFile(tx);
end;

//procedure TChprList.ValueChange(Sender: TObject);
//begin
//  if OutSide(ValueIndex,Count-1) then Exit;
//  Strings[ValueIndex]:=FValues.DelimitedText;
//end;

procedure TChprList.SetIsOEMSource(const Value: Boolean);
begin
  FIsOEMSource := Value;
  SetTextStr(GetOriginalText);
end;

procedure TChprList.SetIsShuffle(const Value: boolean);
begin
  FIsShuffle := Value;
end;

procedure TChprList.SetIsTransformed(const Value: Boolean);
begin
  FIsTransformed := Value;
  SetTextStr(GetOriginalText);
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
  //ao:Integer;
  o,av: Integer;
begin
  if OutSide(Index,high(FOrder)) then Exit;
  o:=FOrder[Index];
  //ao:=FAntiOrder[o];
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
end;

function Check(st:string):boolean;
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
    //if I=9 then sv[i]:=0 else
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
  Result.IsChpr:=sm1=sum;
end;


constructor TSortList.Create(AParent: TChprList);
begin
  inherited Create;
  FParent:=AParent;
end;

procedure TSortList.ExChangeRef(Ind1, Ind2: Integer);
begin
  !
end;

function StringListCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := AnsiCompareText(List[index1],List[Index2]);
  if Result>0 then TSortList(List).ExChangeRef(Index1,Index2);
end;

procedure TSortList.Sort;
begin
  CustomSort(StringListCompareStrings);
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
