unit uTime;

interface
uses httpsend;
procedure Synchronizing(Address:string);

implementation

uses
  Classes, Windows, SysUtils;
const
  TrueSize = 19;
procedure Synchronizing;
var
  HTTP: THTTPSend;
  s: string;
  SysTime:_SYSTEMTIME;
begin
  HTTP:=THTTPSend.Create;
  Repeat
    HTTP.UserAgent:='WebSubsidii';
    HTTP.Clear;
    HTTP.HTTPMethod('GET', Address);
    if HTTP.Document.Size<>TrueSize then break;
    HTTP.Document.Position:=0;
    SetLength(s,TrueSize);
    HTTP.Document.Read(s[1],TrueSize);
    SysTime.wDay:=StrToInt(copy(s,1,2));
    SysTime.wMonth:=StrToInt(copy(s,4,2));
    SysTime.wYear:=StrToInt(copy(s,7,4));
    SysTime.wHour:=StrToInt(copy(s,12,2));
    SysTime.wMinute:=StrToInt(copy(s,15,2));
    SysTime.wSecond:=StrToInt(copy(s,18,2));
    SetSystemTime(SysTime);
  Until true;
  HTTP.Free;
end;

end.
