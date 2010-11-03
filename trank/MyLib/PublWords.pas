unit PublWords;

interface
Uses Classes, SysUtils, Math, Dialogs, windows, Publ, PublIntegers, PublStreams;
Const
  DictCode:longint=$74436944;
  Alphabet:set of Char =['A'..'Z','А'..'Я','Ё'];
type
  TFindType=Record
   Exactly:boolean;
   indx:integer;
   iWord:integer;
   SrtIndx:integer;
  End;

  TDictionary=Class(TObject)
  Constructor Create(fn:string);
  Destructor Destroy; override;
  private
    FFileName: string;
    FIndx:array of integer;
    FAddr:array of integer;
    MaxInd:integer;
    FMaxWordInd:integer;
    FModified: boolean;
    procedure SetFileName(const Value: string);
    procedure IncCount;
    function GetCount: integer;
    function GetWord(a: integer): string;
    procedure SetWord(a: integer; const Value: string);
    function ReadWord(fs:tFileStream; addr:integer):ShortString;
  public
    property FileName:string read FFileName write SetFileName;
    property Word[ID:integer]:string read GetWord write SetWord;
    property Count:integer read GetCount;
    procedure Fresh;
    property Modified:boolean read FModified;
    function IndexOf(s:string):integer;
    procedure Add(s:ShortString);
    procedure Delete(s:ShortString); overload;
    procedure Delete(a:integer); overload;
  End;

  TSpeedDictionary=Class(TDictionary)
   Constructor Create(fn:string);
   destructor Destroy; override;
  private
    FChar1:array of Char;
    Kesh:array of string;
    Kind:array of integer;
    FKechLength: integer;
    ToKesh:boolean;
    inKesh:integer;
    procedure AddFS(fs: TFileStream; st: string;index:integer);
    procedure SaveKesh;
    procedure SetFileName(const Value: string);
    procedure SetKechLength(const Value: integer);
    procedure SortKesh;
    function GetFileName: string;
  public
    FSortInd:array of integer;
    property FileName:string read GetFileName write SetFileName;
    property KechLength:integer read FKechLength write SetKechLength;
    procedure Add(s:string);
    Procedure IncCount;
    Function Find(s:string; mx:integer):TFindType;
    Procedure Fresh;
    Function GetWords(BeginOfWord:string):TStrings;
  End;

  TWordID=type Integer;

  TCustomWords=class
  protected
    function GetIDs(AWord: string): TWordID; virtual; abstract;
    function GetWords(WordID: TWordID): string; virtual; abstract;
  public
    function Add(AWord:string):TWordID;  virtual; abstract;
    procedure Delete(WordID:TWordID); overload; virtual; abstract;
    procedure Delete(AWord:string); overload; virtual; abstract;
    property Words[WordID:TWordID]:string read GetWords; default;
    property IDs[AWord:string]:TWordID read GetIDs;
  end;

  TWords=class(TCustomWords)
  private
    FWords:TStringList;
    FIDs:TIntegers;
    FContain:TIntegers;
    MaxID: TWordID;
    function NextID:TWordID;
    function GetContain(AWord: String): TIntegers;
  protected
    function GetIDs(AWord: string): TWordID; override;
    function GetWords(WordID: TWordID): string; override;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AWord:string):TWordID; override;
    procedure Delete(WordID:TWordID); override;
    procedure Delete(AWord:string); override;
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);
    procedure SaveToFile(FileName:string);
    procedure LoadFromFile(FileName:string);
    property Contain[AWord:String]:TIntegers read GetContain;
  end;

  TCompactWords=class(TCustomWords)
  private
    Words:TWords;
    FIDs:TRefIntegers;
    FInds:TRefIntegers;
    FContain:TIntegers;
    MaxID: TWordID;
    function NextID:TWordID;
    function GetContain(Word: String): TIntegers;
    function CollectWord(Ints:TIntegers): string;
    function MiniHash(AWord: string): Integer;
  protected
    function GetIDs(Word: string): TWordID; override;
    function GetWords(WordID: TWordID): string; override;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AWord:string):TWordID; override;
    procedure Delete(WordID:TWordID); override;
    procedure Delete(Word:string); override;
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);
    procedure SaveToFile(FileName:string);
    procedure LoadFromFile(FileName:string);
    property Contain[Word:String]:TIntegers read GetContain;
  end;

  TTextCompressor=class
  private
    FText: string;
    aChar:array of char;
    CharCase:array of Cardinal;
    aWords:array of TWordID;
    FWords: TCustomWords;
    FLength: Integer;
    Spectr: array[#0..#$ff] of Integer;
    NormSpectr:array[0..256] of char;
    LengthSpectr:Integer;
    procedure SetText(const Value: string);
    procedure SetWords(const Value: TCustomWords);
    procedure DoNormSpectr;
  public
    property Words:TCustomWords read FWords write SetWords;
    property Text:string read FText write SetText;
    property Length:Integer read FLength;
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);
  end;

  TProgressPrc=procedure (Position,Max:Integer) of object;
  function CutOff(s:string):string;
  procedure FiltStrings(SrcStrings:TStrings; DstStrings:TStrings; Filt:string; PP:TProgressPrc=nil);
