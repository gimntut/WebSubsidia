unit PublStr;

interface

uses PublTime, Types, Classes, Publ;
/////////////////// SysUtils ///////////////////
type
  TFormatSettings = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    CurrencyString: string;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    TwoDigitYearCenturyWindow: Word;
  end;

  TTimeDat = (tdHour, tdMinute, tdSecond, tdMilliSecond);
  TFloatValue = (fvExtended, fvCurrency);
  TFloatFormat = (ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency);

  TFloatRec = packed record
    Exponent: Smallint;
    Negative: Boolean;
    Digits: array[0..20] of Char;
  end;

  TTimeDats = set of TTimeDat;

  TSysLocale = packed record
    DefaultLCID: Integer;
    PriLangID: Integer;
    SubLangID: Integer;
    FarEast: Boolean;
    MiddleEast: Boolean;
  end;
  LCID = DWORD;
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);
  PStrData = ^TStrData;

  TStrData = record
    Ident: Integer;
    Str: string;
  end;
  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

function AnsiCompareStr(const S1, S2: string): Integer;
function AnsiCompareText(const S1, S2: string): Integer;
function AnsiLowerCase(const S: string): string;
function AnsiPos(const Substr, S: string): Integer;
function AnsiReplaceStr(const AText, AFromText, AToText: string): string;
function AnsiStrPos(Str, SubStr: Pchar): Pchar;
function AnsiUpperCase(const S: string): string;
function ByteToCharIndex(const S: string; Index: Integer): Integer;
function ByteToCharLen(const S: string; MaxLen: Integer): Integer;
function ByteTypeTest(P: Pchar; Index: Integer): TMbcsByteType;
function CharLength(const S: string; Index: Integer): Integer;
function CharToByteIndex(const S: string; Index: Integer): Integer;
function CharToByteLen(const S: string; MaxLen: Integer): Integer;
function CompareText(const S1, S2: string): Integer; assembler;
function ContStr(s1, Separator, s2: string): string;
function DateTimeToStr(const DateTime: TDateTime): string;
function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
function DateToStr(const DateTime: TDateTime): string;
function DayOfWeek(const DateTime: TDateTime): Word;
function DecodeDateFully(const DateTime: TDateTime; var Year, Month, Day, DOW: Word): Boolean;
function EnumEraNames(Names: Pchar): Integer; stdcall;
function EnumEraYearOffsets(YearOffsets: Pchar): Integer; stdcall;
function ExtractFilePath(const FileName: string): string;
function FloatToStr(Value: Extended): string;
function FloatToText(BufferArg: Pchar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer): Integer; overload;
function FloatToText(BufferArg: Pchar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer; const FormatSettings: TFormatSettings): Integer;
  overload;
function FloatToTextFmt(Buf: Pchar; const Value; ValueType: TFloatValue; Format: Pchar): Integer;
  overload;
function FloatToTextFmt(Buf: Pchar; const Value; ValueType: TFloatValue;
  Format: Pchar; const FormatSettings: TFormatSettings): Integer; overload;
function Format(const Format: string; const Args: array of const): string;
function FormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal;
  const Args: array of const): Cardinal;
function FormatDateTime(const Format: string; DateTime: TDateTime): string; overload; inline;
function FormatDateTime(const Format: string; DateTime: TDateTime;
  const FormatSettings: TFormatSettings): string; overload;
function GetDateOrder(const DateFormat: string): TDateOrder;
function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char;
function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string;
function IntToHex(Value: Integer; Digits: Integer): string;
function IntToStr(Value: Integer): string;
function LastDelimiter(const Delimiters, S: string): Integer;
function LCIDToCodePage(ALcid: LCID): Integer;
function LoadStr(Ident: Integer): string;
function LowerCase(const S: string): string; overload;
function LowerCase(const S: string; LocaleOptions: TLocaleOptions): string; overload; inline;
function NextCharIndex(const S: string; Index: Integer): Integer;
function SameText(const S1, S2: string): Boolean;
function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
function ScanDate(const S: string; var Pos: Integer; var Date: TDateTime): Boolean; overload;
function ScanNumber(const S: string; var Pos: Integer; var Number: Word;
  var CharCount: Byte): Boolean;
function ScanString(const S: string; var Pos: Integer; const Symbol: string): Boolean;
function ScanTime(const S: string; var Pos: Integer; var Time: TDateTime): Boolean; overload;
function StrByteType(Str: Pchar; Index: Cardinal): TMbcsByteType;
function StrCharLength(const Str: Pchar): Integer;
function StrCopy(Dest: Pchar; const Source: Pchar): Pchar;
function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
function StrLComp(const Str1, Str2: Pchar; MaxLen: Cardinal): Integer;
function StrLCopy(Dest: Pchar; const Source: Pchar; MaxLen: Cardinal): Pchar;
function StrLen(const Str: Pchar): Cardinal;
function StrLIComp(const Str1, Str2: Pchar; MaxLen: Cardinal): Integer; assembler;
function StrMove(Dest: Pchar; const Source: Pchar; Count: Cardinal): Pchar;
function StrNextChar(const Str: Pchar): Pchar;
function StrPas(const Str: Pchar): string;
function StrPCopy(Dest: Pchar; const Source: string): Pchar;
function StrScan(const Str: Pchar; Chr: Char): Pchar;
function StrToDateDef(const S: string; const Default: TDateTime): TDateTime;
function StrToDateTimeDef(const S: string; const Default: TDateTime): TDateTime;
function StrToFloat(const S: string): Extended; overload;
function StrToFloat(const S: string; const FormatSettings: TFormatSettings): Extended; overload;
function StrToFloatDef(const S: string; const Default: Extended): Extended;
function StrToInt64(const S: string): Int64;
function StrToInt64Def(const S: string; const Default: Int64): Int64;
function StrToInt(const S: string): Integer;
function StrToIntDef(const S: string; Default: Integer): Integer;
function StrToTimeDef(const S: string; const Default: TDateTime): TDateTime;
function TextToFloat(Buffer: Pchar; var Value; ValueType: TFloatValue): Boolean; overload;
function TextToFloat(Buffer: Pchar; var Value; ValueType: TFloatValue;
  const FormatSettings: TFormatSettings): Boolean; overload;
function TimeToStr(const DateTime: TDateTime): string;
function TranslateDateFormat(const FormatStr: string): string;
function Trim(const S: string): string; overload;
function Trim(const S: Widestring): Widestring; overload;
function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;
function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
function TryStrToDate(const S: string; out Value: TDateTime): Boolean;
function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean;
function TryStrToInt(const S: string; out Value: Integer): Boolean;
function TryStrToTime(const S: string; out Value: TDateTime): Boolean;
function UpperCase(const S: string): string; overload;
function UpperCase(const S: string; LocaleOptions: TLocaleOptions): string; overload; inline;
procedure CountChars(const S: string; MaxChars: Integer; var CharCount, ByteCount: Integer);
procedure DateTimeToString(var Result: string; const Format: string;
  DateTime: TDateTime); overload;
procedure DateTimeToString(var Result: string; const Format: string;
  DateTime: TDateTime; const FormatSettings: TFormatSettings); overload;
procedure DecodeDate(const DateTime: TDateTime; var Year, Month, Day: Word);
procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);
procedure FloatToDecimal(var Result: TFloatRec; const Value; ValueType: TFloatValue;
  Precision, Decimals: Integer);
procedure FmtStr(var Result: string; const Format: string; const Args: array of const);
procedure FormatClearStr(var S: string);
procedure FormatError(ErrorCode: Integer; Format: Pchar; FmtLen: Cardinal);
function FormatFloat(const Format: string; Value: Extended): string; overload;
function FormatFloat(const Format: string; Value: Extended;
  const FormatSettings: TFormatSettings): string; overload;
procedure FormatVarToStr(var S: string; const V: TVarData);
procedure GetEraNamesAndYearOffsets;
procedure GetFormatSettings;
procedure GetMonthDayNames;
procedure InitSysLocale;
procedure PutExponent;
procedure ScanBlanks(const S: string; var Pos: Integer);
procedure ScanToNumber(const S: string; var Pos: Integer);

//------------------------------------------------------------------------//
type
 // Список строк с правильной сортировкой чисел
  TSortType = (stAsText, stAsNumbers);
 /////////////////// x ///////////////////
  TNumStrList = class (TStringList)
  private
    FDirection: TDirection;
    FSortType: TSortType;
    procedure SetDirection(const Value: TDirection);
    function GetIam: TNumStrList;
    function GetValues(x: Integer): Integer;
    procedure SetValues(x: Integer; const Value: Integer);
  protected
    function CompareStrings(const S1: string; const S2: string): Integer; override;
  public
    constructor Create;
    property Direction: TDirection read FDirection write SetDirection;
    property Iam: TNumStrList read GetIam;
    property Values[x: Integer]: Integer read GetValues write SetValues;
    property SortType: TSortType read FSortType write FSortType default stAsNumbers;
  end;

// Сравнение строк начинающихся с числа
function CompNumStr(s1, s2: string): Integer; overload;
function CompNumText(s1, s2: string): Integer; overload;
// Преобразование кода сообщения в название сообщения
function MsgToStr(Msg: Cardinal): string;
// Проверка наличия элемента в массиве
function EnteringS(S: string; ps: array of string): Integer;
// Преобразование данных в строку и обратно
function Int2Str(Value: Integer): string;
function Date2Str(Value: TDateTime): string;
function Time2Str(Value: TDateTime; TimeDats: TTimeDats = [tdHour..tdSecond]): string;
function Time2StrRus(Value: TDateTime): string;
function DateTime2Str(Value: TDateTime): string;
function Float2Str(Value: Extended; Digits: Integer = 2): string;
function Str2Int(Value: string): Integer;
function Str2Date(Value: string): TDateTime;
function Str2Time(Value: string): TDateTime;
function Str2DateTime(Value: string): TDateTime;
function Str2Float(Value: string): Extended;
// 16to10
function HexToInt(p_strHex: string): Integer;
// Запись числа прописными буквами
function propis(x: Real): string;
// Число в cтроку с нулями спереди
function ToZeroStr(n, l: Integer): string;
// Изменение строки разделённой ззапятыми
function ChangeCommaText(S, subS: string; index: Integer): string;
// Элемент строки с разделителями
function ItemOfCommaText(S: string; index: Integer): string;
// Элемент строки с разделителями
function CountCommaText(S: string): Integer;
// TStrings.Text без #13#10
function SolidText(sts: TStrings): string;
// Преобразование текста с запятыми к многострочному тексту
function CommaTextToText(ACommaText: string): string;
function TextToCommaText(AText: string): string;
/////////////////// x ///////////////////
function ChangeChar(var S: string; var Position: Integer; ch: Char): Boolean;
procedure ChangeCharPlus(var s: string; var Position: Integer; ch: Char);
procedure NewLine(var s: string; var Position: Integer);
procedure EmbbedStr(var S: string; Subst: string; var position: Integer; Len: Integer); overload;
procedure EmbbedStr(var S: string; Subst: string; var position: Integer); overload;
// Добавление пробелов к строке с нужной стороны
function LSpace(s: string; len: Integer; Cut: Boolean = true): string; // - слева
function RSpace(s: string; len: Integer; Cut: Boolean = true): string; // - справа
// Преобразование строки в DOS кодировку
function AsOEM(s: string): string;
// Преобразование строки в WinDOwS кодировку
function AsAnsi(s: string): string;
function ByteType(const S: string; Index: Integer): TMbcsByteType;
// Проверка число-нечисло
function IsNumber(s:string):boolean;

/////////////////// x ///////////////////
const
// 8087 status word masks
  mIE = $0001;
  mDE = $0002;
  mZE = $0004;
  mOE = $0008;
  mUE = $0010;
  mPE = $0020;
  mC0 = $0100;
  mC1 = $0200;
  mC2 = $0400;
  mC3 = $4000;
  MaxEraCount = 7;
/////////////////// x ///////////////////
const
  // 1E18 as a 64-bit integer
  Const1E18Lo = $0A7640000;
  Const1E18Hi = $00DE0B6B3;
  FCon1E18: Extended = 1E18;
  DCon10: Integer = 10;

var
  EraNames: array [1..MaxEraCount] of string;
  EraYearOffsets: array [1..MaxEraCount] of Integer;
  CurrencyString: string;
  CurrencyFormat: Byte;
  NegCurrFormat: Byte;
  ThousandSeparator: Char;
  DecimalSeparator: Char;
  CurrencyDecimals: Byte;
  DateSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  TimeSeparator: Char;
  TimeAMString: string;
  TimePMString: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
  ShortMonthNames: array[1..12] of string;
  LongMonthNames: array[1..12] of string;
  ShortDayNames: array[1..7] of string;
  LongDayNames: array[1..7] of string;
  SysLocale: TSysLocale;
  TwoDigitYearCenturyWindow: Word = 50;
  ListSeparator: Char;
  LeadBytes: set of Char = [];

const
  PathDelim = '\';
  DriveDelim = ':';
  PathSep = ';';

implementation

uses Messages, PublExcept, SysConst, Windows;

const
  CM_BASE = $B000;
  CM_ACTIVATE = CM_BASE + 0;
  CM_DEACTIVATE = CM_BASE + 1;
  CM_GOTFOCUS = CM_BASE + 2;
  CM_LOSTFOCUS = CM_BASE + 3;
  CM_CANCELMODE = CM_BASE + 4;
  CM_DIALOGKEY = CM_BASE + 5;
  CM_DIALOGCHAR = CM_BASE + 6;
  CM_FOCUSCHANGED = CM_BASE + 7;
  CM_PARENTFONTCHANGED = CM_BASE + 8;
  CM_PARENTCOLORCHANGED = CM_BASE + 9;
  CM_HITTEST = CM_BASE + 10;
  CM_VISIBLECHANGED = CM_BASE + 11;
  CM_ENABLEDCHANGED = CM_BASE + 12;
  CM_COLORCHANGED = CM_BASE + 13;
  CM_FONTCHANGED = CM_BASE + 14;
  CM_CURSORCHANGED = CM_BASE + 15;
  CM_CTL3DCHANGED = CM_BASE + 16;
  CM_PARENTCTL3DCHANGED = CM_BASE + 17;
  CM_TEXTCHANGED = CM_BASE + 18;
  CM_MOUSEENTER = CM_BASE + 19;
  CM_MOUSELEAVE = CM_BASE + 20;
  CM_MENUCHANGED = CM_BASE + 21;
  CM_APPKEYDOWN = CM_BASE + 22;
  CM_APPSYSCOMMAND = CM_BASE + 23;
  CM_BUTTONPRESSED = CM_BASE + 24;
  CM_SHOWINGCHANGED = CM_BASE + 25;
  CM_ENTER = CM_BASE + 26;
  CM_EXIT = CM_BASE + 27;
  CM_DESIGNHITTEST = CM_BASE + 28;
  CM_ICONCHANGED = CM_BASE + 29;
  CM_WANTSPECIALKEY = CM_BASE + 30;
  CM_INVOKEHELP = CM_BASE + 31;
  CM_WINDOWHOOK = CM_BASE + 32;
  CM_RELEASE = CM_BASE + 33;
  CM_SHOWHINTCHANGED = CM_BASE + 34;
  CM_PARENTSHOWHINTCHANGED = CM_BASE + 35;
  CM_SYSCOLORCHANGE = CM_BASE + 36;
  CM_WININICHANGE = CM_BASE + 37;
  CM_FONTCHANGE = CM_BASE + 38;
  CM_TIMECHANGE = CM_BASE + 39;
  CM_TABSTOPCHANGED = CM_BASE + 40;
  CM_UIACTIVATE = CM_BASE + 41;
  CM_UIDEACTIVATE = CM_BASE + 42;
  CM_DOCWINDOWACTIVATE = CM_BASE + 43;
  CM_CONTROLLISTCHANGE = CM_BASE + 44;
  CM_GETDATALINK = CM_BASE + 45;
  CM_CHILDKEY = CM_BASE + 46;
  CM_DRAG = CM_BASE + 47;
  CM_HINTSHOW = CM_BASE + 48;
  CM_DIALOGHANDLE = CM_BASE + 49;
  CM_ISTOOLCONTROL = CM_BASE + 50;
  CM_RECREATEWND = CM_BASE + 51;
  CM_INVALIDATE = CM_BASE + 52;
  CM_SYSFONTCHANGED = CM_BASE + 53;
  CM_CONTROLCHANGE = CM_BASE + 54;
  CM_CHANGED = CM_BASE + 55;
  CM_DOCKCLIENT = CM_BASE + 56;
  CM_UNDOCKCLIENT = CM_BASE + 57;
  CM_FLOAT = CM_BASE + 58;
  CM_BORDERCHANGED = CM_BASE + 59;
  CM_BIDIMODECHANGED = CM_BASE + 60;
  CM_PARENTBIDIMODECHANGED = CM_BASE + 61;
  CM_ALLCHILDRENFLIPPED = CM_BASE + 62;
  CM_ACTIONUPDATE = CM_BASE + 63;
  CM_ACTIONEXECUTE = CM_BASE + 64;
  CM_HINTSHOWPAUSE = CM_BASE + 65;
  CM_DOCKNOTIFICATION = CM_BASE + 66;
  CM_MOUSEWHEEL = CM_BASE + 67;
  CM_ISSHORTCUT = CM_BASE + 68;
{$IFDEF LINUX}
  CM_RAWX11EVENT = CM_BASE + 69;
{$ENDIF}
{ VCL control notification IDs }
const
  CN_BASE = $BC00;
  CN_CHARTOITEM = CN_BASE + WM_CHARTOITEM;
  CN_COMMAND = CN_BASE + WM_COMMAND;
  CN_COMPAREITEM = CN_BASE + WM_COMPAREITEM;
  CN_CTLCOLORBTN = CN_BASE + WM_CTLCOLORBTN;
  CN_CTLCOLORDLG = CN_BASE + WM_CTLCOLORDLG;
  CN_CTLCOLOREDIT = CN_BASE + WM_CTLCOLOREDIT;
  CN_CTLCOLORLISTBOX = CN_BASE + WM_CTLCOLORLISTBOX;
  CN_CTLCOLORMSGBOX = CN_BASE + WM_CTLCOLORMSGBOX;
  CN_CTLCOLORSCROLLBAR = CN_BASE + WM_CTLCOLORSCROLLBAR;
  CN_CTLCOLORSTATIC = CN_BASE + WM_CTLCOLORSTATIC;
  CN_DELETEITEM = CN_BASE + WM_DELETEITEM;
  CN_DRAWITEM = CN_BASE + WM_DRAWITEM;
  CN_HSCROLL = CN_BASE + WM_HSCROLL;
  CN_MEASUREITEM = CN_BASE + WM_MEASUREITEM;
  CN_PARENTNOTIFY = CN_BASE + WM_PARENTNOTIFY;
  CN_VKEYTOITEM = CN_BASE + WM_VKEYTOITEM;
  CN_VSCROLL = CN_BASE + WM_VSCROLL;
  CN_KEYDOWN = CN_BASE + WM_KEYDOWN;
  CN_KEYUP = CN_BASE + WM_KEYUP;
  CN_CHAR = CN_BASE + WM_CHAR;
  CN_SYSKEYDOWN = CN_BASE + WM_SYSKEYDOWN;
  CN_SYSCHAR = CN_BASE + WM_SYSCHAR;
  CN_NOTIFY = CN_BASE + WM_NOTIFY;

{function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;}

{ TNumStrList }

function TNumStrList.CompareStrings(const S1, S2: string): Integer;
var
  k: Integer;
  l1, l2: Integer;
  st1, st2: string;
begin
  if fDirection = drIncrease then
    k := 1
  else
    k := -1;
  st1 := s1;
  st2 := s2;
  l1 := Length(st1);
  l2 := Length(st2);
  if l1 > l2 + 1 then
    SetLength(st1, l2 + 1)
  else
  if l1 + 1 < l2 then
    SetLength(st2, l1 + 1);
  if CaseSensitive then
    if SortType = stAsText then
      Result := k * AnsiCompareStr(st1, st2)
    else
      Result := k * PublStr.CompNumStr(st1, st2)
  else
  if SortType = stAsText then
    Result := k * AnsiCompareText(st1, st2)
  else
    Result := k * CompNumText(st1, st2);
end;

constructor TNumStrList.Create;
begin
  inherited;
  FDirection := drIncrease;
  FSortType := stAsNumbers;
end;

function TNumStrList.GetIam: TNumStrList;
begin
  result := self;
end;

function TNumStrList.GetValues(x: Integer): Integer;
begin
  Result := Integer(Objects[x]);
end;

procedure TNumStrList.SetDirection(const Value: TDirection);
begin
  FDirection := Value;
  if Sorted then
    Sort;
end;

procedure TNumStrList.SetValues(x: Integer; const Value: Integer);
begin
  Objects[x] := TObject(Value);
end;

function CompNumStr(s1, s2: string): Integer; //overload;
var
  s, ns: array[1..2] of string;
  n, x: array[1..2] of Int64;
  i, j: Integer;
begin
  result := 0;
  if s1 = s2 then
    Exit;
  s[1] := trim(s1);
  s[2] := trim(s2);
  for j := 1 to 2 do
  begin
    ns[j] := '';
    for i := 1 to Min(18, Length(s[j])) do
      if s[j][1] in ['0'..'9'] then
      begin
        ns[j] := ns[j] + s[j][1];
        Delete(s[j], 1, 1);
      end
      else
        break;
    if ns[j] <> '' then
    begin
      x[j] := 1;
      n[j] := StrToInt64(ns[j]);
    end
    else
      x[j] := 2;
  end;
  i := x[1] * 10 + x[2];
  case i of
    11:
    begin
      result := n[1] - n[2];
      if result = 0 then
        result := CompNumStr(s[1], s[2]);
    end;
    12:
      result := -1;
    21:
      result := 1;
    22:
      if (length(s[1]) = 0) or (length(s[2]) = 0) or (s[1][1] <> s[2][1]) then
        result := AnsiCompareStr(s[1], s[2])
      else
      begin
        while (length(s[1]) > 0) and (length(s[2]) > 0) and (s[1][1] = s[2][1]) and
          not (s[1][1] in ['0'..'9']) do
        begin
          Delete(s[1], 1, 1);
          Delete(s[2], 1, 1);
        end;
        result := CompNumStr(s[1], s[2]);
      end;
  else
    result := 0;
  end;
end;

function CompNumText(s1, s2: string): Integer; //overload;
var
  s, ns: array[1..2] of string;
  n, x: array[1..2] of Int64;
  i, j: Integer;
begin
  result := 0;
  if SameText(s1, s2) then
    Exit;
  s[1] := s1;
  s[2] := s2;
  for j := 1 to 2 do
  begin
    ns[j] := '';
    for i := 1 to Min(Length(s[j]), 18) do
      if s[j][1] in ['0'..'9'] then
      begin
        ns[j] := ns[j] + s[j][1];
        Delete(s[j], 1, 1);
      end
      else
        break;
    if ns[j] <> '' then
    begin
      x[j] := 1;
      n[j] := StrToInt64(ns[j]);
    end
    else
      x[j] := 2;
  end;
  i := x[1] * 10 + x[2];
  case i of
    11:
    begin
      result := n[1] - n[2];
      if result = 0 then
        result := CompNumText(s[1], s[2]);
    end;
    12:
      result := -1;
    21:
      result := 1;
    22:
      if (length(s[1]) = 0) or (length(s[2]) = 0) or (s[1][1] <> s[2][1]) then
        result := AnsiCompareText(s[1], s[2])
      else
      begin
        while (length(s[1]) > 0) and (length(s[2]) > 0) and (s[1][1] = s[2][1]) and
          not (s[1][1] in ['0'..'9']) do
        begin
          Delete(s[1], 1, 1);
          Delete(s[2], 1, 1);
        end;
        result := CompNumText(s[1], s[2]);
      end;
  else
    result := 0;
  end;
end;

