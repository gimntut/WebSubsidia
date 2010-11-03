unit PublTime;
interface
Uses Windows;
type
 TTimeStamp = record
   Time: Integer;      { Number of milliseconds since midnight }
   Date: Integer;      { One plus number of days since 1/1/0001 }
 end;
 PDayTable = ^TDayTable;
 TDayTable = array[1..12] of Word;
 TDateOrder = (doMDY, doDMY, doYMD);
/////////////////// x ///////////////////
// Время в долях часов
function FromTime(h, m: integer): currency; overload;
function FromTime(Time:TDateTime): currency; overload;
/////////////////// SysUtils ///////////////////
function IsLeapYear(Year: Word): Boolean;
function CurrentYear: Word;
function GetEraYearOffset(const Name: string): Integer;
function AnsiStrPos(Str, SubStr: PChar): PChar;
function StrLen(const Str: PChar): Cardinal; assembler;
function StrPos(const Str1, Str2: PChar): PChar; assembler;
function Now: TDateTime;
function EncodeDate(Year, Month, Day: Word): TDateTime;
function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);
function Date: TDateTime;

/////////////////// x ///////////////////
const
  MonthDays: array [Boolean] of TDayTable =
    ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
     (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
  HoursPerDay   = 24;
  MinsPerHour   = 60;
  SecsPerMin    = 60;
  MSecsPerSec   = 1000;
  MinsPerDay    = HoursPerDay * MinsPerHour;
  SecsPerDay    = MinsPerDay * SecsPerMin;
  MSecsPerDay   = SecsPerDay * MSecsPerSec;
  FMSecsPerDay: Single = MSecsPerDay;
  IMSecsPerDay: Integer = MSecsPerDay;
  DateDelta = 693594;
  MaxEraCount = 7;
Var
  EraNames: array [1..MaxEraCount] of string;
implementation

uses publ, PublStr, PublExcept, SysConst;

function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
asm
        PUSH    EBX
{$IFDEF PIC}
        PUSH    EAX
        CALL    GetGOT
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

procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);
var
  MinCount, MSecCount: Word;
begin
  DivMod(DateTimeToTimeStamp(DateTime).Time, SecsPerMin * MSecsPerSec, MinCount, MSecCount);
  DivMod(MinCount, MinsPerHour, Hour, Min);
  DivMod(MSecCount, MSecsPerSec, Sec, MSec);
end;

function Date: TDateTime;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do Result := EncodeDate(wYear, wMonth, wDay);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  T: TTime_T;
  UT: TUnixTime;
begin
  __time(@T);
  localtime_r(@T, UT);
  Result := EncodeDate(UT.tm_year + 1900, UT.tm_mon + 1, UT.tm_mday);
end;
{$ENDIF}

function FromTime(h, m: integer): currency;
begin
 result:=h+m/60;
end;

function FromTime(Time:TDateTime): currency; overload;
Var
 h,m,s,ms:Word;
begin
 DecodeTime(Time,h,m,s,ms);
 result:=FromTime(h,m);
end;

function IsLeapYear(Year: Word): Boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function CurrentYear: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;

function AnsiStrPos(Str, SubStr: PChar): PChar;
var
  L1, L2: Cardinal;
  ByteType : TMbcsByteType;
