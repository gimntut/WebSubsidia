unit PublIntegers;

{$Define DEBUG}

interface

uses
  Classes, Publ, Windows, PublStreams, PublExcept;

type
  TIntRec = Class
  private
    procedure SetCount(const AValue: Integer);
    function GetCount: Integer;
  public
    Value: Integer;
    Index: Integer;
    Next: Integer;
    Prev: Integer;
    property Count:Integer read GetCount write SetCount;
    constructor Create;
    procedure Assign(Obj:TIntRec);
  published
  end;

//const
//  NullInt: TIntRec = (Value: 0; Index: -1; Next: -1; Prev: -1);

type
  TIntegers = class
  private
    FIntegers: array of array[0..1024] of TIntRec;

    // Сортированый массив чисел, Х - числа, Y - индексы в неотсортированом массиве

    FIndexes: array of Integer; // Индексы чисел в массиве FInts

    // Сортированый массив чисел, Х - индекс, Y - номер по порядку

    MaxInd: Integer;
    Capacity: Integer;
    NullInt:TIntRec;
    // Нахождение положения числа в массиве FInts
    // Index - внешнй индекс величины
    // RealInd - внутрений индекс величины
    function FindEx(Value: Integer; var ExIndex, InIndex: Integer): Boolean;
    function GetCount: Integer;
    function GetInt(InIndex, Token: Integer): Integer;
    function GetIntegers(ExIndex: Integer): Integer;
    procedure IncCount;
    procedure SetCapacity(Value: Integer);
    procedure SetInt(Index, Int, Token: Integer);
    procedure SetIntegers(Index: Integer; const Value: Integer);
    function FindReadMode(var RealInd: Integer; Value: Integer): Boolean;
    function AddReadMode(Value: Integer): Integer;
    procedure TestError(ErrStr: string);
    function GetInts(Index: Integer): TIntRec;
    procedure SetInts(Index: Integer; const Value: TIntRec);
    procedure GetCoord(Index: Integer; out Position: Integer; out Line: Integer);
  protected
    property Ints[Index: Integer]: TIntRec read GetInts write SetInts;
    function GetPrev(Index:Integer):Integer;
    function GetNext(Index:Integer):Integer;
  public
    constructor Create;
    // Добавление числа в конец Integers
    function Add(Value: Integer): Integer; overload;
    // Нахождение положение числа в массиве Integers
    function Find(Value: Integer; out Index: Integer): Boolean;
    // Нахождение положение числа в массиве Integers
    function IndexOf(Value: Integer): Integer;
    // Добавление числа в Integers
    function Insert(Index, Value: Integer): Integer;
    // Проверка наличия числа в массиве
    function IsIn(Value: Integer): Boolean;
    // Обмен двух чисел местами
    function Swap(Value1, Value2: Integer): Boolean;
    // Добавление чисел из другого массва
    procedure Add(AIntegers: TIntegers); overload;
    // Получение всех
    procedure Assign(AIntegers: TIntegers);
    // Очистка массива
    procedure Clear;
    // Удаление массива чисел
    procedure Delete(Integers: TIntegers); overload;
    // Удаление числа из массива
    procedure Delete(Value: Integer); overload; virtual;
    // Оставить только совпадающие числа двух массивов
    procedure KeepEquals(Integers: TIntegers);
    // Уменьшение всех чисел больших From+Offset на Offset
    procedure Renum(From: Integer; Offset: Integer = 1);
    property Count: Integer read GetCount;
    // Массив чисел
    property Integers[Index: Integer]: Integer read GetIntegers write SetIntegers; default;
    //
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    // Проверка целостности массива
    {$IFDEF DEBUG}
    procedure Test(DoTest: Boolean = true);
    {$ELSE}
    procedure Test(DoTest: Boolean = false);
    {$ENDIF DEBUG}
  end;

