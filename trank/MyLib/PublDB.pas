unit PublDB;

interface

uses
  Classes, DB;

type
  TPublDB = class (TComponent)
  end;
// Преобразование типа поля таблицы в строку
function FieldTypeToStr(FT: TFieldType): string;
// Преобразование типа поля таблицы в тип SQL
function FtToSQL(FT: TFieldType; Size: Integer): string;
// Копирование таблицы базы данных в другую Paradox-таблицу
procedure CopyDBFile(Source, Dest: string; PKeys: array of string);
// Добавление нового поля
procedure CreateEmptyTable(TableName: string);
// Добавление нового поля
procedure AddField(TableName, FieldName: string; FT: TFieldType; Size: Integer);
// Создание индекса
procedure AddIndex(FN, ind, FieldNames: string);
// Изменение кодировки таблицы
procedure TableToAnsi(TableName: string);
procedure TableToOEM(TableName: string);

implementation

uses
  DBTables, PublStr, StrUtils, SysUtils;

function FtToSQL(FT: TFieldType; Size: Integer): string;
begin
  case ft of
    ftDate:
      result := 'DATE';
    ftTime:
      result := 'TIME';
    ftFloat:
      result := 'FLOAT';
    ftMemo:
      result := format('BLOB(%d,1)', [Size]);
    ftBlob:
      result := format('BLOB(%d,2)', [Size]);
    ftSmallint:
      result := 'SMALLINT';
    ftInteger:
      result := 'INTEGER';
    ftString:
      result := format('CHAR(%d)', [Size]);
  else
    result := '';
  end;
end;

function FieldTypeToStr(FT: TFieldType): string;
begin
  case ft of
    ftUnknown:
      Result := 'ftUnknown';
    ftString:
      Result := 'ftString';
    ftSmallint:
      Result := 'ftSmallint';
    ftInteger:
      Result := 'ftInteger';
    ftWord:
      Result := 'ftWord';
    ftBoolean:
      Result := 'ftBoolean';
    ftFloat:
      Result := 'ftFloat';
    ftCurrency:
      Result := 'ftCurrency';
    ftBCD:
      Result := 'ftBCD';
    ftDate:
      Result := 'ftDate';
    ftTime:
      Result := 'ftTime';
    ftDateTime:
      Result := 'ftDateTime';
    ftBytes:
      Result := 'ftBytes';
    ftVarBytes:
      Result := 'ftVarBytes';
    ftAutoInc:
      Result := 'ftAutoInc';
    ftBlob:
      Result := 'ftBlob';
    ftMemo:
      Result := 'ftMemo';
    ftGraphic:
      Result := 'ftGraphic';
    ftFmtMemo:
      Result := 'ftFmtMemo';
    ftParadoxOle:
      Result := 'ftParadoxOle';
    ftDBaseOle:
      Result := 'ftDBaseOle';
    ftTypedBinary:
      Result := 'ftTypedBinary';
    ftCursor:
      Result := 'ftCursor';
    ftFixedChar:
      Result := 'ftFixedChar';
    ftWideString:
      Result := 'ftWideString';
    ftLargeint:
      Result := 'ftLargeint';
    ftADT:
      Result := 'ftADT';
    ftArray:
      Result := 'ftArray';
    ftReference:
      Result := 'ftReference';
    ftDataSet:
      Result := 'ftDataSet';
    ftOraBlob:
      Result := 'ftOraBlob';
    ftOraClob:
      Result := 'ftOraClob';
    ftVariant:
      Result := 'ftVariant';
    ftInterface:
      Result := 'ftInterface';
    ftIDispatch:
      Result := 'ftIDispatch';
    ftGuid:
      Result := 'ftGuid';
    ftTimeStamp:
      Result := 'ftTimeStamp';
    ftFMTBcd:
      Result := 'ftFMTBcd';
  else
    Result := '';
  end;
end;


procedure CopyDBFile(Source, Dest: string; PKeys: array of string);
var
  st1, st2: TStringList;
  sf, sf2, str, fn: string;
  i: Integer;
  quConvert: TQuery;
  tabConv: TTable;
  s1, s2: string;
