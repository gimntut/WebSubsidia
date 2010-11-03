unit HardPubl;

interface

uses
  Classes, ClipBrd, Controls, Publ,
//  SysUtils,
  Windows;

type
 ////////////////////// x //////////////////////
  TExtClipboard = class (TClipboard)
  public
    procedure SetBuffer(Format: Word; var Buffer; Size: Integer);
  end;
 ////////////////////// x //////////////////////

function TextFromValue(value: Extended): string;
// Создание ссылки на файл
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
// Проверка наличия запущеной программы
function IsProgramRun(s: string): Boolean;
// Установка фокуса на дочерний объект
procedure SetFocusTo(root: TWinControl; s: string);
// Вывод сообщения
procedure ShowMessage(Text: string; Title: string = ''); overload;
// Получение версии программы
function GetVersion(Name: string): string;
//
function FiltKey(Text: string; SelStart: Integer; Key: Char): Char; overload;
function FiltKey(Sender: TObject; Key: Char): Char; overload;
// Сравнение строк начинающихся с числа
function CompNumStr(List: TStringList; Index1, Index2: Integer): Integer; overload;
function CompNumText(List: TStringList; Index1, Index2: Integer): Integer; overload;
// Вариант в число
function VarToInt(v: Variant; ADefault: Integer = 0): Integer;
// Сохранение и загрузка файла с восстановлением
//procedure SaveToFileEx(fn: string; sp: TStreamProc); overload;
//procedure LoadFromFileEx(fn: string; sp: TStreamProc; ErrStr: string = ''); overload;

implementation

uses
  ActiveX, ComObj, PublDB, PublStr, shlObj, StdCtrls, TlHelp32, Variants, PublFile, 
  PublConst, PublExcept;

function TextFromValue(value: Extended): string;
var
  IntegerPartLen: Integer;
  IntegerText: string;
  s1, s2, s3: string;
  StrAll: string[12];
  Counter: Integer;
  st_1: string;//0-999
  st_2: string;//1 000-999 999
  st_3: string;//1 000 000-999 999 999
  st_4: string;//1 000 000 000 - 999 999 999 999
const
  Array_1: array[0..9] of string =
    ('', ' один', ' два', ' три', ' четыре', ' пять',
    ' шесть', ' семь', ' восемь', ' девять');
  Array_1_2: array[0..9] of string =
    ('', ' одна', ' две', ' три', ' четыре', ' пять',
    ' шесть', ' семь', ' восемь', ' девять');
//...
  Array_11_19: array[1..9] of string =
    (' одиннадцать', ' двенадцать', ' тринадцать',
    ' четырнадцать', ' пятнадцать', ' шестнадцать',
    ' семнадцать', ' восемнадцать',
    ' девятнадцать');
//...
  Array_10_90: array[0..9] of string =
    ('', ' десять', ' двадцать', ' тридцать',
    ' сорок', ' пятьдесят', ' шестьдесят',
    ' семьдесят', ' восемьдесят',
    ' девяносто');
//...
  Array_E: array[0..9] of string =
    ('', ' сто', ' двести', ' триста',
    ' четыреста', ' пятьсот', ' шестьсот',
    ' семьсот', ' восемьсот',
    ' девятьсот');

{} function IntegerPart(value: Extended): string;
{} var
    Counter: Integer;
{}     ResStr: string[1];
{}     ValueStr: string;
{}     r: string;
{} begin
{}  Counter := 1;
{}  r := '';
{}  ValueStr := FormatFloat('0.00', value);
{}  repeat
{}    ResStr := ValueStr[counter];
{}    Inc(Counter);
{}    if (ResStr = ',') or (ResStr = '.') then
        break;
{}    if ResStr = ' ' then
        continue;
{}    r := r + ResStr;
{}  until (ResStr = ',') or (ResStr = '.');
{}  Result := r;
{} end;

