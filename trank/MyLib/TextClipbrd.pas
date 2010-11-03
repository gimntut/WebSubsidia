
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2001 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit TextClipbrd;

{$R-,T-,H+,X+}

interface

{$IFDEF MSWINDOWS}
uses Windows, Messages, Classes;

{$ENDIF}

var
  CF_PICTURE: Word;
  CF_COMPONENT: Word;

{ TClipboard }

{ The clipboard object encapsulates the Windows clipboard.

  Assign - Assigns the given object to the clipboard.  If the object is
    a TPicture or TGraphic desendent it will be placed on the clipboard
    in the corresponding format (e.g. TBitmap will be placed on the
    clipboard as a CF_BITMAP). Picture.Assign(Clipboard) and
    Bitmap.Assign(Clipboard) are also supported to retrieve the contents
    of the clipboard.
  Clear - Clears the contents of the clipboard.  This is done automatically
    when the clipboard object adds data to the clipboard.
  Close - Closes the clipboard if it is open.  Open and close maintain a
    count of the number of times the clipboard has been opened.  It will
    not actually close the clipboard until it has been closed the same
    number of times it has been opened.
  Open - Open the clipboard and prevents all other applications from changeing
    the clipboard.  This is call is not necessary if you are adding just one
    item to the clipboard.  If you need to add more than one format to
    the clipboard, call Open.  After all the formats have been added. Call
    close.
  HasFormat - Returns true if the given format is available on the clipboard.
  GetAsHandle - Returns the data from the clipboard in a raw Windows handled
    for the specified format.  The handle is not owned by the application and
    the data should be copied.
  SetAsHandle - Places the handle on the clipboard in the given format.  Once
    a handle has been given to the clipboard it should *not* be deleted.  It
    will be deleted by the clipboard.
  GetTextBuf - Retrieves
  AsText - Allows placing and retrieving text from the clipboard.  This property
    is valid to retrieve if the CF_TEXT format is available.
  FormatCount - The number of formats in the Formats array.
  Formats - A list of all the formats available on the clipboard. }

type
  TTextClipboard = class (TPersistent)
  private
    FOpenRefCount: Integer;
    FClipboardWindow: HWND;
    FAllocated: Boolean;
    FEmptied: Boolean;
    procedure Adding;
    function GetAsText: string;
    function GetClipboardWindow: HWND;
    function GetFormatCount: Integer;
    function GetFormats(Index: Integer): Word;
    procedure SetAsText(const Value: string);
  protected
    procedure SetBuffer(Format: Word; var Buffer; Size: Integer);
    procedure WndProc(var Message: TMessage); virtual;
    procedure MainWndProc(var Message: TMessage);
    property Handle: HWND read GetClipboardWindow;
    property OpenRefCount: Integer read FOpenRefCount;
  public
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Close; virtual;
    function GetComponent(Owner, Parent: TComponent): TComponent;
    function GetAsHandle(Format: Word): THandle;
    function GetTextBuf(Buffer: Pchar; BufSize: Integer): Integer;
    procedure Open; virtual;
    procedure SetComponent(Component: TComponent);
    procedure SetAsHandle(Format: Word; Value: THandle);
    procedure SetTextBuf(Buffer: Pchar);
    property AsText: string read GetAsText write SetAsText;
    property FormatCount: Integer read GetFormatCount;
    property Formats[Index: Integer]: Word read GetFormats;
  end;

  TGetStringPrc = procedure(var S: string);
  TGetStringMtd = procedure(var S: string) of object;

function TextClipboard: TTextClipboard;
function SetClipboard(NewClipboard: TTextClipboard): TTextClipboard;
procedure GetSelectedText(GetString: TGetStringMtd); overload;
procedure GetSelectedText(GetString: TGetStringPrc); overload;

implementation

uses Consts, Forms, SysUtils;

procedure TTextClipboard.Clear;
begin
  Open;
  try
    EmptyClipboard;
  finally
    Close;
  end;
end;

