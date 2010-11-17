{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
{-$Define DEBUG}
unit Publ;

interface

uses Windows, Messages, Classes; {System}

const
  NaN = 0.0 / 0.0;
  ImpossibleInt: Integer = Low(Integer);
  ImpossibleCompressInt: Integer = 1;
  ImpossibleDateTime: Double = NAN;
  ImpossibleFloat: Real = NAN;
  ImpossibleCurrency: Currency = Low(Int64) div 10000;
  CRLF: string = #13#10;
  HexSet: set of Char = ['0'..'9', 'A'..'F'];

type
  ai = array of Integer;
  aai = array of ai;
  ar = array of Extended;
  aar = array of ar;
  ast = array of string;
  sb = set of Byte;
 ////////////////////// x //////////////////////
  TRealPoint = record
    X, Y: Real;
  end;
 ////////////////////// x //////////////////////
  TRealRect = record
    Left, Top, Right, Bottom: Real;
  end;
 // Простые виды событий
  TBoolEvent = procedure(Sender: TObject; Value: Boolean) of object;
  TBoolVarEvent = procedure(Sender: TObject; var Value: Boolean) of object;
  TIntEvent = procedure(Sender: TObject; Value: Integer) of object;
  TIntVarEvent = procedure(Sender: TObject; var Value: Integer) of object;
  TStrEvent = procedure(Sender: TObject; Value: string) of object;
  TStrVarEvent = procedure(Sender: TObject; var Value: string) of object;
  TVarEvent = procedure(Sender: TObject; ind: Integer; var Value) of object;
  TFloatEvent = procedure(Sender: TObject; ind: Integer; Value: Extended) of object;
  TVarFloatEvent = procedure(Sender: TObject; ind: Integer; var Value: Extended) of object;
  TBoolFunction = function: Boolean of object;
  //
  TIntProc = procedure(Index: Integer; Int: Integer; Token:integer=0);
  TIntFunc = function(Index: Integer; Token:integer=0): Integer;
  TIntProcObj = procedure(Index: Integer; Int: Integer; Token:integer=0) of object;
  TIntFuncMtd = function(Index: Integer; Token:integer=0): Integer of object;
 //

  TCustomCompare = function(Index: Integer; obj: TObject): Integer of object;
  TCustomStrCompare = function(Index: Integer; str: string): Integer of object;
  TIndCompare = function(Index1, Index2: Integer): Integer of object;
 //
  TExchangeProc = procedure(Index1, Index2: Integer) of object;
 // Компонент автоматического подключения модуля
  TPubl = class (TComponent)
  end;
 // Список строк с нулевым символом
  TNullStrList = class (TStringList)
  protected
    procedure SetTextStr(const Value: string); override;
    function GetTextStr: string; override;
  end;

  TDirection = (drLeft, drTop, drRight, drBottom, drIncrease, drDecrease, drUp, drDown);

 /////////////////// x ///////////////////
 // Компонент используемый с TPersistent-свойствами
 // которые, в свою очередь пытаются получить доступ
 // к визуальным компонентам  в DesignTime
 // Предназначен для хранения данных о компоненте
 // и очистки поля, при его удалении
  TListener = class (TComponent)
  private
    FComponent: TComponent;
    procedure SetComponent(const Value: TComponent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property Component: TComponent read FComponent write SetComponent;
  end;
 ////////////////////// x //////////////////////
 // Класс обмена сообщениями между разнородными классами
 // OnChange - событие задаваемое владельцем связи
 //  вызывается при измении данных в классе-собеседнике
 // OnGetValue - событие задаваемое владельцем связи
 //  вызывается, если классу-собеседнику нужно получить
 //  информацию от владельца связи
 // GetValue - вызывается классом-собеседником для получения данных
 // DoChange - вызывается классом-собеседником при изменении
 //  собственных данных
  TSimpleLink = class
  private
    FOnChange: TIntVarEvent;
    FOnGetValue: TVarEvent;
  public
    property OnChange: TIntVarEvent read FOnChange write FOnChange;
    property OnGetValue: TVarEvent read FOnGetValue write FOnGetValue;
    procedure GetValue(Index: Integer; out x);
    function DoChange(x: Integer = 0): Integer;
  end;
//
function IfThen(AValue: Boolean; const ATrue: string; AFalse: string = ''): string; overload;
// Запись и чтение строки в/из потока
function ReadBinCompressInt(Stream: TStream): Integer;
function ReadBinInt(Stream: TStream): Integer;
function ReadStrBool(Stream: TStream): Boolean;
function ReadString(Stream: TStream): string;
function ReadStrInt(Stream: TStream): Integer;
function WriteBinCompressInt(Stream: TStream; Value: Integer): Boolean;
procedure WriteBinInt(Stream: TStream; Value: Integer);
procedure WriteStrBool(Stream: TStream; Value: Boolean);
procedure WriteString(Stream: TStream; s: string);
procedure WriteStrInt(Stream: TStream; Value: Integer);
//-------------------------------
function WriteBeginBlock(Stream: TStream): Integer;
procedure ReadBlock(Stream: TStream);
procedure WriteEndBlock(Stream: TStream; BeginBlockPos: Integer);
// Создание массива целых чисел
procedure SetAI(var a: ai; x: array of const);
procedure MergeAI(var a: ai; x: array of ai);
// Создание массива целых чисел
procedure SetAR(var a: ar; x: array of const);
// Создание массива строк
procedure GroupStrings(var asts: ast; x: array of string);
// Сравнение прямоугольников
function CompareRect(rct1, rct2: TRect): Boolean;
// Нахождение числового корня
function Koren(x: Integer): Integer;
// Вывод сообщения
procedure MessageBox(Title, Text: string);
// Обмен значениями двух переменных
procedure Exchange(var x1, x2: Integer); overload;
procedure Exchange(var p1, p2: pointer); overload;
// Сравнение двух величин
function Equal(var a; var b; Size: Integer): Boolean;
// Проверка наличия элемента в массиве
function EnteringP(p: pointer; ps: array of pointer): Integer;
function EnteringI(p: Integer; ps: array of Integer): Integer;
// Округление с учётом невозможных чисел
function Round_(Value: Real): Integer;
// Список методов заданого класса
procedure GetMethodList(AClass: TClass; List: TStrings; IncludeParents: Boolean);
// Проверка соответсвия классов аналогичная оператору Is
function IsIt(obj: TObject; c: TClass): Boolean;
// Бинарный поиск в отсортитрованом массиве
function Find(obj: TObject; Count: Integer; Compare: TCustomCompare; out Index: Integer): Boolean;
  overload;
function Find(s: string; Count: Integer; Compare: TCustomStrCompare; out Index: Integer): Boolean;
  overload;
function Find(Value: Integer; Count: Integer; Compare: TIndCompare; out Index: Integer): Boolean;
  overload;
// Быстрая сортировка данных
procedure QuickSort(L, R: Integer; SCompare: TIndCompare; Exchange: TExchangeProc);
// Пустая процедура
procedure Dummy;
// Проверка на выход из границ
function OutSide(Value, MaxValue: Integer): Boolean; overload;
function OutSide(Value, MinValue, MaxValue: Integer): Boolean; overload;
// Преобразование от чисел к записи вещественных точки и прямоугольника
function RealRect(Left, Top, Right, Bottom: Real): TRealRect;
function RealPoint(X, Y: Real): TRealPoint;
// Функция возвращающая дизайнер объекта
procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
//
procedure Cycle(var x: Integer; MaxValue: Integer = MaxInt; MinValue: Integer = 0); overload;
procedure Cycle(var x: Word; MaxValue: Word = MAXWORD; MinValue: Word = 0); overload;
//
function Into(bit: Byte; Value: Integer): Boolean;
//
function CompressInt(Value: Integer): Integer;
function DeCompressInt(Value: Integer): Integer;
function CompressSize(Value: Integer): Byte;


////////////////////// SysUtils //////////////////////
type
{ Type conversion records }

  WordRec = packed record
    case Integer of
      0: (Lo, Hi: Byte);
      1: (Bytes: array [0..1] of Byte);
  end;

  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

  Int64Rec = packed record
    case Integer of
      0: (Lo, Hi: Cardinal);
      1: (Cardinals: array [0..1] of Cardinal);
      2: (Words: array [0..3] of Word);
      3: (Bytes: array [0..7] of Byte);
  end;

  TLocaleOptions = (loInvariantLocale, loUserLocale);


function SafeLoadLibrary(const FileName: string;  ErrorMode: UINT = SEM_NOOPENFILEERRORBOX): HMODULE;
procedure DivMod(Dividend: Integer; Divisor: Word; var Result, Remainder: Word);
procedure FreeAndNil(var Obj);
procedure Sleep(milliseconds: Cardinal);{$IFDEF MSWINDOWS}  stdcall;{$ENDIF}
function GetEnvironmentVariable(const Name: string): string;

var
  LeadBytes: set of Char = [];
  Win32Platform: Integer = 0;
  Win32MajorVersion: Integer = 0;
  Win32MinorVersion: Integer = 0;
  Win32BuildNumber: Integer = 0;
  Win32CSDVersion: string = '';
/////////////////// x ///////////////////
type
  TRoundToRange = -37..37;
  TValueRelationship = -1..1;

function IsNan(const AValue: Double): Boolean; overload;
function IsNan(const AValue: Single): Boolean; overload;
function IsNan(const AValue: Extended): Boolean; overload;
function Min(const A, B: Integer): Integer; overload; inline;
function Min(const A, B: Int64): Int64; overload; inline;
function Min(const A, B: Single): Single; overload; inline;
function Min(const A, B: Double): Double; overload; inline;
function Min(const A, B: Extended): Extended; overload; inline;
function Max(const A, B: Integer): Integer; overload; inline;
function Max(const A, B: Int64): Int64; overload; inline;
function Max(const A, B: Single): Single; overload; inline;
function Max(const A, B: Double): Double; overload; inline;
function Max(const A, B: Extended): Extended; overload; inline;
function CompareValue(const A, B: Extended; Epsilon: Extended = 0): TValueRelationship; overload;
function CompareValue(const A, B: Double; Epsilon: Double = 0): TValueRelationship; overload;
function CompareValue(const A, B: Single; Epsilon: Single = 0): TValueRelationship; overload;
function CompareValue(const A, B: Integer): TValueRelationship; overload;
function CompareValue(const A, B: Int64): TValueRelationship; overload;
function SameValue(const A, B: Extended; Epsilon: Extended = 0): Boolean; overload;
function SameValue(const A, B: Double; Epsilon: Double = 0): Boolean; overload;
function SameValue(const A, B: Single; Epsilon: Single = 0): Boolean; overload;
function RoundTo(const AValue: Double; const ADigit: TRoundToRange): Double;
function IntPower(const Base: Extended; const Exponent: Integer): Extended register;
function LogN(const Base, X: Extended): Extended;
function Power(const Base, Exponent: Extended): Extended; overload;
function Power(const Base, Exponent: Double): Double; overload;
function Power(const Base, Exponent: Single): Single; overload;
function IsZero(const A: Extended; Epsilon: Extended = 0): Boolean; overload;
function IsZero(const A: Double; Epsilon: Double = 0): Boolean; overload;
function IsZero(const A: Single; Epsilon: Single = 0): Boolean; overload;
function Poly(const X: Extended; const Coefficients: array of Double): Extended;
/////////////////// x ///////////////////
procedure SaveValue(Stream: TStream; Field: Integer; Value: string); overload;
procedure SaveValue(Stream: TStream; Field: Integer; Value: Integer); overload;
procedure SaveValue(Stream: TStream; Field: Integer; Value: Boolean); overload;

var
  DayCountInMonth: array[1..12] of Byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  CountBytesOfStringLength: Byte = 2;

implementation

uses Types;

function WriteBeginBlock(Stream: TStream): Integer;
var
  buf: Integer;
begin
  Result := Stream.Position;
  buf := 0;
  Stream.Write(buf, 4);
end;

procedure WriteEndBlock(Stream: TStream; BeginBlockPos: Integer);
var
  p: Integer;
  BlockSize: Integer;
begin
  p := Stream.Position;
  Stream.Position := BeginBlockPos;
  BlockSize := p - BeginBlockPos - 4;
  Stream.Write(BlockSize, 4);
end;

procedure ReadBlock(Stream: TStream);
var
  sz: Integer;
begin
  Stream.Read(sz, 4);
  Stream.Seek(sz, soFromCurrent);
end;

procedure WriteString(Stream: TStream; s: string);
var
  l: Longword;
begin
  if Stream = nil then
    Exit;
  l := length(s);
  if (CountBytesOfStringLength = 2) and (l > $ffff) then
    l := $ffff;
  Stream.Write(l, CountBytesOfStringLength);
  if l > 0 then
    Stream.Write(s[1], l);
end;

function ReadString(Stream: TStream): string;
var
  l: Integer;
begin
  l := 0;
  Stream.Read(l, CountBytesOfStringLength);
  SetLength(result, l);
  if l > 0 then
    Stream.Read(result[1], l);
  Stream.position := Stream.position;
end;

procedure WriteStrInt(Stream: TStream; Value: Integer);
var
  s: string;
begin
  Str(Value, s);
  WriteString(Stream, s);
end;

function ReadStrInt(Stream: TStream): Integer;
var
  s: string;
  v, c: Integer;
begin
  s := ReadString(Stream);
  Val(s, v, c);
  if c = 0 then
    Result := v
  else
    Result := ImpossibleInt;
end;

function IfThen(AValue: Boolean; const ATrue: string; AFalse: string = ''): string;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

(*function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;*)

procedure WriteStrBool(Stream: TStream; Value: Boolean);
var
  s: string;
begin
  s := IfThen(Value, '1', '0');
  WriteString(Stream, s);
end;

function ReadStrBool(Stream: TStream): Boolean;
begin
  Result := ReadString(Stream) = '1';
end;

function WriteBinCompressInt(Stream: TStream; Value: Integer): Boolean;
var
  CmprsInt: Integer;
begin
  CmprsInt := CompressInt(Value);
  Result := CmprsInt <> ImpossibleCompressInt;
  Stream.Write(CmprsInt, CompressSize(CmprsInt));
end;

function ReadBinCompressInt(Stream: TStream): Integer;
var
  CmprsInt: Integer;
  sz: Byte;
  arbyte: array[0..3] of Byte absolute CmprsInt;
begin
  CmprsInt := 0;
  Stream.Read(CmprsInt, 1);
  sz := CompressSize(CmprsInt);
  if sz > 1 then
    Stream.Read(arbyte[1], sz - 1);
  Result := DecompressInt(CmprsInt);
end;

procedure WriteBinInt(Stream: TStream; Value: Integer);
begin
  Stream.Write(Value, 4);
end;

function ReadBinInt(Stream: TStream): Integer;
begin
  Stream.Read(Result, 4);
end;

procedure SetAI(var a: ai; x: array of const);
var
  i, l: Integer;
begin
  l := High(x);
  SetLength(a, l + 1);
  for i := 0 to l do
    a[i] := x[i].VInteger;
end;

procedure MergeAI(var a: ai; x: array of ai);
var
  i, j, n, l: Integer;
begin
  l := 0;
  for i := 0 to High(x) do
    l := l + Length(x[i]);
  SetLength(a, l);
  n := 0;
  for i := 0 to High(x) do
    for j := 0 to High(x[i]) do
    begin
      a[n] := x[i, j];
      inc(n);
    end;
end;

procedure SetAR(var a: ar; x: array of const);
var
  i, l: Integer;
begin
  l := High(x);
  SetLength(a, l + 1);
  for i := 0 to l do
    case x[i].VType of
      vtExtended:
        a[i] := x[i].VExtended^;
      vtInteger:
        a[i] := x[i].VInteger;
    end;
end;

procedure GroupStrings(var asts: ast; x: array of string);
var
  i, l: Integer;
begin
  l := High(x);
  SetLength(asts, l + 1);
  for i := 0 to l do
    asts[i] := x[i];
end;

function StrLCopy(Dest: Pchar; const Source: Pchar; MaxLen: Cardinal): Pchar; assembler;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     ESI,EAX
  MOV     EDI,EDX
  MOV     EBX,ECX
  XOR     AL,AL
  TEST    ECX,ECX
  JZ      @@1
  REPNE   SCASB
  JNE     @@1
  INC     ECX
  @@1:    SUB     EBX,ECX
  MOV     EDI,ESI
  MOV     ESI,EDX
  MOV     EDX,EDI
  MOV     ECX,EBX
  SHR     ECX,2
  REP     MOVSD
  MOV     ECX,EBX
  AND     ECX,3
  REP     MOVSB
  STOSB
  MOV     EAX,EDX
  POP     EBX
  POP     ESI
  POP     EDI
end;

function StrPCopy(Dest: Pchar; const Source: string): Pchar;
begin
  Result := StrLCopy(Dest, Pchar(Source), Length(Source));
end;

function CompareRect(rct1, rct2: TRect): Boolean;
begin
  result := (rct1.Left = rct2.Left) and (rct1.Top = rct2.Top) and (rct1.Right = rct2.Right) and
    (rct1.Bottom = rct2.Bottom);
end;

function Koren(x: Integer): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 1 to 9 do
  begin
    result := result + x mod 10;
    x := x div 10;
  end;
end;

procedure Exchange(var x1, x2: Integer);
var
  p: Integer;
begin
  if x1 = x2 then
    Exit;
  p := x1;
  x1 := x2;
  x2 := p;
end;

procedure Exchange(var p1, p2: pointer);
var
  p: pointer;
begin
  if p1 = p2 then
    Exit;
  p := p1;
  p1 := p2;
  p2 := p;
end;

{ TNullStrList }

function TNullStrList.GetTextStr: string;
var
  I, L, Size, Count: Integer;
  P: Pchar;
  S, LB: string;
begin
  Count := GetCount;
  Size := 0;
  LB := #13#0#10#0;
  for I := 0 to Count - 1 do
    Inc(Size, Length(Get(I)) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(Pointer(LB)^, P^, L);
      Inc(P, L);
    end;
  end;
end;

procedure TNullStrList.SetTextStr(const Value: string);
var
  P, Start: Pchar;
  S: string;
  n, l: Integer;
begin
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    n := 0;
    l := length(Value);
    if P <> nil then
      while n < l do
      begin
        Start := P + n;
        while not ((P + n)^ in [#10, #13]) do
          Inc(n);
        SetString(S, Start, P + n - Start);
        Add(S);
        if P^ = #13 then
          Inc(n);
        if P^ = #10 then
          Inc(n);
      end;
  finally
    EndUpdate;
  end;
end;

procedure MessageBox(Title, Text: string);
Var
  p:integer;
begin
  if Title='' then begin
    Title:=ParamStr(0);
    Repeat
     p:=pos('\',Title);
     if p=0 then break;
     Delete(Title,1,p);
    Until p=0;
  end;
  windows.MessageBox(0, Pchar(Text), Pchar(Title), MB_OK + MB_ICONASTERISK);
end;

function Equal(var a; var b; Size: Integer): Boolean;
type
  bytes = array[1..MaxInt] of Byte;
var
  i: Integer;
begin
  result := true;
  for i := 1 to Size do
  begin
    result := bytes(a)[i] = bytes(b)[i];
    if not result then
      Exit;
  end;
end;

function xEntering(var p; var ps; Count, ItemSize: Integer): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if Equal(p, Pointer(Integer(@ps) + i * ItemSize)^, ItemSize) then
    begin
      result := i;
      break;
    end;
end;

function EnteringP(p: pointer; ps: array of pointer): Integer;
begin
  result := xEntering(p, ps, length(ps), SizeOf(p));
end;

function EnteringI(p: Integer; ps: array of Integer): Integer;
begin
  result := xEntering(p, ps, Length(ps), SizeOf(p));
end;

////////////////////// x //////////////////////

function Round_(Value: Real): Integer;
begin
  if IsNan(Value) then
    result := ImpossibleInt
  else
    result := Round(Value);
end;

procedure GetMethodList(AClass: TClass; List: TStrings; IncludeParents: Boolean);
var
  P: pointer;
  N: Word;
  i: Integer;
  S: ShortString;

  procedure IncAddr(Offset: Integer);
  begin
    P := Pointer(Integer(P) + Offset);
  end;

begin
  if AClass <> nil then
  begin
    P := AClass;
    IncAddr(vmtMethodTable);
    P := Pointer(P^);
    if P <> nil then
    begin
      N := Word(P^);
      IncAddr(2);
      for i := 0 to N - 1 do
      begin
        IncAddr(6);
        S := ShortString(P^);
        List.AddObject(S, TObject(AClass.MethodAddress(S)));
        IncAddr(Byte(P^) + 1);
      end;
    end;
    if IncludeParents then
      GetMethodList(AClass.ClassParent, List, True);
  end;
end;

function IsIt(obj: TObject; c: TClass): Boolean;
var
  cls: TClass;
begin
  result := false;
  if obj = nil then
    Exit;
  cls := obj.ClassType;
  result := true;
  while cls <> nil do
  begin
    if cls = c then
      Exit;
    cls := cls.ClassParent;
  end;
  result := false;
end;

function Find(obj: TObject; Count: Integer; Compare: TCustomCompare; out Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  Index := 0;
  if not Assigned(Compare) then
    Exit;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(I, obj);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function Find(s: string; Count: Integer; Compare: TCustomStrCompare; out Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  Index := 0;
  if not Assigned(Compare) then
    Exit;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(I, s);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function Find(Value: Integer; Count: Integer; Compare: TIndCompare; out Index: Integer): Boolean;
  overload;
var
  L, H, I, C: Integer;
begin
  Result := False;
  Index := 0;
  if not Assigned(Compare) then
    Exit;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(I, Value);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure QuickSort(L, R: Integer; SCompare: TIndCompare; Exchange: TExchangeProc);
var
  I, J: Integer;
  P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(I, P) < 0 do
        Inc(I);
      while SCompare(J, P) > 0 do
        Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J, SCompare, Exchange);
    L := I;
  until I >= R;
end;

procedure Dummy;
begin
 // Здесь должно быть пусто
end;

function OutSide(Value, MaxValue: Integer): Boolean; overload;
begin
  result := (Value < 0) or (Value > MaxValue);
end;

function OutSide(Value, MinValue, MaxValue: Integer): Boolean; overload;
begin
  result := (Value < MinValue) or (Value > MaxValue);
end;

{ TSimpleLink }

function TSimpleLink.DoChange(x: Integer): Integer;
begin
  if Assigned(FOnChange) then
    FOnChange(Self, x);
  result := x;
end;

function RealRect(Left, Top, Right, Bottom: Real): TRealRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function RealPoint(X, Y: Real): TRealPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

procedure Cycle(var x: Integer; MaxValue: Integer = MaxInt; MinValue: Integer = 0);
begin
  if x < MinValue then
    x := MinValue
  else
  if x > MaxValue then
    x := MaxValue
  else
    x := (x + 1 - MinValue) mod (MaxValue - MinValue + 1) + MinValue;
end;

procedure Cycle(var x: Word; MaxValue: Word; MinValue: Word);
begin
  if x < MinValue then
    x := MinValue
  else
  if x > MaxValue then
    x := MaxValue
  else
    x := (x + 1 - MinValue) mod (MaxValue - MinValue + 1) + MinValue;
end;

function Into(bit: Byte; Value: Integer): Boolean;
var
  i: Integer;
begin
  result := false;
  if OutSide(bit, 31) then
    Exit;
  i := 1 shl bit;
  result := (Value and i = i);
end;

function CompressInt(Value: Integer): Integer;
var
  I: Integer;
begin
  Result := ImpossibleCompressInt;
  for I := 0 to 3 do
  begin
    if cardinal(Value) >= cardinal(1 shl (i * 8 + 6)) then
      Continue;
    if I < 3 then
      Result := Value shl 2 + I;
    break;
  end;
end;

function DeCompressInt(Value: Integer): Integer;
begin
  if Value=ImpossibleCompressInt
  then Result:=ImpossibleInt
  else Result := Value shr 2;
end;

function CompressSize(Value: Integer): Byte;
begin
  Result := Value mod 4 + 1;
end;

{
begin
end;

}

procedure TSimpleLink.GetValue(Index: Integer; out x);
begin
  if Assigned(FOnGetValue) then
    FOnGetValue(self, Index, x);
end;

{ TListener }

procedure TListener.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (FComponent = AComponent) then
    FComponent := nil;
end;

procedure TListener.SetComponent(const Value: TComponent);
begin
  if FComponent <> nil then
    FComponent.RemoveFreeNotification(self);
  FComponent := Value;
  if FComponent <> nil then
    FComponent.FreeNotification(self);
end;
/////////////////// x ///////////////////
type
  THookPersistent = class (TPersistent)
  protected
    function GetOwner: TPersistent; override;
  end;
 /////////////////// x ///////////////////
  THookComponent = class (TComponent)
  public
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; override; stdcall;
  end;
/////////////////// x ///////////////////
procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
var
  Temp: TPersistent;
begin
  Result := nil;
  if Obj = nil then
    Exit;
  Temp := THookPersistent(Obj).GetOwner;
  if Temp = nil then
  begin
    if (Obj is TComponent) and (csDesigning in TComponent(Obj).ComponentState) then
      THookComponent(Obj).QueryInterface(IDesignerNotify, Result);
  end
  else
  begin
    if (Obj is TComponent) and not (csDesigning in TComponent(Obj).ComponentState) then
      Exit;
    GetDesigner(Temp, Result);
  end;
end;

{ THookPersistent }

function THookPersistent.GetOwner: TPersistent;
begin
  result := inherited GetOwner;
end;

{ THookComponent }

function THookComponent.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  result := inherited QueryInterface(iid, obj);
end;

procedure Carrying(var Source, Dest: Word; Period: Word);
begin
  while Source > Period do
  begin
    inc(Dest);
    dec(Source, Period);
  end;
end;

function AbsoluteDay(Year, Month, Day: Word): Word;
var
  i: Integer;
begin
  if Year div 4 = 0 then
    DayCountInMonth[2] := 29
  else
    DayCountInMonth[2] := 28;
  Result := 0;
  for i := 1 to Month - 1 do
    Result := Result + ord(DayCountInMonth[i]);
  Result := Result + Day;
end;

function IncDate(Date1, Date2: TSystemTime): TSystemTime;
var
  x, y, m: Integer;
begin
  with Date1 do
    x := AbsoluteDay(wYear, wMonth, wDay);
  with Date2 do
    x := x + AbsoluteDay(wYear, wMonth, wDay);
  with Result do
    for y := 0 to 1 do
      for m := 1 to 12 do
        if ord(DayCountInMonth[m]) > x then
        begin
          wYear := Date1.wYear + Date2.wYear + y;
          wMonth := m;
          wDay := x;
        end
        else
          x := x - ord(DayCountInMonth[m]);
end;

function IncTime(Time1, Time2: TSystemTime): TSystemTime;
begin
  Result.wYear := Time1.wYear + Time2.wYear;
  Result.wMonth := Time1.wMonth + Time2.wMonth;
  Result.wDay := Time1.wDay + Time2.wDay;
  Result.wHour := Time1.wHour + Time2.wHour;
  Result.wMinute := Time1.wMinute + Time2.wMinute;
  Result.wSecond := Time1.wSecond + Time2.wSecond;
  Result.wMilliseconds := Time1.wMilliseconds + Time2.wMilliseconds;
  with Result do
  begin
    Carrying(wMilliseconds, wSecond, 1000);
    Carrying(wSecond, wMinute, 60);
    Carrying(wMinute, wHour, 60);
    Carrying(wHour, wDay, 24);
  end;
end;

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

procedure DivMod(Dividend: Integer; Divisor: Word; var Result, Remainder: Word);
asm
  PUSH    EBX
  MOV     EBX,EDX
  MOV     EDX,EAX
  SHR     EDX,16
  DIV     BX
  MOV     EBX,Remainder
  MOV     [ECX],AX
  MOV     [EBX],DX
  POP     EBX
end;

function SafeLoadLibrary(const Filename: string; ErrorMode: UINT): HMODULE;
var
  OldMode: UINT;
  FPUControlWord: Word;
begin
  OldMode := SetErrorMode(ErrorMode);
  try
    asm
      FNSTCW  FPUControlWord
    end;
    try
      Result := LoadLibrary(Pchar(Filename));
    finally
      asm
        FNCLEX
        FLDCW FPUControlWord
      end;
    end;
  finally
    SetErrorMode(OldMode);
  end;
end;

{$IFDEF MSWINDOWS}
procedure Sleep; external kernel32 name 'Sleep'; stdcall;
{$ENDIF}
{$IFDEF LINUX}
procedure Sleep(milliseconds: Cardinal);
begin
  usleep(milliseconds * 1000);  // usleep is in microseconds
end;
{$ENDIF}

function GetEnvironmentVariable(const Name: string): string;
const
  BufSize = 1024;
var
  Len: Integer;
  Buffer: array[0..BufSize - 1] of Char;
begin
  Result := '';
  Len := Windows.GetEnvironmentVariable(PChar(Name), @Buffer, BufSize);
  if Len < BufSize then
    SetString(Result, PChar(@Buffer), Len)
  else
  begin
    SetLength(Result, Len - 1);
    Windows.GetEnvironmentVariable(PChar(Name), PChar(Result), Len);
  end;
end;

function IsNan(const AValue: Single): Boolean;
begin
  Result := ((PLongWord(@AValue)^ and $7F800000) = $7F800000) and
    ((PLongWord(@AValue)^ and $007FFFFF) <> $00000000);
end;

function IsNan(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $7FF0000000000000) = $7FF0000000000000) and
    ((PInt64(@AValue)^ and $000FFFFFFFFFFFFF) <> $0000000000000000);
end;

function IsNan(const AValue: Extended): Boolean;
type
  TExtented = packed record
    Mantissa: Int64;
    Exponent: Word;
  end;
  PExtended = ^TExtented;
begin
  Result := ((PExtended(@AValue)^.Exponent and $7FFF) = $7FFF) and
    ((PExtended(@AValue)^.Mantissa and $7FFFFFFFFFFFFFFF) <> 0);
end;

function Min(const A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Int64): Int64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Single): Single;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Double): Double;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Extended): Extended;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Int64): Int64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Single): Single;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Double): Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Max(const A, B: Extended): Extended;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function CompareValue(const A, B: Extended; Epsilon: Extended): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else
  if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Double; Epsilon: Double): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else
  if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Single; Epsilon: Single): TValueRelationship;
