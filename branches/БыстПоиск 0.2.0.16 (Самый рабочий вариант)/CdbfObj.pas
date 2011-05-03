unit CdbfObj;

interface
uses cdbfapi;
type
  TCdbfField=class
  private
    FBase: PDBF;
    FIndex: Integer;
    procedure SetBase(const Value: PDBF);
    procedure SetIndex(const Value: Integer);
    function GetFieldType: Char;
    function GetHighLen: Integer;
    function GetLowLen: Integer;
    function GetName: string;
  public
    property Base:PDBF read FBase write SetBase;
    property Name:string read GetName;
    property LowLen:Integer read GetLowLen;
    property HidhLen:Integer read GetHighLen;
    property FieldType:Char read GetFieldType;
    property Index:Integer read FIndex write SetIndex;
  end;

  TCdbfRecord=class
  private
    FBase: PDBF;
    FIndex: Integer;
    function GetValues(Index: Integer): string;
    procedure SetBase(const Value: PDBF);
    procedure SetIndex(const Value: Integer);
  public
    property Base:PDBF read FBase write SetBase;
    property Values[Index:Integer]:string read GetValues; default;
    property Index:Integer read FIndex write SetIndex;
  end;

  TCdbf=class
  private
    FFileName: string;
    FDBF:PDBF;
    FActive: Boolean;
    FTmpField: TCdbfField;
    FTmpRec: TCdbfRecord;
    procedure SetFileName(const Value: string);
    procedure SetActive(const Value: Boolean);
    function GetCount: Integer;
    function GetFieldCount: Integer;
    function GetFields(Index: Integer): TCdbfField;
    function GetRec(Index: Integer): TCdbfRecord;
  published
  public
    constructor Create(AFileName:string);
    destructor Destroy; override;
    procedure Open;
    property FileName:string read FFileName write SetFileName;
    property Active:Boolean read FActive write SetActive;
    procedure Close;
    property Count:Integer read GetCount;
    property FieldCount:Integer read GetFieldCount;
    property Fields[Index:Integer]:TCdbfField read GetFields;
    property Rec[Index:Integer]:TCdbfRecord read GetRec;
  end;

implementation

{ TCDBF }

procedure TCDBF.Close;
begin
  FActive:=false;
  CloseBase(FDBF);
  FDBF:=nil;
end;

constructor TCDBF.Create;
begin
  FFileName:=AFileName;
  FTmpField:=TCdbfField.Create;
  FTmpRec:=TCdbfRecord.Create;
end;

destructor TCDBF.Destroy;
begin
  FTmpField.Free;
  FTmpRec.Free;
  inherited;
end;

function TCdbf.GetCount: Integer;
begin
  Result:=-1;
  if not FActive then Exit;
  Result:=reccount(FDBF);
end;

function TCdbf.GetFieldCount: Integer;
begin
  Result:=-1;
  if not FActive then Exit;
  Result:=cdbfapi.fieldcount(FDBF);
end;

function TCdbf.GetFields(Index: Integer): TCdbfField;
begin
  FTmpField.Base:=FDBF;
  FTmpField.Index:=Index;
  Result:=FTmpField;
end;

function TCdbf.GetRec(Index: Integer): TCdbfRecord;
begin
  FTmpRec.Index:=Index;
  Result:=FTmpRec;
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

procedure TCDBF.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

{ TCdbfField }

function TCdbfField.GetFieldType: Char;
begin
  Result:=cdbfapi.GetFieldType(FBase, FIndex)
end;

function TCdbfField.GetHighLen: Integer;
begin
  Result:=cdbfapi.GetHighLen(FBase, FIndex);
end;

function TCdbfField.GetLowLen: Integer;
begin
  Result:=cdbfapi.GetLowLen(FBase, FIndex);
end;

function TCdbfField.GetName: string;
begin
  Result:=cdbfapi.GetFieldName(FBase, FIndex);
end;

procedure TCdbfField.SetBase(const Value: PDBF);
begin
  FBase := Value;
end;

procedure TCdbfField.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

{ TCdbfRecord }

function TCdbfRecord.GetValues(Index: Integer): string;
begin
  Result:=GetStr(FBase, Index);
end;

procedure TCdbfRecord.SetBase(const Value: PDBF);
begin
  FBase := Value;
end;

procedure TCdbfRecord.SetIndex(const Value: Integer);
begin
  ReadRecord(FBase,Value);
  FIndex := Value;
end;

end.