begin
  quConvert := TQuery.Create(nil);
  tabConv := TTable.Create(nil);
  st1 := TStringList.Create;
  st2 := TStringList.Create;
  sf := '(';
  sf2 := '';
  quConvert.DataBaseName := ExtractFilePath(dest);
  with quConvert, tabConv do
  begin
    st1.Text := Format('Create table "%s" (', [Dest]);
    TableName := Source;
    tabConv.Open;
    st2.clear;
    fn := ExtractFileName(Dest);
    s1 := '';
    s2 := '';
    for i := 0 to FieldCount - 1 do
      with Fields[i] do
      begin
        if s2 <> '' then
          s2 := s2 + ',';
        s2 := s2 + '"' + Dest + '"."' + FieldName + '"';
        if AnsiMatchText(FieldName, PKeys) and (i < 7) and
          (DataType in [ftString, ftSmallint, ftInteger, ftBoolean, ftFloat,
          ftCurrency, ftDate, ftDateTime, ftBytes]) then
        begin
          if s1 <> '' then
            s1 := s1 + ',';
          s1 := s1 + s2;
          s2 := '';
        end;
        str := '"' + Dest + '"."' + FieldName + '" ' + FtToSQL(DataType, Size);
        sf := sf + '"' + fn + '"."' + FieldName + '"';
        sf2 := sf2 + 'XXX."' + FieldName + '"';
        if i < FieldCount - 1 then
          str := str + ','
        else
          str := str + ','#13#10'Primary key (' + s1 + '));';
        if i < FieldCount - 1 then
          sf := sf + ', '
        else
          sf := sf + ')';
        if i < FieldCount - 1 then
          sf2 := sf2 + ', '
        else
          sf2 := sf2;
        St1.add(str);
      end;
    tabConv.Close;
    St2.Add(format('Insert into "%s" ', [fn]));
    St2.Add(sf);
    St2.Add(format('select %s from "%s" as XXX', [sf2, Source]));
  //ShowMessage(SQL.Text);
    sql.Assign(st1);
    ExecSQL;
    sql.Assign(st2);
    ExecSQL;
  end;
  st1.Free;
  st2.Free;
  quConvert.Free;
  tabConv.Free;
end;

procedure CreateEmptyTable(TableName: string);
var
  qwt: TQuery;
  s1: string;
begin
  qwt := TQuery.Create(nil);
  qwt.DataBaseName := ExtractFilePath(TableName);
  TableName := ExtractFileName(TableName);
  with qwt do
  begin
    s1 := Format('Create table "%s" ()', [TableName]);
    sql.text := s1;
    ExecSQL;
  end;
  qwt.Free;
end;

procedure AddField(TableName, FieldName: string; FT: TFieldType; Size: Integer);
begin
  with TQuery.Create(nil) do
  begin
    sql.Text := Format('Alter table "%s"'#13#10 + 'add "%s"."%s" %s;',
      [TableName, TableName, FieldName, FtToSQL(ft, size)]);
    ExecSQL;
    Free;
  end;
end;

procedure AddIndex(FN, ind, FieldNames: string);
begin
  with TQuery.Create(nil) do
  begin
    SQL.Text := format('Create Index %s on "%s" (%s)', [ind, FN, FieldNames]);
    ExecSQL;
    Free;
  end;
end;

procedure TableToAnsi(TableName: string);
var
  table: TTable;
  i: Integer;
  ist: set of Byte;
begin
  table := TTable.Create(nil);
  table.TableName := TableName;
  Table.Open;
  Table.Last;
  ist := [];
  for i := 0 to table.FieldCount - 1 do
    if table.Fields[i].DataType in [ftString, ftMemo] then
      ist := ist + [i];
  while not table.Bof do
  begin
    table.Edit;
    for i := 0 to table.FieldCount - 1 do
    begin
      if not (i in ist) then
        Continue;
      table.Fields[i].AsString := asAnsi(table.Fields[i].AsString);
    end;
    table.Post;
    table.Prior;
  end;
  table.Close;
  table.Free;
end;

procedure TableToOEM(TableName: string);
var
  table: TTable;
  i: Integer;
  ist: set of Byte;
begin
  table := TTable.Create(nil);
  table.TableName := TableName;
  Table.Open;
  for i := 0 to table.FieldCount - 1 do
    if table.Fields[i].DataType in [ftString, ftMemo] then
      ist := ist + [i];
  while not table.Eof do
  begin
    table.Edit;
    for i := 0 to table.FieldCount - 1 do
    begin
      if not (i in ist) then
        Continue;
      table.Fields[i].AsString := asOEM(table.Fields[i].AsString);
    end;
    table.Post;
    table.Next;
  end;
  table.Close;
  table.Free;
end;

end.