procedure TTextClipboard.Adding;
begin
  if (FOpenRefCount <> 0) and not FEmptied then
  begin
    Clear;
    FEmptied := True;
  end;
end;

procedure TTextClipboard.Close;
begin
  if FOpenRefCount = 0 then
    Exit;
  Dec(FOpenRefCount);
  if FOpenRefCount = 0 then
  begin
    CloseClipboard;
    if FAllocated then
{$IFDEF MSWINDOWS}
      Classes.DeallocateHWnd(FClipboardWindow);
{$ENDIF}
{$IFDEF LINUX}
      WinUtils.DeallocateHWnd(FClipboardWindow);
{$ENDIF}
    FClipboardWindow := 0;
  end;
end;

procedure TTextClipboard.Open;
begin
  if FOpenRefCount = 0 then
  begin
    FClipboardWindow := Application.Handle;
    if FClipboardWindow = 0 then
    begin
{$IFDEF MSWINDOWS}
      FClipboardWindow := Classes.AllocateHWnd(MainWndProc);
{$ENDIF}
{$IFDEF LINUX}
      FClipboardWindow := WinUtils.AllocateHWnd(MainWndProc);
{$ENDIF}
      FAllocated := True;
    end;
    if not OpenClipboard(FClipboardWindow) then
      raise Exception.CreateRes(@SCannotOpenClipboard);
    FEmptied := False;
  end;
  Inc(FOpenRefCount);
end;

procedure TTextClipboard.WndProc(var Message: TMessage);
begin
  with Message do
    Result := DefWindowProc(FClipboardWindow, Msg, wParam, lParam);
end;

function TTextClipboard.GetComponent(Owner, Parent: TComponent): TComponent;
var
  Data: THandle;
  DataPtr: Pointer;
  MemStream: TMemoryStream;
  Reader: TReader;
begin
  Result := nil;
  Open;
  try
    Data := GetClipboardData(CF_COMPONENT);
    if Data = 0 then
      Exit;
    DataPtr := GlobalLock(Data);
    if DataPtr = nil then
      Exit;
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.WriteBuffer(DataPtr^, GlobalSize(Data));
        MemStream.Position := 0;
        Reader := TReader.Create(MemStream, 256);
        try
          Reader.Parent := Parent;
          Result := Reader.ReadRootComponent(nil);
          try
            if Owner <> nil then
              Owner.InsertComponent(Result);
          except
            Result.Free;
            raise;
          end;
        finally
          Reader.Free;
        end;
      finally
        MemStream.Free;
      end;
    finally
      GlobalUnlock(Data);
    end;
  finally
    Close;
  end;
end;

procedure TTextClipboard.SetBuffer(Format: Word; var Buffer; Size: Integer);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  Open;
  try
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(Buffer, DataPtr^, Size);
        Adding;
        SetClipboardData(Format, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    Close;
  end;
end;

procedure TTextClipboard.SetComponent(Component: TComponent);
var
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  try
    MemStream.WriteComponent(Component);
    SetBuffer(CF_COMPONENT, MemStream.Memory^, MemStream.Size);
  finally
    MemStream.Free;
  end;
end;

function TTextClipboard.GetTextBuf(Buffer: Pchar; BufSize: Integer): Integer;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_TEXT);
  if Data = 0 then
    Result := 0
  else
  begin
    Result := StrLen(StrLCopy(Buffer, GlobalLock(Data), BufSize - 1));
    GlobalUnlock(Data);
  end;
  Close;
end;

procedure TTextClipboard.SetTextBuf(Buffer: Pchar);
begin
  SetBuffer(CF_TEXT, Buffer^, StrLen(Buffer) + 1);
end;

function TTextClipboard.GetAsText: string;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if Data <> 0 then
      Result := Pchar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then
      GlobalUnlock(Data);
    Close;
  end;
end;

function TTextClipboard.GetClipboardWindow: HWND;
begin
  if FClipboardWindow = 0 then
    Open;
  Result := FClipboardWindow;