(*  TObjIntegers = class (TIntegers)
  public
//    property Objects;
//    property Values;
  end;
*)
(*
  TCustomRefs = class (TObjIntegers)
  protected
    function GetReferences(ID: Integer): TIntegers; virtual; abstract;
    procedure SetReferences(ID: Integer; const Value: TIntegers); virtual; abstract;
  public
    function Add(ID, Ref: Integer): Integer; virtual; abstract;
    function AddRefs(ID: Integer; Refs: TIntegers): Integer; virtual; abstract;
    property References[ID: Integer]: TIntegers read GetReferences write SetReferences;
  end;
*)

(*  TRefIntegers = class (TCustomRefs)
  protected
    function GetReferences(ID: Integer): TIntegers; override;
    procedure SetReferences(ID: Integer; const Value: TIntegers); override;
  public
    destructor Destroy; override;
    function Add(ID, Ref: Integer): Integer; override;
    function AddRefs(ID: Integer; Refs: TIntegers): Integer; override;
    procedure Clear;
    procedure Delete(ID: Integer); override;// Удаление ID из массива
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property References[ID: Integer]: TIntegers read GetReferences write SetReferences;
  end;
*)
(*
  TRefFile = class (TCustomRefs)
  private
    FFileName: string;
    FileStream: TMultiStream;
    Ints: TIntegers;
    FID: Integer;
    FSID: Integer;
    LastStream: TStream;
    procedure SetFileName(const Value: string);
    function GetStreams(ID: Integer): TStream;
  protected
    function GetReferences(ID: Integer): TIntegers; override;
    procedure SetReferences(ID: Integer; const Value: TIntegers); override;
    property Streams[ID: Integer]: TStream read GetStreams;
  public
    constructor Create(AFileName: string);
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    destructor Destroy; override;
    function Add(ID: Integer; Ref: Integer): Integer; override;
    function AddRefs(ID: Integer; Refs: TIntegers): Integer; override;
    procedure Delete(Num: Integer); override;
    procedure Flush;
    property FileName: string read FFileName write SetFileName;
  end;
*)
implementation

uses
  PublConst, PublFile, PublStr;

{ TIntegers }

procedure TIntegers.Add(AIntegers: TIntegers);
var
  i: Integer;
begin
  if AIntegers = nil then
    Exit;
  for i := 0 to AIntegers.Count - 1 do Add(AIntegers[i]);
end;

procedure TIntegers.Assign(AIntegers: TIntegers);
begin
  Clear;
  Add(AIntegers);
end;

function TIntegers.Add(Value: Integer): Integer;
begin
  Result := -1;
  if Value = ImpossibleInt then Exit;
  Result := AddReadMode(Value);
  Test;
end;

procedure TIntegers.Delete(Value: Integer);
var
  ExIndex: Integer;
  i: Integer;
  InIndex: Integer;
  j: Integer;
  Line:Integer;
  Position:Integer;
begin
  if not FindEx(Value, ExIndex, InIndex) then Exit;
  if MaxInd <> ExIndex then begin
    GetCoord(ExIndex, Position, Line);
    if FIntegers[Line,0].count=1 then begin
      // Dispose(@FIntegers[Line]); ?
      Move(FIntegers[Line + 1], FIntegers[Line], (MaxInd - ExIndex) * SizeOf(FIntegers[0]));
      For i:=0 to High(FIndexes) do
        if FIndexes[i]>=ExIndex then Dec(FIndexes[i],1024);
    end else begin
      Move(FIntegers[Line, Position + 1], FIntegers[Line, Position], (FIntegers[Line,0].Count - ExIndex -1) * SizeOf(FIntegers[0,0]));
    end;
  end;
//  if FValues[RealInd] <> 0 then dec(ValueCount);
  Move(FIndexes[InIndex + 1], FIndexes[InIndex], (MaxInd - InIndex) * SizeOf(Integer));
//  Move(FValues[RealInd + 1], FValues[RealInd], (MaxInd - RealInd) * SizeOf(Integer));
//  Move(FObjects[RealInd + 1], FObjects[RealInd], (MaxInd - RealInd) * SizeOf(TObject));
  // Остановился здесь
  SetCapacity(MaxInd);
  Dec(MaxInd);
  j:=0;
  for i := 0 to MaxInd do begin
    if Ints[j].Index > InIndex then
      dec(Ints[j].Index);
    if Ints[j].Value > ExIndex then
      Ints[i].Value:=Ints[i].Value-1;
    j:=GetNext(j);
  end;
  Test;
