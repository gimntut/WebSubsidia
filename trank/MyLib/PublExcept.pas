unit PublExcept;
interface
uses PublStr, Types;
type
  Exception = class(TObject)
  private
    FMessage: string;
    FHelpContext: Integer;
  public
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
    constructor CreateRes(Ident: Integer); overload;
    constructor CreateRes(ResStringRec: PResStringRec); overload;
    constructor CreateResFmt(Ident: Integer; const Args: array of const); overload;
    constructor CreateResFmt(ResStringRec: PResStringRec; const Args: array of const); overload;
    constructor CreateHelp(const Msg: string; AHelpContext: Integer);
    constructor CreateFmtHelp(const Msg: string; const Args: array of const;
      AHelpContext: Integer);
    constructor CreateResHelp(Ident: Integer; AHelpContext: Integer); overload;
    constructor CreateResHelp(ResStringRec: PResStringRec; AHelpContext: Integer); overload;
    constructor CreateResFmtHelp(ResStringRec: PResStringRec; const Args: array of const;
      AHelpContext: Integer); overload;
    constructor CreateResFmtHelp(Ident: Integer; const Args: array of const;
      AHelpContext: Integer); overload;
    property HelpContext: Integer read FHelpContext write FHelpContext;
    property Message: string read FMessage write FMessage;
  end;

  EInOutError = class(Exception)
  public
    ErrorCode: Integer;
  end;

  EConvertError = class(Exception);

  EOSError = class(Exception)
  public
    ErrorCode: DWORD;
  end;

  EAbort = class(Exception);

  procedure Abort;
  procedure ConvertError(ResString: PResStringRec);
  procedure RaiseLastOSError; overload;
  procedure RaiseLastOSError(LastError: Integer); overload;
  function SysErrorMessage(ErrorCode: Integer): string;

implementation
uses SysConst, Windows;
{ Exception class }

constructor Exception.Create(const Msg: string);
begin
  FMessage := Msg;
end;

constructor Exception.CreateFmt(const Msg: string;
  const Args: array of const);
begin
  FMessage := Format(Msg, Args);
end;

constructor Exception.CreateRes(Ident: Integer);
begin
  FMessage := LoadStr(Ident);
end;

constructor Exception.CreateRes(ResStringRec: PResStringRec);
begin
  FMessage := LoadResString(ResStringRec);
end;

constructor Exception.CreateResFmt(Ident: Integer;
  const Args: array of const);
begin
  FMessage := Format(LoadStr(Ident), Args);
end;

constructor Exception.CreateResFmt(ResStringRec: PResStringRec;
  const Args: array of const);
begin
  FMessage := Format(LoadResString(ResStringRec), Args);
end;

constructor Exception.CreateHelp(const Msg: string; AHelpContext: Integer);
begin
  FMessage := Msg;
  FHelpContext := AHelpContext;
end;

constructor Exception.CreateFmtHelp(const Msg: string; const Args: array of const;
  AHelpContext: Integer);
begin
  FMessage := Format(Msg, Args);
  FHelpContext := AHelpContext;
end;

constructor Exception.CreateResHelp(Ident: Integer; AHelpContext: Integer);
begin
  FMessage := LoadStr(Ident);
  FHelpContext := AHelpContext;
end;

constructor Exception.CreateResHelp(ResStringRec: PResStringRec;
  AHelpContext: Integer);
begin
  FMessage := LoadResString(ResStringRec);
  FHelpContext := AHelpContext;
end;

constructor Exception.CreateResFmtHelp(Ident: Integer;
  const Args: array of const;
  AHelpContext: Integer);
begin
  FMessage := Format(LoadStr(Ident), Args);
  FHelpContext := AHelpContext;
end;

constructor Exception.CreateResFmtHelp(ResStringRec: PResStringRec;
  const Args: array of const;
  AHelpContext: Integer);
begin
  FMessage := Format(LoadResString(ResStringRec), Args);
  FHelpContext := AHelpContext;
end;

procedure Abort;

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP + 4]
  end;

begin
  raise EAbort.CreateRes(@SOperationAborted) at ReturnAddr;
end;

procedure ConvertError(ResString: PResStringRec);
begin
  raise EConvertError.CreateRes(ResString);
end;

procedure RaiseLastOSError;
begin
  RaiseLastOSError(GetLastError);
end;

procedure RaiseLastOSError(LastError: Integer);
var
  Error: EOSError;
begin
  if LastError <> 0 then
    Error := EOSError.CreateResFmt(@SOSError, [LastError,
      SysErrorMessage(LastError)])
  else
    Error := EOSError.CreateRes(@SUnkOSError);
  Error.ErrorCode := LastError;
  raise Error;
end;

function SysErrorMessage(ErrorCode: Integer): string;
var
  Buffer: array[0..255] of Char;
{$IFDEF MSWINDOWS}
var
  Len: Integer;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do Dec(Len);
  SetString(Result, Buffer, Len);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  //Result := Format('System error: %4x',[ErrorCode]);
  Result := strerror_r(ErrorCode, Buffer, sizeof(Buffer));
end;
{$ENDIF}

end.