implementation
uses publFile;

function CutOff(s:string):string;
begin
 While (length(s)>0) and (s[Length(s)]
  in ['.',',','-','"','''','(',')','[',']','!','?']) do
  SetLength(s,Length(s)-1);
 result:=s;
end;

procedure FiltStrings(SrcStrings:TStrings; DstStrings:TStrings; Filt:string; PP:TProgressPrc=nil);
var
  stsp: TStrings;
  p: Integer;
  j: Integer;
  l: Integer;
  i: Integer;
  sts, sts2: TStrings;
  cs: TStringList;
  s, subs: string;
begin
  if Filt='' then begin
    DstStrings.Assign(SrcStrings);
    Exit;
  end;
  cs := TStringList.Create;
  sts2 := TStringList.Create;
  cs.CommaText := AnsiUpperCase(Filt);
  sts := SrcStrings;
  for i := 0 to cs.Count - 1 do
  begin
    subs:=cs[i];
    l := length(subs);
    if l = 0 then Continue;
    if Assigned(pp) then pp(-1,sts.Count);
    for j := 0 to sts.Count - 1 do begin
      if Assigned(pp) then pp(j,-1);
      s:=sts[j];
      p := pos(subs, s);
      if p = 0 then Continue;
      Delete(s,p,l);
      sts2.AddObject(s,sts.Objects[j]);
    end;
    if i=0 then sts := TStringList.Create;
    stsp := sts;
    sts := sts2;
    sts2 := stsp;
    sts2.Clear;
  end;
  cs.Free;
  sts2.Free;
  DstStrings.Assign(sts);
  if sts<>SrcStrings then sts.Free;
end;

{ TDictionary }

procedure TDictionary.Add(s: ShortString);
Var
 fs:TFileStream;
 i:integer;
begin
 if IndexOf(s)>-1 then Exit;
 s:=CutOff(s);
 if FileExists(FFileName) then
  fs:=TFileStream.create(FFileName,fmOpenWrite)
 else Begin
  fs:=TFileStream.create(FFileName,fmCreate);
  i:=DictCode;
  fs.Write(i,4);
 End;
 IncCount;
 Inc(FMaxWordInd);
 FIndx[MaxInd]:=FMaxWordInd;
 fs.Position:=fs.Size;
 fs.Write(FMaxWordInd,4);
 FAddr[MaxInd]:=fs.Position;
 fs.write(s,ord(s[0])+1);
 fs.Destroy;
end;

constructor TDictionary.Create(fn: string);
begin
 MaxInd:=-1;
 FMaxWordInd:=-1;
 SetLength(FIndx,0);
 SetLength(FAddr,0);
 FileName:=fn;
end;

procedure TDictionary.Delete(s: ShortString);
begin
 Delete(IndexOf(s));
end;

procedure TDictionary.Delete(a: integer);
begin
 if (a<0) or (a>MaxInd) then Exit;
 FIndx[a]:=-1;
 FModified:=true;
end;

destructor TDictionary.Destroy;
begin
 Fresh;
end;

procedure TDictionary.Fresh;
Var
 fs,f2:tFileStream;
 i:integer;
 bakFile:string;
 s:ShortString;
begin
 if not FModified then Exit;
 bakFile:=ChangeFileExt(FFileName,'.bak');
 RenameFile(FFileName,bakFile);
 fs:=tFileStream.Create(FFileName,fmOpenWrite);
 f2:=tFileStream.Create(bakFile,fmOpenRead);
 For i:=0 to MaxInd do Begin
  if FIndx[i]=-1 then Continue;
  s:=ReadWord(f2,Faddr[i]);
  fs.Write(FIndx[i],4);
  FAddr[i]:=fs.Position;
  fs.Write(s,ord(s[0])+1);
 End;
 f2.Destroy;
 fs.Destroy;
 FModified:=false;
end;

function TDictionary.GetCount: integer;
begin
 result:=MaxInd+1;
end;

function TDictionary.GetWord(a: integer): string;
Var
 fs:tFileStream;
begin
 result:='';
 if (a<0) or (a>MaxInd) then Exit;
 fs:=tFileStream.Create(FileName,fmOpenRead);
 result:=ReadWord(fs,FAddr[a]);
 fs.Destroy;
end;

procedure TDictionary.IncCount;
begin
 inc(MaxInd);
 SetLength(FIndx,MaxInd+1);
 SetLength(FAddr,MaxInd+1);
end;

function TDictionary.IndexOf(s: string): integer;
Var
 i:integer;
begin
 result:=-1;
 For i:=0 to MaxInd do
  if Word[i]=s then Begin
   result:=i;
   break;
  End;
end;

function TDictionary.ReadWord(fs: tFileStream; addr: integer): ShortString;
Var
 b:byte;
begin
 fs.Position:=addr;
 fs.Read(b,1);
 result[0]:=chr(b);
 fs.Read(result[1],b);
end;

procedure TDictionary.SetFileName(const Value: string);
Var
 fs:TFileStream;
 i:integer;
 b:byte;
begin
  FFileName := Value;
  if not FileExists(Value) then Exit;
  fs:=TFileStream.Create(Value,fmOpenRead);
  fs.Read(i,4);
  if i<>DictCode then Begin
   fs.Destroy;
   Exit;
  End;
  While fs.Position<fs.Size do Begin
   IncCount;
   fs.read(FIndx[MaxInd],4);
   if FIndx[MaxInd]>FMaxWordInd then FMaxWordInd:=FIndx[MaxInd];
   FAddr[MaxInd]:=fs.Position;
   fs.Read(b,1);
   fs.Seek(b,soFromCurrent);
  End;
  fs.Destroy;
end;

procedure TDictionary.SetWord(a: integer; const Value: string);
Var
 s,vl:ShortString;
 fs:TFileStream;
begin
 if (a<0) or (a>MaxInd) then Exit;
 s:=Word[a];
 Vl:=CutOff(Value);
 if s=Vl then Exit;
 if IndexOf(Vl)<>-1 then Exit;
 fs:=TFileStream.Create(FFileName,fmOpenWrite);
 fs.Position:=fs.size;
 fs.Write(FIndx[a],4);
 fs.Write(s,ord(s[0])+1);
 fs.Destroy;
 FModified:=true;
end;

{ TSpeedDictionary }

procedure TSpeedDictionary.Add(s: string);
Var
 fs:TFileStream;
 fm:integer;
 ft:TFindType;
 us:boolean;
begin
 // todo: Добавление нового слова
 if s[1]='-' then Exit;
 s:=AnsiLowerCase(s);
 us:=FileExists(FileName);
 if us then fm:=fmOpenWrite else fm:=fmCreate;
 ft:=Find(s,MaxInd);
 With ft do
  if not exactly then Begin
   if ToKesh then Begin
    Kesh[inKesh]:=s;
    Kind[inKesh]:=SrtIndx;
    inc(inKesh);
    if inKesh=FKechLength then SaveKesh;
   End Else Begin
    fs:=TFileStream.Create(FileName,fm);
    if not us then fs.Write(DictCode,4);
    AddFs(fs,s,SrtIndx);
    fs.Destroy;
   End;
  End;
end;

constructor TSpeedDictionary.Create(fn:string);
begin
 MaxInd:=-1;
 FMaxWordInd:=-1;
 SetLength(FIndx,0);
 SetLength(FAddr,0);
 SetLength(fSortInd,0);
 SetLength(fChar1,0);
 inKesh:=0;
 FKechLength:=0;
 ToKesh:=false;
 FileName:=fn;
end;

function TSpeedDictionary.Find(s: string; Mx:integer): TFindType;
Var
 a,b,c,sc:integer;
 st:string;
 us:boolean;
begin
 // todo: Поиск слова
 With result do Begin
  Exactly:=false;
  iword:=0;
  indx:=0;
  SrtIndx:=0;
 End;
 sc:=0;
 if Mx=-1 then Exit;
 a:=-1; b:=Mx+1;
 s:=AnsiLowerCase(s);
 if s>word[FSortInd[mx]] then With Result do Begin
  Result.Exactly:=false;
  Result.SrtIndx:=mx+1;
  Exit;
 End;
 us:=false;
 Repeat
  c:=(a+b) div 2;
  if c=-1 then break;
  sc:=fSortInd[c];
  st:=fChar1[sc];
  us:=(s[1]=st);
  if us then st:=word[sc];
  us:=(s=st);
  if us then break else
   if st>s then b:=c else a:=c;
 Until (c=Mx) or (b-a<2);
 if us then Result.iWord:=sc else c:=b;
 Result.Exactly:=us;
 Result.SrtIndx:=c;
 if (c<=Mx) and (c>=0) then Result.indx:=Findx[c];
end;

function TSpeedDictionary.GetFileName: string;
begin
  Result:=inherited FileName;
end;

function TSpeedDictionary.GetWords(BeginOfWord: string): TStrings;
Var
 i,si:integer;
 s:string;
 ft:TFindType;
begin
 result:=TStringList.Create;
 ft:=Find(BeginOfWord,MaxInd);
 si:=fSortInd[ft.SrtIndx];
 s:=Word[si];
 i:=0;
 While pos(BeginOfWord,s)=1 do Begin
  result.Add(s);
  inc(i);
  s:=Word[FSortInd[ft.SrtIndx]+i];
 End;
end;

procedure TSpeedDictionary.IncCount;
begin
 inherited IncCount;
 SetLength(FSortInd,MaxInd+1);
 SetLength(FChar1,MaxInd+1);
end;

procedure TSpeedDictionary.SetFileName(const Value: string);
Var
 i,j:integer;
 s:string;
 ss:shortstring;
 fs:TFileStream;
 ft:TFindType;
 b:byte;
begin
 FFileName := Value;
 if not FileExists(Value) then Exit;
 fs:=TFileStream.Create(Value,fmOpenRead);
 fs.Read(i,4);
 if i<>DictCode then Begin
  fs.Destroy;
  Exit;
 End;
 While fs.Position<fs.Size do Begin
  IncCount;
  fs.read(FIndx[MaxInd],4);
  if FIndx[MaxInd]>FMaxWordInd then FMaxWordInd:=FIndx[MaxInd];
  FAddr[MaxInd]:=fs.Position;
  fs.Read(b,1);
  ss[0]:=Chr(b);
  fs.Read(ss[1],b);
  FChar1[MaxInd]:=ss[1];
 End;
 fs.Destroy;
 SetLength(FChar1,MaxInd+1);
 For i:=0 to MaxInd do Begin
  s:=word[i];
  if Length(s)=0 then FChar1[i]:=#0 else FChar1[i]:=s[1];
  if i=0 then Continue;
  ft:=Find(s,i-1);
  For j:=i downto ft.SrtIndx+1
   do FSortInd[j]:=FSortInd[j-1];
  FSortInd[ft.SrtIndx]:=i;
 End;
end;

procedure TSpeedDictionary.SetKechLength(const Value: integer);
begin
 SaveKesh;
 ToKesh:=Value>0;
 FKechLength := Value;
 SetLength(Kesh,FKechLength+1);
 SetLength(Kind,FKechLength+1);
end;

procedure TSpeedDictionary.SaveKesh;
Var
 us:boolean;
 fs:TFileStream;
 i,fm:integer;
begin
 SortKesh;
 us:=FileExists(FileName);
 if us then fm:=fmOpenWrite else fm:=fmCreate;
 fs:=TFileStream.Create(FileName,fm);
 if not us then fs.Write(DictCode,4);
 us:=ToKesh;
 ToKesh:=false;
 For i:=0 to inKesh-1 do AddFS(fs,Kesh[i],Kind[i]);
 fs.Destroy;
 inKesh:=0;
 ToKesh:=us;
end;

procedure TSpeedDictionary.AddFS(fs:TFileStream;st:string;index:integer);
Var
 s:shortstring;
 i:integer;
begin
 // todo: Запись слова в словарь
 s:=st;
 fs.Position:=fs.Size;
 IncCount;
 FChar1[MaxInd]:=st[1];
 inc(fMaxWordInd);
 fs.Write(fMaxWordInd,4);
 FAddr[MaxInd]:=fs.Position;
 FIndx[MaxInd]:=fMaxWordInd;
 fs.write(s,ord(s[0])+1);
 For i:=MaxInd downto index+1 do FSortInd[i]:=FSortInd[i-1];
  FSortInd[index]:=MaxInd;
end;

Procedure TSpeedDictionary.SortKesh;
Var
 i,j,p:integer;
 ps:string;
begin
 For i:=0 to inKesh-2 do
  For j:=i+1 to inKesh-1 do
   if kind[i]<kind[j] then Begin
    p:=kind[i];        ps:=Kesh[i];
    kind[i]:=kind[j];  Kesh[i]:=Kesh[j];
    kind[j]:=p;        Kesh[j]:=ps;
   End;
 i:=0;
 While i<inKesh-2 do
  if Kind[i]=Kind[i+1] then Begin
   For j:=i+1 to inKesh-2 do Begin
    Kind[j]:=Kind[j+1];
    Kesh[j]:=Kesh[j+1];
   End;
   dec(inKesh);
  End;
end;

Procedure TSpeedDictionary.Fresh;
Var
 fs,f2:tFileStream;
 i,si:integer;
 bakFile:string;
 s:ShortString;
begin
 //if not FModified then Exit;
 bakFile:=ChangeFileExt(FFileName,'.bak');
 SysUtils.DeleteFile(bakFile);
 RenameFile(FFileName,bakFile);
 sleep(1000);
 fs:=tFileStream.Create(FFileName,fmCreate);
 fs.Write(DictCode,4);
 f2:=tFileStream.Create(bakFile,fmOpenRead);
 For i:=0 to MaxInd do Begin
  si:=FSortInd[i];
  s:=ReadWord(f2,FAddr[si]);
  fs.Write(FIndx[si],4);
  FAddr[si]:=fs.Position;
  fs.Write(s,ord(s[0])+1);
 End;
 f2.Destroy;
 fs.Destroy;
 FModified:=false;
end;

destructor TSpeedDictionary.Destroy;
begin
 Fresh;
end;

{ TWords }

function TWords.Add(AWord: string): TWordID;
Var
 Index:Integer;
begin
 AWord:=AnsiUpperCase(AWord);
 if FWords.Find(AWord,Index) then begin
   Result:=FIDs[Index];
 end else begin
   Index:=FWords.Add(AWord);
   Result:=NextID;
   FIDs.Insert(Index,Result);
 end;
end;

procedure TWords.Delete(WordID: TWordID);
Var
  Index:Integer;
begin
  Index:=FIDs.IndexOf(WordID);
  if Index=ImpossibleInt then Exit;
  FWords.Delete(Index);
  FIDs.Delete(WordID);
end;

constructor TWords.Create;
begin
  FWords:=TStringList.Create;
  FIDs:=TObjIntegers.Create;
  FContain:=TIntegers.Create;
  MaxID:=0;
  /////////////////////////////////////////////
  FWords.CaseSensitive:=false;
  FWords.Sorted:=true;
  FWords.Duplicates:=dupIgnore;
end;

procedure TWords.Delete(AWord: string);
Var
  Index:Integer;
begin
  if not FWords.Find(AWord,Index) then Exit;
  FWords.Delete(Index);
  FIDs.Delete(FIDs[Index]);
end;

destructor TWords.Destroy;
begin
  FWords.Free;
  FIDs.Free;
  FContain.Free;
  inherited;
end;

function TWords.GetContain(AWord: String): TIntegers;
Var
  I:Integer;
begin
  AWord:=AnsiUpperCase(AWord);
  FContain.Clear;
  For i:=0 to FWords.Count-1 do
    if pos(AWord, FWords[i])>0 then FContain.Add(FIDs[i]);
  Result:=FContain;
end;

function TWords.GetIDs(AWord: string): TWordID;
Var
  Index:Integer;
begin
  Result:=ImpossibleInt;
  if not FWords.Find(AWord,Index) then Exit;
  Result:=FIDs[Index];
end;

function TWords.GetWords(WordID: TWordID): string;
Var
  Index:Integer;
begin
  Result:='';
  Index:=FIDs.IndexOf(WordID);
  if Index=-1 then Exit;
  Result:=FWords[Index];
end;

procedure TWords.LoadFromFile(FileName: string);
var
  fs:TFileStream;
begin
  fs:=TFileStream.Create(FileName,fmOpenRead);
  LoadFromStream(fs);
  fs.Free;
end;

procedure TWords.LoadFromStream(Stream: TStream);
var
  strm:TMemoryStream;
  Size:Integer;
begin
  Stream.Seek(4,soCurrent);
  MaxID:=ReadStrInt(Stream);
  FIDs.LoadFromStream(Stream);
  strm:=TMemoryStream.Create;
  Size:=ReadStrInt(Stream);
  strm.CopyFrom(Stream,Size);
  strm.Position:=0;
  FWords.LoadFromStream(strm);
  strm.Free;
end;

function TWords.NextID: TWordID;
begin
  inc(MaxID);
  Result:=MaxID;
end;

procedure TWords.SaveToFile(FileName: string);
var
  fs:TFileStream;
begin
  fs:=TFileStream.Create(FileName,fmCreate);
  SaveToStream(fs);
  fs.Free;
end;

procedure TWords.SaveToStream(Stream: TStream);
var
  BeginBlock:Integer;
  strm:TMemoryStream;
begin
  BeginBlock:=WriteBeginBlock(Stream);
  WriteStrInt(Stream,MaxID);
  FIDs.SaveToStream(Stream);
  strm:=TMemoryStream.Create;
  FWords.SaveToStream(strm);
  strm.Position:=0;
  WriteStrInt(Stream,strm.Size);
  Stream.CopyFrom(strm,strm.Size);
  strm.Free;
  WriteEndBlock(Stream,BeginBlock);
end;

{ TCompactWords }

function TCompactWords.Add(AWord: string): TWordID;
var
  I, L, L2, Cnt:integer;
  ShortID: Integer;
  ShortWord: string;
  WordID:integer;
  Hash: Integer;
begin
  AWord:=AnsiUpperCase(AWord);
  Result:=IDs[AWord];
  if Result<>-1 then Exit;
  Hash := MiniHash(AWord);
  WordID:=NextID;
  FInds.Add(Hash,WordID);
  L:=length(AWord);
  Cnt:=L div 5+1;
  for I := 1 to Cnt do begin
    L2:=L div Cnt;
    if L mod Cnt<=I then L2:=L2+1;
    ShortWord:=Copy(AWord,1,L2);
    System.Delete(AWord,1,L2);
    ShortID:=Words.Add(ShortWord);
    FIDs.Add(WordID,ShortID);
  end;
end;

function TCompactWords.CollectWord(Ints: TIntegers): string;
var
  I: Integer;
begin
  Result:='';
  For I:=0 to Ints.Count-1 do
    Result:=Result+Words[Ints[i]];
end;

constructor TCompactWords.Create;
begin
  Words:=TWords.Create;
  FIDs:=TRefIntegers.Create;
  FInds:=TRefIntegers.Create;
  FContain:=nil;
  MaxID:=0;
end;

procedure TCompactWords.Delete(WordID: TWordID);
Var
  Index:Integer;
begin
  Index:=FIDs.IndexOf(WordID);
  if Index=ImpossibleInt then Exit;
  FIDs.Delete(WordID);
end;

procedure TCompactWords.Delete(Word: string);
begin

end;

destructor TCompactWords.Destroy;
begin
  Words.Free;
  FIDs.Free;
  FInds.Free;
  FContain.Free;
  inherited;
end;

function TCompactWords.GetContain(Word: String): TIntegers;
begin
  if FContain = nil then FContain:=TIntegers.Create;
  Result:=FContain;
  // todo:
end;

function TCompactWords.GetIDs(Word: string): TWordID;
Var
  Ints:TIntegers;
  Hash: Integer;
  I: Integer;
begin
  Result:=-1;
  Word:=AnsiUpperCase(Word);
  Hash := MiniHash(Word);
  Ints := FInds.References[Hash];
  for I := 0 to Ints.Count - 1 do begin
    if Words[Ints[I]]<>Word then Continue;
    Result:=Ints[I];
    break;
  end;
end;

function TCompactWords.GetWords(WordID: TWordID): string;
begin
  Result:=CollectWord(FIDs.References[WordID]);
end;

procedure TCompactWords.LoadFromFile(FileName: string);
var
  fs:TFileStream;
begin
  fs:=TFileStream.Create(FileName,fmOpenRead);
  LoadFromStream(fs);
  fs.Free;
end;

function TCompactWords.MiniHash(AWord: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to 4 do begin
    if I > Length(AWord) then break;
    LongRec(Result).Bytes[4 - I] := Byte(AWord[I]);
  end;
end;

procedure TCompactWords.LoadFromStream(Stream: TStream);
begin

end;

function TCompactWords.NextID: TWordID;
begin
  MaxID:=MaxID+1;
  Result:=MaxID;
end;

procedure TCompactWords.SaveToFile(FileName: string);
var
  fs:TFileStream;
begin
  fs:=TFileStream.Create(FileName,fmCreate);
  SaveToStream(fs);
  fs.Free;
end;

procedure TCompactWords.SaveToStream(Stream: TStream);
begin

end;

{ TTextCompressor }

procedure TTextCompressor.DoNormSpectr;
var
  I, J, mx, mxi: Integer;
begin
  LengthSpectr:=0;
  for I := 0 to 255 do begin
    mx:=-1;
    mxi:=0;
    for J := 0 to 255 do
      if Spectr[chr(J)]>mx then begin
        mx:=Spectr[chr(J)];
        mxi:=J;
      end;
    NormSpectr[I]:=Chr(mxi);
    Spectr[Chr(mxi)]:=-1;
    LengthSpectr:=I;
    if mx=0 then break;
  end;
  J:=LengthSpectr;
  for I := 0 to 255 do begin
    if Spectr[chr(I)]=-1 then Continue;
    NormSpectr[J]:=chr(I);
    inc(J);
  end;
end;

procedure TTextCompressor.LoadFromStream(Stream: TStream);
begin

end;

procedure TTextCompressor.SaveToStream(Stream: TStream);
var
  I: Integer;
begin
  Stream.Write(FLength,4);
  Stream.Write(FLength,4);
end;

procedure TTextCompressor.SetText(const Value: string);
var
  S: string;
  WordCount: Integer;
  Word: string;
  X, Y: Integer;
  I, CharCount: Integer;
begin
  FText := Value;
  S:=AnsiUpperCase(Value);
  FLength:=System.Length(Value);
  SetLength(aChar,FLength);
  SetLength(CharCase,FLength div 8 +1);
  SetLength(aWords,FLength);
  WordCount:=0;
  FillChar(CharCase[0],FLength div 8 +1,0);
  FillChar(Spectr[#0],256,0);
  Word:='';
  CharCount:=0;
  for I := 1 to FLength do begin
    if S[I]<>FText[I] then begin
      X := (I-1) div 8;
      Y := (I-1) mod 8;
      CharCase[X]:=CharCase[X] or (1 shl Y);
    end;
    if (S[I] in Alphabet) and (FWords<>nil) then begin
      Word:=Word+S[I];
    end else begin
      if Word<>'' then begin
        aWords[WordCount]:=FWords.Add(Word);
        Word:='';
        inc(WordCount);
        aChar[CharCount]:=#0;
        inc(CharCount);
        inc(Spectr[#0]);
      end;
      aChar[CharCount]:=S[I];
      inc(CharCount);
      inc(Spectr[S[I]]);
    end;
  end;
  SetLength(aWords,WordCount);
  SetLength(aChar,CharCount);
end;

procedure TTextCompressor.SetWords(const Value: TCustomWords);
begin
  FWords := Value;
  Text:=FText;
end;

end.