end;

function TIntegers.AddReadMode(Value: Integer): Integer;
var
  i: Integer;
  RealInd: Integer;
begin
  if FindEx(Value, Result, RealInd) then
    Exit;
  Result := ImpossibleInt;
  for i := 0 to High(FIndexes) do
    if FIndexes[i] >= RealInd then
      Inc(FIndexes[i]);
  IncCount;
  if MaxInd > RealInd then
    Move(FIntegers[RealInd], FIntegers[RealInd + 1], (MaxInd - RealInd) * SizeOf(TIntRec));
  Ints[RealInd].Value := Value;
  Ints[RealInd].Index := MaxInd;
  Ints[RealInd].Next := RealInd + 1;
  Ints[RealInd].Prev := RealInd - 1;
  FIndexes[MaxInd] := RealInd;
  result := MaxInd;
end;

function TIntegers.FindReadMode(var RealInd: Integer; Value: Integer): Boolean;
var
  C: Integer;
  I: Integer;
  H: Integer;
  L: Integer;
begin
  Result := False;
  L := 0;
  H := MaxInd;
  while L <= H do begin
    I := (L + H) shr 1;
    C := CompareValue(Ints[i].Value, Value);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := True;
        L := I;
      end;
    end;
  end;
  RealInd := L;
end;

constructor TIntegers.Create;
begin
  SetLength(FIntegers, 0);
  SetLength(FIndexes, 0);
  MaxInd := -1;
//  ValueCount := 0;
//  SortedCount := 0;
  Capacity := 128;
  SetCapacity(128);
end;

procedure TIntegers.Delete(Integers: TIntegers);
var
  i: Integer;
begin
  for i := 0 to Integers.Count - 1 do
    Delete(Integers[i]);
end;

function TIntegers.Find(Value: Integer; out Index: Integer): Boolean;
var
  RealInd: Integer;
begin
  Result := FindEx(Value, Index, RealInd);
end;

function TIntegers.GetCount: Integer;
begin
  result := MaxInd + 1;
end;

function TIntegers.GetInt(InIndex, Token: Integer): Integer;
begin
  Result := 0;
  case Token of
    0:
      Result := Ints[InIndex].Value;
    1:
      Result := Ints[InIndex].Index;
    2:
      Result := FIndexes[InIndex];
//    3:
//      Result := FValues[Index];
  end;
end;

function TIntegers.GetIntegers(ExIndex: Integer): Integer;
begin
  Result := ImpossibleInt;
  if (ExIndex < 0) or (ExIndex > MaxInd) then
    Exit;
  Result := Ints[FIndexes[ExIndex]].Value;
end;

function TIntegers.GetInts(Index: Integer): TIntRec;
Var
  Line:Integer;
  Position:Integer;
begin
  Result:=NullInt;
  Line:=Index div 1024;
  Position:=(Index mod 1024) + 1;
  if Position>FIntegers[Line,0].Count then Exit;
  Result:=FIntegers[Line,Position];
end;

function TIntegers.GetNext(Index: Integer): Integer;
Var
  Line:Integer;
  Position:Integer;
begin
  Result:=-1;
  Line:=Index div 1024;
  Position:=(Index mod 1024) + 1;
  if Position>FIntegers[Line,0].Count then begin
    if Line>=High(FIntegers) then Exit;
    Result:=(Line+1)*1024;
  end else Result:=Index+1;
end;

procedure TIntegers.IncCount;
begin
  Inc(MaxInd);
  SetCapacity(Count);
end;

function TIntegers.IsIn(Value: Integer): Boolean;
var
  x: Integer;
begin
  result := Find(Value, x);
end;

procedure TIntegers.KeepEquals(Integers: TIntegers);
var
  i: Integer;
begin
  for i := MaxInd downto 0 do
    if not Integers.IsIn(Ints[i].Value) then
      Delete(Ints[i].Value);