function MsgToStr(Msg: Cardinal): string;
begin
  case msg of
    WM_NULL:
      result := 'WM_NULL';
    WM_CREATE:
      result := 'WM_CREATE';
    WM_DESTROY:
      result := 'WM_DESTROY';
    WM_MOVE:
      result := 'WM_MOVE';
    WM_SIZE:
      result := 'WM_SIZE';
    WM_ACTIVATE:
      result := 'WM_ACTIVATE';
    WM_SETFOCUS:
      result := 'WM_SETFOCUS';
    WM_KILLFOCUS:
      result := 'WM_KILLFOCUS';
    WM_ENABLE:
      result := 'WM_ENABLE';
    WM_SETREDRAW:
      result := 'WM_SETREDRAW';
    WM_SETTEXT:
      result := 'WM_SETTEXT';
    WM_GETTEXT:
      result := 'WM_GETTEXT';
    WM_GETTEXTLENGTH:
      result := 'WM_GETTEXTLENGTH';
    WM_PAINT:
      result := 'WM_PAINT';
    WM_CLOSE:
      result := 'WM_CLOSE';
    WM_QUERYENDSESSION:
      result := 'WM_QUERYENDSESSION';
    WM_QUIT:
      result := 'WM_QUIT';
    WM_QUERYOPEN:
      result := 'WM_QUERYOPEN';
    WM_ERASEBKGND:
      result := 'WM_ERASEBKGND';
    WM_SYSCOLORCHANGE:
      result := 'WM_SYSCOLORCHANGE';
    WM_ENDSESSION:
      result := 'WM_ENDSESSION';
    WM_SYSTEMERROR:
      result := 'WM_SYSTEMERROR';
    WM_SHOWWINDOW:
      result := 'WM_SHOWWINDOW';
    WM_CTLCOLOR:
      result := 'WM_CTLCOLOR';
    WM_WININICHANGE:
      result := 'WM_WININICHANGE';
    WM_DEVMODECHANGE:
      result := 'WM_DEVMODECHANGE';
    WM_ACTIVATEAPP:
      result := 'WM_ACTIVATEAPP';
    WM_FONTCHANGE:
      result := 'WM_FONTCHANGE';
    WM_TIMECHANGE:
      result := 'WM_TIMECHANGE';
    WM_CANCELMODE:
      result := 'WM_CANCELMODE';
    WM_SETCURSOR:
      result := 'WM_SETCURSOR';
    WM_MOUSEACTIVATE:
      result := 'WM_MOUSEACTIVATE';
    WM_CHILDACTIVATE:
      result := 'WM_CHILDACTIVATE';
    WM_QUEUESYNC:
      result := 'WM_QUEUESYNC';
    WM_GETMINMAXINFO:
      result := 'WM_GETMINMAXINFO';
    WM_PAINTICON:
      result := 'WM_PAINTICON';
    WM_ICONERASEBKGND:
      result := 'WM_ICONERASEBKGND';
    WM_NEXTDLGCTL:
      result := 'WM_NEXTDLGCTL';
    WM_SPOOLERSTATUS:
      result := 'WM_SPOOLERSTATUS';
    WM_DRAWITEM:
      result := 'WM_DRAWITEM';
    WM_MEASUREITEM:
      result := 'WM_MEASUREITEM';
    WM_DELETEITEM:
      result := 'WM_DELETEITEM';
    WM_VKEYTOITEM:
      result := 'WM_VKEYTOITEM';
    WM_CHARTOITEM:
      result := 'WM_CHARTOITEM';
    WM_SETFONT:
      result := 'WM_SETFONT';
    WM_GETFONT:
      result := 'WM_GETFONT';
    WM_SETHOTKEY:
      result := 'WM_SETHOTKEY';
    WM_GETHOTKEY:
      result := 'WM_GETHOTKEY';
    WM_QUERYDRAGICON:
      result := 'WM_QUERYDRAGICON';
    WM_COMPAREITEM:
      result := 'WM_COMPAREITEM';
    WM_GETOBJECT:
      result := 'WM_GETOBJECT';
    WM_COMPACTING:
      result := 'WM_COMPACTING';
    WM_COMMNOTIFY:
      result := 'WM_COMMNOTIFY';
    WM_WINDOWPOSCHANGING:
      result := 'WM_WINDOWPOSCHANGING';
    WM_WINDOWPOSCHANGED:
      result := 'WM_WINDOWPOSCHANGED';
    WM_POWER:
      result := 'WM_POWER';
    WM_COPYDATA:
      result := 'WM_COPYDATA';
    WM_CANCELJOURNAL:
      result := 'WM_CANCELJOURNAL';
    WM_NOTIFY:
      result := 'WM_NOTIFY';
    WM_INPUTLANGCHANGEREQUEST:
      result := 'WM_INPUTLANGCHANGEREQUEST';
    WM_INPUTLANGCHANGE:
      result := 'WM_INPUTLANGCHANGE';
    WM_TCARD:
      result := 'WM_TCARD';
    WM_HELP:
      result := 'WM_HELP';
    WM_USERCHANGED:
      result := 'WM_USERCHANGED';
    WM_NOTIFYFORMAT:
      result := 'WM_NOTIFYFORMAT';
    WM_CONTEXTMENU:
      result := 'WM_CONTEXTMENU';
    WM_STYLECHANGING:
      result := 'WM_STYLECHANGING';
    WM_STYLECHANGED:
      result := 'WM_STYLECHANGED';
    WM_DISPLAYCHANGE:
      result := 'WM_DISPLAYCHANGE';
    WM_GETICON:
      result := 'WM_GETICON';
    WM_SETICON:
      result := 'WM_SETICON';
    WM_NCCREATE:
      result := 'WM_NCCREATE';
    WM_NCDESTROY:
      result := 'WM_NCDESTROY';
    WM_NCCALCSIZE:
      result := 'WM_NCCALCSIZE';
    WM_NCHITTEST:
      result := 'WM_NCHITTEST';
    WM_NCPAINT:
      result := 'WM_NCPAINT';
    WM_NCACTIVATE:
      result := 'WM_NCACTIVATE';
    WM_GETDLGCODE:
      result := 'WM_GETDLGCODE';
    WM_NCMOUSEMOVE:
      result := 'WM_NCMOUSEMOVE';
    WM_NCLBUTTONDOWN:
      result := 'WM_NCLBUTTONDOWN';
    WM_NCLBUTTONUP:
      result := 'WM_NCLBUTTONUP';
    WM_NCLBUTTONDBLCLK:
      result := 'WM_NCLBUTTONDBLCLK';
    WM_NCRBUTTONDOWN:
      result := 'WM_NCRBUTTONDOWN';
    WM_NCRBUTTONUP:
      result := 'WM_NCRBUTTONUP';
    WM_NCRBUTTONDBLCLK:
      result := 'WM_NCRBUTTONDBLCLK';
    WM_NCMBUTTONDOWN:
      result := 'WM_NCMBUTTONDOWN';
    WM_NCMBUTTONUP:
      result := 'WM_NCMBUTTONUP';
    WM_NCMBUTTONDBLCLK:
      result := 'WM_NCMBUTTONDBLCLK';
    WM_NCXBUTTONDOWN:
      result := 'WM_NCXBUTTONDOWN';
    WM_NCXBUTTONUP:
      result := 'WM_NCXBUTTONUP';
    WM_NCXBUTTONDBLCLK:
      result := 'WM_NCXBUTTONDBLCLK';
    WM_INPUT:
      result := 'WM_INPUT';
    WM_KEYDOWN:
      result := 'WM_KEYDOWN';
    WM_KEYUP:
      result := 'WM_KEYUP';
    WM_CHAR:
      result := 'WM_CHAR';
    WM_DEADCHAR:
      result := 'WM_DEADCHAR';
    WM_SYSKEYDOWN:
      result := 'WM_SYSKEYDOWN';
    WM_SYSKEYUP:
      result := 'WM_SYSKEYUP';
    WM_SYSCHAR:
      result := 'WM_SYSCHAR';
    WM_SYSDEADCHAR:
      result := 'WM_SYSDEADCHAR';
    WM_KEYLAST:
      result := 'WM_KEYLAST';
    WM_INITDIALOG:
      result := 'WM_INITDIALOG';
    WM_COMMAND:
      result := 'WM_COMMAND';
    WM_SYSCOMMAND:
      result := 'WM_SYSCOMMAND';
    WM_TIMER:
      result := 'WM_TIMER';
    WM_HSCROLL:
      result := 'WM_HSCROLL';
    WM_VSCROLL:
      result := 'WM_VSCROLL';
    WM_INITMENU:
      result := 'WM_INITMENU';
    WM_INITMENUPOPUP:
      result := 'WM_INITMENUPOPUP';
    WM_MENUSELECT:
      result := 'WM_MENUSELECT';
    WM_MENUCHAR:
      result := 'WM_MENUCHAR';
    WM_ENTERIDLE:
      result := 'WM_ENTERIDLE';
    WM_MENURBUTTONUP:
      result := 'WM_MENURBUTTONUP';
    WM_MENUDRAG:
      result := 'WM_MENUDRAG';
    WM_MENUGETOBJECT:
      result := 'WM_MENUGETOBJECT';
    WM_UNINITMENUPOPUP:
      result := 'WM_UNINITMENUPOPUP';
    WM_MENUCOMMAND:
      result := 'WM_MENUCOMMAND';
    WM_CHANGEUISTATE:
      result := 'WM_CHANGEUISTATE';
    WM_UPDATEUISTATE:
      result := 'WM_UPDATEUISTATE';
    WM_QUERYUISTATE:
      result := 'WM_QUERYUISTATE';
    WM_CTLCOLORMSGBOX:
      result := 'WM_CTLCOLORMSGBOX';
    WM_CTLCOLOREDIT:
      result := 'WM_CTLCOLOREDIT';
    WM_CTLCOLORLISTBOX:
      result := 'WM_CTLCOLORLISTBOX';
    WM_CTLCOLORBTN:
      result := 'WM_CTLCOLORBTN';
    WM_CTLCOLORDLG:
      result := 'WM_CTLCOLORDLG';
    WM_CTLCOLORSCROLLBAR:
      result := 'WM_CTLCOLORSCROLLBAR';
    WM_CTLCOLORSTATIC:
      result := 'WM_CTLCOLORSTATIC';
    WM_MOUSEMOVE:
      result := 'WM_MOUSEMOVE';
    WM_LBUTTONDOWN:
      result := 'WM_LBUTTONDOWN';
    WM_LBUTTONUP:
      result := 'WM_LBUTTONUP';
    WM_LBUTTONDBLCLK:
      result := 'WM_LBUTTONDBLCLK';
    WM_RBUTTONDOWN:
      result := 'WM_RBUTTONDOWN';
    WM_RBUTTONUP:
      result := 'WM_RBUTTONUP';
    WM_RBUTTONDBLCLK:
      result := 'WM_RBUTTONDBLCLK';
    WM_MBUTTONDOWN:
      result := 'WM_MBUTTONDOWN';
    WM_MBUTTONUP:
      result := 'WM_MBUTTONUP';
    WM_MBUTTONDBLCLK:
      result := 'WM_MBUTTONDBLCLK';
    WM_MOUSEWHEEL:
      result := 'WM_MOUSEWHEEL';
    WM_PARENTNOTIFY:
      result := 'WM_PARENTNOTIFY';
    WM_ENTERMENULOOP:
      result := 'WM_ENTERMENULOOP';
    WM_EXITMENULOOP:
      result := 'WM_EXITMENULOOP';
    WM_NEXTMENU:
      result := 'WM_NEXTMENU';
    WM_SIZING:
      result := 'WM_SIZING';
    WM_CAPTURECHANGED:
      result := 'WM_CAPTURECHANGED';
    WM_MOVING:
      result := 'WM_MOVING';
    WM_POWERBROADCAST:
      result := 'WM_POWERBROADCAST';
    WM_DEVICECHANGE:
      result := 'WM_DEVICECHANGE';
    WM_IME_STARTCOMPOSITION:
      result := 'WM_IME_STARTCOMPOSITION';
    WM_IME_ENDCOMPOSITION:
      result := 'WM_IME_ENDCOMPOSITION';
    WM_IME_COMPOSITION:
      result := 'WM_IME_COMPOSITION';
    WM_IME_SETCONTEXT:
      result := 'WM_IME_SETCONTEXT';
    WM_IME_NOTIFY:
      result := 'WM_IME_NOTIFY';
    WM_IME_CONTROL:
      result := 'WM_IME_CONTROL';
    WM_IME_COMPOSITIONFULL:
      result := 'WM_IME_COMPOSITIONFULL';
    WM_IME_SELECT:
      result := 'WM_IME_SELECT';
    WM_IME_CHAR:
      result := 'WM_IME_CHAR';
    WM_IME_REQUEST:
      result := 'WM_IME_REQUEST';
    WM_IME_KEYDOWN:
      result := 'WM_IME_KEYDOWN';
    WM_IME_KEYUP:
      result := 'WM_IME_KEYUP';
    WM_MDICREATE:
      result := 'WM_MDICREATE';
    WM_MDIDESTROY:
      result := 'WM_MDIDESTROY';
    WM_MDIACTIVATE:
      result := 'WM_MDIACTIVATE';
    WM_MDIRESTORE:
      result := 'WM_MDIRESTORE';
    WM_MDINEXT:
      result := 'WM_MDINEXT';
    WM_MDIMAXIMIZE:
      result := 'WM_MDIMAXIMIZE';
    WM_MDITILE:
      result := 'WM_MDITILE';
    WM_MDICASCADE:
      result := 'WM_MDICASCADE';
    WM_MDIICONARRANGE:
      result := 'WM_MDIICONARRANGE';
    WM_MDIGETACTIVE:
      result := 'WM_MDIGETACTIVE';
    WM_MDISETMENU:
      result := 'WM_MDISETMENU';
    WM_ENTERSIZEMOVE:
      result := 'WM_ENTERSIZEMOVE';
    WM_EXITSIZEMOVE:
      result := 'WM_EXITSIZEMOVE';
    WM_DROPFILES:
      result := 'WM_DROPFILES';
    WM_MDIREFRESHMENU:
      result := 'WM_MDIREFRESHMENU';
    WM_MOUSEHOVER:
      result := 'WM_MOUSEHOVER';
    WM_MOUSELEAVE:
      result := 'WM_MOUSELEAVE';
    WM_NCMOUSEHOVER:
      result := 'WM_NCMOUSEHOVER';
    WM_NCMOUSELEAVE:
      result := 'WM_NCMOUSELEAVE';
    WM_WTSSESSION_CHANGE:
      result := 'WM_WTSSESSION_CHANGE';
    WM_TABLET_FIRST:
      result := 'WM_TABLET_FIRST';
    WM_TABLET_LAST:
      result := 'WM_TABLET_LAST';
    WM_CUT:
      result := 'WM_CUT';
    WM_COPY:
      result := 'WM_COPY';
    WM_PASTE:
      result := 'WM_PASTE';
    WM_CLEAR:
      result := 'WM_CLEAR';
    WM_UNDO:
      result := 'WM_UNDO';
    WM_RENDERFORMAT:
      result := 'WM_RENDERFORMAT';
    WM_RENDERALLFORMATS:
      result := 'WM_RENDERALLFORMATS';
    WM_DESTROYCLIPBOARD:
      result := 'WM_DESTROYCLIPBOARD';
    WM_DRAWCLIPBOARD:
      result := 'WM_DRAWCLIPBOARD';
    WM_PAINTCLIPBOARD:
      result := 'WM_PAINTCLIPBOARD';
    WM_VSCROLLCLIPBOARD:
      result := 'WM_VSCROLLCLIPBOARD';
    WM_SIZECLIPBOARD:
      result := 'WM_SIZECLIPBOARD';
    WM_ASKCBFORMATNAME:
      result := 'WM_ASKCBFORMATNAME';
    WM_CHANGECBCHAIN:
      result := 'WM_CHANGECBCHAIN';
    WM_HSCROLLCLIPBOARD:
      result := 'WM_HSCROLLCLIPBOARD';
    WM_QUERYNEWPALETTE:
      result := 'WM_QUERYNEWPALETTE';
    WM_PALETTEISCHANGING:
      result := 'WM_PALETTEISCHANGING';
    WM_PALETTECHANGED:
      result := 'WM_PALETTECHANGED';
    WM_HOTKEY:
      result := 'WM_HOTKEY';
    WM_PRINT:
      result := 'WM_PRINT';
    WM_PRINTCLIENT:
      result := 'WM_PRINTCLIENT';
    WM_APPCOMMAND:
      result := 'WM_APPCOMMAND';
    WM_THEMECHANGED:
      result := 'WM_THEMECHANGED';
    WM_HANDHELDFIRST:
      result := 'WM_HANDHELDFIRST';
    WM_HANDHELDLAST:
      result := 'WM_HANDHELDLAST';
    WM_PENWINFIRST:
      result := 'WM_PENWINFIRST';
    WM_PENWINLAST:
      result := 'WM_PENWINLAST';
    WM_COALESCE_FIRST:
      result := 'WM_COALESCE_FIRST';
    WM_COALESCE_LAST:
      result := 'WM_COALESCE_LAST';
    WM_DDE_FIRST:
      result := 'WM_DDE_FIRST';
    WM_DDE_TERMINATE:
      result := 'WM_DDE_TERMINATE';
    WM_DDE_ADVISE:
      result := 'WM_DDE_ADVISE';
    WM_DDE_UNADVISE:
      result := 'WM_DDE_UNADVISE';
    WM_DDE_ACK:
      result := 'WM_DDE_ACK';
    WM_DDE_DATA:
      result := 'WM_DDE_DATA';
    WM_DDE_REQUEST:
      result := 'WM_DDE_REQUEST';
    WM_DDE_POKE:
      result := 'WM_DDE_POKE';
    WM_DDE_EXECUTE:
      result := 'WM_DDE_EXECUTE';
    WM_APP:
      result := 'WM_APP';
    WM_USER:
      result := 'WM_USER';
    CM_ACTIVATE:
      result := 'CM_ACTIVATE';
    CM_DEACTIVATE:
      result := 'CM_DEACTIVATE';
    CM_GOTFOCUS:
      result := 'CM_GOTFOCUS';
    CM_LOSTFOCUS:
      result := 'CM_LOSTFOCUS';
    CM_CANCELMODE:
      result := 'CM_CANCELMODE';
    CM_DIALOGKEY:
      result := 'CM_DIALOGKEY';
    CM_DIALOGCHAR:
      result := 'CM_DIALOGCHAR';
    CM_FOCUSCHANGED:
      result := 'CM_FOCUSCHANGED';
    CM_PARENTFONTCHANGED:
      result := 'CM_PARENTFONTCHANGED';
    CM_PARENTCOLORCHANGED:
      result := 'CM_PARENTCOLORCHANGED';
    CM_HITTEST:
      result := 'CM_HITTEST';
    CM_VISIBLECHANGED:
      result := 'CM_VISIBLECHANGED';
    CM_ENABLEDCHANGED:
      result := 'CM_ENABLEDCHANGED';
    CM_COLORCHANGED:
      result := 'CM_COLORCHANGED';
    CM_FONTCHANGED:
      result := 'CM_FONTCHANGED';
    CM_CURSORCHANGED:
      result := 'CM_CURSORCHANGED';
    CM_CTL3DCHANGED:
      result := 'CM_CTL3DCHANGED';
    CM_PARENTCTL3DCHANGED:
      result := 'CM_PARENTCTL3DCHANGED';
    CM_TEXTCHANGED:
      result := 'CM_TEXTCHANGED';
    CM_MOUSEENTER:
      result := 'CM_MOUSEENTER';
    CM_MOUSELEAVE:
      result := 'CM_MOUSELEAVE';
    CM_MENUCHANGED:
      result := 'CM_MENUCHANGED';
    CM_APPKEYDOWN:
      result := 'CM_APPKEYDOWN';
    CM_APPSYSCOMMAND:
      result := 'CM_APPSYSCOMMAND';
    CM_BUTTONPRESSED:
      result := 'CM_BUTTONPRESSED';
    CM_SHOWINGCHANGED:
      result := 'CM_SHOWINGCHANGED';
    CM_ENTER:
      result := 'CM_ENTER';
    CM_EXIT:
      result := 'CM_EXIT';
    CM_DESIGNHITTEST:
      result := 'CM_DESIGNHITTEST';
    CM_ICONCHANGED:
      result := 'CM_ICONCHANGED';
    CM_WANTSPECIALKEY:
      result := 'CM_WANTSPECIALKEY';
    CM_INVOKEHELP:
      result := 'CM_INVOKEHELP';
    CM_WINDOWHOOK:
      result := 'CM_WINDOWHOOK';
    CM_RELEASE:
      result := 'CM_RELEASE';
    CM_SHOWHINTCHANGED:
      result := 'CM_SHOWHINTCHANGED';
    CM_PARENTSHOWHINTCHANGED:
      result := 'CM_PARENTSHOWHINTCHANGED';
    CM_SYSCOLORCHANGE:
      result := 'CM_SYSCOLORCHANGE';
    CM_WININICHANGE:
      result := 'CM_WININICHANGE';
    CM_FONTCHANGE:
      result := 'CM_FONTCHANGE';
    CM_TIMECHANGE:
      result := 'CM_TIMECHANGE';
    CM_TABSTOPCHANGED:
      result := 'CM_TABSTOPCHANGED';
    CM_UIACTIVATE:
      result := 'CM_UIACTIVATE';
    CM_UIDEACTIVATE:
      result := 'CM_UIDEACTIVATE';
    CM_DOCWINDOWACTIVATE:
      result := 'CM_DOCWINDOWACTIVATE';
    CM_CONTROLLISTCHANGE:
      result := 'CM_CONTROLLISTCHANGE';
    CM_GETDATALINK:
      result := 'CM_GETDATALINK';
    CM_CHILDKEY:
      result := 'CM_CHILDKEY';
    CM_DRAG:
      result := 'CM_DRAG';
    CM_HINTSHOW:
      result := 'CM_HINTSHOW';
    CM_DIALOGHANDLE:
      result := 'CM_DIALOGHANDLE';
    CM_ISTOOLCONTROL:
      result := 'CM_ISTOOLCONTROL';
    CM_RECREATEWND:
      result := 'CM_RECREATEWND';
    CM_INVALIDATE:
      result := 'CM_INVALIDATE';
    CM_SYSFONTCHANGED:
      result := 'CM_SYSFONTCHANGED';
    CM_CONTROLCHANGE:
      result := 'CM_CONTROLCHANGE';
    CM_CHANGED:
      result := 'CM_CHANGED';
    CM_DOCKCLIENT:
      result := 'CM_DOCKCLIENT';
    CM_UNDOCKCLIENT:
      result := 'CM_UNDOCKCLIENT';
    CM_FLOAT:
      result := 'CM_FLOAT';
    CM_BORDERCHANGED:
      result := 'CM_BORDERCHANGED';
    CM_BIDIMODECHANGED:
      result := 'CM_BIDIMODECHANGED';
    CM_PARENTBIDIMODECHANGED:
      result := 'CM_PARENTBIDIMODECHANGED';
    CM_ALLCHILDRENFLIPPED:
      result := 'CM_ALLCHILDRENFLIPPED';
    CM_ACTIONUPDATE:
      result := 'CM_ACTIONUPDATE';
    CM_ACTIONEXECUTE:
      result := 'CM_ACTIONEXECUTE';
    CM_HINTSHOWPAUSE:
      result := 'CM_HINTSHOWPAUSE';
    CM_DOCKNOTIFICATION:
      result := 'CM_DOCKNOTIFICATION';
    CM_MOUSEWHEEL:
      result := 'CM_MOUSEWHEEL';
    CM_ISSHORTCUT:
      result := 'CM_ISSHORTCUT';
    CN_BASE:
      result := 'CN_BASE';
    CN_CHARTOITEM:
      result := 'CN_CHARTOITEM';
    CN_COMMAND:
      result := 'CN_COMMAND';
    CN_COMPAREITEM:
      result := 'CN_COMPAREITEM';
    CN_CTLCOLORBTN:
      result := 'CN_CTLCOLORBTN';
    CN_CTLCOLORDLG:
      result := 'CN_CTLCOLORDLG';
    CN_CTLCOLOREDIT:
      result := 'CN_CTLCOLOREDIT';
    CN_CTLCOLORLISTBOX:
      result := 'CN_CTLCOLORLISTBOX';
    CN_CTLCOLORMSGBOX:
      result := 'CN_CTLCOLORMSGBOX';
    CN_CTLCOLORSCROLLBAR:
      result := 'CN_CTLCOLORSCROLLBAR';
    CN_CTLCOLORSTATIC:
      result := 'CN_CTLCOLORSTATIC';
    CN_DELETEITEM:
      result := 'CN_DELETEITEM';
    CN_DRAWITEM:
      result := 'CN_DRAWITEM';
    CN_HSCROLL:
      result := 'CN_HSCROLL';
    CN_MEASUREITEM:
      result := 'CN_MEASUREITEM';
    CN_PARENTNOTIFY:
      result := 'CN_PARENTNOTIFY';
    CN_VKEYTOITEM:
      result := 'CN_VKEYTOITEM';
    CN_VSCROLL:
      result := 'CN_VSCROLL';
    CN_KEYDOWN:
      result := 'CN_KEYDOWN';
    CN_KEYUP:
      result := 'CN_KEYUP';
    CN_CHAR:
      result := 'CN_CHAR';
    CN_SYSKEYDOWN:
      result := 'CN_SYSKEYDOWN';
    CN_SYSCHAR:
      result := 'CN_SYSCHAR';
    CN_NOTIFY:
      result := 'CN_NOTIFY';
  else
    result := 'WM_' + IntToHex(msg, 8);
  end;
end;

function EnteringS(S: string; ps: array of string): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to High(ps) do
    if SameText(s, ps[i]) then
    begin
      result := i;
      break;
    end;
end;

function Int2Str(Value: Integer): string;
begin
  if Value = ImpossibleInt then
    result := ''
  else
    Result := IntToStr(Value);
end;

function Date2Str(Value: TDateTime): string;
begin
  if IsNan(Value) then
    result := ''
  else
    Result := DateToStr(Value);
end;

function Time2StrRus(Value: TDateTime): string;
var
  h, m, s, ms: Word;
  st: string;
begin
  st := '';
  DecodeTime(Value, h, m, s, ms);
  if h > 0 then
    st := Format('%d час(а,ов), %d мин', [h, m])
  else
  if m > 0 then
    st := Format('%d мин,  %d сек', [m, s])
  else
    st := Format('%d cек', [s, ms]);
  Result := st;
end;

function Time2Str(Value: TDateTime; TimeDats: TTimeDats): string;
var
  s, s2: string;
  p: Integer;
begin
  if IsNan(Value) then
    result := ''
  else
  begin
    s := LongTimeFormat;
    s2 := 'h';
    if tdMinute in TimeDats then
      s2 := ContStr(s2, ':', 'mm');
    if tdSecond in TimeDats then
      s2 := ContStr(s2, ':', 'ss');
    if tdMilliSecond in TimeDats then
      s2 := ContStr(s2, '.', 'zzz');
    LongTimeFormat := s2;
    s2 := TimeToStr(Value);
    LongTimeFormat := s;
    if not (tdHour in TimeDats) then
    begin
      p := pos(':', s2);
      if p = 0 then
        p := pos('.', s2);
      if p <> 0 then
        Delete(s2, 1, p);
    end;
    Result := s2;
  end;
end;

function DateTime2Str(Value: TDateTime): string;
begin
  if IsNan(Value) then
    result := ''
  else
    Result := DateTimeToStr(Value);
end;

function Float2Str(Value: Extended; Digits: Integer): string;
begin
  if IsNan(Value) then
    result := ''
  else
  begin
    Value := RoundTo(Value, -Digits);
    Result := FloatToStr(Value);
  end;
end;
////////////////////// x //////////////////////
function Str2Int(Value: string): Integer;
begin
  result := StrToIntDef(Value, ImpossibleInt);
end;

function Str2Date(Value: string): TDateTime;
begin
  result := StrToDateDef(Value, ImpossibleDateTime);
end;

function Str2Time(Value: string): TDateTime;
begin
  result := StrToTimeDef(Value, ImpossibleDateTime);
end;

function Str2DateTime(Value: string): TDateTime;
begin
  result := StrToDateTimeDef(Value, ImpossibleDateTime);
end;

function Str2Float(Value: string): Extended;
begin
  result := StrToFloatDef(Value, ImpossibleFloat);
end;