begin
  Result := nil;
  if (Str = nil) or (Str^ = #0) or (SubStr = nil) or (SubStr^ = #0) then Exit;
  L1 := StrLen(Str);
  L2 := StrLen(SubStr);
  Result := StrPos(Str, SubStr);
  while (Result <> nil) and ((L1 - Cardinal(Result - Str)) >= L2) do
  begin
    ByteType := StrByteType(Str, Integer(Result-Str));
    if (ByteType <> mbTrailByte) and
      (CompareString(LOCALE_USER_DEFAULT, 0, Result, L2, SubStr, L2) = 2) then Exit;
    if (ByteType = mbLeadByte) then Inc(Result);
    Inc(Result);
    Result := StrPos(Result, SubStr);
  end;
  Result := nil;
end;


function GetEraYearOffset(const Name: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(EraNames) to High(EraNames) do
  begin
    if EraNames[I] = '' then Break;
    if AnsiStrPos(PChar(EraNames[I]), PChar(Name)) <> nil then
    begin
      Result := EraYearOffsets[I];
      Exit;
    end;
  end;
end;

function StrLen(const Str: PChar): Cardinal; assembler;
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

function StrPos(const Str1, Str2: PChar): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        OR      EAX,EAX
        JE      @@2
        OR      EDX,EDX
        JE      @@2
        MOV     EBX,EAX
        MOV     EDI,EDX
        XOR     AL,AL
        MOV     ECX,0FFFFFFFFH
        REPNE   SCASB
        NOT     ECX
        DEC     ECX
        JE      @@2
        MOV     ESI,ECX
        MOV     EDI,EBX
        MOV     ECX,0FFFFFFFFH
        REPNE   SCASB
        NOT     ECX
        SUB     ECX,ESI
        JBE     @@2
        MOV     EDI,EBX
        LEA     EBX,[ESI-1]
@@1:    MOV     ESI,EDX
        LODSB
        REPNE   SCASB
        JNE     @@2
        MOV     EAX,ECX
        PUSH    EDI
        MOV     ECX,EBX
        REPE    CMPSB
        POP     EDI
        MOV     ECX,EAX
        JNE     @@1
        LEA     EAX,[EDI-1]
        JMP     @@3
@@2:    XOR     EAX,EAX
@@3:    POP     EBX
        POP     ESI
        POP     EDI
end;

function Now: TDateTime;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := EncodeDate(wYear, wMonth, wDay) +
      EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  T: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  localtime_r(@T, UT);
  Result := EncodeDate(UT.tm_year + 1900, UT.tm_mon + 1, UT.tm_mday) +
    EncodeTime(UT.tm_hour, UT.tm_min, UT.tm_sec, TV.tv_usec div 1000);
end;
{$ENDIF}

function EncodeDate(Year, Month, Day: Word): TDateTime;
begin
  if not TryEncodeDate(Year, Month, Day, Result) then
    ConvertError(@SDateEncodeError);
end;

function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
begin
  if not TryEncodeTime(Hour, Min, Sec, MSec, Result) then
    ConvertError(@STimeEncodeError);
end;

function EnumEraYearOffsets(YearOffsets: PChar): Integer; stdcall;
var
  I: Integer;
begin
  Result := 0;
  I := Low(EraYearOffsets);
  while EraYearOffsets[I] <> -1 do
    if (I = High(EraYearOffsets)) then
      Exit
    else Inc(I);
  EraYearOffsets[I] := StrToIntDef(YearOffsets, 0);
  Result := 1;
end;

procedure GetEraNamesAndYearOffsets;
var
  J: Integer;
  CalendarType: CALTYPE;
begin
  CalendarType := StrToIntDef(GetLocaleStr(GetThreadLocale,
    LOCALE_IOPTIONALCALENDAR, '1'), 1);
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

function TranslateDateFormat(const FormatStr: string): string;
var
  I: Integer;
  L: Integer;
  CalendarType: CALTYPE;
  RemoveEra: Boolean;
begin
  I := 1;
  Result := '';
  CalendarType := StrToIntDef(GetLocaleStr(GetThreadLocale,
    LOCALE_ICALENDARTYPE, '1'), 1);
  if not (CalendarType in [CAL_JAPAN, CAL_TAIWAN, CAL_KOREA]) then
  begin
    RemoveEra := SysLocale.PriLangID in [LANG_JAPANESE, LANG_CHINESE, LANG_KOREAN];
    if RemoveEra then
    begin
      While I <= Length(FormatStr) do
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
  begin
    if FormatStr[I] in LeadBytes then
    begin
      L := CharLength(FormatStr, I);
      Result := Result + Copy(FormatStr, I, L);
      Inc(I, L);
    end else
    begin
      if StrLIComp(@FormatStr[I], 'gg', 2) = 0 then
      begin
        Result := Result + 'ggg';
        Inc(I, 1);
      end
      else if StrLIComp(@FormatStr[I], 'yyyy', 4) = 0 then
      begin
        Result := Result + 'eeee';
        Inc(I, 4-1);
      end
      else if StrLIComp(@FormatStr[I], 'yy', 2) = 0 then
      begin
        Result := Result + 'ee';
        Inc(I, 2-1);
      end
      else if FormatStr[I] in ['y', 'Y'] then
        Result := Result + 'e'
      else
        Result := Result + FormatStr[I];
      Inc(I);
    end;
  end;
end;

end.