end;

procedure TIntegers.LoadFromStream(Stream: TStream);
var
  Flag: Byte;
begin
  MaxInd := ReadBinCompressInt(Stream);
  SetCapacity(MaxInd);
  LoadFromStreamInts(Stream, SetInt, 0);
  LoadFromStreamInts(Stream, SetInt, 1);
  LoadFromStreamInts(Stream, SetInt, 2);
  Stream.Read(Flag, 1);
//  if Flag = 1 then begin
//    Stream.Read(ValueCount, 4);
//    for I := 1 to ValueCount do begin
//      N := ReadBinCompressInt(Stream);
//      FValues[N] := ReadBinInt(Stream);
//    end;
//  end else
//    LoadFromStreamInts(Stream, SetInt, 3);
end;

procedure TIntegers.SetCapacity(Value: Integer);
begin
  if Value < 128 then
    Value := 128;
  if not OutSide(Value, Capacity div 4, Capacity - 1) then
    Exit;
  if Value < Capacity div 4 then
    Capacity := Capacity shr 2;
  while Value >= Capacity do
    Capacity := Capacity shl 2;
  SetLength(FIntegers, Capacity);
  SetLength(FIndexes, Capacity);
//  SetLength(FObjects, Capacity);
//  SetLength(FValues, Capacity);
end;

procedure TIntegers.Renum(From, Offset: Integer);
var
  i: Integer;
begin
  for i := 0 to MaxInd do
    if Integers[i] >= From + Offset then
      Integers[i] := Integers[i] - Offset;
end;

procedure TIntegers.SaveToStream(Stream: TStream);
begin

  WriteBinCompressInt(Stream, MaxInd);
  SaveToStreamInts(Stream, Count, GetInt, 0);
  SaveToStreamInts(Stream, Count, GetInt, 1);
  SaveToStreamInts(Stream, Count, GetInt, 2);
end;

procedure TIntegers.SetInt(Index, Int, Token: Integer);
begin
  case Token of
    0:
      Ints[Index].Value := Int;
    1:
      Ints[Index].Index := Int;
    2:
      FIndexes[Index] := Int;
//    3:
//      FValues[Index] := Int;
  end;
end;

procedure TIntegers.SetIntegers(Index: Integer; const Value: Integer);
var
  i, x1, x2, d, l, r: Integer;
  RealInd: Integer;
begin
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  if FindEx(Value, x1, RealInd) then
    Exit;
  //todo: если упдатинг изменить значения не изменяя положения

  x2 := FIndexes[Index];
  if abs(x1 - x2) < 2 then begin
    if x1 > x2 then
      dec(x1);
    Ints[x1].Value := Value;
    Exit;
  end;
  if x1 > x2 then begin
    d := -1;
//    x := x2;
    x1 := x1 - 1;
  end else begin
    d := 1;
//    x := x1 + 1;
  end;
  l := min(x1, x2);
  r := max(x1, x2);
  {todo: Главные изменения здесь}
//  Move(Ints[x - d], Ints[x], abs(x2 - x1) * SizeOf(TIntRec));
  Ints[x1].Value := Value;
  Ints[x1].Index := Index;
  for i := 0 to MaxInd do
    if (FIndexes[i] >= l) and (FIndexes[i] <= r) then
      inc(FIndexes[i], d);
  FIndexes[Index] := x1;
  Test;
end;

procedure TIntegers.SetInts(Index: Integer; const Value: TIntRec);
Var
  Line:Integer;
  Position:Integer;
begin
  Line:=Index div 1024;
  Position:=(Index mod 1024) + 1;
  if Position>FIntegers[Line,0].Count then Exit;
  FIntegers[Line,Position].Assign(Value);
end;

function TIntegers.FindEx(Value: Integer; var ExIndex, InIndex: Integer): Boolean;
//var
//  I: Integer;
begin
  Result := FindReadMode(InIndex, Value);
  if Outside(InIndex, MaxInd) then
    ExIndex := -1
  else
    ExIndex := Ints[InIndex].Index;
