unit DbfApi;

interface
uses cdbfapi;
type
  TCdbfField=class
  private
    FName: string;
    FFieldType: Char;
    FHidhLen: Integer;
    FLowLen: Integer;
    FBase: PDBF;
    procedure SetFieldType(const Value: Char);
    procedure SetHidhLen(const Value: Integer);
    procedure SetLowLen(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetBase(const Value: PDBF);
  public
    property Base:PDBF read FBase write SetBase;
  published
    property Name:string read FName write SetName;
    property LowLen:Integer read FLowLen write SetLowLen;
    property HidhLen:Integer read FHidhLen write SetHidhLen;
    property FieldType:Char read FFieldType write SetFieldType;
  end;

  TCdbf=class
  private
    FFileName: string;
    FDBF:PDBF;
    FActive: Boolean;
    FCount: Integer;
    FFieldCount: Integer;
    procedure SetFileName(const Value: string);
    procedure SetActive(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure SetFieldCount(const Value: Integer);
  published
  public
    constructor Create(AFileName:string);
    destructor Destroy; override;
    procedure Open;
    property FileName:string read FFileName write SetFileName;
    property Active:Boolean read FActive write SetActive;
    procedure Close;
    property Count:Integer read FCount write SetCount;
    property FieldCount:Integer read FFieldCount write SetFieldCount;
  end;

implementation

{ TCDBF }

procedure TCDBF.Close;
begin
  CloseBase(FDBF);
end;

constructor TCDBF.Create;
begin

end;

destructor TCDBF.Destroy;
begin

  inherited;
end;

procedure TCDBF.Open;
begin
  FDBF:=OpenBase(Pchar(FFileName));
  FActive:=FDBF<>nil;
end;

procedure TCDBF.SetActive(const Value: Boolean);
begin
  if Value then Open else Close;
end;

procedure TCDBF.SetCount(const Value: Integer);
begin
  FCount := Value;
end;

procedure TCDBF.SetFieldCount(const Value: Integer);
begin
  FFieldCount := Value;
end;

procedure TCDBF.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

{ TCdbfField }

procedure TCdbfField.SetBase(const Value: PDBF);
begin
  FBase := Value;
end;

procedure TCdbfField.SetFieldType(const Value: Char);
begin
  FFieldType := Value;
end;

procedure TCdbfField.SetHidhLen(const Value: Integer);
begin
  FHidhLen := Value;
end;

procedure TCdbfField.SetLowLen(const Value: Integer);
begin
  FLowLen := Value;
end;

procedure TCdbfField.SetName(const Value: string);
begin
  FName := Value;
end;

end.
