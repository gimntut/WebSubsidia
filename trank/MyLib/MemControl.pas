unit MemControl;
{-$I Defines.inc}
{$DEFINE MemControl}
interface

implementation
{$IFDEF MEMCONTROL}
uses Windows, SysUtils;
type
 TObjInfo=Record
  obj:TObject;
  Size:Integer;
 end;
 PDayTable = ^TDayTable;
 TDayTable = array[1..12] of Word;
var
  GetMemCount: Integer;
  FreeMemCount: Integer;
  ReallocMemCount: Integer;

  OldMemMgr: TMemoryManagerEx;
  Check:boolean=false;
  //Emptily:integer;
  p:array of TObjInfo;
  Capacity:Integer;
  Count:integer;
  xTime:TDateTime;
const
 AllocBy=1024;
 HoursPerDay   = 24;
 MinsPerHour   = 60;
 SecsPerMin    = 60;
 MSecsPerSec   = 1000;
 MinsPerDay    = HoursPerDay * MinsPerHour;
 SecsPerDay    = MinsPerDay * SecsPerMin;
 MSecsPerDay   = SecsPerDay * MSecsPerSec;
 MonthDays: array [Boolean] of TDayTable =
   ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
    (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
 DateDelta = 693594;
 /////////////////// x ///////////////////
function IsLeapYear(Year: Word): Boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
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
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

function EncodeDate(Year, Month, Day: Word): TDateTime;
begin
 TryEncodeDate(Year, Month, Day, Result);
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < HoursPerDay) and (Min < MinsPerHour) and (Sec < SecsPerMin) and (MSec < MSecsPerSec) then
  begin
    Time := (Hour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
             Min * (SecsPerMin * MSecsPerSec) +
             Sec * MSecsPerSec +
             MSec) / MSecsPerDay;
    Result := True;
  end;
end;

function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
begin
 TryEncodeTime(Hour, Min, Sec, MSec, Result);
end;

function Now: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := EncodeDate(wYear, wMonth, wDay) +
      EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
end;

 /////////////////// x ///////////////////
procedure Add(pn:pointer;Size:integer);
Var
 t:TDateTime;
begin
 if Check then Exit;
 if Size=0 then Exit;
 t:=Now;
 Check:=true;
 if Count>=Capacity then begin
  inc(Capacity,AllocBy);
  SetLength(p,Capacity);
 end;
 p[Count].obj:=pn;
 p[Count].Size:=Size;
 inc(Count);
 Check:=false;
 xTime:=xTime+Now-t;
end;
/////////////////// x ///////////////////
function Find(pn:pointer):Integer;
Var
 i:integer;
begin
 result:=-1;
 For i:=0 to Count-1 do
  if pn=p[i].obj then begin
   result:=i;
   Break;
  end;
end;
/////////////////// x ///////////////////
procedure Delete(i:integer); overload;
Var
 t:TDateTime;
begin
 if i=-1 then Exit;
 t:=Now;
 Dec(Count);
 p[i]:=p[Count];
 FillChar(p[Count],SizeOf(TObjInfo),#0);
 xTime:=xTime+Now-t;
end;
/////////////////// x ///////////////////
procedure Delete(pn:pointer); overload;
Var
 i:integer;
begin
 if Check then Exit;
 Check:=true;
 i:=Find(pn);
 Delete(i);
 Check:=false;
end;

function NewGetMem(Size: Integer): Pointer;
begin
  Inc(GetMemCount);
  Result := OldMemMgr.GetMem(Size);
  if Size>0
   then Add(Result,Size)
   else Delete(Result);
end;

function NewFreeMem(P: Pointer): Integer;
begin
  Inc(FreeMemCount);
  Delete(p);
  Result := OldMemMgr.FreeMem(P);
end;

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Inc(ReallocMemCount);
  Delete(p);
  Result := OldMemMgr.ReallocMem(P, Size);
  Add(Result,Size);
end;

function NewAllocMem(Size: Cardinal): Pointer;
begin
//  Inc(ReallocMemCount);
//  Delete(p);
  Result := OldMemMgr.AllocMem(Size);
  Add(Result,Size);
end;

function NewRegisterExpectedMemoryLeak(P: Pointer): Boolean;
begin
  Result:=OldMemMgr.RegisterExpectedMemoryLeak(P);
end;

function NewUnregisterExpectedMemoryLeak(P: Pointer): Boolean;
begin
  Result:=OldMemMgr.UnregisterExpectedMemoryLeak(P);
end;

  const
  NewMemMgr: TMemoryManagerEx = (
  GetMem: NewGetMem;
  FreeMem: NewFreeMem;
  ReallocMem: NewReallocMem;
  AllocMem: NewAllocMem;
  RegisterExpectedMemoryLeak: nil;
  UnregisterExpectedMemoryLeak: nil;
  );
type
 f=function(Size: Cardinal): Pointer;
procedure SetNewMemMgr;
begin
  GetMemoryManager(OldMemMgr);
  SetMemoryManager(NewMemMgr);
end;

procedure MessageBox(Title,Text:String);
begin
 windows.MessageBox(0,PChar(Text),PChar(Title),MB_OK+MB_ICONASTERISK);
end;
////////////////////// x //////////////////////
// CvtInt и IntToStr скопированы из модуля SysUtils
////////////////////// x //////////////////////
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

function IntToStr(Value: Integer): string;
//  FmtStr(Result, '%d', [Value]);      2.txt
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

procedure Diagnoz;
Var
 i,j,x,nObj,nDat,t:integer;
 s:string;
 sResultObj:string;
 sResultDat:string;
begin
 if Count=0 then Exit;
 t:=Round(xTime*MSecsPerDay);
 For i:=Count-1 downto 1 do
  For j:=i-1 downto 0 do
  if p[i].obj=p[j].obj then Delete(i);
  MessageBox('Внимание',PChar('(!)  Происходит утечка памяти  (!)'#13#10#13#10
  +'В памяти осталось блоков -    '+IntToStr(Count)+#13#10
  +'Освобождено блоков / Захвачено блоков -    '
  +IntToStr(FreeMemCount)+'/'+IntToStr(GetMemCount)+#13#10
  +'Время MemControl -   '+IntToStr(t)+' мс'));

 nObj:=0;
 nDat:=0;
 sResultObj:='';
 sResultDat:='';
 For i:=0 to Count-1 do begin
  x:=PInteger(p[i].obj)^;
  if (x>=$400000) and (x<$500000) and (nObj<=10) then begin
   inc(nObj);
   s:=p[i].obj.ClassName;
   sResultObj:=sResultObj+#13#10'№'+IntToStr(nObj)+': '+s+' ('+IntToStr(p[i].Size)+')';
   if nObj=500 then Exit;
  end else begin
   inc(nDat);
   if nDat<=10 then
     sResultDat:=sResultDat+#13#10'№'+IntToStr(nDat)+': $'+IntToHex(Integer(p[i].obj),6)+' - $'+IntToHex(Integer(p[i].obj)+p[i].Size,6)+' ('+IntToStr(p[i].Size)+')';
  end;
 end;
 MessageBox('Объекты: ',sResultObj);
 MessageBox('Данные: ',sResultDat);
end;

initialization
 Capacity:=AllocBy;
 Count:=0;
 SetLength(p,Capacity);
 SetNewMemMgr;
finalization
 SetMemoryManager(OldMemMgr);
 Diagnoz;
 p:=nil;
{$ENDIF}
end.