end;

//function TIntegers.GetObjects(Index: Integer): TObject;
//begin
//  result := nil;
//  if (Index < 0) or (Index > MaxInd) then
//    Exit;
//  result := FObjects[Index];
//end;
//
function TIntegers.GetPrev(Index: Integer): Integer;
Var
  Line:Integer;
  Position:Integer;
begin
  Result:=-1;
  Line:=Index div 1024;
  Position:=(Index mod 1024) + 1;
  if Position>FIntegers[Line,0].Count then begin
    if Line=0 then Exit;
    Result:=(Line-1)*1024+FIntegers[Line-1,0].Count-1;
  end else Result:=Index+1;
end;

//function TIntegers.GetValues(Index: Integer): Integer;
//begin
//  result := 0;
//  if (Index < 0) or (Index > MaxInd) then
//    Exit;
//  result := FValues[Index];
//end;
//
//procedure TIntegers.SetObjects(Index: Integer; const Value: TObject);
//begin
//  if (Index < 0) or (Index > MaxInd) then
//    Exit;
//  FObjects[Index] := Value;
//end;
//
//procedure TIntegers.SetValues(Index: Integer; const Value: Integer);
//begin
//  if Outside(Index, MaxInd) then
//    Exit;
//  if (FValues[Index] <> 0) and (Value = 0) then
//    dec(ValueCount)
//  else if (FValues[Index] = 0) and (Value <> 0) then
//    inc(ValueCount);
//  FValues[Index] := Value;
//end;
//
function TIntegers.IndexOf(Value: Integer): Integer;
var
  x: Integer;
begin
  result := -1;
  if Find(Value, x) then
    Result := x;
end;

procedure TIntegers.Clear;
begin
  MaxInd := -1;
  SetCapacity(0);
// {$IFDEF DEBUG}
//  SetLength(FInts, 128);
//  SetLength(FObjects, 128);
//  SetLength(FValues, 128);
//  SetLength(Inds, 128);
//  FillChar(FInts[0], SizeOf(FInts[0]) * 128, 0);
//  FillChar(FObjects[0], SizeOf(FObjects[0]) * 128, 0);
//  FillChar(FValues[0], SizeOf(FValues[0]) * 128, 0);
//  FillChar(Inds[0], SizeOf(Inds[0]) * 128, 0);
//{$ENDIF DEBUG}
end;

procedure TIntegers.Test;
var
  i, j: Integer;
const
  ErrStr1: string =
    'Нарушена целостность массива Integers в режиме чтения';
  ErrStr2: string =
    'Нарушена целостность массива Integers в режиме изменения'#13#10 + 'Нарушен порядок';
  ErrStr3: string =
    'Нарушена целостность массива Integers в режиме изменения'#13#10 + 'Неверный максимум';
  ErrStr4: string =
    'Нарушена целостность массива Integers в режиме изменения'#13#10 + 'Зацикленый массив';
begin
  if not DoTest then
  Exit;
  for i := 0 to MaxInd - 1 do
    for j := i + 1 to MaxInd do
      if (FIndexes[i] = FIndexes[j]) or (Ints[i].Value = Ints[j].Value) or
        (Ints[i].Index = Ints[j].Index) or (i <> FIndexes[Ints[i].Index]) then
      begin
        TestError(ErrStr1);
        exit;
      end;
end;

procedure TIntegers.GetCoord(Index: Integer; out Position: Integer; out Line: Integer);
begin
  Line := Index div 1024;
  Position := (Index mod 1024) + 1;
end;


procedure TIntegers.TestError(ErrStr: string);
begin
//  publ.MessageBox('', ErrStr);
  Exception.Create(ErrStr);
end;

function TIntegers.Swap(Value1, Value2: Integer): Boolean;
var
  ind1, ind2: Integer;
  x1, x2: Integer;
begin
  result := false;
  if Value1 = Value2 then
    Exit;
  if not Find(Value1, ind1) then
    Exit;
  if not Find(Value2, ind2) then
    Exit;
  x1 := FIndexes[ind1];
  x2 := FIndexes[ind2];
  Ints[x1].Index := ind2;
  Ints[x2].Index := ind1;
  FIndexes[ind1] := x2;
  FIndexes[ind2] := x1;
  result := true;