function ByteType(const S: string; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
  if SysLocale.FarEast then
    Result := ByteTypeTest(Pchar(S), Index - 1);
end;

function IsNumber(s:string):boolean;
var
  v:Extended;
  c:integer;
begin
  s:=AnsiReplaceStr(s,DecimalSeparator,'.');
  Val(s,V,c);
  Result:=c=0;
end;

/////////////////// x ///////////////////
function StrScan(const Str: Pchar; Chr: Char): Pchar;
begin
  Result := Str;
  while Result^ <> Chr do
  begin
    if Result^ = #0 then
    begin
      Result := nil;
      Exit;
    end;
    Inc(Result);
  end;
end;

function LastDelimiter(const Delimiters, S: string): Integer;
var
  P: Pchar;
begin
  Result := Length(S);
  P := Pchar(Delimiters);
  while Result > 0 do
  begin
    if (S[Result] <> #0) and (StrScan(P, S[Result]) <> nil) then
      if (ByteType(S, Result) = mbTrailByte) then
        Dec(Result)
      else
        Exit;
    Dec(Result);
  end;
end;

function ExtractFilePath(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function propis(x: Real): string;
var
  i, j: Integer;
  s: string;
  r: Real;
  tetr: array[1..6] of string[3];
  cisl: array[1..3] of string[1];
begin
  for i := 1 to 6 do
    tetr[i] := '000';
  r := int(x);
  s := float2str(r);
  i := length(s);
  i := i mod 3;
  case i of
    1:
      s := '00' + s;
    2:
      s := '0' + s;
  end;
  j := round(length(s) / 3);
  for i := 1 to j do
  begin
    tetr[i] := copy(s, length(s) - 2, 3);
    delete(s, length(s) - 2, 3);
  end;
  s := '';
  repeat
    cisl[1] := copy(tetr[j], 1, 1);
    cisl[2] := copy(tetr[j], 2, 1);
    cisl[3] := copy(tetr[j], 3, 1);
    if cisl[1] <> '0' then
      case str2int(cisl[1]) of
        1:
          s := s + 'сто ';
        2:
          s := s + 'двести ';
        3:
          s := s + 'триста ';
        4:
          s := s + 'четыреста ';
        5:
          s := s + 'пятьсот ';
        6:
          s := s + 'шестьсот ';
        7:
          s := s + 'семьсот ';
        8:
          s := s + 'восемьсот ';
        9:
          s := s + 'девятьсот ';
      end;
    if cisl[2] <> '0' then
      case str2int(cisl[2]) of
        1:
          case str2int(cisl[3]) of
            1:
              s := s + 'одинадцать ';
            2:
              s := s + 'двенадцать ';
            3:
              s := s + 'тринадцать ';
            4:
              s := s + 'четырнадцать ';
            5:
              s := s + 'пятнадцать ';
            6:
              s := s + 'шестнадцать ';
            7:
              s := s + 'семнадцать ';
            8:
              s := s + 'восемнадцать ';
            9:
              s := s + 'девятнадцать ';
            0:
              s := s + 'десять ';
          end;
        2:
          s := s + 'двадцать ';
        3:
          s := s + 'тридцать ';
        4:
          s := s + 'сорок ';
        5:
          s := s + 'пятьдесят ';
        6:
          s := s + 'шестьдесят ';
        7:
          s := s + 'семьдесят ';
        8:
          s := s + 'восемьдесят ';
        9:
          s := s + 'девяносто ';
      end;
    if (cisl[3] <> '0') and (cisl[2] <> '1') then
      case Str2int(cisl[3]) of
        1:
          if j <> 2 then
            s := s + 'один '
          else
            s := s + 'одна ';
        2:
          if j <> 2 then
            s := s + 'два '
          else
            s := s + 'две ';
        3:
          s := s + 'три ';
        4:
          s := s + 'четыре ';
        5:
          s := s + 'пять ';
        6:
          s := s + 'шесть ';
        7:
          s := s + 'семь ';
        8:
          s := s + 'восемь ';
        9:
          s := s + 'девять ';
      end;
    if Str2int(cisl[1] + cisl[2] + cisl[3]) <> 0 then
      case j of
        2:
          case Str2int(cisl[3]) of
            1:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'тысяча '
              else
                s := s + 'тысяч ';
            2..4:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'тысячи '
              else
                s := s + 'тысяч ';
          else
            s := s + 'тысяч ';
          end;
        3:
          case Str2int(cisl[3]) of
            1:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'миллион '
              else
                s := s + 'миллионов ';
            2..4:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'миллиона '
              else
                s := s + 'миллионов ';
          else
            s := s + 'миллионов ';
          end;
        4:
          case Str2int(cisl[2] + cisl[3]) of
            1:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'миллиард '
              else
                s := s + 'миллиардов ';
            2..4:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'миллиарда '
              else
                s := s + 'миллиардов ';
          else
            s := s + 'миллиардов ';
          end;
        5:
          case Str2int(cisl[2] + cisl[3]) of
            1:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'трилион '
              else
                s := s + 'трилионов ';
            2..4:
              if Str2int(cisl[2]) <> 1 then
                s := s + 'трилиона '
              else
                s := s + 'трилионов ';
          else
            s := s + 'трилионов ';
          end;
        6:
          case Str2int(cisl[2] + cisl[3]) of
            1:
              s := s + 'трилиард ';
            2..4:
              s := s + 'трилиарда ';
          else
            s := s + 'трилиардов ';
          end;
      end;
    j := j - 1;
  until j = 0;
  propis := s;
end;

function ToZeroStr(n, l: Integer): string;
var
  s: string;
  l2: Integer;
begin
  s := Int2Str(n);
  Result := StringOfChar('0', l);
  l2 := Length(s);
  if l2 < l then
    Move(s[1], Result[l - l2 + 1], l2)
  else
    Result := s;
end;

function ChangeCommaText(S, SubS: string; index: Integer): string;
begin
  with TStringList.Create do
  begin
    CommaText := S;
    if (index >= 0) and (index < Count) then
      strings[index] := SubS;
    result := CommaText;
    Free;
  end;
end;

function ItemOfCommaText(S: string; index: Integer): string;
begin
  with TStringList.Create do
  begin
    CommaText := S;
    if (index >= 0) and (index < Count) then
      result := strings[index];
    ;
    Free;
  end;
end;

function CountCommaText(S: string): Integer;
begin
  with TStringList.Create do
  begin
    CommaText := S;
    result := Count;
    Free;
  end;
end;

function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end
  else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function AnsiReplaceStr(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll]);
end;

function EnumStringModules(Instance: Longint; Data: Pointer): Boolean;
{$IFDEF MSWINDOWS}
var
  Buffer: array [0..1023] of char;
begin
  with PStrData(Data)^ do
  begin
    SetString(Str, Buffer,
      LoadString(Instance, Ident, Buffer, sizeof(Buffer)));
    Result := Str = '';
  end;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  rs: TResStringRec;
  Module: HModule;
begin
  Module := Instance;
  rs.Module := @Module;
  with PStrData(Data)^ do
  begin
    rs.Identifier := Ident;
    Str := LoadResString(@rs);
    Result := Str = '';
  end;
end;

{$ENDIF}

function FindStringResource(Ident: Integer): string;
var
  StrData: TStrData;
begin
  StrData.Ident := Ident;
  StrData.Str := '';
  EnumResourceModules(EnumStringModules, @StrData);
  Result := StrData.Str;
end;

function LoadStr(Ident: Integer): string;
begin
  Result := FindStringResource(Ident);
end;

function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do
    Inc(I);
  if I > L then
    Result := ''
  else
  begin
    while S[L] <= ' ' do
      Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function Trim(const S: Widestring): Widestring;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do
    Inc(I);
  if I > L then
    Result := ''
  else
  begin
    while S[L] <= ' ' do
      Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function LowerCase(const S: string): string;
asm
  PUSH  EBX
  PUSH  ESI
  PUSH  EDI
  MOV   ESI, EAX          // s
  MOV   EAX, EDX
  TEST  ESI, ESI
  JZ    @Nil
  MOV   EDX, [ESI-4]      // Length(s)
  MOV   EDI, EAX          // @Result
  TEST  EDX, EDX
  JLE   @Nil
  MOV   ECX, [EAX]
  MOV   EBX, EDX
  TEST  ECX, ECX
  JZ    @Realloc          // Jump if Result not allocated
  test  EDX, 3
  JNZ   @Length3
  XOR   EDX, [ECX-4]
  CMP   EDX, 3
  JBE   @TestRef
  JMP   @Realloc
  @Length3:
  OR    EDX, 2
  XOR   EDX, [ECX-4]
  CMP   EDX, 1
  JA    @Realloc
  @TestRef:
  CMP   [ECX-8], 1
  JE    @LengthOK         // Jump if Result RefCt=1
  @Realloc:
  MOV   EDX, EBX
  OR    EDX, 3
  CALL  System.@LStrSetLength
  @LengthOK:
  MOV   EDI, [EDI]        // Result
  MOV   [EDI-4], EBX      // Correct Result length
  MOV   byte ptr [EBX+EDI], 0
  ADD   EBX, -1
  AND   EBX, -4
  MOV   EAX, [EBX+ESI]

  @Loop: MOV   ECX, EAX
  OR    EAX, $80808080    // $C1..$DA
  MOV   EDX, EAX
  SUB   EAX, $5B5B5B5B    // $66..$7F
  XOR   EDX, ECX          // $80
  OR    EAX, $80808080    // $E6..$FF
  SUB   EAX, $66666666    // $80..$99
  AND   EAX, EDX          // $80
  SHR   EAX, 2            // $20
  XOR   EAX, ECX          // Lower
  MOV   [EBX+EDI], EAX
  MOV   EAX, [EBX+ESI-4]
  SUB   EBX, 4
  JGE   @Loop

  POP   EDI
  POP   ESI
  POP   EBX
  RET

  @Nil:  POP   EDI
  POP   ESI
  POP   EBX
  JMP    System.@LStrClr   // Result:=''
end;

function LowerCase(const S: string; LocaleOptions: TLocaleOptions): string;
begin
  if LocaleOptions = loUserLocale then
    Result := AnsiLowerCase(S)
  else
    Result := LowerCase(S);
end;

function UpperCase(const S: string): string;
asm
  PUSH  EBX
  PUSH  ESI
  PUSH  EDI
  MOV   ESI, EAX          // s
  MOV   EAX, EDX
  TEST  ESI, ESI
  JZ    @Nil
  MOV   EDX, [ESI-4]      // Length(s)
  MOV   EDI, EAX          // @Result
  TEST  EDX, EDX
  JLE   @Nil
  MOV   ECX, [EAX]
  MOV   EBX, EDX
  TEST  ECX, ECX
  JZ    @Realloc          // Jump if Result not allocated
  test  EDX, 3
  JNZ   @Length3
  XOR   EDX, [ECX-4]
  CMP   EDX, 3
  JBE   @TestRef
  JMP   @Realloc
  @Length3:
  OR    EDX, 2
  XOR   EDX, [ECX-4]
  CMP   EDX, 1
  JA    @Realloc
  @TestRef:
  CMP   [ECX-8], 1
  JE    @LengthOK         // Jump if Result RefCt=1
  @Realloc:
  MOV   EDX, EBX
  OR    EDX, 3
  CALL  System.@LStrSetLength
  @LengthOK:
  MOV   EDI, [EDI]        // Result
  MOV   [EDI-4], EBX      // Correct Result length
  MOV   byte ptr [EBX+EDI], 0
  ADD   EBX, -1
  AND   EBX, -4
  MOV   EAX, [EBX+ESI]

  @Loop: MOV   ECX, EAX
  OR    EAX, $80808080    // $E1..$FA
  MOV   EDX, EAX
  SUB   EAX, $7B7B7B7B    // $66..$7F
  XOR   EDX, ECX          // $80
  OR    EAX, $80808080    // $E6..$FF
  SUB   EAX, $66666666    // $80..$99
  AND   EAX, EDX          // $80
  SHR   EAX, 2            // $20
  XOR   EAX, ECX          // Upper
  MOV   [EBX+EDI], EAX
  MOV   EAX, [EBX+ESI-4]
  SUB   EBX, 4
  JGE   @Loop

  POP   EDI
  POP   ESI
  POP   EBX
  RET

  @Nil:  POP   EDI
  POP   ESI
  POP   EBX
  JMP    System.@LStrClr   // Result:=''
end;

function UpperCase(const S: string; LocaleOptions: TLocaleOptions): string;
begin
  if LocaleOptions = loUserLocale then
    Result := AnsiUpperCase(S)
  else
    Result := UpperCase(S);
end;

function AnsiUpperCase(const S: string): string;
{$IFDEF MSWINDOWS}
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PChar(S), Len);
  if Len > 0 then CharUpperBuff(Pointer(Result), Len);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := WideUpperCase(S);
end;

{$ENDIF}

function AnsiLowerCase(const S: string): string;
{$IFDEF MSWINDOWS}
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PChar(S), Len);
  if Len > 0 then CharLowerBuff(Pointer(Result), Len);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := WideLowerCase(S);
end;

{$ENDIF}

function AnsiStrPos(Str, SubStr: Pchar): Pchar;
var
  L1, L2: Cardinal;
  ByteType: TMbcsByteType;
begin
  Result := nil;
  if (Str = nil) or (Str^ = #0) or (SubStr = nil) or (SubStr^ = #0) then
    Exit;
  L1 := StrLen(Str);
  L2 := StrLen(SubStr);
  Result := StrPos(Str, SubStr);
  while (Result <> nil) and ((L1 - Cardinal(Result - Str)) >= L2) do
  begin
    ByteType := StrByteType(Str, Integer(Result - Str));
{$IFDEF MSWINDOWS}
    if (ByteType <> mbTrailByte) and
      (CompareString(LOCALE_USER_DEFAULT, 0, Result, L2, SubStr, L2) = CSTR_EQUAL) then Exit;
    if (ByteType = mbLeadByte) then Inc(Result);
{$ENDIF}
{$IFDEF LINUX}
    if (ByteType <> mbTrailByte) and (strncmp(Result, SubStr, L2) = 0) then
      Exit;
{$ENDIF}
    Inc(Result);
    Result := StrPos(Result, SubStr);
  end;
  Result := nil;
end;

function StrLen(const Str: Pchar): Cardinal; assembler;
asm
  MOV     EDX,EDI
  MOV     EDI,EAX
  MOV     ECX,0FFFFFFFFH
  XOR     AL,AL
  REPNE   SCASB
  MOV     EAX,0FFFFFFFEH
  SUB     EAX,ECX
  MOV     EDI,EDX
end;

function StrCopy(Dest: Pchar; const Source: Pchar): Pchar;
asm
  SUB   EDX, EAX
  TEST  EAX, 1
  PUSH  EAX
  JZ    @loop
  MOVZX ECX, byte ptr[EAX+EDX]
  MOV   [EAX], CL
  TEST  ECX, ECX
  JZ    @ret
  INC   EAX
  @loop:
  MOVZX ECX, byte ptr[EAX+EDX]
  TEST  ECX, ECX
  JZ    @move0
  MOVZX ECX, word ptr[EAX+EDX]
  MOV   [EAX], CX
  ADD   EAX, 2
  CMP   ECX, 255
  JA    @loop
  @ret:
  POP   EAX
  RET
  @move0:
  MOV   [EAX], CL
  POP   EAX
end;

function FormatDateTime(const Format: string; DateTime: TDateTime): string;
begin
  DateTimeToString(Result, Format, DateTime);
end;

function FormatDateTime(const Format: string; DateTime: TDateTime;
  const FormatSettings: TFormatSettings): string;
begin
  DateTimeToString(Result, Format, DateTime, FormatSettings);
end;

function TryStrToInt(const S: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function StrPCopy(Dest: Pchar; const Source: string): Pchar;
begin
  Result := StrLCopy(Dest, Pchar(Source), Length(Source));
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

procedure GetFormatSettings;
{$IFDEF MSWINDOWS}
var
  HourFormat, TimePrefix, TimePostfix: string;
  DefaultLCID: Integer;
begin
  InitSysLocale;
  GetMonthDayNames;
  if SysLocale.FarEast then GetEraNamesAndYearOffsets;
  DefaultLCID := GetThreadLocale;
  CurrencyString := GetLocaleStr(DefaultLCID, LOCALE_SCURRENCY, '');
  CurrencyFormat := StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_ICURRENCY, '0'), 0);
  NegCurrFormat := StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_INEGCURR, '0'), 0);
  ThousandSeparator := GetLocaleChar(DefaultLCID, LOCALE_STHOUSAND, ',');
  DecimalSeparator := GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.');
  CurrencyDecimals := StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_ICURRDIGITS, '0'), 0);
  DateSeparator := GetLocaleChar(DefaultLCID, LOCALE_SDATE, '/');
  ShortDateFormat := TranslateDateFormat(GetLocaleStr(DefaultLCID, LOCALE_SSHORTDATE, 'm/d/yy'));
  LongDateFormat := TranslateDateFormat(GetLocaleStr(DefaultLCID, LOCALE_SLONGDATE, 'mmmm d, yyyy'));
  TimeSeparator := GetLocaleChar(DefaultLCID, LOCALE_STIME, ':');
  TimeAMString := GetLocaleStr(DefaultLCID, LOCALE_S1159, 'am');
  TimePMString := GetLocaleStr(DefaultLCID, LOCALE_S2359, 'pm');
  TimePrefix := '';
  TimePostfix := '';
  if StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_ITLZERO, '0'), 0) = 0 then
    HourFormat := 'h' else
    HourFormat := 'hh';
  if StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_ITIME, '0'), 0) = 0 then
    if StrToIntDef(GetLocaleStr(DefaultLCID, LOCALE_ITIMEMARKPOSN, '0'), 0) = 0 then
      TimePostfix := ' AMPM'
    else
      TimePrefix := 'AMPM ';
  ShortTimeFormat := TimePrefix + HourFormat + ':mm' + TimePostfix;
  LongTimeFormat := TimePrefix + HourFormat + ':mm:ss' + TimePostfix;
  ListSeparator := GetLocaleChar(DefaultLCID, LOCALE_SLIST, ',');
end;
{$ELSE}
{$IFDEF LINUX}
const
  //first boolean is p_cs_precedes, second is p_sep_by_space
  CurrencyFormats: array[Boolean, Boolean] of Byte = ((1, 3), (0, 2));
  //first boolean is n_cs_precedes, second is n_sep_by_space and finally n_sign_posn
  NegCurrFormats: array[Boolean, Boolean, 0..4] of Byte =
    (((4, 5, 7, 6, 7), (15, 8, 10, 13, 10)), ((0, 1, 3, 1, 2), (14, 9, 11, 9, 12)));

  function TranslateFormat(s: Pchar; const Default: string): string;
  begin
    Result := '';
    while s^ <> #0 do
    begin
      if s^ = '%' then
      begin
        inc(s);
        case s^ of
          'a':
            Result := Result + 'ddd';
          'A':
            Result := Result + 'dddd';
          'b':
            Result := Result + 'MMM';
          'B':
            Result := Result + 'MMMM';
          'c':
            Result := Result + 'c';
//        'C':  year / 100 not supported
          'd':
            Result := Result + 'dd';
          'D':
            Result := Result + 'MM/dd/yy';
          'e':
            Result := Result + 'd';
//        'E': alternate format not supported
          'g':
            Result := Result + 'yy';
          'G':
            Result := Result + 'yyyy';
          'h':
            Result := Result + 'MMM';
          'H':
            Result := Result + 'HH';
          'I':
            Result := Result + 'hh';
//        'j': day of year not supported
          'k':
            Result := Result + 'H';
          'l':
            Result := Result + 'h';
          'm':
            Result := Result + 'MM';
          'M':
            Result := Result + 'nn';  // minutes! not months!
          'n':
            Result := Result + sLineBreak;  // line break
//        'O': alternate format not supported
          'P',   // P's implied lowercasing of locale string is not supported
          'p':
            Result := Result + 'AMPM';
          'r':
            Result := Result + TranslateFormat(nl_langInfo(T_FMT_AMPM), '');
          'R':
            Result := Result + 'HH:mm';
//        's': number of seconds since Epoch not supported
          'S':
            Result := Result + 'ss';
          't':
            Result := Result + #9;  // tab char
          'T':
            Result := Result + 'HH:mm:ss';
//        'u': day of week 1..7 not supported
//        'U': week number of the year not supported
//        'V': week number of the year not supported
//        'w': day of week 0..6 not supported
//        'W': week number of the year not supported
          'x':
            Result := Result + TranslateFormat(nl_langInfo(D_FMT), '');
          'X':
            Result := Result + TranslateFormat(nl_langinfo(T_FMT), '');
          'y':
            Result := Result + 'yy';
          'Y':
            Result := Result + 'yyyy';
//        'z': GMT offset is not supported
          '%':
            Result := Result + '%';
        end;
      end
      else
        Result := Result + s^;
      Inc(s);
    end;
    if Result = '' then
      Result := Default;
  end;

  function GetFirstCharacter(const SrcString, match: string): Char;
  var
    i, p: Integer;
  begin
    result := match[1];
    for i := 1 to length(SrcString) do
    begin
      p := Pos(SrcString[i], match);
      if p > 0 then
      begin
        result := match[p];
        break;
      end;
    end;
  end;

var
  P: PLConv;
begin
  InitSysLocale;
  GetMonthDayNames;
  if SysLocale.FarEast then
    InitEras;

  CurrencyString := '';
  CurrencyFormat := 0;
  NegCurrFormat := 0;
  ThousandSeparator := ',';
  DecimalSeparator := '.';
  CurrencyDecimals := 0;

  P := localeconv;
  if P <> nil then
  begin
    if P^.currency_symbol <> nil then
      CurrencyString := P^.currency_symbol;

    if (Byte(P^.p_cs_precedes) in [0..1]) and (Byte(P^.p_sep_by_space) in [0..1]) then
    begin
      CurrencyFormat := CurrencyFormats[P^.p_cs_precedes, P^.p_sep_by_space];
      if P^.p_sign_posn in [0..4] then
        NegCurrFormat := NegCurrFormats[P^.n_cs_precedes, P^.n_sep_by_space,
          P^.n_sign_posn];
    end;

    // #0 is valid for ThousandSeparator.  Indicates no thousand separator.
    ThousandSeparator := P^.thousands_sep^;

    // #0 is not valid for DecimalSeparator.
    if P^.decimal_point <> #0 then
      DecimalSeparator := P^.decimal_point^;
    CurrencyDecimals := P^.frac_digits;
  end;

  ShortDateFormat := TranslateFormat(nl_langinfo(D_FMT), 'm/d/yy');
  LongDateFormat := TranslateFormat(nl_langinfo(D_T_FMT), ShortDateFormat);
  ShortTimeFormat := TranslateFormat(nl_langinfo(T_FMT), 'hh:mm AMPM');
  LongTimeFormat := TranslateFormat(nl_langinfo(T_FMT_AMPM), ShortTimeFormat);

  DateSeparator := GetFirstCharacter(ShortDateFormat, '/.-');
  TimeSeparator := GetFirstCharacter(ShortTimeFormat, ':.');

  TimeAMString := nl_langinfo(AM_STR);
  TimePMString := nl_langinfo(PM_STR);
  ListSeparator := ',';
end;

{$ELSE}
var
  HourFormat, TimePrefix, TimePostfix: string;
begin
  InitSysLocale;
  GetMonthDayNames;
  CurrencyString := '';
  CurrencyFormat := 0;
  NegCurrFormat := 0;
  ThousandSeparator := ',';
  DecimalSeparator := '.';
  CurrencyDecimals := 0;
  DateSeparator := '/';
  ShortDateFormat := 'm/d/yy';
  LongDateFormat := 'mmmm d, yyyy';
  TimeSeparator := ':';
  TimeAMString := 'am';
  TimePMString := 'pm';
  TimePrefix := '';
  TimePostfix := '';
  HourFormat := 'h';
  TimePostfix := ' AMPM';
  ShortTimeFormat := TimePrefix + HourFormat + ':mm' + TimePostfix;
  LongTimeFormat := TimePrefix + HourFormat + ':mm:ss' + TimePostfix;
  ListSeparator := ',';
end;
{$ENDIF}
{$ENDIF}

procedure ConvertErrorFmt(ResString: PResStringRec; const Args: array of const); local;
begin
  raise EConvertError.CreateResFmt(ResString, Args);
end;

function StrToInt(const S: string): Integer;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then
    ConvertErrorFmt(@SInvalidInteger, [S]);
end;

function StrPas(const Str: Pchar): string;
begin
  Result := Str;
end;

function StrToFloat(const S: string): Extended;
begin
  if not TextToFloat(Pchar(S), Result, fvExtended) then
    ConvertErrorFmt(@SInvalidFloat, [S]);
end;

function StrToFloat(const S: string; const FormatSettings: TFormatSettings): Extended;
begin
  if not TextToFloat(Pchar(S), Result, fvExtended, FormatSettings) then
    ConvertErrorFmt(@SInvalidFloat, [S]);
end;

function TextToFloat(Buffer: Pchar; var Value; ValueType: TFloatValue): Boolean;
const
// 8087 control word
// Infinity control  = 1 Affine
// Rounding Control  = 0 Round to nearest or even
// Precision Control = 3 64 bits
// All interrupts masked
  CWNear: Word = $133F;
var
  Temp: Integer;
  CtrlWord: Word;
  DecimalSep: Char;
  SaveGOT: Integer;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     ESI,EAX
  MOV     EDI,EDX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        POP     EBX
        MOV     SAVEGOT,EAX
        MOV     ECX,[EAX].OFFSET DECIMALSEPARATOR
        MOV     CL,[ECX].BYTE
        MOV     DECIMALSEP,CL
{$ELSE}
  MOV     SaveGOT,0
  MOV     AL,DecimalSeparator
  MOV     DecimalSep,AL
  MOV     EBX,ECX
{$ENDIF}
  FSTCW   CtrlWord
  FCLEX
{$IFDEF PIC}
        FLDCW   [EAX].CWNEAR
{$ELSE}
  FLDCW   CWNear
{$ENDIF}
  FLDZ
  CALL    @@SkipBlanks
  MOV     BH, byte ptr [ESI]
  CMP     BH,'+'
  JE      @@1
  CMP     BH,'-'
  JNE     @@2
  @@1:    INC     ESI
  @@2:    MOV     ECX,ESI
  CALL    @@GetDigitStr
  XOR     EDX,EDX
  MOV     AL,[ESI]
  CMP     AL,DecimalSep
  JNE     @@3
  INC     ESI
  CALL    @@GetDigitStr
  NEG     EDX
  @@3:    CMP     ECX,ESI
  JE      @@9
  MOV     AL, byte ptr [ESI]
  AND     AL,0DFH
  CMP     AL,'E'
  JNE     @@4
  INC     ESI
  PUSH    EDX
  CALL    @@GetExponent
  POP     EAX
  ADD     EDX,EAX
  @@4:    CALL    @@SkipBlanks
  CMP     BYTE PTR [ESI],0
  JNE     @@9
  MOV     EAX,EDX
  CMP     BL,fvCurrency
  JNE     @@5
  ADD     EAX,4
  @@5:    PUSH    EBX
  MOV     EBX,SaveGOT
  CALL    FPower10
  POP     EBX
  CMP     BH,'-'
  JNE     @@6
  FCHS
  @@6:    CMP     BL,fvExtended
  JE      @@7
  FISTP   QWORD PTR [EDI]
  JMP     @@8
  @@7:    FSTP    TBYTE PTR [EDI]
  @@8:    FSTSW   AX
  TEST    AX,mIE+mOE
  JNE     @@10
  MOV     AL,1
  JMP     @@11
  @@9:    FSTP    ST(0)
  @@10:   XOR     EAX,EAX
  @@11:   FCLEX
  FLDCW   CtrlWord
  FWAIT
  JMP     @@Exit

  @@SkipBlanks:

  @@21:   LODSB
  OR      AL,AL
  JE      @@22
  CMP     AL,' '
  JE      @@21
  @@22:   DEC     ESI
  RET