end;

procedure TTextClipboard.SetAsText(const Value: string);
begin
  SetBuffer(CF_TEXT, Pchar(Value)^, Length(Value) + 1);
end;

function TTextClipboard.GetAsHandle(Format: Word): THandle;
begin
  Open;
  try
    Result := GetClipboardData(Format);
  finally
    Close;
  end;
end;

procedure TTextClipboard.SetAsHandle(Format: Word; Value: THandle);
begin
  Open;
  try
    Adding;
    SetClipboardData(Format, Value);
  finally
    Close;
  end;
end;

function TTextClipboard.GetFormatCount: Integer;
begin
  Result := CountClipboardFormats;
end;

function TTextClipboard.GetFormats(Index: Integer): Word;
begin
  Open;
  try
    Result := EnumClipboardFormats(0);
    while Index > 0 do
    begin
      Dec(Index);
      Result := EnumClipboardFormats(Result);
    end;
  finally
    Close;
  end;
end;


var
  FClipboard: TTextClipboard;

function TextClipboard: TTextClipboard;
begin
  if FClipboard = nil then
    FClipboard := TTextClipboard.Create;
  Result := FClipboard;
end;

function SetClipboard(NewClipboard: TTextClipboard): TTextClipboard;
begin
  Result := FClipboard;
  FClipboard := NewClipboard;
end;

procedure TTextClipboard.MainWndProc(var Message: TMessage);
begin
  try
    WndProc(Message);
  except
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self)
    else
      raise;
  end;
end;

destructor TTextClipboard.Destroy;
begin
  if (FClipboard = Self) then
    FClipboard := nil;
  inherited Destroy;
end;

procedure GetSelectedText(GetString: TGetStringMtd);
var
  S1, S2: string;
  us: Boolean;
begin
  keybd_event(VK_CONTROL,0,0,0);
  keybd_event(Ord('C'),0,0,0);
  keybd_event(Ord('C'),0,KEYEVENTF_KEYUP,0);
  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
  Repeat
    sleep(100);
    us := true;
    try
      S1 := TextClipboard.AsText;
    except
      on Exception do begin
       us:=false;
      end;
    end;
  Until us;
  S2 := S1;
  if Assigned(GetString) then GetString(S2);
  if S2=S1 then Exit;
  Repeat
    sleep(100);
    us := true;
    try
      TextClipboard.AsText := S2;
    except
      on Exception do begin
       us:=false;
      end;
    end;
  Until us;
  keybd_event(VK_CONTROL,0,0,0);
  keybd_event(Ord('V'),0,0,0);
  keybd_event(Ord('V'),0,KEYEVENTF_KEYUP,0);
  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
end;

procedure GetSelectedText(GetString: TGetStringPrc);
var
  S1, S2: string;
  us: Boolean;
begin
  keybd_event(VK_CONTROL,0,0,0);
  keybd_event(Ord('C'),0,0,0);
  keybd_event(Ord('C'),0,KEYEVENTF_KEYUP,0);
  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
  Repeat
    sleep(100);
    us := true;
    try
      S1 := TextClipboard.AsText;
    except
      on Exception do begin
       us:=false;
      end;
    end;
  Until us;
  S2 := S1;
  if Assigned(GetString) then GetString(S2);
  if S2=S1 then Exit;
  Repeat
    sleep(100);
    us := true;
    try
      TextClipboard.AsText := S2;
    except
      on Exception do begin
       us:=false;
      end;
    end;
  Until us;
  keybd_event(VK_CONTROL,0,0,0);
  keybd_event(Ord('V'),0,0,0);
  keybd_event(Ord('V'),0,KEYEVENTF_KEYUP,0);
  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
end;

initialization
  { The following strings should not be localized }
  CF_PICTURE := RegisterClipboardFormat('Delphi Picture');
  CF_COMPONENT := RegisterClipboardFormat('Delphi Component');
  FClipboard := nil;

finalization
  FClipboard.Free;
end.