//  Exchange(FValues[ind1], FValues[ind2]);
//  Exchange(pointer(FObjects[ind1]), pointer(FObjects[ind2]));
  Test;
end;

function TIntegers.Insert(Index, Value: Integer): Integer;
 // Ind - индекс числа в массиве Integers
 // n - индекс числа в отсортированом массиве FInts
var
  X, N: Integer;
  i: Integer;
  RealInd: Integer;
begin
  Result := -1;
  if (Index < 0) or (Index > Count) then
    Exit;
  if FindEx(Value, X, RealInd) then
    Exit;
  if Index = Count then begin
    result := Add(Value);
    Exit;
  end;
  //todo: При упдатинге число добавляются в конец массива
  N := Index;
  IncCount;
  if MaxInd <> X then
    Move(FIntegers[X], FIntegers[X + 1], (MaxInd - X) * SizeOf(TIntRec));
  if MaxInd <> N then begin
    Move(FIndexes[N], FIndexes[N + 1], (MaxInd - N) * SizeOf(Integer));
//    Move(FValues[N], FValues[N + 1], (MaxInd - N) * SizeOf(Integer));
//    Move(FObjects[N], FObjects[N + 1], (MaxInd - N) * SizeOf(TObject));
  end;
  for i := 0 to MaxInd do begin
    if Ints[i].Index >= N then
      inc(Ints[i].Index);
    if FIndexes[i] >= X then
      inc(FIndexes[i]);
  end;
  FIndexes[N] := X;
  Ints[X].Value := Value;
  Ints[X].Index := N;
  Test;
end;

//procedure TIntegers.InsInt(Value, RealInd, PrevInd, NextInd: Integer);
//begin
//  FIntegers[RealInd].Value := Value;
//  FIntegers[RealInd].Next := NextInd;
//  FIntegers[RealInd].Prev := PrevInd;
//  if NextInd <> -1 then
//    FIntegers[NextInd].Prev := RealInd;
//  if PrevInd <> -1 then
//    FIntegers[PrevInd].Next := RealInd;
//end;