{} //................................................
{} //................
{} function Return_1(var sStr: string): string;
{} var
    vv: Integer;
{}     code: Integer;
{}     sCheck: string[2];
{}     cc: Integer;
{} begin
{}  Val(sStr[1], vv, code);
{}  s3 := Array_E[vv];
{}  //...
{}  sCheck := Copy(sStr, 2, 2);
{}  Val(sCheck, cc, code);
{}  if cc in [11..19] then
{}   begin
{}    s2 := Array_11_19[cc - 10];
{}    Result := s3 + s2;
{}    exit;
{}   end
    else
{}   begin
{}     Val(sStr[2], vv, code);
{}     s2 := Array_10_90[vv];
{}     //...
{}     Val(sStr[3], vv, code);
{}     s1 := Array_1[vv];
{}     //...
{}   end;
{}  Result := s3 + s2 + s1;
{} end;//func 1
{} //.......
{} function Return_2(var sStr: string): string;
{} var
    vv: Integer;
{}     code: Integer;
{}     sCheck: string[2];
{}     cc: Integer;
{}     LastWord: string;
{} begin
{}  Val(sStr[1], vv, code);
{}  s3 := Array_E[vv];
{}  //...
{}  sCheck := Copy(sStr, 2, 2);
{}  Val(sCheck, cc, code);
{}  if cc in [11..19] then
{}   begin
{}    s2 := Array_11_19[cc - 10];
{}    Result := s3 + s2 + ' тысяч';
{}    exit;
{}   end
    else
{}   begin
{}     Val(sStr[2], vv, code);
{}     s2 := Array_10_90[vv];
{}     //...
{}     Val(sStr[3], vv, code);
{}     s1 := Array_1_2[vv];
{}     //...
{}   end;
{}  LastWord := ' тысяч';
{}  if vv = 4 then
      LastWord := ' тысячи';
{}  if vv = 3 then
      LastWord := ' тысячи';
{}  if vv = 2 then
      LastWord := ' тысячи';
{}  if vv = 1 then
      LastWord := ' тысяча';
{}  if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
{}  Result := s3 + s2 + s1 + LastWord;
{} end;//func 1
{}
{} function Return_3(var sStr: string): string;
{} var
    vv: Integer;
{}     code: Integer;
{}     sCheck: string[2];
{}     cc: Integer;
{}     LastWord: string;
{} begin
{}  Val(sStr[1], vv, code);
{}  s3 := Array_E[vv];
{}  //...
{}  sCheck := Copy(sStr, 2, 2);
{}  Val(sCheck, cc, code);
{}  if cc in [11..19] then
{}   begin
{}    s2 := Array_11_19[cc - 10];
{}    Result := s3 + s2 + ' миллионов';
{}    exit;
{}   end
    else
{}   begin
{}     Val(sStr[2], vv, code);
{}     s2 := Array_10_90[vv];
{}     //...
{}     Val(sStr[3], vv, code);
{}     s1 := Array_1[vv];
{}     //...
{}   end;
{}  LastWord := ' миллионов';
{}  if vv = 4 then
      LastWord := ' миллиона';
{}  if vv = 3 then
      LastWord := ' миллиона';
{}  if vv = 2 then
      LastWord := ' миллиона';
{}  if vv = 1 then
      LastWord := ' миллион';
{}  if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
{}  Result := s3 + s2 + s1 + LastWord;
{} end;//func 1
{} //.......
{} //.......
{} function Return_4(var sStr: string): string;
{} var
    vv: Integer;
{}     code: Integer;
{}     sCheck: string[2];
{}     cc: Integer;
{}     LastWord: string;
{} begin
{}  Val(sStr[1], vv, code);
{}  s3 := Array_E[vv];
{}  //...
{}  sCheck := Copy(sStr, 2, 2);
{}  Val(sCheck, cc, code);
{}  if cc in [11..19] then
{}   begin
{}    s2 := Array_11_19[cc - 10];
{}    Result := s3 + s2 + ' миллиардов';
{}    exit;
{}   end
    else
{}   begin
{}     Val(sStr[2], vv, code);
{}     s2 := Array_10_90[vv];
{}     //...
{}     Val(sStr[3], vv, code);
{}     s1 := Array_1[vv];
{}     //...
{}   end;
{}  LastWord := ' миллиардов';
{}  if vv = 4 then
      LastWord := ' миллиарда';
{}  if vv = 3 then
      LastWord := ' миллиарда';
{}  if vv = 2 then
      LastWord := ' миллиарда';
{}  if vv = 1 then
      LastWord := ' миллиард';
{}  if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
{}  Result := s3 + s2 + s1 + LastWord;
{} end;//func 1
{} //Main function body
{} //.......
var
  Txt: string;
  OneChar: string;
  s: string;
