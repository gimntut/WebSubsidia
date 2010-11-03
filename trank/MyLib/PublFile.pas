unit PublFile;


interface

uses Windows, Classes, ShlObj, Publ;

type
{ Generic filename type }
  TFileName = type String;
 //
  TStreamProc = procedure(ms: TStream) of object;
 // Виды событий поиска фалов
  TffEvent = (ffStart, ffFile, ffDir);
 // Событие поиска файлов
  TFileFindEvent = procedure(Name: string; ffEvent: TffEvent;
    var StopSearch: Boolean) of object;
 // Событие добавления файла
  TFileAddEvent = procedure(var Name: string) of object;
/////////////////// x ///////////////////
procedure SaveStrToFile(s, FileName: string);
function LoadStrFromFile(FileName: string): string;
// Создать не существующий файл, либо открыть существующий
function OpenOrCreateFile(FileName: string): TFileStream;
// Путь папки временных файлов
function GetTempPath: string;
// Поиск файлов на диске
// 1) Поиск по всем дискам
procedure FindFilesFromAll(FileMask: string; sts: TStrings; FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil; subdir: Boolean = true);
// 2) Поиск перебором
procedure FindFiles(path, FileMask: string; sts: TStrings; FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil; subdir: Boolean = true);
// 3) Поиск по уровням вложености папок
function FindF(path, FileMask: string; sts: TStrings; Level: Integer;
  FileFindEvent: TFileFindEvent = nil; FileAddEvent: TFileAddEvent = nil): Boolean;
// Начало поиска по уровням
procedure SearchFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil; FileAddEvent: TFileAddEvent = nil);
// Удаление папки с файлами
function RemoveSubDirs(Path: string; ErrStr: string = ''): Boolean;
// Создание папки Path в Application Data
function SetAppDataPath(Path: string; nFolder: Integer = CSIDL_APPDATA): string;
function GetSpecialFolderPath(CSIDL_Folder: Integer; fCreate: Boolean = false): string;
procedure RegFileExt(Ext, FileClass: string; ApplicationPath: string = ''; IconNum: Integer = 1);
// Определение размера файла
function GetFileSize(FileName: string): Integer;
// Сохранение и загрузка массива чисел в сдутом виде
procedure SaveToStreamInts(Stream: TStream; Count: Integer; GetInt: TIntFunc; Token:integer = 0);
procedure LoadFromStreamInts(Stream: TStream; SetInt: TIntProc; Token:integer = 0);

////////////////////// SysUtils //////////////////////
const
{ File attribute constants }

  faReadOnly = $00000001;// platform;
  faHidden = $00000002;// platform;
  faSysFile = $00000004;// platform;
  faVolumeID = $00000008;// platform deprecated;  // not used in Win32
  faDirectory = $00000010;//;
  faArchive = $00000020;// platform;
  faSymLink = $00000040;// platform;
  faAnyFile = $0000003F;//;

type
{ Search record used by FindFirst, FindNext, and FindClose }
  TSearchRec = record
    Time: Integer;
    Size: Int64;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
{$IFDEF MSWINDOWS}
    FindHandle: THandle platform;
    FindData: TWin32FindData platform;
{$ENDIF}
{$IFDEF LINUX}
    Mode: mode_t  platform;
    FindHandle: Pointer  platform;
    PathOnly: String  platform;
    Pattern: String  platform;
{$ENDIF}
  end;

function FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
function FindNext(var F: TSearchRec): Integer;
procedure FindClose(var F: TSearchRec);
function RemoveDir(const Dir: string): Boolean;
function DirectoryExists(const Directory: string): Boolean;
function ForceDirectories(Dir: string): Boolean;
function ExcludeTrailingPathDelimiter(const S: string): string;
function CreateDir(const Dir: string): Boolean;
function IsPathDelimiter(const S: string; Index: Integer): Boolean;
function IncludeTrailingPathDelimiter(const S: string): string;
function ExtractFileName(const FileName: string): string;
function ExtractFileExt(const FileName: string): string;
function ChangeFileExt(const FileName, Extension: string): string;
function FileOpen(const FileName: string; Mode: Longword): Integer;
function FileGetDate(Handle: Integer): Integer;
procedure FileClose(Handle: Integer);
function FileDateToDateTime(FileDate: Integer): TDateTime;
function FileSetDate(const FileName: string; Age: Integer): Integer; overload;
function FileSetDate(Handle: Integer; Age: Integer): Integer; overload; //platform;
function DateTimeToFileDate(DateTime: TDateTime): Integer;
function FileExists(const FileName: string): Boolean;
function RenameFile(const OldName, NewName: string): Boolean; inline;
function GetFileVersion(const FileName:string):string;

////////////////////// -------- //////////////////////

var
  ProgramPath: string;
  TempPath: string;
  AppDataPath: string = '';

implementation

uses PublConst, PublExcept, PublStr, PublTime, Registry, StrUtils, SysConst;

function DoFindEvent(FFE: TFileFindEvent; Name: string; ffEvent: TffEvent): Boolean;
begin
  result := false;
  if Assigned(FFE) then
    FFE(Name, ffEvent, result);
end;

function AddEvent(FAE: TFileAddEvent; Name: string): string;
begin
  Result := Name;
  if Assigned(FAE) then
    FAE(Result);
end;

procedure FindFilesFromAll(FileMask: string; sts: TStrings; FileFindEvent: TFileFindEvent;
  FileAddEvent: TFileAddEvent; subdir: Boolean);
var
  DriveNum: Integer;
  DriveBits: set of 0..25;
  s: string;
begin
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do
  begin
    if not (DriveNum in DriveBits) then
      Continue;
    s := Char(DriveNum + Ord('a')) + ':\';
    if GetDriveType(Pchar(s)) <> DRIVE_FIXED then
      Continue;
    FindFiles(s, FileMask, sts, FileFindEvent, FileAddEvent);
  end;
end;

procedure FindFiles(path, FileMask: string; sts: TStrings; FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil; subdir: Boolean = true);
var
  fs: TSearchRec;
  r: Integer;
  s: string;
  us: Boolean;