begin
  if SameValue(A, B, Epsilon) then
    Result := EqualsValue
  else
  if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Integer): TValueRelationship;
begin
  if A = B then
    Result := EqualsValue
  else
  if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

function CompareValue(const A, B: Int64): TValueRelationship;
begin
  if A = B then
    Result := EqualsValue
  else
  if A < B then
    Result := LessThanValue
  else
    Result := GreaterThanValue;
end;

const
  FuzzFactor = 1000;
  ExtendedResolution = 1E-19 * FuzzFactor;
  DoubleResolution = 1E-15 * FuzzFactor;
  SingleResolution = 1E-7 * FuzzFactor;

function SameValue(const A, B: Extended; Epsilon: Extended): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * ExtendedResolution, ExtendedResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Double; Epsilon: Double): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * DoubleResolution, DoubleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function SameValue(const A, B: Single; Epsilon: Single): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := Max(Min(Abs(A), Abs(B)) * SingleResolution, SingleResolution);
  if A > B then
    Result := (A - B) <= Epsilon
  else
    Result := (B - A) <= Epsilon;
end;

function RoundTo(const AValue: Double; const ADigit: TRoundToRange): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, ADigit);
  Result := Round(AValue / LFactor) * LFactor;
end;

function IntPower(const Base: Extended; const Exponent: Integer): Extended;
asm
  MOV     ECX, EAX
  CDQ
  FLD1                      { Result := 1 }
  XOR     EAX, EDX
  SUB     EAX, EDX          { eax := Abs(Exponent) }
  JZ      @@3
  FLD     Base
  JMP     @@2
  @@1:    FMUL    ST, ST            { X := Base * Base }
  @@2:    SHR     EAX,1
  JNC     @@1
  FMUL    ST(1),ST          { Result := Result * X }
  JNZ     @@1
  FSTP    ST                { pop X from FPU stack }
  CMP     ECX, 0
  JGE     @@3
  FLD1
  FDIVRP                    { Result := 1 / Result }
  @@3:
  FWAIT