// Process string of digits
// Out EDX = Digit count

  @@GetDigitStr:

  XOR     EAX,EAX
  XOR     EDX,EDX
  @@31:   LODSB
  SUB     AL,'0'+10
  ADD     AL,10
  JNC     @@32
{$IFDEF PIC}
        XCHG    SAVEGOT,EBX
        FIMUL   [EBX].DCON10
        XCHG    SAVEGOT,EBX
{$ELSE}
  FIMUL   DCon10
{$ENDIF}
  MOV     Temp,EAX
  FIADD   Temp
  INC     EDX
  JMP     @@31
  @@32:   DEC     ESI
  RET

// Get exponent
// Out EDX = Exponent (-4999..4999)

  @@GetExponent:

  XOR     EAX,EAX
  XOR     EDX,EDX
  MOV     CL, byte ptr [ESI]
  CMP     CL,'+'
  JE      @@41
  CMP     CL,'-'
  JNE     @@42
  @@41:   INC     ESI
  @@42:   MOV     AL, byte ptr [ESI]
  SUB     AL,'0'+10
  ADD     AL,10
  JNC     @@43
  INC     ESI
  IMUL    EDX,10
  ADD     EDX,EAX
  CMP     EDX,500
  JB      @@42
  @@43:   CMP     CL,'-'
  JNE     @@44
  NEG     EDX
  @@44:   RET

  @@Exit:
  POP     EBX
  POP     ESI
  POP     EDI
end;

function TextToFloat(Buffer: Pchar; var Value; ValueType: TFloatValue;
  const FormatSettings: TFormatSettings): Boolean;
const
// 8087 control word
// Infinity control  = 1 Affine
// Rounding Control  = 0 Round to nearest or even
// Precision Control = 3 64 bits
// All interrupts masked
  CWNear: Word = $133F;
var
  Temp: Integer;
  CtrlWord: Word;
  DecimalSep: Char;
  SaveGOT: Integer;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     ESI,EAX
  MOV     EDI,EDX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        POP     EBX
        MOV     SAVEGOT,EAX
{$ELSE}
  MOV     SaveGOT,0
  MOV     EBX,ECX
{$ENDIF}
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.DecimalSeparator
  MOV     DecimalSep,AL
  FSTCW   CtrlWord
  FCLEX
{$IFDEF PIC}
        FLDCW   [EAX].CWNEAR
{$ELSE}
  FLDCW   CWNear
{$ENDIF}
  FLDZ
  CALL    @@SkipBlanks
  MOV     BH, byte ptr [ESI]
  CMP     BH,'+'
  JE      @@1
  CMP     BH,'-'
  JNE     @@2
  @@1:    INC     ESI
  @@2:    MOV     ECX,ESI
  CALL    @@GetDigitStr
  XOR     EDX,EDX
  MOV     AL,[ESI]
  CMP     AL,DecimalSep
  JNE     @@3
  INC     ESI
  CALL    @@GetDigitStr
  NEG     EDX
  @@3:    CMP     ECX,ESI
  JE      @@9
  MOV     AL, byte ptr [ESI]
  AND     AL,0DFH
  CMP     AL,'E'
  JNE     @@4
  INC     ESI
  PUSH    EDX
  CALL    @@GetExponent
  POP     EAX
  ADD     EDX,EAX
  @@4:    CALL    @@SkipBlanks
  CMP     BYTE PTR [ESI],0
  JNE     @@9
  MOV     EAX,EDX
  CMP     BL,fvCurrency
  JNE     @@5
  ADD     EAX,4
  @@5:    PUSH    EBX
  MOV     EBX,SaveGOT
  CALL    FPower10
  POP     EBX
  CMP     BH,'-'
  JNE     @@6
  FCHS
  @@6:    CMP     BL,fvExtended
  JE      @@7
  FISTP   QWORD PTR [EDI]
  JMP     @@8
  @@7:    FSTP    TBYTE PTR [EDI]
  @@8:    FSTSW   AX
  TEST    AX,mIE+mOE
  JNE     @@10
  MOV     AL,1
  JMP     @@11
  @@9:    FSTP    ST(0)
  @@10:   XOR     EAX,EAX
  @@11:   FCLEX
  FLDCW   CtrlWord
  FWAIT
  JMP     @@Exit

  @@SkipBlanks:

  @@21:   LODSB
  OR      AL,AL
  JE      @@22
  CMP     AL,' '
  JE      @@21
  @@22:   DEC     ESI
  RET

// Process string of digits
// Out EDX = Digit count

  @@GetDigitStr:

  XOR     EAX,EAX
  XOR     EDX,EDX
  @@31:   LODSB
  SUB     AL,'0'+10
  ADD     AL,10
  JNC     @@32
{$IFDEF PIC}
        XCHG    SAVEGOT,EBX
        FIMUL   [EBX].DCON10
        XCHG    SAVEGOT,EBX
{$ELSE}
  FIMUL   DCon10
{$ENDIF}
  MOV     Temp,EAX
  FIADD   Temp
  INC     EDX
  JMP     @@31
  @@32:   DEC     ESI
  RET

// Get exponent
// Out EDX = Exponent (-4999..4999)

  @@GetExponent:

  XOR     EAX,EAX
  XOR     EDX,EDX
  MOV     CL, byte ptr [ESI]
  CMP     CL,'+'
  JE      @@41
  CMP     CL,'-'
  JNE     @@42
  @@41:   INC     ESI
  @@42:   MOV     AL, byte ptr [ESI]
  SUB     AL,'0'+10
  ADD     AL,10
  JNC     @@43
  INC     ESI
  IMUL    EDX,10
  ADD     EDX,EAX
  CMP     EDX,500
  JB      @@42
  @@43:   CMP     CL,'-'
  JNE     @@44
  NEG     EDX
  @@44:   RET

  @@Exit:
  POP     EBX
  POP     ESI
  POP     EDI
end;

function StrToInt64Def(const S: string; const Default: Int64): Int64;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then
    Result := Default;
end;

function StrToIntDef(const S: string; Default: Integer): Integer;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then
    Result := Default;
end;

function StrLComp(const Str1, Str2: Pchar; MaxLen: Cardinal): Integer; assembler;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     EDI,EDX
  MOV     ESI,EAX
  MOV     EBX,ECX
  XOR     EAX,EAX
  OR      ECX,ECX
  JE      @@1
  REPNE   SCASB
  SUB     EBX,ECX
  MOV     ECX,EBX
  MOV     EDI,EDX
  XOR     EDX,EDX
  REPE    CMPSB
  MOV     AL,[ESI-1]
  MOV     DL,[EDI-1]
  SUB     EAX,EDX
  @@1:    POP     EBX
  POP     ESI
  POP     EDI
end;

function SolidText(sts: TStrings): string;
begin
  result := AnsiReplaceStr(sts.Text, #13#10, '');
end;

function CommaTextToText(ACommaText: string): string;
begin
  with TStringList.Create do
  begin
    CommaText := ACommaText;
    Result := Text;
    Free;
    SetLength(Result, Length(Result) - 2);
  end;
end;

function TextToCommaText(AText: string): string;
begin
  with TStringList.Create do
  begin
    Text := AText;
    if Strings[Count - 1] = '' then
      Delete(Count - 1);
    Result := CommaText;
    Free;
  end;
end;

function HexToInt(p_strHex: string): Integer;
begin
  Result := Str2Int('$' + p_strHex);
end;

function ChangeChar(var s: string; var Position: Integer; ch: Char): Boolean;
begin
  result := false;
  if OutSide(Position, 1, Length(s) - 1) then
    Exit;
  s[Position] := ch;
  inc(Position);
  result := true;
end;

procedure ChangeCharPlus(var s: string; var Position: Integer; ch: Char);
begin
  while not ChangeChar(s, Position, ch) do
    SetLength(s, Length(s) * 2);
end;

procedure EmbbedStr(var S: string; Subst: string; var Position: Integer; Len: Integer);
var
  i, n: Integer;
begin
  n := Length(Subst) - 1;
  for i := 0 to Min(n, Len - 1) do
    if not ChangeChar(S, Position, Subst[i + 1]) then
      break;
end;

procedure EmbbedStr(var S: string; Subst: string; var Position: Integer);
begin
  EmbbedStr(S, Subst, Position, Length(Subst));
end;

function LSpace(s: string; len: Integer; Cut: Boolean): string; // - слева
var
  l: Integer;
begin
  if Cut then
    s := Copy(s, 1, len);
  result := s;
  l := Length(s);
  if l >= len then
    Exit;
  result := StringOfChar(' ', len - l) + s;
end;

function RSpace(s: string; len: Integer; Cut: Boolean): string; // - справа
var
  l: Integer;
begin
  if Cut then
    s := Copy(s, 1, len);
  result := s;
  l := Length(s);
  if l >= len then
    Exit;
  result := s + StringOfChar(' ', len - l);
end;

function AsOEM(s: string): string;
begin
  s := s + #0;
  SetLength(result, Length(s));
  CharToOEM(Pchar(s), Pchar(result));
  SetLength(result, Length(s) - 1);
end;

function AsAnsi(s: string): string;
begin
  s := s + #0;
  SetLength(result, Length(s));
  OEMToChar(Pchar(s), Pchar(result));
  SetLength(result, Length(s) - 1);
end;

procedure NewLine(var S: string; var Position: Integer);
begin
  EmbbedStr(S, CRLF, Position);
end;

/////////////////// SysUtils ///////////////////
function StrToInt64(const S: string): Int64;
var
  E: Integer;
begin
  Val(S, Result, E);
  //if E <> 0 then MessageBox(SInvalidInteger, S);
end;

function AnsiCompareStr(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, 0, Pchar(S1), Length(S1),
    Pchar(S2), Length(S2)) - 2;
end;

function SameText(const S1, S2: string): Boolean; assembler;
asm
  CMP     EAX,EDX
  JZ      @1
  OR      EAX,EAX
  JZ      @2
  OR      EDX,EDX
  JZ      @3
  MOV     ECX,[EAX-4]
  CMP     ECX,[EDX-4]
  JNE     @3
  CALL    CompareText
  TEST    EAX,EAX
  JNZ     @3
  @1:     MOV     AL,1
  @2:     RET
  @3:     XOR     EAX,EAX
end;

procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
  OR      CL,CL
  JNZ     @CvtLoop
  @C1:    OR      EAX,EAX
  JNS     @C2
  NEG     EAX
  CALL    @C2
  MOV     AL,'-'
  INC     ECX
  DEC     ESI
  MOV     [ESI],AL
  RET
  @C2:    MOV     ECX,10

  @CvtLoop:
  PUSH    EDX
  PUSH    ESI
  @D1:    XOR     EDX,EDX
  DIV     ECX
  DEC     ESI
  ADD     DL,'0'
  CMP     DL,'0'+10
  JB      @D2
  ADD     DL,('A'-'0')-10
  @D2:    MOV     [ESI],DL
  OR      EAX,EAX
  JNE     @D1
  POP     ECX
  POP     EDX
  SUB     ECX,ESI
  SUB     EDX,ECX
  JBE     @D5
  ADD     ECX,EDX
  MOV     AL,'0'
  SUB     ESI,EDX
  JMP     @z
  @zloop: MOV     [ESI+EDX],AL
  @z:     DEC     EDX
  JNZ     @zloop
  MOV     [ESI],AL
  @D5:
end;

function IntToHex(Value: Integer; Digits: Integer): string;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
  CMP     EDX, 32        // Digits < buffer length?
  JBE     @A1
  XOR     EDX, EDX
  @A1:    PUSH    ESI
  MOV     ESI, ESP
  SUB     ESP, 32
  PUSH    ECX            // result ptr
  MOV     ECX, 16        // base 16     EDX = Digits = field width
  CALL    CvtInt
  MOV     EDX, ESI
  POP     EAX            // result ptr
  CALL    System.@LStrFromPCharLen
  ADD     ESP, 32
  POP     ESI
end;

function IntToStr(Value: Integer): string;
//  FmtStr(Result, '%d', [Value]);
asm
  PUSH    ESI
  MOV     ESI, ESP
  SUB     ESP, 16
  XOR     ECX, ECX       // base: 0 for signed decimal
  PUSH    EDX            // result ptr
  XOR     EDX, EDX       // zero filled field width: 0 for no leading zeros
  CALL    CvtInt
  MOV     EDX, ESI
  POP     EAX            // result ptr
  CALL    System.@LStrFromPCharLen
  ADD     ESP, 16
  POP     ESI
end;

function DateToStr(const DateTime: TDateTime): string;
begin
  DateTimeToString(Result, ShortDateFormat, DateTime);
end;

procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);
var
  MinCount, MSecCount: Word;
begin
  DivMod(DateTimeToTimeStamp(DateTime).Time, SecsPerMin * MSecsPerSec, MinCount, MSecCount);
  DivMod(MinCount, MinsPerHour, Hour, Min);
  DivMod(MSecCount, MSecsPerSec, Sec, MSec);
end;

function Format(const Format: string; const Args: array of const): string;
begin
  FmtStr(Result, Format, Args);
end;

procedure FmtStr(var Result: string; const Format: string; const Args: array of const);
var
  Len, BufLen: Integer;
  Buffer: array[0..4095] of Char;
begin
  BufLen := SizeOf(Buffer);
  if Length(Format) < (sizeof(Buffer) - (sizeof(Buffer) div 4)) then
    Len := FormatBuf(Buffer, sizeof(Buffer) - 1, Pointer(Format)^, Length(Format), Args)
  else
  begin
    BufLen := Length(Format);
    Len := BufLen;
  end;
  if Len >= BufLen - 1 then
  begin
    while Len >= BufLen - 1 do
    begin
      Inc(BufLen, BufLen);
      Result := '';          // prevent copying of existing data, for speed
      SetLength(Result, BufLen);
      Len := FormatBuf(Pointer(Result)^, BufLen - 1, Pointer(Format)^, Length(Format), Args);
    end;
    SetLength(Result, Len);
  end
  else
    SetString(Result, Buffer, Len);
end;

function TimeToStr(const DateTime: TDateTime): string;
begin
  DateTimeToString(Result, LongTimeFormat, DateTime);
end;

function DateTimeToStr(const DateTime: TDateTime): string;
begin
  DateTimeToString(Result, '', DateTime);
end;

procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime);
var
  BufPos, AppendLevel: Integer;
  Buffer: array[0..255] of Char;

  procedure AppendChars(P: Pchar; Count: Integer);
  var
    N: Integer;
  begin
    N := SizeOf(Buffer) - BufPos;
    if N > Count then
      N := Count;
    if N <> 0 then
      Move(P[0], Buffer[BufPos], N);
    Inc(BufPos, N);
  end;

  procedure AppendString(const S: string);
  begin
    AppendChars(Pointer(S), Length(S));
  end;

  procedure AppendNumber(Number, Digits: Integer);
  const
    Format: array[0..3] of Char = '%.*d';
  var
    NumBuf: array[0..15] of Char;
  begin
    AppendChars(NumBuf, FormatBuf(NumBuf, SizeOf(NumBuf), Format, SizeOf(Format),
      [Digits, Number]));
  end;

  procedure AppendFormat(Format: Pchar);
  var
    Starter, Token, LastToken: Char;
    DateDecoded, TimeDecoded, Use12HourClock, BetweenQuotes: Boolean;
    P: Pchar;
    Count: Integer;
    Year, Month, Day, Hour, Min, Sec, MSec, H: Word;

    procedure GetCount;
    var
      P: Pchar;
    begin
      P := Format;
      while Format^ = Starter do
        Inc(Format);
      Count := Format - P + 1;
    end;

    procedure GetDate;
    begin
      if not DateDecoded then
      begin
        DecodeDate(DateTime, Year, Month, Day);
        DateDecoded := True;
      end;
    end;

    procedure GetTime;
    begin
      if not TimeDecoded then
      begin
        DecodeTime(DateTime, Hour, Min, Sec, MSec);
        TimeDecoded := True;
      end;
    end;

{$IFDEF MSWINDOWS}
    function ConvertEraString(const Count: Integer) : string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
      P: PChar;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      FormatStr := 'gg';
      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if Count = 1 then
        begin
          case SysLocale.PriLangID of
            LANG_JAPANESE:
              Result := Copy(Result, 1, CharToBytelen(Result, 1));
            LANG_CHINESE:
              if (SysLocale.SubLangID = SUBLANG_CHINESE_TRADITIONAL)
                and (ByteToCharLen(Result, Length(Result)) = 4) then
              begin
                P := Buffer + CharToByteIndex(Result, 3) - 1;
                SetString(Result, P, CharToByteLen(P, 2));
              end;
          end;
        end;
      end;
    end;

    function ConvertYearString(const Count: Integer): string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      if Count <= 2 then
        FormatStr := 'yy' // avoid Win95 bug.
      else
        FormatStr := 'yyyy';

      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if (Count = 1) and (Result[1] = '0') then
          Result := Copy(Result, 2, Length(Result)-1);
      end;
    end;
{$ENDIF}

{$IFDEF LINUX}
    function FindEra(Date: Integer): Byte;
    var
      I: Byte;
    begin
      Result := 0;
      for I := 1 to EraCount do
        if (EraRanges[I].StartDate <= Date) and (EraRanges[I].EndDate >= Date) then
        begin
          Result := I;
          Exit;
        end;
    end;

    function ConvertEraString(const Count: Integer): string;
    var
      I: Byte;
    begin
      Result := '';
      I := FindEra(Trunc(DateTime));
      if I > 0 then
        Result := EraNames[I];
    end;

    function ConvertYearString(const Count: Integer): string;
    var
      I: Byte;
      S: string;
    begin
      I := FindEra(Trunc(DateTime));
      if I > 0 then
        S := IntToStr(Year - EraYearOffsets[I])
      else
        S := IntToStr(Year);
      while Length(S) < Count do
        S := '0' + S;
      if Length(S) > Count then
        S := Copy(S, Length(S) - (Count - 1), Count);
      Result := S;
    end;

{$ENDIF}
  begin
    if (Format <> nil) and (AppendLevel < 2) then
    begin
      Inc(AppendLevel);
      LastToken := ' ';
      DateDecoded := False;
      TimeDecoded := False;
      Use12HourClock := False;
      while Format^ <> #0 do
      begin
        Starter := Format^;
        if Starter in LeadBytes then
        begin
          AppendChars(Format, StrCharLength(Format));
          Format := StrNextChar(Format);
          LastToken := ' ';
          Continue;
        end;
        Format := StrNextChar(Format);
        Token := Starter;
        if Token in ['a'..'z'] then
          Dec(Token, 32);
        if Token in ['A'..'Z'] then
        begin
          if (Token = 'M') and (LastToken = 'H') then
            Token := 'N';
          LastToken := Token;
        end;
        case Token of
          'Y':
          begin
            GetCount;
            GetDate;
            if Count <= 2 then
              AppendNumber(Year mod 100, 2)
            else
              AppendNumber(Year, 4);
          end;
          'G':
          begin
            GetCount;
            GetDate;
            AppendString(ConvertEraString(Count));
          end;
          'E':
          begin
            GetCount;
            GetDate;
            AppendString(ConvertYearString(Count));
          end;
          'M':
          begin
            GetCount;
            GetDate;
            case Count of
              1, 2:
                AppendNumber(Month, Count);
              3:
                AppendString(ShortMonthNames[Month]);
            else
              AppendString(LongMonthNames[Month]);
            end;
          end;
          'D':
          begin
            GetCount;
            case Count of
              1, 2:
              begin
                GetDate;
                AppendNumber(Day, Count);
              end;
              3:
                AppendString(ShortDayNames[DayOfWeek(DateTime)]);
              4:
                AppendString(LongDayNames[DayOfWeek(DateTime)]);
              5:
                AppendFormat(Pointer(ShortDateFormat));
            else
              AppendFormat(Pointer(LongDateFormat));
            end;
          end;
          'H':
          begin
            GetCount;
            GetTime;
            BetweenQuotes := False;
            P := Format;
            while P^ <> #0 do
            begin
              if P^ in LeadBytes then
              begin
                P := StrNextChar(P);
                Continue;
              end;
              case P^ of
                'A', 'a':
                  if not BetweenQuotes then
                  begin
                    if ((StrLIComp(P, 'AM/PM', 5) = 0) or
                      (StrLIComp(P, 'A/P', 3) = 0) or (StrLIComp(P, 'AMPM', 4) = 0)) then
                      Use12HourClock := True;
                    Break;
                  end;
                'H', 'h':
                  Break;
                '''', '"':
                  BetweenQuotes := not BetweenQuotes;
              end;
              Inc(P);
            end;
            H := Hour;
            if Use12HourClock then
              if H = 0 then
                H := 12
              else
              if H > 12 then
                Dec(H, 12);
            if Count > 2 then
              Count := 2;
            AppendNumber(H, Count);
          end;
          'N':
          begin
            GetCount;
            GetTime;
            if Count > 2 then
              Count := 2;
            AppendNumber(Min, Count);
          end;
          'S':
          begin
            GetCount;
            GetTime;
            if Count > 2 then
              Count := 2;
            AppendNumber(Sec, Count);
          end;
          'T':
          begin
            GetCount;
            if Count = 1 then
              AppendFormat(Pointer(ShortTimeFormat))
            else
              AppendFormat(Pointer(LongTimeFormat));
          end;
          'Z':
          begin
            GetCount;
            GetTime;
            if Count > 3 then
              Count := 3;
            AppendNumber(MSec, Count);
          end;
          'A':
          begin
            GetTime;
            P := Format - 1;
            if StrLIComp(P, 'AM/PM', 5) = 0 then
            begin
              if Hour >= 12 then
                Inc(P, 3);
              AppendChars(P, 2);
              Inc(Format, 4);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'A/P', 3) = 0 then
            begin
              if Hour >= 12 then
                Inc(P, 2);
              AppendChars(P, 1);
              Inc(Format, 2);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'AMPM', 4) = 0 then
            begin
              if Hour < 12 then
                AppendString(TimeAMString)
              else
                AppendString(TimePMString);
              Inc(Format, 3);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'AAAA', 4) = 0 then
            begin
              GetDate;
              AppendString(LongDayNames[DayOfWeek(DateTime)]);
              Inc(Format, 3);
            end
            else
            if StrLIComp(P, 'AAA', 3) = 0 then
            begin
              GetDate;
              AppendString(ShortDayNames[DayOfWeek(DateTime)]);
              Inc(Format, 2);
            end
            else
              AppendChars(@Starter, 1);
          end;
          'C':
          begin
            GetCount;
            AppendFormat(Pointer(ShortDateFormat));
            GetTime;
            if (Hour <> 0) or (Min <> 0) or (Sec <> 0) then
            begin
              AppendChars(' ', 1);
              AppendFormat(Pointer(LongTimeFormat));
            end;
          end;
          '/':
            if DateSeparator <> #0 then
              AppendChars(@DateSeparator, 1);
          ':':
            if TimeSeparator <> #0 then
              AppendChars(@TimeSeparator, 1);
          '''', '"':
          begin
            P := Format;
            while (Format^ <> #0) and (Format^ <> Starter) do
              if Format^ in LeadBytes then
                Format := StrNextChar(Format)
              else
                Inc(Format);
            AppendChars(P, Format - P);
            if Format^ <> #0 then
              Inc(Format);
          end;
        else
          AppendChars(@Starter, 1);
        end;
      end;
      Dec(AppendLevel);
    end;
  end;

begin
  BufPos := 0;
  AppendLevel := 0;
  if Format <> '' then
    AppendFormat(Pointer(Format))
  else
    AppendFormat('C');
  SetString(Result, Buffer, BufPos);
end;

procedure DateTimeToString(var Result: string; const Format: string;
  DateTime: TDateTime; const FormatSettings: TFormatSettings);
var
  BufPos, AppendLevel: Integer;
  Buffer: array[0..255] of Char;

  procedure AppendChars(P: Pchar; Count: Integer);
  var
    N: Integer;
  begin
    N := SizeOf(Buffer) - BufPos;
    if N > Count then
      N := Count;
    if N <> 0 then
      Move(P[0], Buffer[BufPos], N);
    Inc(BufPos, N);
  end;

  procedure AppendString(const S: string);
  begin
    AppendChars(Pointer(S), Length(S));
  end;

  procedure AppendNumber(Number, Digits: Integer);
  const
    Format: array[0..3] of Char = '%.*d';
  var
    NumBuf: array[0..15] of Char;
  begin
    AppendChars(NumBuf, FormatBuf(NumBuf, SizeOf(NumBuf), Format, SizeOf(Format),
      [Digits, Number]));
  end;

  procedure AppendFormat(Format: Pchar);
  var
    Starter, Token, LastToken: Char;
    DateDecoded, TimeDecoded, Use12HourClock, BetweenQuotes: Boolean;
    P: Pchar;
    Count: Integer;
    Year, Month, Day, Hour, Min, Sec, MSec, H: Word;

    procedure GetCount;
    var
      P: Pchar;
    begin
      P := Format;
      while Format^ = Starter do
        Inc(Format);
      Count := Format - P + 1;
    end;

    procedure GetDate;
    begin
      if not DateDecoded then
      begin
        DecodeDate(DateTime, Year, Month, Day);
        DateDecoded := True;
      end;
    end;

    procedure GetTime;
    begin
      if not TimeDecoded then
      begin
        DecodeTime(DateTime, Hour, Min, Sec, MSec);
        TimeDecoded := True;
      end;
    end;

{$IFDEF MSWINDOWS}
    function ConvertEraString(const Count: Integer) : string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
      P: PChar;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      FormatStr := 'gg';
      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if Count = 1 then
        begin
          case SysLocale.PriLangID of
            LANG_JAPANESE:
              Result := Copy(Result, 1, CharToBytelen(Result, 1));
            LANG_CHINESE:
              if (SysLocale.SubLangID = SUBLANG_CHINESE_TRADITIONAL)
                and (ByteToCharLen(Result, Length(Result)) = 4) then
              begin
                P := Buffer + CharToByteIndex(Result, 3) - 1;
                SetString(Result, P, CharToByteLen(P, 2));
              end;
          end;
        end;
      end;
    end;

    function ConvertYearString(const Count: Integer): string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      if Count <= 2 then
        FormatStr := 'yy' // avoid Win95 bug.
      else
        FormatStr := 'yyyy';

      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if (Count = 1) and (Result[1] = '0') then
          Result := Copy(Result, 2, Length(Result)-1);
      end;
    end;
{$ENDIF}

{$IFDEF LINUX}
    function FindEra(Date: Integer): Byte;
    var
      I: Byte;
    begin
      Result := 0;
      for I := 1 to EraCount do
        if (EraRanges[I].StartDate <= Date) and (EraRanges[I].EndDate >= Date) then
        begin
          Result := I;
          Exit;
        end;
    end;

    function ConvertEraString(const Count: Integer): string;
    var
      I: Byte;
    begin
      Result := '';
      I := FindEra(Trunc(DateTime));
      if I > 0 then
        Result := EraNames[I];
    end;

    function ConvertYearString(const Count: Integer): string;
    var
      I: Byte;
      S: string;
    begin
      I := FindEra(Trunc(DateTime));
      if I > 0 then
        S := IntToStr(Year - EraYearOffsets[I])
      else
        S := IntToStr(Year);
      while Length(S) < Count do
        S := '0' + S;
      if Length(S) > Count then
        S := Copy(S, Length(S) - (Count - 1), Count);
      Result := S;
    end;

{$ENDIF}
  begin
    if (Format <> nil) and (AppendLevel < 2) then
    begin
      Inc(AppendLevel);
      LastToken := ' ';
      DateDecoded := False;
      TimeDecoded := False;
      Use12HourClock := False;
      while Format^ <> #0 do
      begin
        Starter := Format^;
        if Starter in LeadBytes then
        begin
          AppendChars(Format, StrCharLength(Format));
          Format := StrNextChar(Format);
          LastToken := ' ';
          Continue;
        end;
        Format := StrNextChar(Format);
        Token := Starter;
        if Token in ['a'..'z'] then
          Dec(Token, 32);
        if Token in ['A'..'Z'] then
        begin
          if (Token = 'M') and (LastToken = 'H') then
            Token := 'N';
          LastToken := Token;
        end;
        case Token of
          'Y':
          begin
            GetCount;
            GetDate;
            if Count <= 2 then
              AppendNumber(Year mod 100, 2)
            else
              AppendNumber(Year, 4);
          end;
          'G':
          begin
            GetCount;
            GetDate;
            AppendString(ConvertEraString(Count));
          end;
          'E':
          begin
            GetCount;
            GetDate;
            AppendString(ConvertYearString(Count));
          end;
          'M':
          begin
            GetCount;
            GetDate;
            case Count of
              1, 2:
                AppendNumber(Month, Count);
              3:
                AppendString(FormatSettings.ShortMonthNames[Month]);
            else
              AppendString(FormatSettings.LongMonthNames[Month]);
            end;
          end;
          'D':
          begin
            GetCount;
            case Count of
              1, 2:
              begin
                GetDate;
                AppendNumber(Day, Count);
              end;
              3:
                AppendString(FormatSettings.ShortDayNames[DayOfWeek(DateTime)]);
              4:
                AppendString(FormatSettings.LongDayNames[DayOfWeek(DateTime)]);
              5:
                AppendFormat(Pointer(FormatSettings.ShortDateFormat));
            else
              AppendFormat(Pointer(FormatSettings.LongDateFormat));
            end;
          end;
          'H':
          begin
            GetCount;
            GetTime;
            BetweenQuotes := False;
            P := Format;
            while P^ <> #0 do
            begin
              if P^ in LeadBytes then
              begin
                P := StrNextChar(P);
                Continue;
              end;
              case P^ of
                'A', 'a':
                  if not BetweenQuotes then
                  begin
                    if ((StrLIComp(P, 'AM/PM', 5) = 0) or
                      (StrLIComp(P, 'A/P', 3) = 0) or (StrLIComp(P, 'AMPM', 4) = 0)) then
                      Use12HourClock := True;
                    Break;
                  end;
                'H', 'h':
                  Break;
                '''', '"':
                  BetweenQuotes := not BetweenQuotes;
              end;
              Inc(P);
            end;
            H := Hour;
            if Use12HourClock then
              if H = 0 then
                H := 12
              else
              if H > 12 then
                Dec(H, 12);
            if Count > 2 then
              Count := 2;
            AppendNumber(H, Count);
          end;
          'N':
          begin
            GetCount;
            GetTime;
            if Count > 2 then
              Count := 2;
            AppendNumber(Min, Count);
          end;
          'S':
          begin
            GetCount;
            GetTime;
            if Count > 2 then
              Count := 2;
            AppendNumber(Sec, Count);
          end;
          'T':
          begin
            GetCount;
            if Count = 1 then
              AppendFormat(Pointer(FormatSettings.ShortTimeFormat))
            else
              AppendFormat(Pointer(FormatSettings.LongTimeFormat));
          end;
          'Z':
          begin
            GetCount;
            GetTime;
            if Count > 3 then
              Count := 3;
            AppendNumber(MSec, Count);
          end;
          'A':
          begin
            GetTime;
            P := Format - 1;
            if StrLIComp(P, 'AM/PM', 5) = 0 then
            begin
              if Hour >= 12 then
                Inc(P, 3);
              AppendChars(P, 2);
              Inc(Format, 4);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'A/P', 3) = 0 then
            begin
              if Hour >= 12 then
                Inc(P, 2);
              AppendChars(P, 1);
              Inc(Format, 2);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'AMPM', 4) = 0 then
            begin
              if Hour < 12 then
                AppendString(FormatSettings.TimeAMString)
              else
                AppendString(FormatSettings.TimePMString);
              Inc(Format, 3);
              Use12HourClock := TRUE;
            end
            else
            if StrLIComp(P, 'AAAA', 4) = 0 then
            begin
              GetDate;
              AppendString(FormatSettings.LongDayNames[DayOfWeek(DateTime)]);
              Inc(Format, 3);
            end
            else
            if StrLIComp(P, 'AAA', 3) = 0 then
            begin
              GetDate;
              AppendString(FormatSettings.ShortDayNames[DayOfWeek(DateTime)]);
              Inc(Format, 2);
            end
            else
              AppendChars(@Starter, 1);
          end;
          'C':
          begin
            GetCount;
            AppendFormat(Pointer(FormatSettings.ShortDateFormat));
            GetTime;
            if (Hour <> 0) or (Min <> 0) or (Sec <> 0) then
            begin
              AppendChars(' ', 1);
              AppendFormat(Pointer(FormatSettings.LongTimeFormat));
            end;
          end;
          '/':
            if DateSeparator <> #0 then
              AppendChars(@FormatSettings.DateSeparator, 1);
          ':':
            if TimeSeparator <> #0 then
              AppendChars(@FormatSettings.TimeSeparator, 1);
          '''', '"':
          begin
            P := Format;
            while (Format^ <> #0) and (Format^ <> Starter) do
              if Format^ in LeadBytes then
                Format := StrNextChar(Format)
              else
                Inc(Format);
            AppendChars(P, Format - P);
            if Format^ <> #0 then
              Inc(Format);
          end;
        else
          AppendChars(@Starter, 1);
        end;
      end;
      Dec(AppendLevel);
    end;
  end;

begin
  BufPos := 0;
  AppendLevel := 0;
  if Format <> '' then
    AppendFormat(Pointer(Format))
  else
    AppendFormat('C');
  SetString(Result, Buffer, BufPos);
end;

function FloatToStr(Value: Extended): string;
var
  Buffer: array[0..63] of Char;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended, ffGeneral, 15, 0));