begin
  if DoFindEvent(FileFindEvent, Path, ffDir) then
    Exit;
  if RightStr(path, 1) <> '\' then
    path := path + '\';
  r := FindFirst(path + FileMask, faAnyFile - faDirectory, fs);
  while r = 0 do
  begin
    s := path + fs.Name;
    if sts <> nil then
      sts.Add(AddEvent(FileAddEvent, s));
    if DoFindEvent(FileFindEvent, s, ffFile) then
      Exit;
    r := FindNext(fs);
  end;
  if not subdir then
    Exit;
  r := FindFirst(Path + '*.*', faDirectory, fs);
  while r = 0 do
  begin
    s := fs.Name;
    us := fs.Attr and faDirectory = 0;
    r := FindNext(fs);
    if us then
      Continue;
    if s[1] = '.' then
      Continue;
    FindFiles(Path + s + '\', FileMask, sts, FileFindEvent, FileAddEvent);
  end;
end;

function FindF(path, FileMask: string; sts: TStrings; Level: Integer;
  FileFindEvent: TFileFindEvent = nil; FileAddEvent: TFileAddEvent = nil): Boolean;
var
  fs: TSearchRec;
  r: Integer;
  s: string;
  us: Boolean;
begin
  result := false;
  if Level = 0 then
  begin
    if DoFindEvent(FileFindEvent, Path, ffDir) then
      Exit;
    r := FindFirst(path + FileMask, faAnyFile - faDirectory, fs);
    while r = 0 do
    begin
      s := Path + fs.Name;
      if sts <> nil then
        sts.Add(AddEvent(FileAddEvent, s));
      if DoFindEvent(FileFindEvent, s, ffFile) then
        Exit;
      r := FindNext(fs);
    end;
    result := true;
    Exit;
  end;
  r := FindFirst(Path + '*.*', faDirectory, fs);
  while r = 0 do
  begin
    s := fs.Name;
    us := fs.Attr and faDirectory = 0;
    r := FindNext(fs);
    if us then
      Continue;
    if s[1] = '.' then
      Continue;
    result := FindF(Path + s + '\', FileMask, sts, Level - 1, FileFindEvent, FileAddEvent);
  end;
end;

procedure SearchFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil; FileAddEvent: TFileAddEvent = nil);
var
  Level: Integer;
begin
  Level := 0;
  while FindF(path, FileMask, sts, Level, FileFindEvent, FileAddEvent) do
    inc(Level);
end;

function RemoveSubDirs(Path: string; ErrStr: string = ''): Boolean;
var
  sts: TStringList;
  i: Integer;
begin
  sts := TStringList.Create;
  FindFiles(Path, '*.*', sts);
  Result := true;
  for i := 0 to sts.Count - 1 do
    Result := Result and DeleteFile(PAnsiChar(sts[i]));
  sts.Free;
  if not Result then
  begin
    if ErrStr <> '' then
      MessageBox('Ошибка! Error!', '(X)' + CRLF + ErrStr);
    Exit;
  end;
  try
    RemoveDir(Path);
  except
    on Exception do ;
  end;
end;

function GetTempPath: string;
var
  FTemp: array[0..MAX_PATH] of Char;
begin
  Windows.GetTempPath(MAX_PATH, FTemp);
  result := FTemp;
end;

procedure AppendStrToFile(s, FileName: string);
var
  TF: TextFile;
begin
  AssignFile(TF, FileName);
  if not FileExists(FileName) then
    Rewrite(TF)
  else
    Append(TF);
  Writeln(TF, s);
  CloseFile(TF);
end;

procedure SaveStrToFile(S, FileName: string);
var
  tx:TextFile;
begin
  //if not FileExists(FileName) then Exit;
  AssignFile(tx,FileName);
  {$R-}
  Rewrite(tx);
  Write(tx,S);
  CloseFile(tx);
  {$R+}
end;

function LoadStrFromFile(FileName: string): string;
var
  sts: TStringList;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;
  sts := TStringList.Create;
  sts.LoadFromFile(FileName);
  result := sts.Text;
  sts.Free;
end;

function OpenOrCreateFile(FileName: string): TFileStream;
var
  fm: Word;
begin
  if FileExists(FileName) then
    fm := fmOpenReadWrite
  else
    fm := fmCreate;
  Result := TFileStream.Create(FileName, fm);
end;

function GetSpecialFolderPath(CSIDL_Folder: Integer; fCreate: Boolean): string;
var
  pCh: Pchar;
  s: string;
begin
  GetMem(pCh, MAX_PATH);
  SHGetSpecialFolderPath(0, pCh, CSIDL_Folder, fCreate);
  s := pCh;
  FreeMemory(pCh);
  Result := s + '\';
end;

function SetAppDataPath(Path: string; nFolder: Integer = CSIDL_APPDATA): string;
var
  s: string;
begin
  if Path[Length(Path)] = '\' then
    SetLength(Path, Length(Path) - 1);
  s := GetSpecialFolderPath(nFolder) + Path;
  if not DirectoryExists(s) then
    ForceDirectories(s);
  Result := s + '\';
  AppDataPath := Result;
end;

procedure RegFileExt(Ext, FileClass: string; ApplicationPath: string; IconNum: Integer);
var
  reg: TRegistry;
begin
  if ApplicationPath = '' then
    ApplicationPath := ParamStr(0);
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  reg.OpenKey('\.' + ext, true);
  reg.WriteString('', FileClass);
  reg.OpenKey('\' + FileClass, true);
  reg.WriteString('', FileClass);
  reg.OpenKey('Shell\open\command', true);
  reg.WriteString('', ApplicationPath + ' "%1"');
  reg.OpenKey('\' + FileClass + '\DefaultIcon', true);
  reg.WriteString('', format('%s,%d', [ApplicationPath, IconNum]));
  reg.Free;
end;

function GetFileSize(FileName: string): Integer;
begin
  With TFileStream.Create(FileName,fmShareDenyNone) do begin
    Result:=Size;
    Free;
  end;
end;

procedure SaveToStreamInts(Stream: TStream; Count: Integer; GetInt: TIntFunc; Token:integer);
var
  I, L, X, CI, N, PB, PE: Integer;
  Ints: array of Integer;
begin
  L := 0;
  N := 0;
  Stream.Write(Count, 4);
  PB := Stream.Position;
  Stream.Write(L, 4);
  SetLength(Ints, Count);
  for I := 0 to Count - 1 do
  begin
    X := GetInt(I);
    if not WriteBinCompressInt(Stream, X) then
    begin
      L := L + 2;
      Ints[N] := X;
      inc(N);
    end
    else
    begin
      CI := CompressInt(X);
      L := L + CompressSize(CI);
      Assert(X=DeCompressInt(CI),format('%d - %d',[X,CI]));
    end;
  end;
  for I := 0 to N - 1 do
    Stream.Write(Ints[I], 4);
  PE := Stream.Position;
  Stream.Position := PB;
  Stream.Write(L, 4);
  Stream.Position := PE;
end;

procedure LoadFromStreamInts(Stream: TStream; SetInt: TIntProc; Token:integer);
var
  I, L, X, N, P, PB, PE, Count: Integer;
  A:array of Integer; 
begin
  Count := ReadBinInt(Stream);
  SetLength(A,Count);
  L := ReadBinInt(Stream);
  P := Stream.Position + L;
  N := 0;
  for i := 0 to Count - 1 do
  begin
    X := ReadBinCompressInt(Stream);
    if X = ImpossibleInt then
    begin
      PB := Stream.Position;
      PE := P + 4 * N;
      Stream.Position := PE;
      X := ReadBinInt(Stream);
      Stream.Position := PB;
      inc(N);
    end;
    SetInt(I, X);
  end;
  PE := P + 4 * N;
  Stream.Position := PE;
end;

function FindMatchingFile(var F: TSearchRec): Integer;
{$IFDEF MSWINDOWS}
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
      LongRec(Time).Lo);
    Size := FindData.nFileSizeLow or Int64(FindData.nFileSizeHigh) shl 32;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

{$ENDIF}
{$IFDEF LINUX}
var
  PtrDirEnt: PDirEnt;
  Scratch: TDirEnt;
  StatBuf: TStatBuf;
  LinkStatBuf: TStatBuf;
  FName: string;
  Attr: Integer;
  Mode: mode_t;
begin
  Result := -1;
  PtrDirEnt := nil;
  if readdir_r(F.FindHandle, @Scratch, PtrDirEnt) <> 0 then
    Exit;
  while PtrDirEnt <> nil do
  begin
    if fnmatch(PChar(F.Pattern), PtrDirEnt.d_name, 0) = 0 then
    begin   // F.PathOnly must include trailing backslash
      FName := F.PathOnly + string(PtrDirEnt.d_name);

      if lstat(PChar(FName), StatBuf) = 0 then
      begin
        Attr := 0;
        Mode := StatBuf.st_mode;

        if S_ISDIR(Mode) then
          Attr := Attr or faDirectory
        else
        if not S_ISREG(Mode) then  // directories shouldn't be treated as system files
        begin
          if S_ISLNK(Mode) then
          begin
            Attr := Attr or faSymLink;
            if (stat(PChar(FName), LinkStatBuf) = 0) and
              S_ISDIR(LinkStatBuf.st_mode) then
                Attr := Attr or faDirectory
          end;
          Attr := Attr or faSysFile;
        end;

        if (PtrDirEnt.d_name[0] = '.') and (PtrDirEnt.d_name[1] <> #0) then
        begin
          if not ((PtrDirEnt.d_name[1] = '.') and (PtrDirEnt.d_name[2] = #0)) then
            Attr := Attr or faHidden;
        end;

        if euidaccess(PChar(FName), W_OK) <> 0 then
          Attr := Attr or faReadOnly;

        if Attr and F.ExcludeAttr = 0 then
        begin
          F.Size := StatBuf.st_size;
          F.Attr := Attr;
          F.Mode := StatBuf.st_mode;
          F.Name := PtrDirEnt.d_name;
          F.Time := StatBuf.st_mtime;
          Result := 0;
          Break;
        end;
      end;
    end;
    Result := -1;
    if readdir_r(F.FindHandle, @Scratch, PtrDirEnt) <> 0 then
      Break;
  end // End of While
end;
{$ENDIF}

function FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faDirectory;
{$IFDEF MSWINDOWS}
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFile(Pchar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then
      FindClose(F);
  end
  else
    Result := GetLastError;
end;

{$ENDIF}
{$IFDEF LINUX}
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.PathOnly := ExtractFilePath(Path);
  F.Pattern := ExtractFileName(Path);
  if F.PathOnly = '' then
    F.PathOnly := IncludeTrailingPathDelimiter(GetCurrentDir);

  F.FindHandle := opendir(PChar(F.PathOnly));
  if F.FindHandle <> nil then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then
      FindClose(F);
  end
  else
    Result:= GetLastError;
end;
{$ENDIF}

function FindNext(var F: TSearchRec): Integer;
begin
{$IFDEF MSWINDOWS}
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F)
  else
    Result := GetLastError;
{$ENDIF}
{$IFDEF LINUX}
  Result := FindMatchingFile(F);
{$ENDIF}
end;

procedure FindClose(var F: TSearchRec);
begin
{$IFDEF MSWINDOWS}
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
{$ENDIF}
{$IFDEF LINUX}
  if F.FindHandle <> nil then
  begin
    closedir(F.FindHandle);
    F.FindHandle := nil;
  end;
{$ENDIF}
end;

function RemoveDir(const Dir: string): Boolean;
begin
{$IFDEF MSWINDOWS}
  Result := RemoveDirectory(Pchar(Dir));
{$ENDIF}
{$IFDEF LINUX}
  Result := __rmdir(PChar(Dir)) = 0;
{$ENDIF}
end;

function DirectoryExists(const Directory: string): Boolean;
{$IFDEF LINUX}
var
  st: TStatBuf;
begin
  if stat(PChar(Directory), st) = 0 then
    Result := S_ISDIR(st.st_mode)
  else
    Result := False;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  Code: Integer;
begin
  Code := GetFileAttributes(Pchar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

{$ENDIF}

function ForceDirectories(Dir: string): Boolean;
var
  E: EInOutError;
begin
  Result := True;
  if Dir = '' then
  begin
    E := EInOutError.CreateRes(@SCannotCreateDir);
    E.ErrorCode := 3;
    raise E;
  end;
  Dir := ExcludeTrailingPathDelimiter(Dir);
{$IFDEF MSWINDOWS}
  if (Length(Dir) < 3) or DirectoryExists(Dir) or (ExtractFilePath(Dir) = Dir) then
    Exit; // avoid 'xyz:\' problem.
{$ENDIF}
{$IFDEF LINUX}
  if (Dir = '') or DirectoryExists(Dir) then Exit;
{$ENDIF}
  Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
end;

function ExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if IsPathDelimiter(Result, Length(Result)) then
    SetLength(Result, Length(Result) - 1);
end;

function CreateDir(const Dir: string): Boolean;
begin
{$IFDEF MSWINDOWS}
  Result := CreateDirectory(Pchar(Dir), nil);
{$ENDIF}
{$IFDEF LINUX}
  Result := __mkdir(PChar(Dir), mode_t(-1)) = 0;
{$ENDIF}
end;

function IsPathDelimiter(const S: string; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = PathDelim) and
    (ByteType(S, Index) = mbSingleByte);
end;

function IncludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;

function ExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function ExtractFileExt(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt)
  else
    Result := '';
end;

function ChangeFileExt(const FileName, Extension: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim, Filename);
  if (I = 0) or (FileName[I] <> '.') then
    I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;

function FileOpen(const FileName: string; Mode: Longword): Integer;
{$IFDEF MSWINDOWS}
const
  AccessMode: array[0..2] of Longword = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of Longword = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := -1;
  if ((Mode and 3) <= fmOpenReadWrite) and ((Mode and $F0) <= fmShareDenyNone) then
    Result := Integer(CreateFile(Pchar(FileName), AccessMode[Mode and 3],
      ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0));
end;

{$ENDIF}
{$IFDEF LINUX}
const
  ShareMode: array[0..fmShareDenyNone shr 4] of Byte = (
    0,        //No share mode specified
    F_WRLCK,  //fmShareExclusive
    F_RDLCK,  //fmShareDenyWrite
    0);       //fmShareDenyNone
var
  FileHandle, Tvar: Integer;
  LockVar: TFlock;
  smode: Byte;
begin
  Result := -1;
  if FileExists(FileName) and
     ((Mode and 3) <= fmOpenReadWrite) and
     ((Mode and $F0) <= fmShareDenyNone) then
  begin
    FileHandle := open(PChar(FileName), (Mode and 3), FileAccessRights);

    if FileHandle = -1 then  Exit;

    smode := Mode and $F0 shr 4;
    if ShareMode[smode] <> 0 then
    begin
      with LockVar do
      begin
        l_whence := SEEK_SET;
        l_start := 0;
        l_len := 0;
        l_type := ShareMode[smode];
      end;
      Tvar :=  fcntl(FileHandle, F_SETLK, LockVar);
      if Tvar = -1 then
      begin
        __close(FileHandle);
        Exit;
      end;
    end;
    Result := FileHandle;
  end;
end;
{$ENDIF}

function FileGetDate(Handle: Integer): Integer;
{$IFDEF MSWINDOWS}
var
  FileTime, LocalFileTime: TFileTime;
begin
  if GetFileTime(THandle(Handle), nil, nil, @FileTime) and
    FileTimeToLocalFileTime(FileTime, LocalFileTime) and
    FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi, LongRec(Result).Lo) then
    Exit;
  Result := -1;
end;

{$ENDIF}
{$IFDEF LINUX}
var
  st: TStatBuf;
begin
  if fstat(Handle, st) = 0 then
    Result := st.st_mtime
  else
    Result := -1;
end;
{$ENDIF}

procedure FileClose(Handle: Integer);
begin
{$IFDEF MSWINDOWS}
  CloseHandle(THandle(Handle));
{$ENDIF}
{$IFDEF LINUX}
  __close(Handle); // No need to unlock since all locks are released on close.
{$ENDIF}
end;

function FileDateToDateTime(FileDate: Integer): TDateTime;
{$IFDEF MSWINDOWS}
begin
  Result :=
    EncodeDate(LongRec(FileDate).Hi shr 9 + 1980, LongRec(FileDate).Hi shr
    5 and 15, LongRec(FileDate).Hi and 31) + EncodeTime(
    LongRec(FileDate).Lo shr 11, LongRec(FileDate).Lo shr 5 and 63,
    LongRec(FileDate).Lo and 31 shl 1, 0);
end;

{$ENDIF}
{$IFDEF LINUX}
var
  UT: TUnixTime;
begin
  localtime_r(@FileDate, UT);
  Result := EncodeDate(UT.tm_year + 1900, UT.tm_mon + 1, UT.tm_mday) +
              EncodeTime(UT.tm_hour, UT.tm_min, UT.tm_sec, 0);
end;
{$ENDIF}

function FileSetDate(const FileName: string; Age: Integer): Integer;
{$IFDEF MSWINDOWS}
var
  f: THandle;
begin
  f := FileOpen(FileName, fmOpenWrite);
  if f = THandle(-1) then
    Result := GetLastError
  else
  begin
    Result := FileSetDate(f, Age);
    FileClose(f);
  end;
end;

{$ENDIF}
{$IFDEF LINUX}
var
  ut: TUTimeBuffer;
begin
  Result := 0;
  ut.actime := Age;
  ut.modtime := Age;
  if utime(PChar(FileName), @ut) = -1 then
    Result := GetLastError;
end;
{$ENDIF}

function FileSetDate(Handle: Integer; Age: Integer): Integer;
var
  LocalFileTime, FileTime: TFileTime;
begin
  Result := 0;
  if DosDateTimeToFileTime(LongRec(Age).Hi, LongRec(Age).Lo, LocalFileTime) and
    LocalFileTimeToFileTime(LocalFileTime, FileTime) and SetFileTime(Handle,
    nil, nil, @FileTime) then
    Exit;
  Result := GetLastError;
end;

function DateTimeToFileDate(DateTime: TDateTime): Integer;
{$IFDEF MSWINDOWS}
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(DateTime, Year, Month, Day);
  if (Year < 1980) or (Year > 2107) then
    Result := 0
  else
  begin
    DecodeTime(DateTime, Hour, Min, Sec, MSec);
    LongRec(Result).Lo := (Sec shr 1) or (Min shl 5) or (Hour shl 11);
    LongRec(Result).Hi := Day or (Month shl 5) or ((Year - 1980) shl 9);
  end;
end;

{$ENDIF}
{$IFDEF LINUX}
var
  tm: TUnixTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(DateTime, Year, Month, Day);
  { Valid range for 32 bit Unix time_t:  1970 through 2038  }
  if (Year < 1970) or (Year > 2038) then
    Result := 0
  else
  begin
    DecodeTime(DateTime, Hour, Min, Sec, MSec);
    FillChar(tm, sizeof(tm), 0);
    with tm do
    begin
      tm_sec := Sec;
      tm_min := Min;
      tm_hour := Hour;
      tm_mday := Day;
      tm_mon  := Month - 1;
      tm_year := Year - 1900;
      tm_isdst := -1;
    end;
    Result := mktime(tm);
  end;
end;
{$ENDIF}

function FileExists(const FileName: string): Boolean;
{$IFDEF MSWINDOWS}
var
  PreCode: DWORD;
  Code: Integer;
begin
  PreCode := GetFileAttributes(Pchar(FileName));
  Code := Integer(PreCode);
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code = 0);
end;

{$ENDIF}
{$IFDEF LINUX}
begin
  Result := euidaccess(PChar(FileName), F_OK) = 0;
end;
{$ENDIF}

function RenameFile(const OldName, NewName: string): Boolean;
begin
{$IFDEF MSWINDOWS}
  Result := MoveFile(Pchar(OldName), Pchar(NewName));
{$ENDIF}
{$IFDEF LINUX}
  Result := __rename(PChar(OldName), PChar(NewName)) = 0;
{$ENDIF}
end;

function GetFileVersion(const FileName:string):string;
var
 DataSize:LongWord;
 pVerInfo,pData: Pointer;
 Translation:string;
begin
 Result := '';
 DataSize := 0;
 DataSize := GetFileVersionInfoSize(PChar(FileName),DataSize);
 if DataSize = 0 then
   Exit;
 GetMem(pVerInfo, DataSize);
 try
   if GetFileVersionInfo(Pchar(FileName),0,DataSize,pVerInfo) then
   begin
     if VerQueryValue(pVerInfo, '\VarFileInfo\Translation', pData, DataSize) and (DataSize=SizeOf(LongWord)) then
       Translation:=IntToHex(MakeLong(HiWord(PLongWord(pData)^), LoWord(PLongWord(pData)^)), 8)
     else
       Exit;
     if VerQueryValue(pVerInfo,PChar('\StringFileInfo\'+Translation+'\FileVersion'),pData,DataSize) then
       SetString(result,PChar(pData),DataSize-1);
   end;
 finally
   FreeMem(pVerInfo);
 end;
end;

initialization
  ProgramPath := ExtractFilePath(ParamStr(0));
  TempPath:=GetEnvironmentVariable('TEMP')+'\';
  Randomize;
end.