end;

function LogN(const Base, X: Extended): Extended;
{ Log.N(X) := Log.2(X) / Log.2(N) }
asm
  FLD1
  FLD     X
  FYL2X
  FLD1
  FLD     Base
  FYL2X
  FDIV
  FWAIT
end;

function Power(const Base, Exponent: Extended): Extended;
const
  Max: Double = MaxInt;
var
  IntExp: Integer;
asm
  FLD     Exponent
  FLD     ST             {copy to st(1)}
  FABS                   {abs(exp)}
  FLD     Max
  FCOMPP                 {leave exp in st(0)}
  FSTSW   AX
  SAHF
  JB      @@RealPower    {exp > MaxInt}
  fld     ST             {exp in st(0) and st(1)}
  FRNDINT                {round(exp)}
  FCOMP                  {compare exp and round(exp)}
  FSTSW   AX
  SAHF
  JNE     @@RealPower
  FISTP   IntExp
  MOV     EAX, IntExp    {eax=Trunc(Exponent)}
  MOV     ECX, EAX
  CDQ
  FLD1                   {Result=1}
  XOR     EAX, EDX
  SUB     EAX, EDX       {abs(exp)}
  JZ      @@Exit
  FLD     Base
  JMP     @@Entry
  @@Loop:
  FMUL    ST, ST         {Base * Base}
  @@Entry:
  SHR     EAX, 1
  JNC     @@Loop
  FMUL    ST(1), ST      {Result * X}
  JNZ     @@Loop
  FSTP    ST
  CMP     ECX, 0
  JGE     @@Exit
  FLD1
  FDIVRP                 {1/Result}
  JMP     @@Exit
  @@RealPower:
  FLD     Base
  FTST
  FSTSW   AX
  SAHF
  JZ      @@Done
  FLDLN2
  FXCH
  FYL2X
  FXCH
  FMULP   ST(1), ST
  FLDL2E
  FMULP   ST(1), ST
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADDP   ST(1), ST
  FSCALE
  @@Done:
  FSTP    ST(1)
  @@Exit:
end;

function Power(const Base, Exponent: Double): Double; overload;
const
  Max: Double = MaxInt;
var
  IntExp: Integer;
asm
  FLD     Exponent
  FLD     ST             {copy to st(1)}
  FABS                   {abs(exp)}
  FLD     Max
  FCOMPP                 {leave exp in st(0)}
  FSTSW   AX
  SAHF
  JB      @@RealPower    {exp > MaxInt}
  fld     ST             {exp in st(0) and st(1)}
  FRNDINT                {round(exp)}
  FCOMP                  {compare exp and round(exp)}
  FSTSW   AX
  SAHF
  JNE     @@RealPower
  FISTP   IntExp
  MOV     EAX, IntExp    {eax=Trunc(Exponent)}
  MOV     ECX, EAX
  CDQ
  FLD1                   {Result=1}
  XOR     EAX, EDX
  SUB     EAX, EDX       {abs(exp)}
  JZ      @@Exit
  FLD     Base
  JMP     @@Entry
  @@Loop:
  FMUL    ST, ST         {Base * Base}
  @@Entry:
  SHR     EAX, 1
  JNC     @@Loop
  FMUL    ST(1), ST      {Result * X}
  JNZ     @@Loop
  FSTP    ST
  CMP     ECX, 0
  JGE     @@Exit
  FLD1
  FDIVRP                 {1/Result}
  JMP     @@Exit
  @@RealPower:
  FLD     Base
  FTST
  FSTSW   AX
  SAHF
  JZ      @@Done
  FLDLN2
  FXCH
  FYL2X
  FXCH
  FMULP   ST(1), ST
  FLDL2E
  FMULP   ST(1), ST
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADDP   ST(1), ST
  FSCALE
  @@Done:
  FSTP    ST(1)
  @@Exit:
end;

function Power(const Base, Exponent: Single): Single; overload;
const
  Max: Double = MaxInt;
var
  IntExp: Integer;
asm
  FLD     Exponent
  FLD     ST             {copy to st(1)}
  FABS                   {abs(exp)}
  FLD     Max
  FCOMPP                 {leave exp in st(0)}
  FSTSW   AX
  SAHF
  JB      @@RealPower    {exp > MaxInt}
  fld     ST             {exp in st(0) and st(1)}
  FRNDINT                {round(exp)}
  FCOMP                  {compare exp and round(exp)}
  FSTSW   AX
  SAHF
  JNE     @@RealPower
  FISTP   IntExp
  MOV     EAX, IntExp    {eax=Integer(Exponent)}
  MOV     ECX, EAX
  CDQ
  FLD1                   {Result=1}
  XOR     EAX, EDX
  SUB     EAX, EDX       {abs(exp)}
  JZ      @@Exit
  FLD     Base
  JMP     @@Entry
  @@Loop:
  FMUL    ST, ST         {Base * Base}
  @@Entry:
  SHR     EAX, 1
  JNC     @@Loop
  FMUL    ST(1), ST      {Result * X}
  JNZ     @@Loop
  FSTP    ST
  CMP     ECX, 0
  JGE     @@Exit
  FLD1
  FDIVRP                 {1/Result}
  JMP     @@Exit
  @@RealPower:
  FLD     Base
  FTST
  FSTSW   AX
  SAHF
  JZ      @@Done
  FLDLN2
  FXCH
  FYL2X
  FXCH
  FMULP   ST(1), ST
  FLDL2E
  FMULP   ST(1), ST
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADDP   ST(1), ST
  FSCALE
  @@Done:
  FSTP    ST(1)
  @@Exit:
end;

function IsZero(const A: Extended; Epsilon: Extended): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := ExtendedResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Double; Epsilon: Double): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := DoubleResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Single; Epsilon: Single): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := SingleResolution;
  Result := Abs(A) <= Epsilon;
end;

function Poly(const X: Extended; const Coefficients: array of Double): Extended;
{ Horner's method }
var
  I: Integer;
begin
  Result := Coefficients[High(Coefficients)];
  for I := High(Coefficients) - 1 downto Low(Coefficients) do
    Result := Result * X + Coefficients[I];
end;

procedure InitPlatformId;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
      Win32Platform := dwPlatformId;
      Win32MajorVersion := dwMajorVersion;
      Win32MinorVersion := dwMinorVersion;
      if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
        Win32BuildNumber := dwBuildNumber and $FFFF
      else
        Win32BuildNumber := dwBuildNumber;
      Win32CSDVersion := szCSDVersion;
    end;
end;

function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string;
{$IFDEF MSWINDOWS}
var
  L: Integer;
  Buffer: array[0..255] of Char;
begin
  L := GetLocaleInfo(Locale, LocaleType, Buffer, SizeOf(Buffer));
  if L > 0 then
    SetString(Result, Buffer, L - 1)
  else
    Result := Default;
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := Default;
end;
{$ENDIF}

function StrLIComp(const Str1, Str2: Pchar; MaxLen: Cardinal): Integer; assembler;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     EDI,EDX
  MOV     ESI,EAX
  MOV     EBX,ECX
  XOR     EAX,EAX
  OR      ECX,ECX
  JE      @@4
  REPNE   SCASB
  SUB     EBX,ECX
  MOV     ECX,EBX
  MOV     EDI,EDX
  XOR     EDX,EDX
  @@1:    REPE    CMPSB
  JE      @@4
  MOV     AL,[ESI-1]
  CMP     AL,'a'
  JB      @@2
  CMP     AL,'z'
  JA      @@2
  SUB     AL,20H
  @@2:    MOV     DL,[EDI-1]
  CMP     DL,'a'
  JB      @@3
  CMP     DL,'z'
  JA      @@3
  SUB     DL,20H
  @@3:    SUB     EAX,EDX
  JE      @@1
  @@4:    POP     EBX
  POP     ESI
  POP     EDI
end;

procedure SaveValue(Stream: TStream; Field, Value: Integer);
begin
  Stream.Write(Field, 4);
  WriteStrInt(Stream, Value);
end;

procedure SaveValue(Stream: TStream; Field: Integer; Value: Boolean);
begin
  Stream.Write(Field, 4);
  WriteStrBool(Stream, Value);
end;

procedure SaveValue(Stream: TStream; Field: Integer; Value: string);
begin
  Stream.Write(Field, 4);
  WriteString(Stream, Value);
end;

end.