end;

function StrToDateDef(const S: string; const Default: TDateTime): TDateTime;
begin
  if not TryStrToDate(S, Result) then
    Result := Default;
end;

function StrToTimeDef(const S: string; const Default: TDateTime): TDateTime;
begin
  if not TryStrToTime(S, Result) then
    Result := Default;
end;

function StrToDateTimeDef(const S: string; const Default: TDateTime): TDateTime;
begin
  if not TryStrToDateTime(S, Result) then
    Result := Default;
end;

function StrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  if not TextToFloat(Pchar(S), Result, fvExtended) then
    Result := Default;
end;

function ByteTypeTest(P: Pchar; Index: Integer): TMbcsByteType;
var
  I: Integer;
begin
  Result := mbSingleByte;
  if (P = nil) or (P[Index] = #$0) then
    Exit;
  if (Index = 0) then
  begin
    if P[0] in LeadBytes then
      Result := mbLeadByte;
  end
  else
  begin
    I := Index - 1;
    while (I >= 0) and (P[I] in LeadBytes) do
      Dec(I);
    if ((Index - I) mod 2) = 0 then
      Result := mbTrailByte
    else
    if P[Index] in LeadBytes then
      Result := mbLeadByte;
  end;
end;

function CompareText(const S1, S2: string): Integer; assembler;
asm
  PUSH    ESI
  PUSH    EDI
  PUSH    EBX
  MOV     ESI,EAX
  MOV     EDI,EDX
  OR      EAX,EAX
  JE      @@0
  MOV     EAX,[EAX-4]
  @@0:    OR      EDX,EDX
  JE      @@1
  MOV     EDX,[EDX-4]
  @@1:    MOV     ECX,EAX
  CMP     ECX,EDX
  JBE     @@2
  MOV     ECX,EDX
  @@2:    CMP     ECX,ECX
  @@3:    REPE    CMPSB
  JE      @@6
  MOV     BL,BYTE PTR [ESI-1]
  CMP     BL,'a'
  JB      @@4
  CMP     BL,'z'
  JA      @@4
  SUB     BL,20H
  @@4:    MOV     BH,BYTE PTR [EDI-1]
  CMP     BH,'a'
  JB      @@5
  CMP     BH,'z'
  JA      @@5
  SUB     BH,20H
  @@5:    CMP     BL,BH
  JE      @@3
  MOVZX   EAX,BL
  MOVZX   EDX,BH
  @@6:    SUB     EAX,EDX
  POP     EBX
  POP     EDI
  POP     ESI
end;

function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
asm
  PUSH    EBX
{$IFDEF PIC}
        PUSH    EAX
        CALL    GETGOT
        MOV     EBX,EAX
        POP     EAX
{$ELSE}
  XOR     EBX,EBX
{$ENDIF}
  MOV     ECX,EAX
  FLD     DateTime
  FMUL    [EBX].FMSecsPerDay
  SUB     ESP,8
  FISTP   QWORD PTR [ESP]
  FWAIT
  POP     EAX
  POP     EDX
  OR      EDX,EDX
  JNS     @@1
  NEG     EDX
  NEG     EAX
  SBB     EDX,0
  DIV     [EBX].IMSecsPerDay
  NEG     EAX
  JMP     @@2
  @@1:    DIV     [EBX].IMSecsPerDay
  @@2:    ADD     EAX,DateDelta
  MOV     [ECX].TTimeStamp.Time,EDX
  MOV     [ECX].TTimeStamp.Date,EAX
  POP     EBX
end;

procedure CvtInt64;
{ IN:
    EAX:  Address of the int64 value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[32]
    ECX:  Base for conversion: 0 for signed decimal, or 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Byte length of converted text
}
asm
  OR      CL, CL
  JNZ     @start             // CL = 0  => signed integer conversion
  MOV     ECX, 10
  TEST    [EAX + 4], $80000000
  JZ      @start
  PUSH    [EAX + 4]
  PUSH    [EAX]
  MOV     EAX, ESP
  NEG     [ESP]              // negate the value
  ADC     [ESP + 4],0
  NEG     [ESP + 4]
  CALL    @start             // perform unsigned conversion
  MOV     [ESI-1].Byte, '-'  // tack on the negative sign
  DEC     ESI
  INC     ECX
  ADD     ESP, 8
  RET

  @start:   // perform unsigned conversion
  PUSH    ESI
  SUB     ESP, 4
  FNSTCW  [ESP+2].Word     // save
  FNSTCW  [ESP].Word       // scratch
  OR      [ESP].Word, $0F00  // trunc toward zero, full precision
  FLDCW   [ESP].Word

  MOV     [ESP].Word, CX
  FLD1
  TEST    [EAX + 4], $80000000 // test for negative
  JZ      @ld1                 // FPU doesn't understand unsigned ints
  PUSH    [EAX + 4]            // copy value before modifying
  PUSH    [EAX]
  AND     [ESP + 4], $7FFFFFFF // clear the sign bit
  PUSH    $7FFFFFFF
  PUSH    $FFFFFFFF
  FILD    [ESP + 8].QWord     // load value
  FILD    [ESP].QWord
  FADD    ST(0), ST(2)        // Add 1.  Produces unsigned $80000000 in ST(0)
  FADDP   ST(1), ST(0)        // Add $80000000 to value to replace the sign bit
  ADD     ESP, 16
  JMP     @ld2
  @ld1:
  FILD    [EAX].QWord         // value
  @ld2:
  FILD    [ESP].Word          // base
  FLD     ST(1)
  @loop:
  DEC     ESI
  FPREM                       // accumulator mod base
  FISTP   [ESP].Word
  FDIV    ST(1), ST(0)        // accumulator := acumulator / base
  MOV     AL, [ESP].Byte      // overlap long FPU division op with int ops
  ADD     AL, '0'
  CMP     AL, '0'+10
  JB      @store
  ADD     AL, ('A'-'0')-10
  @store:
  MOV     [ESI].Byte, AL
  FLD     ST(1)           // copy accumulator
  FCOM    ST(3)           // if accumulator >= 1.0 then loop
  FSTSW   AX
  SAHF
  JAE @loop

  FLDCW   [ESP+2].Word
  ADD     ESP,4

  FFREE   ST(3)
  FFREE   ST(2)
  FFREE   ST(1);
  FFREE   ST(0);

  POP     ECX             // original ESI
  SUB     ECX, ESI        // ECX = length of converted string
  SUB     EDX,ECX
  JBE     @done           // output longer than field width = no pad
  SUB     ESI,EDX
  MOV     AL,'0'
  ADD     ECX,EDX
  JMP     @z
  @zloop: MOV     [ESI+EDX].Byte,AL
  @z:     DEC     EDX
  JNZ     @zloop
  MOV     [ESI].Byte,AL
  @done:
end;

function FormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal;
  const Args: array of const): Cardinal;
var
  ArgIndex, Width, Prec: Integer;
  BufferOrg, FormatOrg, FormatPtr, TempStr: Pchar;
  JustFlag: Byte;
  StrBuf: array[0..64] of Char;
  TempAnsiStr: string;
  SaveGOT: Integer;
{ in: eax <-> Buffer }
{ in: edx <-> BufLen }
{ in: ecx <-> Format }

asm
  PUSH    EBX
  PUSH    ESI
  PUSH    EDI
  MOV     EDI,EAX
  MOV     ESI,ECX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        POP     ECX
{$ELSE}
  XOR     EAX,EAX
{$ENDIF}
  MOV     SaveGOT,EAX
  ADD     ECX,FmtLen
  MOV     BufferOrg,EDI
  XOR     EAX,EAX
  MOV     ArgIndex,EAX
  MOV     TempStr,EAX
  MOV     TempAnsiStr,EAX

  @Loop:
  OR      EDX,EDX
  JE      @Done

  @NextChar:
  CMP     ESI,ECX
  JE      @Done
  LODSB
  CMP     AL,'%'
  JE      @Format

  @StoreChar:
  STOSB
  DEC     EDX
  JNE     @NextChar

  @Done:
  MOV     EAX,EDI
  SUB     EAX,BufferOrg
  JMP     @Exit

  @Format:
  CMP     ESI,ECX
  JE      @Done
  LODSB
  CMP     AL,'%'
  JE      @StoreChar
  LEA     EBX,[ESI-2]
  MOV     FormatOrg,EBX
  @A0:    MOV     JustFlag,AL
  CMP     AL,'-'
  JNE     @A1
  CMP     ESI,ECX
  JE      @Done
  LODSB
  @A1:    CALL    @Specifier
  CMP     AL,':'
  JNE     @A2
  MOV     ArgIndex,EBX
  CMP     ESI,ECX
  JE      @Done
  LODSB
  JMP     @A0

  @A2:    MOV     Width,EBX
  MOV     EBX,-1
  CMP     AL,'.'
  JNE     @A3
  CMP     ESI,ECX
  JE      @Done
  LODSB
  CALL    @Specifier
  @A3:    MOV     Prec,EBX
  MOV     FormatPtr,ESI
  PUSH    ECX
  PUSH    EDX

  CALL    @Convert

  POP     EDX
  MOV     EBX,Width
  SUB     EBX,ECX        //(* ECX <=> number of characters output *)
  JAE     @A4            //(*         jump -> output smaller than width *)
  XOR     EBX,EBX

  @A4:    CMP     JustFlag,'-'
  JNE     @A6
  SUB     EDX,ECX
  JAE     @A5
  ADD     ECX,EDX
  XOR     EDX,EDX

  @A5:    REP     MOVSB

  @A6:    XCHG    EBX,ECX
  SUB     EDX,ECX
  JAE     @A7
  ADD     ECX,EDX
  XOR     EDX,EDX
  @A7:    MOV     AL,' '
  REP     STOSB
  XCHG    EBX,ECX
  SUB     EDX,ECX
  JAE     @A8
  ADD     ECX,EDX
  XOR     EDX,EDX
  @A8:    REP     MOVSB
  CMP     TempStr,0
  JE      @A9
  PUSH    EDX
  LEA     EAX,TempStr
//      PUSH    EBX                   // GOT setup unnecessary for
//      MOV     EBX, SaveGOT          // same-unit calls to Pascal procedures
  CALL    FormatClearStr
//        POP     EBX
  POP     EDX
  @A9:    POP     ECX
  MOV     ESI,FormatPtr
  JMP     @Loop

  @Specifier:
  XOR     EBX,EBX
  CMP     AL,'*'
  JE      @B3
  @B1:    CMP     AL,'0'
  JB      @B5
  CMP     AL,'9'
  JA      @B5
  IMUL    EBX,EBX,10
  SUB     AL,'0'
  MOVZX   EAX,AL
  ADD     EBX,EAX
  CMP     ESI,ECX
  JE      @B2
  LODSB
  JMP     @B1
  @B2:    POP     EAX
  JMP     @Done
  @B3:    MOV     EAX,ArgIndex
  CMP     EAX,Args.Integer[-4]
  JG      @B4
  INC     ArgIndex
  MOV     EBX,Args
  CMP     [EBX+EAX*8].Byte[4],vtInteger
  MOV     EBX,[EBX+EAX*8]
  JE      @B4
  XOR     EBX,EBX
  @B4:    CMP     ESI,ECX
  JE      @B2
  LODSB
  @B5:    RET

  @Convert:
  AND     AL,0DFH
  MOV     CL,AL
  MOV     EAX,1
  MOV     EBX,ArgIndex
  CMP     EBX,Args.Integer[-4]
  JG      @ErrorExit
  INC     ArgIndex
  MOV     ESI,Args
  LEA     ESI,[ESI+EBX*8]
  MOV     EAX,[ESI].Integer[0]       // TVarRec.data
  MOVZX   EDX,[ESI].Byte[4]          // TVarRec.VType
{$IFDEF PIC}
        MOV     EBX, SAVEGOT
        ADD     EBX, OFFSET @CVTVECTOR
        MOV     EBX, [EBX+EDX*4]
        ADD     EBX, SAVEGOT
        JMP     EBX
{$ELSE}
  JMP     @CvtVector.Pointer[EDX*4]
{$ENDIF}

  @CvtVector:
  DD      @CvtInteger                // vtInteger
  DD      @CvtBoolean                // vtBoolean
  DD      @CvtChar                   // vtChar
  DD      @CvtExtended               // vtExtended
  DD      @CvtShortStr               // vtString
  DD      @CvtPointer                // vtPointer
  DD      @CvtPChar                  // vtPChar
  DD      @CvtObject                 // vtObject
  DD      @CvtClass                  // vtClass
  DD      @CvtWideChar               // vtWideChar
  DD      @CvtPWideChar              // vtPWideChar
  DD      @CvtAnsiStr                // vtAnsiString
  DD      @CvtCurrency               // vtCurrency
  DD      @CvtVariant                // vtVariant
  DD      @CvtInterface              // vtInterface
  DD      @CvtWideString             // vtWideString
  DD      @CvtInt64                  // vtInt64

  @CvtBoolean:
  @CvtObject:
  @CvtClass:
  @CvtWideChar:
  @CvtInterface:
  @CvtError:
  XOR     EAX,EAX

  @ErrorExit:
  CALL    @ClearTmpAnsiStr
  MOV     EDX,FormatOrg
  MOV     ECX,FormatPtr
  SUB     ECX,EDX
{$IFDEF PC_MAPPED_EXCEPTIONS}
        //  BECAUSE OF ALL THE ASSEMBLY CODE HERE, WE CAN'T CALL A ROUTINE
        //  THAT THROWS AN EXCEPTION IF IT LOOKS LIKE WE'RE STILL ON THE
        //  STACK.  THE STATIC DISASSEMBLER CANNOT GIVE SUFFICIENT UNWIND
        //  FRAME INFO TO UNWIND THE CONFUSION THAT IS GENERATED FROM THE
        //  ASSEMBLY CODE ABOVE.  SO BEFORE WE THROW THE EXCEPTION, WE
        //  GO TO SOME LENGTHS TO EXCISE OURSELVES FROM THE STACK CHAIN.
        //  WE WERE PASSED 12 BYTES OF PARAMETERS ON THE STACK, AND WE HAVE
        //  TO MAKE SURE THAT WE GET RID OF THOSE, TOO.
        MOV     EBX, SAVEGOT
        MOV     ESP, EBP        // DITCH EVERTHING TO THE FRAME
        MOV     EBP, [ESP + 4]  // GET THE RETURN ADDR
        MOV     [ESP + 16], EBP // MOVE THE RET ADDR UP IN THE STACK
        POP     EBP             // DITCH THE REST OF THE FRAME
        ADD     ESP, 12         // DITCH THE SPACE THAT WAS TAKEN BY PARAMS
        JMP     FORMATERROR     // OFF TO FORMATERR
{$ELSE}
  MOV     EBX, SaveGOT
  CALL    FormatError
{$ENDIF}
        // The above call raises an exception and does not return

  @CvtInt64:
        // CL  <= format character
        // EAX <= address of int64
        // EBX <= TVarRec.VType

  LEA     ESI,StrBuf[32]
  MOV     EDX, Prec
  CMP     EDX, 32
  JBE     @I64_1           // zero padded field width > buffer => no padding
  XOR     EDX, EDX
  @I64_1: MOV     EBX, ECX
  SUB     CL, 'D'
  JZ      CvtInt64         // branch predict backward jump taken
  MOV     ECX, 16
  CMP     BL, 'X'
  JE      CvtInt64
  MOV     ECX, 10
  CMP     BL, 'U'
  JE      CvtInt64
  JMP     @CvtError

{        LEA     EBX, TempInt64       // (input is array of const; save original)
        MOV     EDX, [EAX]
        MOV     [EBX], EDX
        MOV     EDX, [EAX + 4]
        MOV     [EBX + 4], EDX

        // EBX <= address of TempInt64

        CMP     CL,'D'
        JE      @DecI64
        CMP     CL,'U'
        JE      @DecI64_2
        CMP     CL,'X'
        JNE     @CvtError

@HexI64:
        MOV     ECX,16               // hex divisor
        JMP     @CvtI64

@DecI64:
        TEST    DWORD PTR [EBX + 4], $80000000      // sign bit set?
        JE      @DecI64_2            //   no -> bypass '-' output

        NEG     DWORD PTR [EBX]      // negate lo-order, then hi-order
        ADC     DWORD PTR [EBX+4], 0
        NEG     DWORD PTR [EBX+4]

        CALL    @DecI64_2

        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET

@DecI64_2:                           // unsigned int64 output
        MOV     ECX,10               // decimal divisor

@CvtI64:
        LEA     ESI,StrBuf[32]

@CvtI64_1:
        PUSH    EBX
        PUSH    ECX                  // save radix
        PUSH    0
        PUSH    ECX                  // radix divisor (10 or 16 only)
        MOV     EAX, [EBX]
        MOV     EDX, [EBX + 4]
        MOV     EBX, SaveGOT
        CALL    System.@_llumod
        POP     ECX                  // saved radix
        POP     EBX

        XCHG    EAX, EDX             // lo-value to EDX for character output
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @CvtI64_2

        ADD     DL,('A'-'0')-10

@CvtI64_2:
        DEC     ESI
        MOV     [ESI],DL

        PUSH    EBX
        PUSH    ECX                  // save radix
        PUSH    0
        PUSH    ECX                  // radix divisor (10 or 16 only)
        MOV     EAX, [EBX]           // value := value DIV radix
        MOV     EDX, [EBX + 4]
        MOV     EBX, SaveGOT
        CALL    System.@_lludiv
        POP     ECX                  // saved radix
        POP     EBX
        MOV     [EBX], EAX
        MOV     [EBX + 4], EDX
        OR      EAX,EDX              // anything left to output?
        JNE     @CvtI64_1            //   no jump => EDX:EAX = 0

        LEA     ECX,StrBuf[32]
        SUB     ECX,ESI
        MOV     EDX,Prec
        CMP     EDX,16
        JBE     @CvtI64_3
        RET

@CvtI64_3:
        SUB     EDX,ECX
        JBE     @CvtI64_5
        ADD     ECX,EDX
        MOV     AL,'0'

@CvtI64_4:
        DEC     ESI
        MOV     [ESI],AL
        DEC     EDX
        JNE     @CvtI64_4

@CvtI64_5:
        RET
}
////////////////////////////////////////////////

  @CvtInteger:
  LEA     ESI,StrBuf[16]
  MOV     EDX, Prec
  MOV     EBX, ECX
  CMP     EDX, 16
  JBE     @C1             // zero padded field width > buffer => no padding
  XOR     EDX, EDX
  @C1:    SUB     CL, 'D'
  JZ      CvtInt          // branch predict backward jump taken
  MOV     ECX, 16
  CMP     BL, 'X'
  JE      CvtInt
  MOV     ECX, 10
  CMP     BL, 'U'
  JE      CvtInt
  JMP     @CvtError

{        CMP     CL,'D'
        JE      @C1
        CMP     CL,'U'
        JE      @C2
        CMP     CL,'X'
        JNE     @CvtError
        MOV     ECX,16
        JMP     @CvtLong
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLong:
        LEA     ESI,StrBuf[16]
@D1:    XOR     EDX,EDX
        DIV     ECX
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    DEC     ESI
        MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        LEA     ECX,StrBuf[16]
        SUB     ECX,ESI
        MOV     EDX,Prec
        CMP     EDX,16
        JBE     @D3
        RET
@D3:    SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
@D4:    DEC     ESI
        MOV     [ESI],AL
        DEC     EDX
        JNE     @D4
@D5:    RET
}
  @CvtChar:
  CMP     CL,'S'
  JNE     @CvtError
  MOV     ECX,1
  RET

  @CvtVariant:
  CMP     CL,'S'
  JNE     @CvtError
  CMP     [EAX].TVarData.VType,varNull
  JBE     @CvtEmptyStr
  MOV     EDX,EAX
  LEA     EAX,TempStr
