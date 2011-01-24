unit cdbf;

interface
uses cdbfapi, PublExcept, Publ;

function DbfDateToPlainDate(s: string): string;
function ConvertDateIfPossible(s: string):string;
procedure DbfToCsv(DbfFileName, CsvFilename:string; AsAnsi:Boolean=true;
          CBProc:TIntProc=nil; TimeOut:integer=100);

implementation
uses PublStr, StrUtils, SysUtils, DateUtils;

function DbfDateToPlainDate(s: string): string;
begin
  Result:=RightStr(s,2)+'.'+Copy(s,5,2)+'.'+LeftStr(s,4);
end;

function ConvertDateIfPossible(s: string):string;
var
  I: Integer;
begin
  Result := s;
  if length(s)<>8 then Exit;
  for I := 1 to 8 do
    if s[i] in ['0'..'9'] then else Exit;
  if (LeftStr(s,2)<>'19') and (LeftStr(s,2)<>'20') then Exit;
  Result := DbfDateToPlainDate(s);
end;

procedure DbfToCsv(DbfFileName, CsvFilename:string; AsAnsi:Boolean=true;
          CBProc:TIntProc=nil; TimeOut:integer=100);
var
	d: PDBF;
	i, j: integer;
  prc, s: string;
  cnt: Integer;
  tx: TextFile;
  tm: TDateTime;
  tmOut: TDateTime;
begin
	d := OpenBase(PChar(DbfFileName));
  d.opt.nodeleted:=1;
	if d = nil then
    raise EInOutError.Create('Невозможно открыть файл базы данных');
  s:=CsvFilename;
  AssignFile(tx,s);
  Rewrite(tx);
  for j := 0 to fieldcount(d)-1 do
  begin
    if j>0 then write(tx,ListSeparator);
    write(tx,GetFieldName(d,j));
  end;
  writeln(tx);
  cnt:=reccount(d)-1;
  prc:='';
  tm:=Now;
  tmOut:=TimeOut*OneMillisecond;
  for i := 0 to cnt do
  begin
    ReadRecord(d, i);

    for j := 0 to fieldcount(d)-1 do
    begin
      if j>0 then write(tx,ListSeparator);
      s := PublStr.Trim(GetStr(d, j));
      s:=ConvertDateIfPossible(s);
      if AsAnsi then s:=PublStr.AsAnsi(s);
      write(tx,s);
    end;
    writeln(tx);
    if not Assigned(CBProc) then Continue;
    if Now-tm<tmOut then Continue;
    CBProc(I,cnt-1);
  end;
  Closebase(d);
  CloseFile(tx);
end;

end.