begin
  Result := 'Очень большое значение!';
  if Value > 999999999999.99 then
    exit;
  IntegerText := IntegerPart(value);
  IntegerPartLen := Length(IntegerText);
  StrAll := '000000000000';
 // Копируем строку задом наперед
  for Counter := IntegerPartLen downto 1 do
    StrAll[(12 - IntegerPartLen) + Counter] := IntegerText[Counter];
 //...
 //Разбираем число по разрадам
  st_1 := Copy(StrAll, 10, 3);
  st_2 := Copy(StrAll, 7, 3);
  st_3 := Copy(StrAll, 4, 3);
  st_4 := Copy(StrAll, 1, 3);
 //...
  txt := Return_4(st_4) + Return_3(st_3) + Return_2(st_2) + Return_1(st_1);
  if txt <> '' then
  begin
    OneChar := txt[2];
    s := AnsiUpperCase(OneChar);
    txt[2] := s[1];
  end;
  Result := txt;
end;

procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  CreateDir(PathLink);
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetPath(Pchar(PathObj));
    SetArguments(Pchar(Param));
    SetDescription(Pchar(Desc));
  end;
  PFile.Save(PWChar(Widestring(PathLink)), True);
end;

function IsProgramRun(s: string): Boolean;
var
  ProcessEntry: TProcessEntry32;
  SnapShot: Thandle;
  st: string;
begin
  Result := false;
  SnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  ProcessEntry.dwSize := SizeOf(ProcessEntry);
  if Process32First(SnapShot, ProcessEntry) then
    repeat
      st := ProcessEntry.szExeFile;
      Result := SameText(ExtractFileName(st), ExtractFileName(s));
      if Result then
        Exit;
    until not Process32Next(SnapShot, ProcessEntry);
end;

procedure SetFocusTo(root: TWinControl; s: string);
var
  sts: TStrings;
  i: Integer;
  wcn1, wcn2: TWincontrol;
begin
  sts := TNumStrList.Create;
  sts.Commatext := s;
  wcn1 := root;
  for i := 1 to sts.Count - 1 do
  begin
    wcn2 := TWinControl(wcn1.FindChildcontrol(sts[i]));
    if wcn2 = nil then
      break
    else
      wcn1 := wcn2;
  end;
  while (wcn1 <> nil) and not wcn1.CanFocus do
    wcn1 := wcn1.Parent;
  if wcn1 <> nil then
    wcn1.SetFocus;
  sts.Free;
end;

procedure ShowMessage(Text: string; Title: string);
begin
  if Title = '' then
    Title := ExtractFileName(ParamStr(0));
  Publ.MessageBox(Title, Text);
end;

