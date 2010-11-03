{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
unit PublStreams;

interface

uses
  Classes, Publ, PublExcept, PublStr, Windows;//}, SysUtils;

type
  TPartState = (psBegin, psDeleted, psContinue);
  TProgressStage = (psStarting, psRunning, psEnding);
  TProgressEvent = procedure(Sender: TObject; Stage: TProgressStage;
    PercentDone: Byte) of object;

  TStreams = class (TFileStream)
  private
    CurBlock: Integer;
    CurPart: Integer;
    FBegs: aai;
    FBlockPosition: Int64;
    FFileName: string;
    FNames: TStrings;
    FOnProgress: TProgressEvent;
    FSizes: aai;
    FToken: string;
    MaxInd: Integer;
    function GetBegs(Block: Integer): Integer;
    function GetBlockSize: Int64;
    function GetCurBeg: Integer;
    function GetCurBeg2: Integer;
    function GetCurrentBlock: string;
    function GetEnds(Block: Integer): Integer;
    function GetParts(Block, Part: Integer): Integer;
    function GetPartSize: Integer;
    function BlockStart(Name: string): Integer; overload;
    function BlockStart(x: Integer): Integer; overload;
    procedure DoProgress(Stage: TProgressStage; PercentDone: Byte);
    procedure IncCount;
    procedure Init;
    procedure SetBegs(Block: Integer; const Value: Integer);
    procedure SetBlockPosition(const Value: Int64);
    procedure SetCurrentBlock(const Value: string);
  protected
    // Преобразование порядкового номера имени к индексу блока
    function ToInd(Block: Integer): Integer;
    // Запомнить имя блока и начало в массиве
    procedure AddBlock(Name: string; ABeg: Integer);
    // Запомнить начало фрагмента и размер
    procedure AddPart(Name: string; ABeg, ASize: Integer);
    // Список начал блоков
    property Begs[Block: Integer]: Integer read GetBegs write SetBegs;
    // Начало текущего блока
    property CurBeg: Integer read GetCurBeg;
    // Начало текущей фрагмента
    property CurBeg2: Integer read GetCurBeg2;
    // Концы блоков
    property Ends[Block: Integer]: Integer read GetEnds;
    // Указатели на Фрагменты
    property Parts[Block, Part: Integer]: Integer read GetParts;
    // Размеры фрагментов
    property PartSize: Integer read GetPartSize;
    // Чтение данных из текущего именованого потока
    function BlockRead(var Buffer; Count: Longint): Longint;
    // Запись данных в текущий именованый поток
    function BlockWrite(const Buffer; Count: Longint): Longint;
    // Добавление именованого потока в файл
    procedure Add(Name: string; Stream: TStream); virtual;
    // Копировать Count данных в поток str
    procedure CopyTo(str: TStream; Count: Integer);
    // Удаление потока по имени
    procedure Delete(Name: string); virtual;
    // Уплотнить поток
    procedure Rebuild;
    // Замена именованого потока
    procedure Replace(Name: string; Stream: TStream);
    // Список имён блоков
    property BlockNames: TStrings read FNames;
    // Установка позиции в текущем именованном потоке
    property BlockPosition: Int64 read FBlockPosition write SetBlockPosition;
    // Размер текущего именованного потока
    property BlockSize: Int64 read GetBlockSize;
    // Имя текущего блока
    property CurrentBlock: string read GetCurrentBlock write SetCurrentBlock;
  public
    constructor Create(const FileName: string; Mode: Word; AToken: string);
    destructor Destroy; override;
    // Событие
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    // Внутрений идентификатор файла
    property Token: string read FToken;
  end;

  TSubStream = class (TStream)
  protected
    FName: string;
    FParent: TStreams;
    FPosition: Integer;
    procedure SetSize(const NewSize: Int64); override;
    function GetSize: Int64; override;
  public
    constructor Create(AParent: TStreams; AName: string);
    // см. хелп для стрим
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    // Имя блока в мульти-стрим
    property Name: string read FName;
  end;

  TMultiStream = class (TStreams)
  private
    FSubStreams: TList;
    function GetStreams(Name: string): TStream;
    function GetStreamNames: TStrings;
    function IndexOf(Name: string): Integer;
  public
    constructor Create(const AFileName: string; Mode: Word; AToken: string);
    function AddStream(Name: string): TStream;
    procedure Add(Name: string; Stream: TStream); override;
    procedure Delete(Name: string); override;
    destructor Destroy; override;
    property StreamNames: TStrings read GetStreamNames;
    property Streams[Name: string]: TStream read GetStreams; default;
  end;

implementation

uses
  PublFile, PublTime;

{ TStreams }

procedure TStreams.Add(Name: string; Stream: TStream);
var
  l, Ind, p: Integer;
  xBlockPosition: Integer;
  s: Longint;
  State: TPartState;
  Next: Longint;
  us: Boolean;
  Znak: Word;
  oldn: string;
begin
  xBlockPosition := BlockPosition;
  if Size = 0 then
    WriteString(self, FToken);
  p := Seek(0, soEnd);
  oldn := CurrentBlock;
  CurrentBlock := Name;
  us := CurrentBlock = Name;
  s := Stream.Size;
  if us then
  begin
    BlockPosition := BlockSize;
    us := Position + 4 = Size;
    if not us then
    begin
      Read(Next, 4);
      Seek(-4, soCurrent);
      Write(p, 4);
      State := psContinue; //Continue of Block
    end;
  end
  else
  begin
    State := psBegin;    //Begin of Block
    AddBlock(Name, p);
  end;
  if not us then
  begin
    Seek(0, soEnd);
    Znak := $3412;
    Write(Znak, 2);
    WriteString(self, Name);
    Write(State, 1);
    Write(s, 4);
    AddPart(Name, position, s);
  end;
  Stream.Position := 0;
  CopyFrom(Stream, s);
  Next := -1;
  Write(Next, 4);
  if us then
  begin
    Ind := ToInd(CurBlock);
    l := Length(FSizes[Ind]) - 1;
    Position := FBegs[Ind, l + 1] - 4;
    s := s + Parts[CurBlock, l];
    Write(s, 4);
    FSizes[Ind, l] := s;
  end;
  CurrentBlock := oldn;
  BlockPosition := xBlockPosition;
end;

function TStreams.BlockRead(var Buffer; Count: Integer): Longint;
var
  l, Next: Integer;
  ms: TMemoryStream;
  us: Boolean;
begin
  result := 0;
  ms := TMemoryStream.Create;
  repeat
    l := CurBeg2 + PartSize - Position;
    if l < Count then
    begin
      Count := Count - l;
      ms.CopyFrom(self, l);
      result := result + l;
      us := (position = size);
      FBlockPosition := FBlockPosition + l;
      if not us then
      begin
        Read(Next, 4);
        us := Next = -1;
      end;
      if us then
        Count := 0
      else
      begin
        CurPart := CurPart + 1;
        position := Next;
        Seek(2, soCurrent);
        ReadString(self);
        Seek(5, soCurrent);
      end;
    end
    else
    begin
      result := result + Count;
      FBlockPosition := FBlockPosition + Count;
      ms.CopyFrom(self, count);
      Count := 0;
    end;
  until Count = 0;
  ms.position := 0;
  ms.Read(Buffer, Result);
  ms.Free;
end;

function TStreams.BlockWrite(const Buffer; Count: Integer): Longint;
var
  l, Next: Integer;
  ms, ms2: TMemoryStream;
begin
  result := 0;
  ms := TMemoryStream.Create;
  ms.Write(Buffer, Count);
  ms.position := 0;
  repeat
    l := CurBeg2 + PartSize - Position;
    if l < Count then
    begin
      Count := Count - l;
      if l > 0 then
        CopyFrom(ms, l);
      result := result + l;
      Read(Next, 4);
      FBlockPosition := FBlockPosition + l;
      if Next = -1 then
      begin
        ms2 := TMemoryStream.Create;
        ms2.CopyFrom(ms, ms.Size - ms.Position);
        Add(CurrentBlock, ms2);
        BlockPosition := BlockSize;
        ms2.Free;
        result := result + Count;
        Count := 0;
      end
      else
      begin
        CurPart := CurPart + 1;
        position := Next;
        Seek(2, soCurrent);
        ReadString(self);
        Seek(5, soCurrent);
      end;
    end
    else
    begin
      result := result + Count;
      FBlockPosition := FBlockPosition + Count;
   //ms.Position:=0;
      CopyFrom(ms, count);
      Count := 0;
    end;
  until Count = 0;
  ms.Free;
end;

procedure TStreams.CopyTo(str: TStream; Count: Integer);
var
  p: pointer;
begin
  GetMem(p, Count);
  BlockRead(p^, Count);
  str.Write(p^, Count);
  FreeMem(p, Count);
end;

constructor TStreams.Create(const FileName: string; Mode: Word; AToken: string);
begin
  FFileName := FileName;
  FToken := AToken;
  FNames := TStringList.Create;
  with TStringList(FNames) do
  begin
    Sorted := true;
    CaseSensitive := false;
    Duplicates := dupIgnore;
  end;
  if not FileExists(FileName) then
    Mode := fmCreate;
  inherited Create(FileName, Mode);
  Init;
end;

procedure TStreams.Delete(Name: string);
var
  p, p1: Integer;
  State: tPartState;
begin
  p1 := Position;
  p := BlockStart(Name);
  if p = -1 then
    Exit;
  Position := p;
  seek(2, soCurrent);
  ReadString(self);
  State := psDeleted;
  Write(State, 1);
  Position := p1;
  with FNames do
    Delete(IndexOf(Name));
end;

destructor TStreams.Destroy;
begin
  if self = nil then
    Exit;
  FNames.Free;
  inherited;
end;

function TStreams.GetCurrentBlock: string;
begin
  result := '';
  if CurBlock <> -1 then
    result := FNames[CurBlock];
end;

procedure TStreams.IncCount;
begin
  Inc(MaxInd);
  SetLength(FSizes, MaxInd + 1);
  SetLength(fBegs, MaxInd + 1);
  SetLength(fBegs[MaxInd], 1);
end;

function TStreams.BlockStart(Name: string): Integer;
var
  i: Integer;
begin
  i := FNames.IndexOf(Name);
  result := BlockStart(i);
end;

function TStreams.BlockStart(x: Integer): Integer;
begin
  result := -1;
  if x = -1 then
    Exit;
  result := Begs[x];
end;

procedure TStreams.Rebuild;
var
  i, s: Integer;
  fn, path: string;
  fs: TStreams;
  ms: TMemoryStream;
  T: TDateTime;
begin
  path := ExtractFilePath(FFileName);
  i := 0;
  repeat
    fn := path + format('file%d.bak', [i]);
    inc(i);
  until not FileExists(fn);
  fs := TStreams.Create(fn, fmCreate, FToken);
  DoProgress(psStarting, 0);
  ms := TMemoryStream.Create;
  s := 0;
  T := Now;
  for i := 0 to FNames.Count - 1 do
  begin
    CurrentBlock := FNames[i];
    s := s + BlockSize;
    ms.Size := 0;
    BlockPosition := 0;
    CopyTo(ms, BlockSize);
    if Now - T > 1 / 24 / 60 / 60 / 3 then
    begin
      T := NOW;
      DoProgress(psRunning, Round(s * 100 / Size));
    end;
    fs.Add(FNames[i], ms);
  end;
  ms.Free;
  DoProgress(psEnding, 100);
  size := 0;
  fs.position := 0;
  CopyFrom(fs, fs.size);
  fs.Free;
  DeleteFile(PAnsiChar(fn));
  Init;
end;

procedure TStreams.Replace(Name: string; Stream: TStream);
begin
  Delete(Name);
  Add(Name, Stream);
end;

procedure TStreams.SetBlockPosition(const Value: Int64);
var
  l, i, xSize, xPart, Ind: Integer;
begin
  if CurBlock = -1 then
    Exit;
  if Value >= BlockSize then
  begin
    Position := Ends[CurBlock];
    FBlockPosition := BlockSize;
    Exit;
  end;
  Ind := ToInd(CurBlock);
  if Ind = -1 then
    Exit;
  l := Length(fSizes[Ind]);
  if l = 0 then
    Exit;
  xSize := fSizes[ind, 0];
  xPart := 0;
  for i := 1 to l - 1 do
  begin
    xPart := i;
    xSize := xSize + FSizes[ind, i];
    if xSize > Value then
      break;
  end;
  CurPart := xPart;
  Position := CurBeg2 + (Value + fSizes[ind, xPart] - xSize);
  FBlockPosition := Value;
end;

procedure TStreams.SetCurrentBlock(const Value: string);
var
  i: Integer;
begin
  if CurrentBlock = Value then
    Exit;
  i := FNames.IndexOf(Value);
  if i = -1 then
    Exit;
  CurBlock := i;
  BlockPosition := 0;
end;

function TStreams.GetBlockSize: Int64;
var
  i, l, Ind: Integer;
begin
  result := -1;
  Ind := ToInd(CurBlock);
  if Ind = -1 then
    Exit;
  l := length(FSizes[Ind]) - 1;
  result := 0;
  for i := 0 to l do
    result := result + FSizes[Ind, i];
end;

procedure TStreams.DoProgress(Stage: TProgressStage; PercentDone: Byte);
begin
  if Assigned(FOnProgress) then
    FOnProgress(self, Stage, PercentDone);
end;

function TStreams.ToInd(Block: Integer): Integer;
begin
  if Block = -1 then
    result := -1
  else
    result := Integer(FNames.Objects[Block]);
end;

procedure TStreams.Init;
var
  s: string;
  Znak: Word;
  ABeg1, ABeg2, ASize: Integer;
  Name: string;
  State: TPartState;
begin
  CurPart := 0;
  FBlockPosition := 0;
  CurBlock := -1;
  MaxInd := -1;
  SetLength(FSizes, 0);
  SetLength(FBegs, 0);
  if Size = 0 then
    Exit;
  Position := 0;
  s := ReadString(Self);
  if (FToken <> '') and (s <> FToken) then
    Abort;
  FToken := S;
  repeat
    ABeg1 := position;
    Read(Znak, 2);
    if Znak <> $3412 then
      Abort;
    Name := ReadString(self);
    Read(State, 1);
    Read(Asize, 4);
    ABeg2 := position;
    Seek(Asize + 4, soCurrent);
    if State = psBegin then
      AddBlock(Name, ABeg1);
    if State <> psDeleted then
      AddPart(Name, ABeg2, ASize);
  until position = size;
  if FNames.count > 0 then
    CurrentBlock := FNames[0];
end;

function TStreams.GetCurBeg: Integer;
var
  Ind: Integer;
begin
  Result := -1;
  Ind := ToInd(CurBlock);
  if Ind = -1 then
    Exit;
  Result := FBegs[Ind, 0];
end;

function TStreams.GetCurBeg2: Integer;
var
  Ind: Integer;
begin
  result := -1;
  Ind := ToInd(CurBlock);
  if Ind = -1 then
    Exit;
  if CurPart = -1 then
    Exit;
  result := FBegs[Ind, CurPart + 1];
end;

function TStreams.GetParts(Block, Part: Integer): Integer;
var
  Ind: Integer;
begin
  result := -1;
  Ind := ToInd(CurBlock);
  if Ind = -1 then
    Exit;
  if Part = -1 then
    Exit;
  result := FSizes[Ind, Part];
end;

function TStreams.GetBegs(Block: Integer): Integer;
var
  ind: Integer;
begin
  result := -1;
  ind := ToInd(Block);
  if Ind = -1 then
    Exit;
  result := FBegs[Ind, 0];
end;

procedure TStreams.SetBegs(Block: Integer; const Value: Integer);
var
  Ind: Integer;
begin
  Ind := ToInd(Block);
  if Ind = -1 then
    Exit;
  FBegs[Ind, 0] := Value;
end;

function TStreams.GetEnds(Block: Integer): Integer;
var
  ind, l: Integer;
begin
  result := -1;
  ind := ToInd(Block);
  if Ind = -1 then
    Exit;
  l := length(FSizes[Ind]);
  result := FBegs[Ind, l] + FSizes[Ind, l - 1];
end;

function TStreams.GetPartSize: Integer;
begin
  result := Parts[CurBlock, CurPart];
end;

procedure TStreams.AddBlock(Name: string; ABeg: Integer);
begin
  incCount;
  CurBlock := FNames.AddObject(Name, TObject(MaxInd));
  Begs[CurBlock] := ABeg;
end;

procedure TStreams.AddPart(Name: string; ABeg, ASize: Integer);
var
  l, Ind, Block: Integer;
begin
  Block := FNames.IndexOf(Name);
  if Block = -1 then
    Exit;
  Ind := ToInd(Block);
  l := Length(fBegs[Ind]);
  SetLength(fSizes[Ind], l);
  SetLength(fBegs[Ind], l + 1);
  fBegs[Ind, l] := ABeg;
  fSizes[Ind, l - 1] := ASize;
end;

{ TSubStream }

constructor TSubStream.Create(AParent: TStreams; AName: string);
begin
  FParent := AParent;
  FName := AName;
  FPosition := 0;
end;

function TSubStream.GetSize: Int64;
begin
  result := 0;
  if self = nil then
    Exit;
  FParent.CurrentBlock := FName;
  result := FParent.BlockSize;
end;

function TSubStream.Read(var Buffer; Count: Integer): Longint;
begin
  result := 0;
  if self = nil then
    Exit;
  FParent.CurrentBlock := FName;
  FParent.BlockPosition := FPosition;
  result := FParent.BlockRead(Buffer, Count);
  FPosition := FParent.BlockPosition;
end;

function TSubStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  result := 0;
  if self = nil then
    Exit;
  FParent.CurrentBlock := FName;
  case Origin of
    soBeginning:
    begin
      FParent.BlockPosition := Offset;
      Result := FParent.BlockPosition;
      FPosition := Result;
    end;
    soCurrent:
      result := Seek(FPosition + Offset, soBeginning);
    soEnd:
      result := Seek(FParent.BlockSize + Offset, soBeginning);
  end;
end;

procedure TSubStream.SetSize(const NewSize: Int64);
begin
  raise Exception.Create('Размер потока изменить нельзя');
end;

function TSubStream.Write(const Buffer; Count: Integer): Longint;
begin
  result := 0;
  if self = nil then
    Exit;
  FParent.CurrentBlock := FName;
  FParent.BlockPosition := FPosition;
  result := FParent.BlockWrite(Buffer, Count);
  FPosition := FParent.BlockPosition;
end;

{ TMultiStream }

procedure TMultiStream.Add(Name: string; Stream: TStream);
var
  ind: Integer;
begin
  ind := IndexOf(Name);
  inherited Add(Name, Stream);
  if ind = -1 then
  begin
    ind := IndexOf(Name);
    Assert(ind = FSubStreams.Add(TSubStream.Create(self, Name)),
      'Error on TMultiStream.Add (line~708)');
  end;
end;

function TMultiStream.AddStream(Name: string): TStream;
var
  ind: Integer;
  ms: TMemoryStream;
begin
  ind := IndexOf(Name);
  if ind = -1 then
  begin
    ms := TMemoryStream.Create;
    Add(Name, ms);
    ms.Free;
  end;
  result := Streams[Name];
end;

constructor TMultiStream.Create(const AFileName: string; Mode: Word; AToken: string);
begin
  inherited Create(AFileName, Mode, AToken);
  FSubStreams := TList.Create;
end;

procedure TMultiStream.Delete(Name: string);
var
  ind: Integer;
begin
  ind := IndexOf(Name);
  if ind = -1 then
    exit;
  inherited;
  TObject(FSubStreams[ind]).Free;
end;

destructor TMultiStream.Destroy;
var
  I: Integer;
begin
  for I := 0 to FSubStreams.Count - 1 do
    TObject(FSubStreams[I]).Free;
  FSubStreams.Free;
  inherited;
end;

function TMultiStream.IndexOf(Name: string): Integer;
begin
  Result := ToInd(BlockNames.IndexOf(Name));
end;

function TMultiStream.GetStreamNames: TStrings;
begin
  result := BlockNames;
end;

function TMultiStream.GetStreams(Name: string): TStream;
var
  ind: Integer;
begin
  result := nil;
  ind := IndexOf(Name);
  if ind = -1 then
    Exit;
  result := FSubStreams[ind];
end;

end.
