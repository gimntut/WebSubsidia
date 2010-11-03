{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
unit Publ2;
interface
Uses Windows, Messages, SysUtils;
Type
 TMessageEvent = procedure (var Msg: TMsg; var Handled: Boolean) of object;
////////////////////// x //////////////////////
procedure Run;
////////////////////// x //////////////////////
Var
 FOnMessage: TMessageEvent=nil;
 Terminated:boolean=false;
implementation
////////////////////// x //////////////////////
function ProcessMessage(var Msg: TMsg): Boolean;
var
  Handled: Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> WM_QUIT then
    begin
      Handled := False;
      if Assigned(FOnMessage) then FOnMessage(Msg, Handled);
      if not Handled then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end
    else
      Terminated := True;
  end;
end;
////////////////////// x //////////////////////
procedure Idle(const Msg: TMsg);
begin
 WaitMessage;
end;
////////////////////// x //////////////////////
procedure HandleMessage;
var
  Msg: TMsg;
begin
  if not ProcessMessage(Msg) then Idle(Msg);
end;
////////////////////// x //////////////////////
procedure HandleException(Sender: TObject);
begin
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  if ExceptObject is Exception then
  begin
    if not (ExceptObject is EAbort) then
      else
        ShowException(Exception(ExceptObject));
  end else
    SysUtils.ShowException(ExceptObject, ExceptAddr);
end;
////////////////////// x //////////////////////
procedure Run;
begin
 Terminated:=false;
 repeat
   try
     HandleMessage;
   except
     HandleException(Self);
   end;
 until Terminated;
end;

end.