//procedure SaveToFileEx(fn: string; sp: TStreamProc); overload;
//var
//  fs: tFileStream;
//  state: Longword;
//  s: string;
//begin
//  if FileExists(fn) then
//  begin
//    s := ChangeFileExt(fn, '.old');
//    DeleteFile(Pchar(s));
//    RenameFile(fn, s);
//  end;
//  fs := TFileStream.Create(fn, fmCreate);
//  State := $87654321;
//  fs.Write(State, 4);
//  sp(fs);
//  fs.Position := 0;
//  State := $12345678;
//  fs.Write(State, 4);
//  fs.Free;
//  DeleteFile(Pchar(s));
//end;
//
//procedure LoadFromFileEx(fn: string; sp: TStreamProc; ErrStr: string); overload;
//var
//  fs: tFileStream;
//  State: Longint;
//  s: string;
//begin
//  if not FileExists(fn) then
//    Exit;
//  s := ChangeFileExt(fn, '.old');
//  fs := TFileStream.Create(fn, fmOpenRead);
//  fs.Read(State, 4);
//  if State <> $12345678 then
//  begin
//    fs.Free;
//    if not FileExists(s) then
//      raise Exception.Create(
//        'Один из файлов повреждён и не может быть открыт.')
//    else
//    begin
//      if ErrStr <> '' then
//        Publ.MessageBox('Ошибка', ErrStr);
//      fs := TFileStream.Create(s, fmOpenRead);
//      fs.Position := 4;
//    end;
//  end;
//  sp(fs);
//  fs.Free;
//end;
//
function FiltKey(Text: string; SelStart: Integer; Key: Char): Char;
begin
  if Key in ['0'..'9', 'e', 'E', '-', ',', '.', #8, '*'] then
  begin
    case Key of
      '-':
        if not ((SelStart = 0) or (Text[SelStart] in ['e', 'E'])) then
          Key := #0;
      '.', ',':
      begin
        Key := DecimalSeparator;
        if (pos(Key, Text) > 0) or (SelStart = 0) then
          Key := #0;
      end;
      'e', 'E', '*':
      begin
        Key := 'E';
        if Pos(Key, Text) > 0 then
          Key := #0;
      end;
    end;
  end
  else
    Key := #0;
  result := Key;
end;

function FiltKey(Sender: TObject; Key: Char): Char;
var
  Text: string;
  SelStart: Integer;
begin
  Text := ' ';
  SelStart := 1;
  if Sender is TCustomEdit then
  begin
    Text := (Sender as TCustomEdit).Text;
    SelStart := (Sender as TCustomEdit).SelStart;
  end;
  Result := FiltKey(Text, SelStart, Key);
end;

function GetVersion(Name: string): string;
var
  VerSize, Temp: DWORD;
  VerInfo: array of Byte;
  Buffer: Pointer;
  pint: ^VS_FIXEDFILEINFO;
begin
  Result := '';
  VerSize := GetFileVersionInfoSize(Pchar(Name), Temp);
  if VerSize <> 0 then
  begin
    SetLength(VerInfo, VerSize);
    GetFileVersionInfo(Pchar(Name), 0, VerSize, @VerInfo[0]);
  end;
  if VerQueryValue(@VerInfo[0], '\', Buffer, temp) then
  begin
    pint := buffer;
    Result := Int2Str(HiWord(pint^.dwFileVersionMS)) + '.' + Int2Str(
      LoWord(pint^.dwFileVersionMS)) + '.' + Int2Str(HiWord(pint^.dwFileVersionLS)) +
      '.' + Int2Str(LoWord(pint^.dwFileVersionLS));
  end;
end;

function CompNumText(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := 0;
  if (Index1 >= 0) and (Index1 < List.Count) and (Index2 >= 0) and (Index2 < List.Count) then
    result := PublStr.CompNumText(List[Index1], List[Index2]);
end;

function CompNumStr(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := 0;
  if (Index1 >= 0) and (Index1 < List.Count) and (Index2 >= 0) and (Index2 < List.Count) then
    result := CompNumStr(List[Index1], List[Index2]);
end;

function VarToInt(v: Variant; ADefault: Integer = 0): Integer;
begin
  if v = null then
    result := ADefault
  else
    result := v;
end;

{ TExtClipboard }

procedure TExtClipboard.SetBuffer(Format: Word; var Buffer; Size: Integer);
begin
  inherited;
end;

end.