{ TRefIntegers }
(*
function TRefIntegers.Add(ID, Ref: Integer): Integer;
begin
  Result := TIntegers(self).add(ID);
//  if Objects[Result] = nil then
//    Objects[Result] := TIntegers.Create;
//  TIntegers(Objects[Result]).Add(Ref);
end;

function TRefIntegers.AddRefs(ID: Integer; Refs: TIntegers): Integer;
begin
  Result := TIntegers(self).add(ID);
//  if Objects[Result] = nil then
//    Objects[Result] := TIntegers.Create;
//  TIntegers(Objects[Result]).Add(Refs);
end;

procedure TRefIntegers.Clear;
var
  I: Integer;
begin
//  for I := 0 to Count - 1 do
//    Objects[I].Free;
  inherited Clear;
end;

procedure TRefIntegers.Delete(ID: Integer);
var
  Ind: Integer;
begin
  Ind := IndexOf(ID);
  if Ind = -1 then
    Exit;
//  Objects[Ind].Free;
  inherited Delete(ID);
end;

destructor TRefIntegers.Destroy;
begin
  Clear;
  inherited;
end;

function TRefIntegers.GetReferences(ID: Integer): TIntegers;
var
  ind: Integer;
begin
  Result := nil;
  ind := IndexOf(ID);
  if Ind = -1 then
    Exit;
//  Result := TIntegers(Objects[Ind]);
end;

procedure TRefIntegers.LoadFromStream(Stream: TStream);
var
  I: Integer;
begin
  inherited LoadFromStream(Stream);
  for I := 0 to Count - 1 do begin
//    Objects[i] := TIntegers.Create;
//    TIntegers(Objects[i]).LoadFromStream(Stream);
  end;
end;

procedure TRefIntegers.SaveToStream(Stream: TStream);
var
  I: Integer;
begin
  inherited SaveToStream(Stream);
//  for I := 0 to Count - 1 do
//    TIntegers(Objects[i]).SaveToStream(Stream);
end;

procedure TRefIntegers.SetReferences(ID: Integer; const Value: TIntegers);
var
  ind: Integer;
begin
  ind := IndexOf(ID);
  if Ind = -1 then
    Exit;
//  TIntegers(Objects[Ind]).Assign(Value);
end;
*)
{ TRefFile }
(*
function TRefFile.Add(ID, Ref: Integer): Integer;
var
  S: string;
begin
  if Streams[ID] = nil then begin
    S := IntToStr(ID);
    FileStream.AddStream(S);
  end;
  Result := References[ID].Add(Ref);
end;

function TRefFile.AddRefs(ID: Integer; Refs: TIntegers): Integer;
begin
  References[ID].Add(Refs);
  Result := IndexOf(ID);
end;

constructor TRefFile.Create(AFileName: string);
begin
  inherited Create;
  FID := -1;
  FSID := -1;
  Ints := TIntegers.Create;
  FileName := AFileName;
end;

procedure TRefFile.Delete(Num: Integer);
begin
  inherited;
end;

destructor TRefFile.Destroy;
begin
  Flush;
  Ints.Free;
  FileStream.Free;
  inherited;
end;

procedure TRefFile.Flush;
var
  Stream: TStream;
begin
  if FID = -1 then
    Exit;
  Stream := FileStream[IntToStr(FID)];
  Stream.Position := 0;
  Ints.SaveToStream(Stream);
end;

function TRefFile.GetReferences(ID: Integer): TIntegers;
begin
  Result := Ints;
  if FID = ID then
    Exit;
  if Streams[ID] = nil then begin
    Ints.Clear;
    Exit;
  end;
  Flush;
  Ints.LoadFromStream(Streams[ID]);
  FID := ID;
end;

function TRefFile.GetStreams(ID: Integer): TStream;
var
  S: string;
begin
  if FSID <> ID then begin
    S := IntToStr(ID);
    LastStream := FileStream[S];
    if LastStream <> nil then
      LastStream.Position := 0;
  end;
  Result := LastStream;
end;

procedure TRefFile.LoadFromStream(Stream: TStream);
var
  I: Integer;
begin
  inherited LoadFromStream(Stream);
  for I := 0 to Count - 1 do begin
//    Objects[i] := TIntegers.Create;
//    TIntegers(Objects[i]).LoadFromStream(Stream);
  end;
end;

procedure TRefFile.SaveToStream(Stream: TStream);
var
  I: Integer;
begin
  inherited SaveToStream(Stream);
//  for I := 0 to Count - 1 do
//    TIntegers(Objects[i]).SaveToStream(Stream);
end;

procedure TRefFile.SetFileName(const Value: string);
begin
  FreeAndNil(FileStream);
  FFileName := Value;
  if FileExists(Value) then
    FileStream := TMultiStream.Create(Value, fmOpenReadWrite, '')
  else
    FileStream := TMultiStream.Create(Value, fmCreate, '');
end;

procedure TRefFile.SetReferences(ID: Integer; const Value: TIntegers);
var
  S: string;
  Stream: TStream;
begin
  Str(ID, S);
  Stream := FileStream.AddStream(S);
  Stream.Position := 0;
  Value.SaveToStream(Stream);
  Flush;
  FID := ID;
  Ints.Assign(Value);
end;
*)
{ TIntRec }

procedure TIntRec.Assign(Obj: TIntRec);
begin
  Value:=  Obj.Value;
  Index:=  Obj.Index;
  Next:=   Obj.Next;
  Prev:=   Obj.Prev;
end;

constructor TIntRec.Create;
begin
  Value:= 0;
  Index:= -1;
  Next:= -1;
  Prev:= -1;
end;

function TIntRec.GetCount: Integer;
begin
  Result:=Value;
end;

procedure TIntRec.SetCount(const AValue: Integer);
begin
  Value:= AValue;
end;

end.