//      PUSH    EBX                   // GOT setup unnecessary for
//      MOV     EBX, SaveGOT          // same-unit calls to Pascal procedures
  CALL    FormatVarToStr
//        POP     EBX
  MOV     ESI,TempStr
  JMP     @CvtStrRef

  @CvtEmptyStr:
  XOR     ECX,ECX
  RET

  @CvtShortStr:
  CMP     CL,'S'
  JNE     @CvtError
  MOV     ESI,EAX
  LODSB
  MOVZX   ECX,AL
  JMP     @CvtStrLen

  @CvtPWideChar:
  MOV    ESI,OFFSET System.@LStrFromPWChar
  JMP    @CvtWideThing

  @CvtWideString:
  MOV    ESI,OFFSET System.@LStrFromWStr

  @CvtWideThing:
  ADD    ESI, SaveGOT
{$IFDEF PIC}
        MOV    ESI, [ESI]
{$ENDIF}
  CMP    CL,'S'
  JNE    @CvtError
  MOV    EDX,EAX
  LEA    EAX,TempAnsiStr
  PUSH   EBX
  MOV    EBX, SaveGOT
  CALL   ESI
  POP    EBX
  MOV    ESI,TempAnsiStr
  MOV    EAX,ESI
  JMP    @CvtStrRef

  @CvtAnsiStr:
  CMP     CL,'S'
  JNE     @CvtError
  MOV     ESI,EAX

  @CvtStrRef:
  OR      ESI,ESI
  JE      @CvtEmptyStr
  MOV     ECX,[ESI-4]

  @CvtStrLen:
  CMP     ECX,Prec
  JA      @E1
  RET
  @E1:    MOV     ECX,Prec
  RET

  @CvtPChar:
  CMP     CL,'S'
  JNE     @CvtError
  MOV     ESI,EAX
  PUSH    EDI
  MOV     EDI,EAX
  XOR     AL,AL
  MOV     ECX,Prec
  JECXZ   @F1
  REPNE   SCASB
  JNE     @F1
  DEC     EDI
  @F1:    MOV     ECX,EDI
  SUB     ECX,ESI
  POP     EDI
  RET

  @CvtPointer:
  CMP     CL,'P'
  JNE     @CvtError
  MOV     EDX,8
  MOV     ECX,16
  LEA     ESI,StrBuf[16]
  JMP     CvtInt

  @CvtCurrency:
  MOV     BH,fvCurrency
  JMP     @CvtFloat

  @CvtExtended:
  MOV     BH,fvExtended

  @CvtFloat:
  MOV     ESI,EAX
  MOV     BL,ffGeneral
  CMP     CL,'G'
  JE      @G2
  MOV     BL,ffExponent
  CMP     CL,'E'
  JE      @G2
  MOV     BL,ffFixed
  CMP     CL,'F'
  JE      @G1
  MOV     BL,ffNumber
  CMP     CL,'N'
  JE      @G1
  CMP     CL,'M'
  JNE     @CvtError
  MOV     BL,ffCurrency
  @G1:    MOV     EAX,18
  MOV     EDX,Prec
  CMP     EDX,EAX
  JBE     @G3
  MOV     EDX,2
  CMP     CL,'M'
  JNE     @G3
  MOVZX   EDX,CurrencyDecimals
  JMP     @G3
  @G2:    MOV     EAX,Prec
  MOV     EDX,3
  CMP     EAX,18
  JBE     @G3
  MOV     EAX,15
  @G3:    PUSH    EBX
  PUSH    EAX
  PUSH    EDX
  LEA     EAX,StrBuf
  MOV     EDX,ESI
  MOVZX   ECX,BH
  MOV     EBX, SaveGOT
  CALL    FloatToText
  MOV     ECX,EAX
  LEA     ESI,StrBuf
  RET

  @ClearTmpAnsiStr:
  PUSH    EBX
  PUSH    EAX
  LEA     EAX,TempAnsiStr
  MOV     EBX, SaveGOT
  CALL    System.@LStrClr
  POP     EAX
  POP     EBX
  RET

  @Exit:
  CALL    @ClearTmpAnsiStr
  POP     EDI
  POP     ESI
  POP     EBX
end;

procedure InitSysLocale;
var
  DefaultLCID: LCID;
  DefaultLangID: LANGID;
  AnsiCPInfo: TCPInfo;
  I: Integer;
  BufferA: array [128..255] of Char;
  BufferW: array [128..256] of Word;
  PCharA: Pchar;

  procedure InitLeadBytes;
  var
    I: Integer;
    J: Byte;
  begin
    GetCPInfo(LCIDToCodePage(SysLocale.DefaultLCID), AnsiCPInfo);
    with AnsiCPInfo do
    begin
      I := 0;
      while (I < MAX_LEADBYTES) and ((LeadByte[I] or LeadByte[I + 1]) <> 0) do
      begin
        for J := LeadByte[I] to LeadByte[I + 1] do
          Include(LeadBytes, Char(J));
        Inc(I, 2);
      end;
    end;
  end;

  function IsWesternGroup: Boolean;
  type
    TLangGroup = $00..$1D;
    TLangGroups = set of TLangGroup;
  const
    lgNeutral = TLangGroup($00);
    lgDanish = TLangGroup($06);
    lgDutch = TLangGroup($13);
    lgEnglish = TLangGroup($09);
    lgFinnish = TLangGroup($0B);
    lgFrench = TLangGroup($0C);
    lgGerman = TLangGroup($07);
    lgItalian = TLangGroup($10);
    lgNorwegian = TLangGroup($14);
    lgPortuguese = TLangGroup($16);
    lgSpanish = TLangGroup($0A);
    lgSwedish = TLangGroup($1D);
    WesternGroups: TLangGroups =
      [lgNeutral, lgDanish, lgDutch, lgEnglish, lgFinnish,
      lgFrench, lgGerman, lgItalian, lgNorwegian, lgPortuguese,
      lgSpanish, lgSwedish];
  begin
    Result := SysLocale.PriLangID in WesternGroups;
  end;

begin
  { Set default to English (US). }
  SysLocale.DefaultLCID := $0409;
  SysLocale.PriLangID := LANG_ENGLISH;
  SysLocale.SubLangID := SUBLANG_ENGLISH_US;

  DefaultLCID := GetThreadLocale;
  if DefaultLCID <> 0 then
    SysLocale.DefaultLCID := DefaultLCID;

  DefaultLangID := Word(DefaultLCID);
  if DefaultLangID <> 0 then
  begin
    SysLocale.PriLangID := DefaultLangID and $3ff;
    SysLocale.SubLangID := DefaultLangID shr 10;
  end;

  LeadBytes := [];
  if true then
  begin
    if IsWesternGroup then
    begin
      SysLocale.MiddleEast := False;
      SysLocale.FarEast := False;
    end
    else
    begin
      { Far East (aka MBCS)? - }
      InitLeadBytes;
      SysLocale.FarEast := LeadBytes <> [];
      if SysLocale.FarEast then
      begin
        SysLocale.MiddleEast := False;
        Exit;
      end;

      { Middle East? }
      for I := Low(BufferA) to High(BufferA) do
        BufferA[I] := Char(I);
      PCharA := @BufferA; { not null terminated: include length in GetStringTypeExA call }
      GetStringTypeEx(SysLocale.DefaultLCID, CT_CTYPE2, PCharA, High(BufferA) -
        Low(BufferA) + 1, BufferW);
      for I := Low(BufferA) to High(BufferA) do
      begin
        SysLocale.MiddleEast := BufferW[I] = C2_RIGHTTOLEFT;
        if SysLocale.MiddleEast then
          Exit;
      end;
    end;
  end
  else
  begin
    SysLocale.MiddleEast := GetSystemMetrics(SM_MIDEASTENABLED) <> 0;
    SysLocale.FarEast := GetSystemMetrics(SM_DBCSENABLED) <> 0;
    if SysLocale.FarEast then
      InitLeadBytes;
  end;
end;

var
  SShortMonthNameJan: string = 'Янв';
  SShortMonthNameFeb: string = 'Фев';
  SShortMonthNameMar: string = 'Мар';
  SShortMonthNameApr: string = 'Апр';
  SShortMonthNameMay: string = 'Май';
  SShortMonthNameJun: string = 'Июн';
  SShortMonthNameJul: string = 'Июл';
  SShortMonthNameAug: string = 'Авг';
  SShortMonthNameSep: string = 'Сен';
  SShortMonthNameOct: string = 'Окт';
  SShortMonthNameNov: string = 'Ноя';
  SShortMonthNameDec: string = 'Дек';
  SLongMonthNameJan: string = 'Январь';
  SLongMonthNameFeb: string = 'Февраль';
  SLongMonthNameMar: string = 'Март';
  SLongMonthNameApr: string = 'Апрель';
  SLongMonthNameMay: string = 'Май';
  SLongMonthNameJun: string = 'Июнь';
  SLongMonthNameJul: string = 'Июль';
  SLongMonthNameAug: string = 'Август';
  SLongMonthNameSep: string = 'Сентябрь';
  SLongMonthNameOct: string = 'Октябрь';
  SLongMonthNameNov: string = 'Ноябрь';
  SLongMonthNameDec: string = 'Декабрь';
  SShortDayNameSun: string = 'Вс';
  SShortDayNameMon: string = 'Пн';
  SShortDayNameTue: string = 'Вт';
  SShortDayNameWed: string = 'Ср';
  SShortDayNameThu: string = 'Чт';
  SShortDayNameFri: string = 'Пт';
  SShortDayNameSat: string = 'Сб';
  SLongDayNameSun: string = 'Воскресенье';
  SLongDayNameMon: string = 'Понедельник';
  SLongDayNameTue: string = 'Вторник';
  SLongDayNameWed: string = 'Среда';
  SLongDayNameThu: string = 'Четверг';
  SLongDayNameFri: string = 'Пятница';
  SLongDayNameSat: string = 'Суббота';

var
  DefShortMonthNames: array[1..12] of
  Pointer = (@SShortMonthNameJan, @SShortMonthNameFeb, @SShortMonthNameMar,
    @SShortMonthNameApr, @SShortMonthNameMay, @SShortMonthNameJun, @SShortMonthNameJul,
    @SShortMonthNameAug, @SShortMonthNameSep, @SShortMonthNameOct, @SShortMonthNameNov,
    @SShortMonthNameDec);

  DefLongMonthNames: array[1..12] of
  Pointer = (@SLongMonthNameJan, @SLongMonthNameFeb, @SLongMonthNameMar,
    @SLongMonthNameApr, @SLongMonthNameMay, @SLongMonthNameJun, @SLongMonthNameJul,
    @SLongMonthNameAug, @SLongMonthNameSep, @SLongMonthNameOct, @SLongMonthNameNov,
    @SLongMonthNameDec);

  DefShortDayNames: array[1..7] of
  Pointer = (@SShortDayNameSun, @SShortDayNameMon, @SShortDayNameTue,
    @SShortDayNameWed, @SShortDayNameThu, @SShortDayNameFri, @SShortDayNameSat);

  DefLongDayNames: array[1..7] of
  Pointer = (@SLongDayNameSun, @SLongDayNameMon, @SLongDayNameTue, @SLongDayNameWed,
    @SLongDayNameThu, @SLongDayNameFri, @SLongDayNameSat);

procedure GetMonthDayNames;
var
  I, Day: Integer;
  DefaultLCID: LCID;

  function LocalGetLocaleStr(LocaleType, Index: Integer;
  const DefValues: array of Pointer): string;
  begin
    Result := GetLocaleStr(DefaultLCID, LocaleType, '');
    if Result = '' then
      Result := LoadResString(DefValues[Index]);
  end;

begin
  DefaultLCID := GetThreadLocale;
  for I := 1 to 12 do
  begin
    ShortMonthNames[I] := LocalGetLocaleStr(LOCALE_SABBREVMONTHNAME1 + I - 1,
      I - Low(DefShortMonthNames), DefShortMonthNames);
    LongMonthNames[I] := LocalGetLocaleStr(LOCALE_SMONTHNAME1 + I - 1, I -
      Low(DefLongMonthNames), DefLongMonthNames);
  end;
  for I := 1 to 7 do
  begin
    Day := (I + 5) mod 7;
    ShortDayNames[I] := LocalGetLocaleStr(LOCALE_SABBREVDAYNAME1 + Day, I -
      Low(DefShortDayNames), DefShortDayNames);
    LongDayNames[I] := LocalGetLocaleStr(LOCALE_SDAYNAME1 + Day, I -
      Low(DefLongDayNames), DefLongDayNames);
  end;
end;

procedure GetEraNamesAndYearOffsets;
var
  J: Integer;
  CalendarType: CALTYPE;
begin
  CalendarType := StrToIntDef(GetLocaleStr(GetThreadLocale, LOCALE_IOPTIONALCALENDAR, '1'), 1);
  if CalendarType in [CAL_JAPAN, CAL_TAIWAN, CAL_KOREA] then
  begin
    EnumCalendarInfoA(@EnumEraNames, GetThreadLocale, CalendarType,
      CAL_SERASTRING);
    for J := Low(EraYearOffsets) to High(EraYearOffsets) do
      EraYearOffsets[J] := -1;
    EnumCalendarInfoA(@EnumEraYearOffsets, GetThreadLocale, CalendarType,
      CAL_IYEAROFFSETRANGE);
  end;
end;

function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string;
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

function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char;
var
  Buffer: array[0..1] of Char;
begin
  if GetLocaleInfo(Locale, LocaleType, Buffer, 2) > 0 then
    Result := Buffer[0]
  else
    Result := Default;
end;

function TranslateDateFormat(const FormatStr: string): string;
var
  I: Integer;
  L: Integer;
  CalendarType: CALTYPE;
  RemoveEra: Boolean;
begin
  I := 1;
  Result := '';
  CalendarType := StrToIntDef(GetLocaleStr(GetThreadLocale, LOCALE_ICALENDARTYPE, '1'), 1);
  if not (CalendarType in [CAL_JAPAN, CAL_TAIWAN, CAL_KOREA]) then
  begin
    RemoveEra := SysLocale.PriLangID in [LANG_JAPANESE, LANG_CHINESE, LANG_KOREAN];
    if RemoveEra then
    begin
      while I <= Length(FormatStr) do
      begin
        if not (FormatStr[I] in ['g', 'G']) then
          Result := Result + FormatStr[I];
        Inc(I);
      end;
    end
    else
      Result := FormatStr;
    Exit;
  end;

  while I <= Length(FormatStr) do
    if FormatStr[I] in LeadBytes then
    begin
      L := CharLength(FormatStr, I);
      Result := Result + Copy(FormatStr, I, L);
      Inc(I, L);
    end
    else
    begin
      if StrLIComp(@FormatStr[I], 'gg', 2) = 0 then
      begin
        Result := Result + 'ggg';
        Inc(I, 1);
      end
      else
      if StrLIComp(@FormatStr[I], 'yyyy', 4) = 0 then
      begin
        Result := Result + 'eeee';
        Inc(I, 4 - 1);
      end
      else
      if StrLIComp(@FormatStr[I], 'yy', 2) = 0 then
      begin
        Result := Result + 'ee';
        Inc(I, 2 - 1);
      end
      else
      if FormatStr[I] in ['y', 'Y'] then
        Result := Result + 'e'
      else
        Result := Result + FormatStr[I];
      Inc(I);
    end;
end;

procedure DecodeDate(const DateTime: TDateTime; var Year, Month, Day: Word);
var
  Dummy: Word;
begin
  DecodeDateFully(DateTime, Year, Month, Day, Dummy);
end;

function CharToByteLen(const S: string; MaxLen: Integer): Integer;
var
  Chars: Integer;
begin
  Result := 0;
  if MaxLen <= 0 then
    Exit;
  if MaxLen > Length(S) then
    MaxLen := Length(S);
  if SysLocale.FarEast then
  begin
    CountChars(S, MaxLen, Chars, Result);
    if Result > Length(S) then
      Result := Length(S);
  end
  else
    Result := MaxLen;
end;

function ByteToCharLen(const S: string; MaxLen: Integer): Integer;
begin
  if Length(S) < MaxLen then
    MaxLen := Length(S);
  Result := ByteToCharIndex(S, MaxLen);
end;

function CharToByteIndex(const S: string; Index: Integer): Integer;
var
  Chars: Integer;
begin
  Result := 0;
  if (Index <= 0) or (Index > Length(S)) then
    Exit;
  if (Index > 1) and SysLocale.FarEast then
  begin
    CountChars(S, Index - 1, Chars, Result);
    if (Chars < (Index - 1)) or (Result >= Length(S)) then
      Result := 0  // Char index out of range
    else
      Inc(Result);
  end
  else
    Result := Index;
end;

function StrCharLength(const Str: Pchar): Integer;
begin
  if SysLocale.FarEast then
    Result := Integer(CharNext(Str)) - Integer(Str)
  else
    Result := 1;
end;

function StrNextChar(const Str: Pchar): Pchar;
begin
  Result := CharNext(Str);
end;

function DayOfWeek(const DateTime: TDateTime): Word;
begin
  Result := DateTimeToTimeStamp(DateTime).Date mod 7 + 1;
end;

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

function FloatToText(BufferArg: Pchar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer): Integer;
var
  Buffer: Cardinal;
  FloatRec: TFloatRec;
  SaveGOT: Integer;
  DecimalSep: Char;
  ThousandSep: Char;
  CurrencyStr: Pointer;
  CurrFmt: Byte;
  NegCurrFmt: Byte;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     Buffer,EAX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        MOV     SAVEGOT,EAX
        MOV     ECX,[EAX].OFFSET DECIMALSEPARATOR
        MOV     CL,[ECX]
        MOV     DECIMALSEP,CL
        MOV     ECX,[EAX].OFFSET THOUSANDSEPARATOR
        MOV     CL,[ECX].BYTE
        MOV     THOUSANDSEP,CL
        MOV     ECX,[EAX].OFFSET CURRENCYSTRING
        MOV     ECX,[ECX].INTEGER
        MOV     CURRENCYSTR,ECX
        MOV     ECX,[EAX].OFFSET CURRENCYFORMAT
        MOV     CL,[ECX].BYTE
        MOV     CURRFMT,CL
        MOV     ECX,[EAX].OFFSET NEGCURRFORMAT
        MOV     CL,[ECX].BYTE
        MOV     NEGCURRFMT,CL
        POP     ECX
{$ELSE}
  MOV     AL,DecimalSeparator
  MOV     DecimalSep,AL
  MOV     AL,ThousandSeparator
  MOV     ThousandSep,AL
  MOV     EAX,CurrencyString
  MOV     CurrencyStr,EAX
  MOV     AL,CurrencyFormat
  MOV     CurrFmt,AL
  MOV     AL,NegCurrFormat
  MOV     NegCurrFmt,AL
  MOV     SaveGOT,0
{$ENDIF}
  MOV     EAX,19
  CMP     CL,fvExtended
  JNE     @@2
  MOV     EAX,Precision
  CMP     EAX,2
  JGE     @@1
  MOV     EAX,2
  @@1:    CMP     EAX,18
  JLE     @@2
  MOV     EAX,18
  @@2:    MOV     Precision,EAX
  PUSH    EAX
  MOV     EAX,9999
  CMP     Format,ffFixed
  JB      @@3
  MOV     EAX,Digits
  @@3:    PUSH    EAX
  LEA     EAX,FloatRec
  CALL    FloatToDecimal
  MOV     EDI,Buffer
  MOVZX   EAX,FloatRec.Exponent
  SUB     EAX,7FFFH
  CMP     EAX,2
  JAE     @@4
  MOV     ECX, EAX
  CALL    @@PutSign
  LEA     ESI,@@INFNAN[ECX+ECX*2]
  ADD     ESI,SaveGOT
  MOV     ECX,3
  REP     MOVSB
  JMP     @@7
  @@4:    LEA     ESI,FloatRec.Digits
  MOVZX   EBX,Format
  CMP     BL,ffExponent
  JE      @@6
  CMP     BL,ffCurrency
  JA      @@5
  MOVSX   EAX,FloatRec.Exponent
  CMP     EAX,Precision
  JLE     @@6
  @@5:    MOV     BL,ffGeneral
  @@6:    LEA     EBX,@@FormatVector[EBX*4]
  ADD     EBX,SaveGOT
  MOV     EBX,[EBX]
  ADD     EBX,SaveGOT
  CALL    EBX
  @@7:    MOV     EAX,EDI
  SUB     EAX,Buffer
  POP     EBX
  POP     ESI
  POP     EDI
  JMP     @@Exit

  @@FormatVector:
  DD      @@PutFGeneral
  DD      @@PutFExponent
  DD      @@PutFFixed
  DD      @@PutFNumber
  DD      @@PutFCurrency

  @@INFNAN: DB 'INFNAN'

// Get digit or '0' if at end of digit string

  @@GetDigit:

  LODSB
  OR      AL,AL
  JNE     @@a1
  MOV     AL,'0'
  DEC     ESI
  @@a1:   RET

// Store '-' if number is negative

  @@PutSign:

  CMP     FloatRec.Negative,0
  JE      @@b1
  MOV     AL,'-'
  STOSB
  @@b1:   RET

// Convert number using ffGeneral format

  @@PutFGeneral:

  CALL    @@PutSign
  MOVSX   ECX,FloatRec.Exponent
  XOR     EDX,EDX
  CMP     ECX,Precision
  JG      @@c1
  CMP     ECX,-3
  JL      @@c1
  OR      ECX,ECX
  JG      @@c2
  MOV     AL,'0'
  STOSB
  CMP     BYTE PTR [ESI],0
  JE      @@c6
  MOV     AL,DecimalSep
  STOSB
  NEG     ECX
  MOV     AL,'0'
  REP     STOSB
  JMP     @@c3
  @@c1:   MOV     ECX,1
  INC     EDX
  @@c2:   LODSB
  OR      AL,AL
  JE      @@c4
  STOSB
  LOOP    @@c2
  LODSB
  OR      AL,AL
  JE      @@c5
  MOV     AH,AL
  MOV     AL,DecimalSep
  STOSW
  @@c3:   LODSB
  OR      AL,AL
  JE      @@c5
  STOSB
  JMP     @@c3
  @@c4:   MOV     AL,'0'
  REP     STOSB
  @@c5:   OR      EDX,EDX
  JE      @@c6
  XOR     EAX,EAX
  JMP     @@PutFloatExpWithDigits
  @@c6:   RET

// Convert number using ffExponent format

  @@PutFExponent:

  CALL    @@PutSign
  CALL    @@GetDigit
  MOV     AH,DecimalSep
  STOSW
  MOV     ECX,Precision
  DEC     ECX
  @@d1:   CALL    @@GetDigit
  STOSB
  LOOP    @@d1
  MOV     AH,'+'

  @@PutFloatExpWithDigits:

  MOV     ECX,Digits
  CMP     ECX,4
  JBE     @@PutFloatExp
  XOR     ECX,ECX

// Store exponent
// In   AH  = Positive sign character ('+' or 0)
//      ECX = Minimum number of digits (0..4)

  @@PutFloatExp:

  MOV     AL,'E'
  MOV     BL, FloatRec.Digits.Byte
  MOVSX   EDX,FloatRec.Exponent
  DEC     EDX
  CALL    PutExponent
  RET

// Convert number using ffFixed or ffNumber format

  @@PutFFixed:
  @@PutFNumber:

  CALL    @@PutSign

// Store number in fixed point format

  @@PutNumber:

  MOV     EDX,Digits
  CMP     EDX,18
  JB      @@f1
  MOV     EDX,18
  @@f1:   MOVSX   ECX,FloatRec.Exponent
  OR      ECX,ECX
  JG      @@f2
  MOV     AL,'0'
  STOSB
  JMP     @@f4
  @@f2:   XOR     EBX,EBX
  CMP     Format,ffFixed
  JE      @@f3
  MOV     EAX,ECX
  DEC     EAX
  MOV     BL,3
  DIV     BL
  MOV     BL,AH
  INC     EBX
  @@f3:   CALL    @@GetDigit
  STOSB
  DEC     ECX
  JE      @@f4
  DEC     EBX
  JNE     @@f3
  MOV     AL,ThousandSep
  TEST    AL,AL
  JZ      @@f3
  STOSB
  MOV     BL,3
  JMP     @@f3
  @@f4:   OR      EDX,EDX
  JE      @@f7
  MOV     AL,DecimalSep
  TEST    AL,AL
  JZ      @@f4b
  STOSB
  @@f4b:  JECXZ   @@f6
  MOV     AL,'0'
  @@f5:   STOSB
  DEC     EDX
  JE      @@f7
  INC     ECX
  JNE     @@f5
  @@f6:   CALL    @@GetDigit
  STOSB
  DEC     EDX
  JNE     @@f6
  @@f7:   RET

// Convert number using ffCurrency format

  @@PutFCurrency:

  XOR     EBX,EBX
  MOV     BL,CurrFmt.Byte
  MOV     ECX,0003H
  CMP     FloatRec.Negative,0
  JE      @@g1
  MOV     BL,NegCurrFmt.Byte
  MOV     ECX,040FH
  @@g1:   CMP     BL,CL
  JBE     @@g2
  MOV     BL,CL
  @@g2:   ADD     BL,CH
  LEA     EBX,@@MoneyFormats[EBX+EBX*4]
  ADD     EBX,SaveGOT
  MOV     ECX,5
  @@g10:  MOV     AL,[EBX]
  CMP     AL,'@'
  JE      @@g14
  PUSH    ECX
  PUSH    EBX
  CMP     AL,'$'
  JE      @@g11
  CMP     AL,'*'
  JE      @@g12
  STOSB
  JMP     @@g13
  @@g11:  CALL    @@PutCurSym
  JMP     @@g13
  @@g12:  CALL    @@PutNumber
  @@g13:  POP     EBX
  POP     ECX
  INC     EBX
  LOOP    @@g10
  @@g14:  RET

// Store currency symbol string

  @@PutCurSym:

  PUSH    ESI
  MOV     ESI,CurrencyStr
  TEST    ESI,ESI
  JE      @@h1
  MOV     ECX,[ESI-4]
  REP     MOVSB
  @@h1:   POP     ESI
  RET

// Currency formatting templates

  @@MoneyFormats:
  DB      '$*@@@'
  DB      '*$@@@'
  DB      '$ *@@'
  DB      '* $@@'
  DB      '($*)@'
  DB      '-$*@@'
  DB      '$-*@@'
  DB      '$*-@@'
  DB      '(*$)@'
  DB      '-*$@@'
  DB      '*-$@@'
  DB      '*$-@@'
  DB      '-* $@'
  DB      '-$ *@'
  DB      '* $-@'
  DB      '$ *-@'
  DB      '$ -*@'
  DB      '*- $@'
  DB      '($ *)'
  DB      '(* $)'

  @@Exit:
end;

function FloatToText(BufferArg: Pchar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer;
  const FormatSettings: TFormatSettings): Integer;
var
  Buffer: Cardinal;
  FloatRec: TFloatRec;
  SaveGOT: Integer;
  DecimalSep: Char;
  ThousandSep: Char;
  CurrencyStr: Pointer;
  CurrFmt: Byte;
  NegCurrFmt: Byte;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     Buffer,EAX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        MOV     SAVEGOT,EAX
        POP     ECX
{$ENDIF}
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.DecimalSeparator
  MOV     DecimalSep,AL
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.ThousandSeparator
  MOV     ThousandSep,AL
  MOV     EAX,FormatSettings
  MOV     EAX,[EAX].TFormatSettings.CurrencyString
  MOV     CurrencyStr,EAX
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.CurrencyFormat
  MOV     CurrFmt,AL
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.NegCurrFormat
  MOV     NegCurrFmt,AL
  MOV     SaveGOT,0
  MOV     EAX,19
  CMP     CL,fvExtended
  JNE     @@2
  MOV     EAX,Precision
  CMP     EAX,2
  JGE     @@1
  MOV     EAX,2
  @@1:    CMP     EAX,18
  JLE     @@2
  MOV     EAX,18
  @@2:    MOV     Precision,EAX
  PUSH    EAX
  MOV     EAX,9999
  CMP     Format,ffFixed
  JB      @@3
  MOV     EAX,Digits
  @@3:    PUSH    EAX
  LEA     EAX,FloatRec
  CALL    FloatToDecimal
  MOV     EDI,Buffer
  MOVZX   EAX,FloatRec.Exponent
  SUB     EAX,7FFFH
  CMP     EAX,2
  JAE     @@4
  MOV     ECX, EAX
  CALL    @@PutSign
  LEA     ESI,@@INFNAN[ECX+ECX*2]
  ADD     ESI,SaveGOT
  MOV     ECX,3
  REP     MOVSB
  JMP     @@7
  @@4:    LEA     ESI,FloatRec.Digits
  MOVZX   EBX,Format
  CMP     BL,ffExponent
  JE      @@6
  CMP     BL,ffCurrency
  JA      @@5
  MOVSX   EAX,FloatRec.Exponent
  CMP     EAX,Precision
  JLE     @@6
  @@5:    MOV     BL,ffGeneral
  @@6:    LEA     EBX,@@FormatVector[EBX*4]
  ADD     EBX,SaveGOT
  MOV     EBX,[EBX]
  ADD     EBX,SaveGOT
  CALL    EBX
  @@7:    MOV     EAX,EDI
  SUB     EAX,Buffer
  POP     EBX
  POP     ESI
  POP     EDI
  JMP     @@Exit

  @@FormatVector:
  DD      @@PutFGeneral
  DD      @@PutFExponent
  DD      @@PutFFixed
  DD      @@PutFNumber
  DD      @@PutFCurrency

  @@INFNAN: DB 'INFNAN'

// Get digit or '0' if at end of digit string

  @@GetDigit:

  LODSB
  OR      AL,AL
  JNE     @@a1
  MOV     AL,'0'
  DEC     ESI
  @@a1:   RET

// Store '-' if number is negative

  @@PutSign:

  CMP     FloatRec.Negative,0
  JE      @@b1
  MOV     AL,'-'
  STOSB
  @@b1:   RET

// Convert number using ffGeneral format

  @@PutFGeneral:

  CALL    @@PutSign
  MOVSX   ECX,FloatRec.Exponent
  XOR     EDX,EDX
  CMP     ECX,Precision
  JG      @@c1
  CMP     ECX,-3
  JL      @@c1
  OR      ECX,ECX
  JG      @@c2
  MOV     AL,'0'
  STOSB
  CMP     BYTE PTR [ESI],0
  JE      @@c6
  MOV     AL,DecimalSep
  STOSB
  NEG     ECX
  MOV     AL,'0'
  REP     STOSB
  JMP     @@c3
  @@c1:   MOV     ECX,1
  INC     EDX
  @@c2:   LODSB
  OR      AL,AL
  JE      @@c4
  STOSB
  LOOP    @@c2
  LODSB
  OR      AL,AL
  JE      @@c5
  MOV     AH,AL
  MOV     AL,DecimalSep
  STOSW
  @@c3:   LODSB
  OR      AL,AL
  JE      @@c5
  STOSB
  JMP     @@c3
  @@c4:   MOV     AL,'0'
  REP     STOSB
  @@c5:   OR      EDX,EDX
  JE      @@c6
  XOR     EAX,EAX
  JMP     @@PutFloatExpWithDigits
  @@c6:   RET

// Convert number using ffExponent format

  @@PutFExponent:

  CALL    @@PutSign
  CALL    @@GetDigit
  MOV     AH,DecimalSep
  STOSW
  MOV     ECX,Precision
  DEC     ECX
  @@d1:   CALL    @@GetDigit
  STOSB
  LOOP    @@d1
  MOV     AH,'+'

  @@PutFloatExpWithDigits:

  MOV     ECX,Digits
  CMP     ECX,4
  JBE     @@PutFloatExp
  XOR     ECX,ECX

// Store exponent
// In   AH  = Positive sign character ('+' or 0)
//      ECX = Minimum number of digits (0..4)

  @@PutFloatExp:

  MOV     AL,'E'
  MOV     BL, FloatRec.Digits.Byte
  MOVSX   EDX,FloatRec.Exponent
  DEC     EDX
  CALL    PutExponent
  RET

// Convert number using ffFixed or ffNumber format

  @@PutFFixed:
  @@PutFNumber:

  CALL    @@PutSign

// Store number in fixed point format

  @@PutNumber:

  MOV     EDX,Digits
  CMP     EDX,18
  JB      @@f1
  MOV     EDX,18
  @@f1:   MOVSX   ECX,FloatRec.Exponent
  OR      ECX,ECX
  JG      @@f2
  MOV     AL,'0'
  STOSB
  JMP     @@f4
  @@f2:   XOR     EBX,EBX
  CMP     Format,ffFixed
  JE      @@f3
  MOV     EAX,ECX
  DEC     EAX
  MOV     BL,3
  DIV     BL
  MOV     BL,AH
  INC     EBX
  @@f3:   CALL    @@GetDigit
  STOSB
  DEC     ECX
  JE      @@f4
  DEC     EBX
  JNE     @@f3
  MOV     AL,ThousandSep
  TEST    AL,AL
  JZ      @@f3
  STOSB
  MOV     BL,3
  JMP     @@f3
  @@f4:   OR      EDX,EDX
  JE      @@f7
  MOV     AL,DecimalSep
  TEST    AL,AL
  JZ      @@f4b
  STOSB
  @@f4b:  JECXZ   @@f6
  MOV     AL,'0'
  @@f5:   STOSB
  DEC     EDX
  JE      @@f7
  INC     ECX
  JNE     @@f5
  @@f6:   CALL    @@GetDigit
  STOSB
  DEC     EDX
  JNE     @@f6
  @@f7:   RET

// Convert number using ffCurrency format

  @@PutFCurrency:

  XOR     EBX,EBX
  MOV     BL,CurrFmt.Byte
  MOV     ECX,0003H
  CMP     FloatRec.Negative,0
  JE      @@g1
  MOV     BL,NegCurrFmt.Byte
  MOV     ECX,040FH
  @@g1:   CMP     BL,CL
  JBE     @@g2
  MOV     BL,CL
  @@g2:   ADD     BL,CH
  LEA     EBX,@@MoneyFormats[EBX+EBX*4]
  ADD     EBX,SaveGOT
  MOV     ECX,5
  @@g10:  MOV     AL,[EBX]
  CMP     AL,'@'
  JE      @@g14
  PUSH    ECX
  PUSH    EBX
  CMP     AL,'$'
  JE      @@g11
  CMP     AL,'*'
  JE      @@g12
  STOSB
  JMP     @@g13
  @@g11:  CALL    @@PutCurSym
  JMP     @@g13
  @@g12:  CALL    @@PutNumber
  @@g13:  POP     EBX
  POP     ECX
  INC     EBX
  LOOP    @@g10
  @@g14:  RET

// Store currency symbol string

  @@PutCurSym:

  PUSH    ESI
  MOV     ESI,CurrencyStr
  TEST    ESI,ESI
  JE      @@h1
  MOV     ECX,[ESI-4]
  REP     MOVSB
  @@h1:   POP     ESI
  RET

// Currency formatting templates

  @@MoneyFormats:
  DB      '$*@@@'
  DB      '*$@@@'
  DB      '$ *@@'
  DB      '* $@@'
  DB      '($*)@'
  DB      '-$*@@'
  DB      '$-*@@'
  DB      '$*-@@'
  DB      '(*$)@'
  DB      '-*$@@'
  DB      '*-$@@'
  DB      '*$-@@'
  DB      '-* $@'
  DB      '-$ *@'
  DB      '* $-@'
  DB      '$ *-@'
  DB      '$ -*@'
  DB      '*- $@'
  DB      '($ *)'
  DB      '(* $)'

  @@Exit:
end;

function FloatToTextEx(BufferArg: Pchar; const Value; ValueType: TFloatValue;
  Format: TFloatFormat; Precision, Digits: Integer;
  const FormatSettings: TFormatSettings): Integer;
begin
  Result := FloatToText(BufferArg, Value, ValueType, Format, Precision, Digits, FormatSettings);
end;

function FloatToTextFmt(Buf: Pchar; const Value; ValueType: TFloatValue; Format: Pchar): Integer;
var
  Buffer: Pointer;
  ThousandSep: Boolean;
  DecimalSep: Char;
  ThousandsSep: Char;
  Scientific: Boolean;
  Section: Integer;
  DigitCount: Integer;
  DecimalIndex: Integer;
  FirstDigit: Integer;
  LastDigit: Integer;
  DigitPlace: Integer;
  DigitDelta: Integer;
  FloatRec: TFloatRec;
  SaveGOT: Pointer;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     Buffer,EAX
  MOV     EDI,EDX
  MOV     EBX,ECX
{$IFDEF PIC}
        CALL    GETGOT
        MOV     SAVEGOT,EAX
        MOV     ECX,[EAX].OFFSET DECIMALSEPARATOR
        MOV     CL,[ECX].BYTE
        MOV     DECIMALSEP,CL
        MOV     ECX,[EAX].OFFSET THOUSANDSEPARATOR
        MOV     CL,[ECX].BYTE
        MOV     THOUSANDSSEP,CL
{$ELSE}
  MOV     SaveGOT,0
  MOV     AL,DecimalSeparator
  MOV     DecimalSep,AL
  MOV     AL,ThousandSeparator
  MOV     ThousandsSep,AL
{$ENDIF}
  MOV     ECX,2
  CMP     BL,fvExtended
  JE      @@1
  MOV     EAX,[EDI].Integer
  OR      EAX,[EDI].Integer[4]
  JE      @@2
  MOV     ECX,[EDI].Integer[4]
  SHR     ECX,31
  JMP     @@2
  @@1:    MOVZX   EAX,[EDI].Word[8]
  OR      EAX,[EDI].Integer[0]
  OR      EAX,[EDI].Integer[4]
  JE      @@2
  MOVZX   ECX,[EDI].Word[8]
  SHR     ECX,15
  @@2:    CALL    @@FindSection
  JE      @@5
  CALL    @@ScanSection
  MOV     EAX,DigitCount
  MOV     EDX,9999
  CMP     Scientific,0
  JNE     @@3
  SUB     EAX,DecimalIndex
  MOV     EDX,EAX
  MOV     EAX,18
  @@3:    PUSH    EAX
  PUSH    EDX
  LEA     EAX,FloatRec
  MOV     EDX,EDI
  MOV     ECX,EBX
  CALL    FloatToDecimal
  MOV     AX,FloatRec.Exponent
  CMP     AX,8000H
  JE      @@5
  CMP     AX,7FFFH
  JE      @@5
  CMP     BL,fvExtended
  JNE     @@6
  CMP     AX,18
  JLE     @@6
  CMP     Scientific,0
  JNE     @@6
  @@5:    PUSH    ffGeneral
  PUSH    15
  PUSH    0
  MOV     EAX,Buffer
  MOV     EDX,EDI
  MOV     ECX,EBX
  CALL    FloatToText
  JMP     @@Exit
  @@6:    CMP     FloatRec.Digits.Byte,0
  JNE     @@7
  MOV     ECX,2
  CALL    @@FindSection
  JE      @@5
  CMP     ESI,Section
  JE      @@7
  CALL    @@ScanSection
  @@7:    CALL    @@ApplyFormat
  JMP     @@Exit

// Find format section
// In   ECX = Section index
// Out  ESI = Section offset
//      ZF  = 1 if section is empty

  @@FindSection:
  MOV     ESI,Format
  JECXZ   @@fs2
  @@fs1:  LODSB
  CMP     AL,"'"
  JE      @@fs4
  CMP     AL,'"'
  JE      @@fs4
  OR      AL,AL
  JE      @@fs2
  CMP     AL,';'
  JNE     @@fs1
  LOOP    @@fs1
  MOV     AL,byte ptr [ESI]
  OR      AL,AL
  JE      @@fs2
  CMP     AL,';'
  JNE     @@fs3
  @@fs2:  MOV     ESI,Format
  MOV     AL,byte ptr [ESI]
  OR      AL,AL
  JE      @@fs3
  CMP     AL,';'
  @@fs3:  RET
  @@fs4:  MOV     AH,AL
  @@fs5:  LODSB
  CMP     AL,AH
  JE      @@fs1
  OR      AL,AL
  JNE     @@fs5
  JMP     @@fs2

// Scan format section

  @@ScanSection:
  PUSH    EBX
  MOV     Section,ESI
  MOV     EBX,32767
  XOR     ECX,ECX
  XOR     EDX,EDX
  MOV     DecimalIndex,-1
  MOV     ThousandSep,DL
  MOV     Scientific,DL
  @@ss1:  LODSB
  @@ss2:  CMP     AL,'#'
  JE      @@ss10
  CMP     AL,'0'
  JE      @@ss11
  CMP     AL,'.'
  JE      @@ss13
  CMP     AL,','
  JE      @@ss14
  CMP     AL,"'"
  JE      @@ss15
  CMP     AL,'"'
  JE      @@ss15
  CMP     AL,'E'
  JE      @@ss20
  CMP     AL,'e'
  JE      @@ss20
  CMP     AL,';'
  JE      @@ss30
  OR      AL,AL
  JNE     @@ss1
  JMP     @@ss30
  @@ss10: INC     EDX
  JMP     @@ss1
  @@ss11: CMP     EDX,EBX
  JGE     @@ss12
  MOV     EBX,EDX
  @@ss12: INC     EDX
  MOV     ECX,EDX
  JMP     @@ss1
  @@ss13: CMP     DecimalIndex,-1
  JNE     @@ss1
  MOV     DecimalIndex,EDX
  JMP     @@ss1
  @@ss14: MOV     ThousandSep,1
  JMP     @@ss1
  @@ss15: MOV     AH,AL
  @@ss16: LODSB
  CMP     AL,AH
  JE      @@ss1
  OR      AL,AL
  JNE     @@ss16
  JMP     @@ss30
  @@ss20: LODSB
  CMP     AL,'-'
  JE      @@ss21
  CMP     AL,'+'
  JNE     @@ss2
  @@ss21: MOV     Scientific,1
  @@ss22: LODSB
  CMP     AL,'0'
  JE      @@ss22
  JMP     @@ss2
  @@ss30: MOV     DigitCount,EDX
  CMP     DecimalIndex,-1
  JNE     @@ss31
  MOV     DecimalIndex,EDX
  @@ss31: MOV     EAX,DecimalIndex
  SUB     EAX,ECX
  JLE     @@ss32
  XOR     EAX,EAX
  @@ss32: MOV     LastDigit,EAX
  MOV     EAX,DecimalIndex
  SUB     EAX,EBX
  JGE     @@ss33
  XOR     EAX,EAX
  @@ss33: MOV     FirstDigit,EAX
  POP     EBX
  RET

// Apply format string

  @@ApplyFormat:
  CMP     Scientific,0
  JE      @@af1
  MOV     EAX,DecimalIndex
  XOR     EDX,EDX
  JMP     @@af3
  @@af1:  MOVSX   EAX,FloatRec.Exponent
  CMP     EAX,DecimalIndex
  JG      @@af2
  MOV     EAX,DecimalIndex
  @@af2:  MOVSX   EDX,FloatRec.Exponent
  SUB     EDX,DecimalIndex
  @@af3:  MOV     DigitPlace,EAX
  MOV     DigitDelta,EDX
  MOV     ESI,Section
  MOV     EDI,Buffer
  LEA     EBX,FloatRec.Digits
  CMP     FloatRec.Negative,0
  JE      @@af10
  CMP     ESI,Format
  JNE     @@af10
  MOV     AL,'-'
  STOSB
  @@af10: LODSB
  CMP     AL,'#'
  JE      @@af20
  CMP     AL,'0'
  JE      @@af20
  CMP     AL,'.'
  JE      @@af10
  CMP     AL,','
  JE      @@af10
  CMP     AL,"'"
  JE      @@af25
  CMP     AL,'"'
  JE      @@af25
  CMP     AL,'E'
  JE      @@af30
  CMP     AL,'e'
  JE      @@af30
  CMP     AL,';'
  JE      @@af40
  OR      AL,AL
  JE      @@af40
  @@af11: STOSB
  JMP     @@af10
  @@af20: CALL    @@PutFmtDigit
  JMP     @@af10
  @@af25: MOV     AH,AL
  @@af26: LODSB
  CMP     AL,AH
  JE      @@af10
  OR      AL,AL
  JE      @@af40
  STOSB
  JMP     @@af26
  @@af30: MOV     AH,[ESI]
  CMP     AH,'+'
  JE      @@af31
  CMP     AH,'-'
  JNE     @@af11
  XOR     AH,AH
  @@af31: MOV     ECX,-1
  @@af32: INC     ECX
  INC     ESI
  CMP     [ESI].Byte,'0'
  JE      @@af32
  CMP     ECX,4
  JB      @@af33
  MOV     ECX,4
  @@af33: PUSH    EBX
  MOV     BL,FloatRec.Digits.Byte
  MOVSX   EDX,FloatRec.Exponent
  SUB     EDX,DecimalIndex
  CALL    PutExponent
  POP     EBX
  JMP     @@af10
  @@af40: MOV     EAX,EDI
  SUB     EAX,Buffer
  RET

// Store formatted digit

  @@PutFmtDigit:
  CMP     DigitDelta,0
  JE      @@fd3
  JL      @@fd2
  @@fd1:  CALL    @@fd3
  DEC     DigitDelta
  JNE     @@fd1
  JMP     @@fd3
  @@fd2:  INC     DigitDelta
  MOV     EAX,DigitPlace
  CMP     EAX,FirstDigit
  JLE     @@fd4
  JMP     @@fd7
  @@fd3:  MOV     AL,[EBX]
  INC     EBX
  OR      AL,AL
  JNE     @@fd5
  DEC     EBX
  MOV     EAX,DigitPlace
  CMP     EAX,LastDigit
  JLE     @@fd7
  @@fd4:  MOV     AL,'0'
  @@fd5:  CMP     DigitPlace,0
  JNE     @@fd6
  MOV     AH,AL
  MOV     AL,DecimalSep
  STOSW
  JMP     @@fd7
  @@fd6:  STOSB
  CMP     ThousandSep,0
  JE      @@fd7
  MOV     EAX,DigitPlace
  CMP     EAX,1
  JLE     @@fd7
  MOV     DL,3
  DIV     DL
  CMP     AH,1
  JNE     @@fd7
  MOV     AL,ThousandsSep
  TEST    AL,AL
  JZ      @@fd7
  STOSB
  @@fd7:  DEC     DigitPlace
  RET

  @@exit:
  POP     EBX
  POP     ESI
  POP     EDI
end;

function FloatToTextFmt(Buf: Pchar; const Value; ValueType: TFloatValue;
  Format: Pchar; const FormatSettings: TFormatSettings): Integer;
var
  Buffer: Pointer;
  ThousandSep: Boolean;
  DecimalSep: Char;
  ThousandsSep: Char;
  Scientific: Boolean;
  Section: Integer;
  DigitCount: Integer;
  DecimalIndex: Integer;
  FirstDigit: Integer;
  LastDigit: Integer;
  DigitPlace: Integer;
  DigitDelta: Integer;
  FloatRec: TFloatRec;
  SaveGOT: Pointer;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     Buffer,EAX
  MOV     EDI,EDX
  MOV     EBX,ECX
{$IFDEF PIC}
        CALL    GETGOT
        MOV     SAVEGOT,EAX
{$ELSE}
  MOV     SaveGOT,0
{$ENDIF}
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.DecimalSeparator
  MOV     DecimalSep,AL
  MOV     EAX,FormatSettings
  MOV     AL,[EAX].TFormatSettings.ThousandSeparator
  MOV     ThousandsSep,AL
  MOV     ECX,2
  CMP     BL,fvExtended
  JE      @@1
  MOV     EAX,[EDI].Integer
  OR      EAX,[EDI].Integer[4]
  JE      @@2
  MOV     ECX,[EDI].Integer[4]
  SHR     ECX,31
  JMP     @@2
  @@1:    MOVZX   EAX,[EDI].Word[8]
  OR      EAX,[EDI].Integer[0]
  OR      EAX,[EDI].Integer[4]
  JE      @@2
  MOVZX   ECX,[EDI].Word[8]
  SHR     ECX,15
  @@2:    CALL    @@FindSection
  JE      @@5
  CALL    @@ScanSection
  MOV     EAX,DigitCount
  MOV     EDX,9999
  CMP     Scientific,0
  JNE     @@3
  SUB     EAX,DecimalIndex
  MOV     EDX,EAX
  MOV     EAX,18
  @@3:    PUSH    EAX
  PUSH    EDX
  LEA     EAX,FloatRec
  MOV     EDX,EDI
  MOV     ECX,EBX
  CALL    FloatToDecimal
  MOV     AX,FloatRec.Exponent
  CMP     AX,8000H
  JE      @@5
  CMP     AX,7FFFH
  JE      @@5
  CMP     BL,fvExtended
  JNE     @@6
  CMP     AX,18
  JLE     @@6
  CMP     Scientific,0
  JNE     @@6
  @@5:    PUSH    ffGeneral
  PUSH    15
  PUSH    0
  MOV     EAX,[FormatSettings]
  PUSH    EAX
  MOV     EAX,Buffer
  MOV     EDX,EDI
  MOV     ECX,EBX
  CALL    FloatToTextEx
  JMP     @@Exit
  @@6:    CMP     FloatRec.Digits.Byte,0
  JNE     @@7
  MOV     ECX,2
  CALL    @@FindSection
  JE      @@5
  CMP     ESI,Section
  JE      @@7
  CALL    @@ScanSection
  @@7:    CALL    @@ApplyFormat
  JMP     @@Exit

// Find format section
// In   ECX = Section index
// Out  ESI = Section offset
//      ZF  = 1 if section is empty

  @@FindSection:
  MOV     ESI,Format
  JECXZ   @@fs2
  @@fs1:  LODSB
  CMP     AL,"'"
  JE      @@fs4
  CMP     AL,'"'
  JE      @@fs4
  OR      AL,AL
  JE      @@fs2
  CMP     AL,';'
  JNE     @@fs1
  LOOP    @@fs1
  MOV     AL,byte ptr [ESI]
  OR      AL,AL
  JE      @@fs2
  CMP     AL,';'
  JNE     @@fs3
  @@fs2:  MOV     ESI,Format
  MOV     AL,byte ptr [ESI]
  OR      AL,AL
  JE      @@fs3
  CMP     AL,';'
  @@fs3:  RET
  @@fs4:  MOV     AH,AL
  @@fs5:  LODSB
  CMP     AL,AH
  JE      @@fs1
  OR      AL,AL
  JNE     @@fs5
  JMP     @@fs2

// Scan format section

  @@ScanSection:
  PUSH    EBX
  MOV     Section,ESI
  MOV     EBX,32767
  XOR     ECX,ECX
  XOR     EDX,EDX
  MOV     DecimalIndex,-1
  MOV     ThousandSep,DL
  MOV     Scientific,DL
  @@ss1:  LODSB
  @@ss2:  CMP     AL,'#'
  JE      @@ss10
  CMP     AL,'0'
  JE      @@ss11
  CMP     AL,'.'
  JE      @@ss13
  CMP     AL,','
  JE      @@ss14
  CMP     AL,"'"
  JE      @@ss15
  CMP     AL,'"'
  JE      @@ss15
  CMP     AL,'E'
  JE      @@ss20
  CMP     AL,'e'
  JE      @@ss20
  CMP     AL,';'
  JE      @@ss30
  OR      AL,AL
  JNE     @@ss1
  JMP     @@ss30
  @@ss10: INC     EDX
  JMP     @@ss1
  @@ss11: CMP     EDX,EBX
  JGE     @@ss12
  MOV     EBX,EDX
  @@ss12: INC     EDX
  MOV     ECX,EDX
  JMP     @@ss1
  @@ss13: CMP     DecimalIndex,-1
  JNE     @@ss1
  MOV     DecimalIndex,EDX
  JMP     @@ss1
  @@ss14: MOV     ThousandSep,1
  JMP     @@ss1
  @@ss15: MOV     AH,AL
  @@ss16: LODSB
  CMP     AL,AH
  JE      @@ss1
  OR      AL,AL
  JNE     @@ss16
  JMP     @@ss30
  @@ss20: LODSB
  CMP     AL,'-'
  JE      @@ss21
  CMP     AL,'+'
  JNE     @@ss2
  @@ss21: MOV     Scientific,1
  @@ss22: LODSB
  CMP     AL,'0'
  JE      @@ss22
  JMP     @@ss2
  @@ss30: MOV     DigitCount,EDX
  CMP     DecimalIndex,-1
  JNE     @@ss31
  MOV     DecimalIndex,EDX
  @@ss31: MOV     EAX,DecimalIndex
  SUB     EAX,ECX
  JLE     @@ss32
  XOR     EAX,EAX
  @@ss32: MOV     LastDigit,EAX
  MOV     EAX,DecimalIndex
  SUB     EAX,EBX
  JGE     @@ss33
  XOR     EAX,EAX
  @@ss33: MOV     FirstDigit,EAX
  POP     EBX
  RET

// Apply format string

  @@ApplyFormat:
  CMP     Scientific,0
  JE      @@af1
  MOV     EAX,DecimalIndex
  XOR     EDX,EDX
  JMP     @@af3
  @@af1:  MOVSX   EAX,FloatRec.Exponent
  CMP     EAX,DecimalIndex
  JG      @@af2
  MOV     EAX,DecimalIndex
  @@af2:  MOVSX   EDX,FloatRec.Exponent
  SUB     EDX,DecimalIndex
  @@af3:  MOV     DigitPlace,EAX
  MOV     DigitDelta,EDX
  MOV     ESI,Section
  MOV     EDI,Buffer
  LEA     EBX,FloatRec.Digits
  CMP     FloatRec.Negative,0
  JE      @@af10
  CMP     ESI,Format
  JNE     @@af10
  MOV     AL,'-'
  STOSB
  @@af10: LODSB
  CMP     AL,'#'
  JE      @@af20
  CMP     AL,'0'
  JE      @@af20
  CMP     AL,'.'
  JE      @@af10
  CMP     AL,','
  JE      @@af10
  CMP     AL,"'"
  JE      @@af25
  CMP     AL,'"'
  JE      @@af25
  CMP     AL,'E'
  JE      @@af30
  CMP     AL,'e'
  JE      @@af30
  CMP     AL,';'
  JE      @@af40
  OR      AL,AL
  JE      @@af40
  @@af11: STOSB
  JMP     @@af10
  @@af20: CALL    @@PutFmtDigit
  JMP     @@af10
  @@af25: MOV     AH,AL
  @@af26: LODSB
  CMP     AL,AH
  JE      @@af10
  OR      AL,AL
  JE      @@af40
  STOSB
  JMP     @@af26
  @@af30: MOV     AH,[ESI]
  CMP     AH,'+'
  JE      @@af31
  CMP     AH,'-'
  JNE     @@af11
  XOR     AH,AH
  @@af31: MOV     ECX,-1
  @@af32: INC     ECX
  INC     ESI
  CMP     [ESI].Byte,'0'
  JE      @@af32
  CMP     ECX,4
  JB      @@af33
  MOV     ECX,4
  @@af33: PUSH    EBX
  MOV     BL,FloatRec.Digits.Byte
  MOVSX   EDX,FloatRec.Exponent
  SUB     EDX,DecimalIndex
  CALL    PutExponent
  POP     EBX
  JMP     @@af10
  @@af40: MOV     EAX,EDI
  SUB     EAX,Buffer
  RET

// Store formatted digit

  @@PutFmtDigit:
  CMP     DigitDelta,0
  JE      @@fd3
  JL      @@fd2
  @@fd1:  CALL    @@fd3
  DEC     DigitDelta
  JNE     @@fd1
  JMP     @@fd3
  @@fd2:  INC     DigitDelta
  MOV     EAX,DigitPlace
  CMP     EAX,FirstDigit
  JLE     @@fd4
  JMP     @@fd7
  @@fd3:  MOV     AL,[EBX]
  INC     EBX
  OR      AL,AL
  JNE     @@fd5
  DEC     EBX
  MOV     EAX,DigitPlace
  CMP     EAX,LastDigit
  JLE     @@fd7
  @@fd4:  MOV     AL,'0'
  @@fd5:  CMP     DigitPlace,0
  JNE     @@fd6
  MOV     AH,AL
  MOV     AL,DecimalSep
  STOSW
  JMP     @@fd7
  @@fd6:  STOSB
  CMP     ThousandSep,0
  JE      @@fd7
  MOV     EAX,DigitPlace
  CMP     EAX,1
  JLE     @@fd7
  MOV     DL,3
  DIV     DL
  CMP     AH,1
  JNE     @@fd7
  MOV     AL,ThousandsSep
  TEST    AL,AL
  JZ      @@fd7
  STOSB
  @@fd7:  DEC     DigitPlace
  RET

  @@exit:
  POP     EBX
  POP     ESI
  POP     EDI
end;

function TryStrToDate(const S: string; out Value: TDateTime): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  Result := ScanDate(S, Pos, Value) and (Pos > Length(S));
end;

function TryStrToTime(const S: string; out Value: TDateTime): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  Result := ScanTime(S, Pos, Value) and (Pos > Length(S));
end;

function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean;
var
  Pos: Integer;
  Date, Time: TDateTime;
begin
  Result := True;
  Pos := 1;
  Time := 0;
  if not ScanDate(S, Pos, Date) or not ((Pos > Length(S)) or ScanTime(S, Pos, Time)) then

    // Try time only
    Result := TryStrToTime(S, Value)
  else
  if Date >= 0 then
    Value := Date + Time
  else
    Value := Date - Time;
end;

procedure FormatClearStr(var S: string);
begin
  S := '';
end;

procedure FormatError(ErrorCode: Integer; Format: Pchar; FmtLen: Cardinal);
var
  FormatErrorStrs: array[0..1] of PResStringRec;
  Buffer: array[0..31] of Char;
begin
  FormatErrorStrs[0] := @SInvalidFormat;
  FormatErrorStrs[1] := @SArgumentMissing;
  if FmtLen > 31 then
    FmtLen := 31;
  if StrByteType(Format, FmtLen - 1) = mbLeadByte then
    Dec(FmtLen);
  StrMove(Buffer, Format, FmtLen);
  Buffer[FmtLen] := #0;
  ConvertErrorFmt(FormatErrorStrs[ErrorCode], [Pchar(@Buffer)]);
end;

function FormatFloat(const Format: string; Value: Extended): string;
var
  Buffer: array[0..255] of Char;
begin
  if Length(Format) > SizeOf(Buffer) - 32 then
    ConvertError(@SFormatTooLong);
  SetString(Result, Buffer, FloatToTextFmt(Buffer, Value, fvExtended, Pchar(Format)));
end;

function FormatFloat(const Format: string; Value: Extended;
  const FormatSettings: TFormatSettings): string;
var
  Buffer: array[0..255] of Char;
begin
  if Length(Format) > SizeOf(Buffer) - 32 then
    ConvertError(@SFormatTooLong);
  SetString(Result, Buffer, FloatToTextFmt(Buffer, Value, fvExtended,
    Pchar(Format), FormatSettings));
end;

procedure FormatVarToStr(var S: string; const V: TVarData);
begin
  if Assigned(System.VarToLStrProc) then
    System.VarToLStrProc(S, V)
  else
    System.Error(reVarInvalidOp);
end;

function LCIDToCodePage(ALcid: LCID): Integer;
var
  Buffer: array [0..6] of Char;
begin
  GetLocaleInfo(ALcid, LOCALE_IDEFAULTANSICODEPAGE, Buffer, SizeOf(Buffer));
  Result := StrToIntDef(Buffer, GetACP);
end;

function EnumEraNames(Names: Pchar): Integer; stdcall;
var
  I: Integer;
begin
  Result := 0;
  I := Low(EraNames);
  while EraNames[I] <> '' do
    if (I = High(EraNames)) then
      Exit
    else
      Inc(I);
  EraNames[I] := Names;
  Result := 1;
end;

function EnumEraYearOffsets(YearOffsets: Pchar): Integer; stdcall;
var
  I: Integer;
begin
  Result := 0;
  I := Low(EraYearOffsets);
  while EraYearOffsets[I] <> -1 do
    if (I = High(EraYearOffsets)) then
      Exit
    else
      Inc(I);
  EraYearOffsets[I] := StrToIntDef(YearOffsets, 0);
  Result := 1;
end;

function CharLength(const S: string; Index: Integer): Integer;
begin
  Result := 1;
  assert((Index > 0) and (Index <= Length(S)));
  if SysLocale.FarEast and (S[Index] in LeadBytes) then
    Result := StrCharLength(Pchar(S) + Index - 1);
end;

function DecodeDateFully(const DateTime: TDateTime; var Year, Month, Day, DOW: Word): Boolean;
const
  D1 = 365;
  D4 = D1 * 4 + 1;
  D100 = D4 * 25 - 1;
  D400 = D100 * 4 + 1;
var
  Y, M, D, I: Word;
  T: Integer;
  DayTable: PDayTable;
begin
  T := DateTimeToTimeStamp(DateTime).Date;
  if T <= 0 then
  begin
    Year := 0;
    Month := 0;
    Day := 0;
    DOW := 0;
    Result := False;
  end
  else
  begin
    DOW := T mod 7 + 1;
    Dec(T);
    Y := 1;
    while T >= D400 do
    begin
      Dec(T, D400);
      Inc(Y, 400);
    end;
    DivMod(T, D100, I, D);
    if I = 4 then
    begin
      Dec(I);
      Inc(D, D100);
    end;
    Inc(Y, I * 100);
    DivMod(D, D4, I, D);
    Inc(Y, I * 4);
    DivMod(D, D1, I, D);
    if I = 4 then
    begin
      Dec(I);
      Inc(D, D1);
    end;
    Inc(Y, I);
    Result := IsLeapYear(Y);
    DayTable := @MonthDays[Result];
    M := 1;
    while True do
    begin
      I := DayTable^[M];
      if D < I then
        Break;
      Dec(D, I);
      Inc(M);
    end;
    Year := Y;
    Month := M;
    Day := D + 1;
  end;
end;

procedure CountChars(const S: string; MaxChars: Integer; var CharCount, ByteCount: Integer);
var
  C, L, B: Integer;
begin
  L := Length(S);
  C := 1;
  B := 1;
  while (B < L) and (C < MaxChars) do
  begin
    Inc(C);
    if S[B] in LeadBytes then
      B := NextCharIndex(S, B)
    else
      Inc(B);
  end;
  if (C = MaxChars) and (B < L) and (S[B] in LeadBytes) then
    B := NextCharIndex(S, B) - 1;
  CharCount := C;
  ByteCount := B;
end;

function ByteToCharIndex(const S: string; Index: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  if (Index <= 0) or (Index > Length(S)) then
    Exit;
  Result := Index;
  if not SysLocale.FarEast then
    Exit;
  I := 1;
  Result := 0;
  while I <= Index do
  begin
    if S[I] in LeadBytes then
      I := NextCharIndex(S, I)
    else
      Inc(I);
    Inc(Result);
  end;
end;

procedure FloatToDecimal(var Result: TFloatRec; const Value; ValueType: TFloatValue;
  Precision, Decimals: Integer);
var
  StatWord: Word;
  Exponent: Integer;
  Temp: Double;
  BCDValue: Extended;
  SaveGOT: Pointer;
asm
  PUSH    EDI
  PUSH    ESI
  PUSH    EBX
  MOV     EBX,EAX
  MOV     ESI,EDX
{$IFDEF PIC}
        PUSH    ECX
        CALL    GETGOT
        POP     ECX
        MOV     SAVEGOT,EAX
{$ELSE}
  MOV     SaveGOT,0
{$ENDIF}
  CMP     CL,fvExtended
  JE      @@1
  CALL    @@CurrToDecimal
  JMP     @@Exit
  @@1:    CALL    @@ExtToDecimal
  JMP     @@Exit

// Convert Extended to decimal

  @@ExtToDecimal:

  MOV     AX,[ESI].Word[8]
  MOV     EDX,EAX
  AND     EAX,7FFFH
  JE      @@ed1
  CMP     EAX,7FFFH
  JNE     @@ed10
// check for special values (INF, NAN)
  TEST    [ESI].Word[6],8000H
  JZ      @@ed2
// any significand bit set = NAN
// all significand bits clear = INF
  CMP     dword ptr [ESI], 0
  JNZ     @@ed0
  CMP     dword ptr [ESI+4], 80000000H
  JZ      @@ed2
  @@ed0:  INC     EAX
  @@ed1:  XOR     EDX,EDX
  @@ed2:  MOV     [EBX].TFloatRec.Digits.Byte,0
  JMP     @@ed31
  @@ed10: FLD     TBYTE PTR [ESI]
  SUB     EAX,3FFFH
  IMUL    EAX,19728
  SAR     EAX,16
  INC     EAX
  MOV     Exponent,EAX
  MOV     EAX,18
  SUB     EAX,Exponent
  FABS
  PUSH    EBX
  MOV     EBX,SaveGOT
  CALL    FPower10
  POP     EBX
  FRNDINT
  MOV     EDI,SaveGOT
  FLD     [EDI].FCon1E18
  FCOMP
  FSTSW   StatWord
  FWAIT
  TEST    StatWord,mC0+mC3
  JE      @@ed11
  FIDIV   [EDI].DCon10
  INC     Exponent
  @@ed11: FBSTP   BCDValue
  LEA     EDI,[EBX].TFloatRec.Digits
  MOV     EDX,9
  FWAIT
  @@ed12: MOV     AL,BCDValue[EDX-1].Byte
  MOV     AH,AL
  SHR     AL,4
  AND     AH,0FH
  ADD     AX,'00'
  STOSW
  DEC     EDX
  JNE     @@ed12
  XOR     AL,AL
  STOSB
  @@ed20: MOV     EDI,Exponent
  ADD     EDI,Decimals
  JNS     @@ed21
  XOR     EAX,EAX
  JMP     @@ed1
  @@ed21: CMP     EDI,Precision
  JB      @@ed22
  MOV     EDI,Precision
  @@ed22: CMP     EDI,18
  JAE     @@ed26
  CMP     [EBX].TFloatRec.Digits.Byte[EDI],'5'
  JB      @@ed25
  @@ed23: MOV     [EBX].TFloatRec.Digits.Byte[EDI],0
  DEC     EDI
  JS      @@ed24
  INC     [EBX].TFloatRec.Digits.Byte[EDI]
  CMP     [EBX].TFloatRec.Digits.Byte[EDI],'9'
  JA      @@ed23
  JMP     @@ed30
  @@ed24: MOV     [EBX].TFloatRec.Digits.Word,'1'
  INC     Exponent
  JMP     @@ed30
  @@ed26: MOV     EDI,18
  @@ed25: MOV     [EBX].TFloatRec.Digits.Byte[EDI],0
  DEC     EDI
  JS      @@ed32
  CMP     [EBX].TFloatRec.Digits.Byte[EDI],'0'
  JE      @@ed25
  @@ed30: MOV     DX,[ESI].Word[8]
  @@ed30a:
  MOV     EAX,Exponent
  @@ed31: SHR     DX,15
  MOV     [EBX].TFloatRec.Exponent,AX
  MOV     [EBX].TFloatRec.Negative,DL
  RET
  @@ed32: XOR     EDX,EDX
  JMP     @@ed30a

  @@DecimalTable:
  DD      10
  DD      100
  DD      1000
  DD      10000

// Convert Currency to decimal

  @@CurrToDecimal:

  MOV     EAX,[ESI].Integer[0]
  MOV     EDX,[ESI].Integer[4]
  MOV     ECX,EAX
  OR      ECX,EDX
  JE      @@cd20
  OR      EDX,EDX
  JNS     @@cd1
  NEG     EDX
  NEG     EAX
  SBB     EDX,0
  @@cd1:  XOR     ECX,ECX
  MOV     EDI,Decimals
  OR      EDI,EDI
  JGE     @@cd2
  XOR     EDI,EDI
  @@cd2:  CMP     EDI,4
  JL      @@cd4
  MOV     EDI,4
  @@cd3:  INC     ECX
  SUB     EAX,Const1E18Lo
  SBB     EDX,Const1E18Hi
  JNC     @@cd3
  DEC     ECX
  ADD     EAX,Const1E18Lo
  ADC     EDX,Const1E18Hi
  @@cd4:  MOV     Temp.Integer[0],EAX
  MOV     Temp.Integer[4],EDX
  FILD    Temp
  MOV     EDX,EDI
  MOV     EAX,4
  SUB     EAX,EDX
  JE      @@cd5
  MOV     EDI,SaveGOT
  FIDIV   @@DecimalTable.Integer[EDI+EAX*4-4]
  @@cd5:  FBSTP   BCDValue
  LEA     EDI,[EBX].TFloatRec.Digits
  FWAIT
  OR      ECX,ECX
  JNE     @@cd11
  MOV     ECX,9
  @@cd10: MOV     AL,BCDValue[ECX-1].Byte
  MOV     AH,AL
  SHR     AL,4
  JNE     @@cd13
  MOV     AL,AH
  AND     AL,0FH
  JNE     @@cd14
  DEC     ECX
  JNE     @@cd10
  JMP     @@cd20
  @@cd11: MOV     AL,CL
  ADD     AL,'0'
  STOSB
  MOV     ECX,9
  @@cd12: MOV     AL,BCDValue[ECX-1].Byte
  MOV     AH,AL
  SHR     AL,4
  @@cd13: ADD     AL,'0'
  STOSB
  MOV     AL,AH
  AND     AL,0FH
  @@cd14: ADD     AL,'0'
  STOSB
  DEC     ECX
  JNE     @@cd12
  MOV     EAX,EDI
  LEA     ECX,[EBX].TFloatRec.Digits[EDX]
  SUB     EAX,ECX
  @@cd15: MOV     BYTE PTR [EDI],0
  DEC     EDI
  CMP     BYTE PTR [EDI],'0'
  JE      @@cd15
  MOV     EDX,[ESI].Integer[4]
  SHR     EDX,31
  JMP     @@cd21
  @@cd20: XOR     EAX,EAX
  XOR     EDX,EDX
  MOV     [EBX].TFloatRec.Digits.Byte[0],AL
  @@cd21: MOV     [EBX].TFloatRec.Exponent,AX
  MOV     [EBX].TFloatRec.Negative,DL
  RET

  @@Exit:
  POP     EBX
  POP     ESI
  POP     EDI
end;

procedure PutExponent;
// Store exponent
// In   AL  = Exponent character ('E' or 'e')
//      AH  = Positive sign character ('+' or 0)
//      BL  = Zero indicator
//      ECX = Minimum number of digits (0..4)
//      EDX = Exponent
//      EDI = Destination buffer
asm
  PUSH    ESI
{$IFDEF PIC}
        PUSH    EAX
        PUSH    ECX
        CALL    GETGOT
        MOV     ESI,EAX
        POP     ECX
        POP     EAX
{$ELSE}
  XOR     ESI,ESI
{$ENDIF}
  STOSB
  OR      BL,BL
  JNE     @@0
  XOR     EDX,EDX
  JMP     @@1
  @@0:    OR      EDX,EDX
  JGE     @@1
  MOV     AL,'-'
  NEG     EDX
  JMP     @@2
  @@1:    OR      AH,AH
  JE      @@3
  MOV     AL,AH
  @@2:    STOSB
  @@3:    XCHG    EAX,EDX
  PUSH    EAX
  MOV     EBX,ESP
  @@4:    XOR     EDX,EDX
  DIV     [ESI].DCon10
  ADD     DL,'0'
  MOV     [EBX],DL
  INC     EBX
  DEC     ECX
  OR      EAX,EAX
  JNE     @@4
  OR      ECX,ECX
  JG      @@4
  @@5:    DEC     EBX
  MOV     AL,[EBX]
  STOSB
  CMP     EBX,ESP
  JNE     @@5
  POP     EAX
  POP     ESI
end;

function ScanDate(const S: string; var Pos: Integer; var Date: TDateTime): Boolean; overload;
var
  DateOrder: TDateOrder;
  N1, N2, N3, Y, M, D: Word;
  L1, L2, L3, YearLen: Byte;
  CenturyBase: Integer;
  EraName: string;
  EraYearOffset: Integer;

  function EraToYear(Year: Integer): Integer;
  begin
{$IFDEF MSWINDOWS}
    if SysLocale.PriLangID = LANG_KOREAN then
    begin
      if Year <= 99 then
        Inc(Year, (CurrentYear + Abs(EraYearOffset)) div 100 * 100);
      if EraYearOffset > 0 then
        EraYearOffset := -EraYearOffset;
    end
    else
      Dec(EraYearOffset);
{$ENDIF}
    Result := Year + EraYearOffset;
  end;

begin
  Y := 0;
  M := 0;
  D := 0;
  YearLen := 0;
  Result := False;
  DateOrder := GetDateOrder(ShortDateFormat);
  EraYearOffset := 0;
  if (ShortDateFormat <> '') and (ShortDateFormat[1] = 'g') then  // skip over prefix text
  begin
    ScanToNumber(S, Pos);
    EraName := Trim(Copy(S, 1, Pos - 1));
    EraYearOffset := GetEraYearOffset(EraName);
  end
  else
  if AnsiPos('e', ShortDateFormat) > 0 then
    EraYearOffset := EraYearOffsets[1];
  if not (ScanNumber(S, Pos, N1, L1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, Pos, N2, L2)) then
    Exit;
  if ScanChar(S, Pos, DateSeparator) then
  begin
    if not ScanNumber(S, Pos, N3, L3) then
      Exit;
    case DateOrder of
      doMDY:
      begin
        Y := N3;
        YearLen := L3;
        M := N1;
        D := N2;
      end;
      doDMY:
      begin
        Y := N3;
        YearLen := L3;
        M := N2;
        D := N1;
      end;
      doYMD:
      begin
        Y := N1;
        YearLen := L1;
        M := N2;
        D := N3;
      end;
    end;
    if EraYearOffset > 0 then
      Y := EraToYear(Y)
    else
    if (YearLen <= 2) then
    begin
      CenturyBase := CurrentYear - TwoDigitYearCenturyWindow;
      Inc(Y, CenturyBase div 100 * 100);
      if (TwoDigitYearCenturyWindow > 0) and (Y < CenturyBase) then
        Inc(Y, 100);
    end;
  end
  else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1;
      M := N2;
    end
    else
    begin
      M := N1;
      D := N2;
    end;
  end;
  ScanChar(S, Pos, DateSeparator);
  ScanBlanks(S, Pos);
  if SysLocale.FarEast and (System.Pos('ddd', ShortDateFormat) <> 0) then
    if ShortTimeFormat[1] in ['0'..'9'] then  // stop at time digit
      ScanToNumber(S, Pos)
    else  // stop at time prefix
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do
          Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or (AnsiCompareText(TimeAMString,
          Copy(S, Pos, Length(TimeAMString))) = 0) or
        (AnsiCompareText(TimePMString, Copy(S, Pos, Length(TimePMString))) =
          0)// ignore trailing text
  ;
  Result := TryEncodeDate(Y, M, D, Date);
end;

function ScanTime(const S: string; var Pos: Integer; var Time: TDateTime): Boolean; overload;
var
  BaseHour: Integer;
  Hour, Min, Sec, MSec: Word;
  Junk: Byte;
begin
  Result := False;
  BaseHour := -1;
  if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
    BaseHour := 0
  else
  if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
    BaseHour := 12;
  if BaseHour >= 0 then
    ScanBlanks(S, Pos);
  if not ScanNumber(S, Pos, Hour, Junk) then
    Exit;
  Min := 0;
  Sec := 0;
  MSec := 0;
  if ScanChar(S, Pos, TimeSeparator) then
  begin
    if not ScanNumber(S, Pos, Min, Junk) then
      Exit;
    if ScanChar(S, Pos, TimeSeparator) then
    begin
      if not ScanNumber(S, Pos, Sec, Junk) then
        Exit;
      if ScanChar(S, Pos, DecimalSeparator) then
        if not ScanNumber(S, Pos, MSec, Junk) then
          Exit;
    end;
  end;
  if BaseHour < 0 then
    if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
      BaseHour := 0
    else
    if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
      BaseHour := 12;
  if BaseHour >= 0 then
  begin
    if (Hour = 0) or (Hour > 12) then
      Exit;
    if Hour = 12 then
      Hour := 0;
    Inc(Hour, BaseHour);
  end;
  ScanBlanks(S, Pos);
  Result := TryEncodeTime(Hour, Min, Sec, MSec, Time);
end;

function StrByteType(Str: Pchar; Index: Cardinal): TMbcsByteType;
begin
  Result := mbSingleByte;
  if SysLocale.FarEast then
    Result := ByteTypeTest(Str, Index);
end;

function StrMove(Dest: Pchar; const Source: Pchar; Count: Cardinal): Pchar;
begin
  Result := Dest;
  Move(Source^, Dest^, Count);
end;

function NextCharIndex(const S: string; Index: Integer): Integer;
begin
  Result := Index + 1;
  assert((Index > 0) and (Index <= Length(S)));
  if SysLocale.FarEast and (S[Index] in LeadBytes) then
    Result := Index + StrCharLength(Pchar(S) + Index - 1);
end;

function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin
  Result := doMDY;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'E':
        Result := doYMD;
      'Y':
        Result := doYMD;
      'M':
        Result := doMDY;
      'D':
        Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := doMDY;
end;

procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  while (Pos <= Length(S)) and not (S[Pos] in ['0'..'9']) do
    if S[Pos] in LeadBytes then
      Pos := NextCharIndex(S, Pos)
    else
      Inc(Pos);
end;

function AnsiPos(const Substr, S: string): Integer;
var
  P: Pchar;
begin
  Result := 0;
  P := AnsiStrPos(Pchar(S), Pchar(SubStr));
  if P <> nil then
    Result := Integer(P) - Integer(Pchar(S)) + 1;
end;

function ScanNumber(const S: string; var Pos: Integer; var Number: Word;
  var CharCount: Byte): Boolean;
var
  I: Integer;
  N: Word;
begin
  Result := False;
  CharCount := 0;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    CharCount := I - Pos;
    Pos := I;
    Number := N;
    Result := True;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do
    Inc(I);
  Pos := I;
end;

function AnsiCompareText(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, Pchar(S1),
    Length(S1), Pchar(S2), Length(S2)) - 2;
end;

function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do
      Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

function ScanString(const S: string; var Pos: Integer; const Symbol: string): Boolean;
begin
  Result := False;
  if Symbol <> '' then
  begin
    ScanBlanks(S, Pos);
    if AnsiCompareText(Symbol, Copy(S, Pos, Length(Symbol))) = 0 then
    begin
      Inc(Pos, Length(Symbol));
      Result := True;
    end;
  end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < HoursPerDay) and (Min < MinsPerHour) and (Sec < SecsPerMin) and
    (MSec < MSecsPerSec) then
  begin
    Time := (Hour * (MinsPerHour * SecsPerMin * MSecsPerSec) + Min *
      (SecsPerMin * MSecsPerSec) + Sec * MSecsPerSec + MSec) / MSecsPerDay;
    Result := True;
  end;
end;

function ContStr(s1, Separator, s2: string): string;
begin
  result := s1;
  if (s1 <> '') and (s2 <> '') then
    result := result + Separator;
  result := result + s2;
end;

initialization
  GetFormatSettings;
end.
