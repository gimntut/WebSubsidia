unit DM;

interface

uses
  SysUtils, Classes, Dialogs, XPMan, ImgList, Controls, ActnList, AppEvnts,
  Menus, ExtCtrls;

type
  TOnOpenFile = procedure (FileName:string) of object;

  TQFSOptions = class
  private
    FIniFileName: string;
    FFontSize: Integer;
    FWebProtocol: string;
    FWebSite: string;
    FExtFileList: string;
    FFavoritePath: string;
    FSpravkiSts: TStringList;
    procedure SetIniFileName(const Value: string);
    procedure SetFontSize(const Value: Integer);
    procedure SetWebProtocol(const Value: string);
    procedure SetExtFileList(const Value: string);
    procedure SetWebSite(const Value: string);
    procedure SetFavoritePath(const Value: string);
    function GetSpravkiSts: TStringList;
  published
  public
    constructor Create(AIniFileName:string);
    procedure Load;
    procedure Save;
    property IniFileName:string read FIniFileName write SetIniFileName;
    property FontSize:Integer read FFontSize write SetFontSize;
    property WebProtocol:string read FWebProtocol write SetWebProtocol;
    property WebSite:string read FWebSite write SetWebSite;
    property ExtFileList:string read FExtFileList write SetExtFileList;
    property FavoritePath:string read FFavoritePath write SetFavoritePath;
    property SpravkiSts: TStringList read GetSpravkiSts;
  end;

  TDataModule3 = class(TDataModule)
    Timer1: TTimer;
    OpenFileMenu: TPopupMenu;
    N5: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    TopListMenu: TPopupMenu;
    N4: TMenuItem;
    SpravkiMenu: TPopupMenu;
    MenuItem2: TMenuItem;
    DetailListMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    acCopyParamValue1: TMenuItem;
    N12: TMenuItem;
    N6: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    SortMenu: TPopupMenu;
    TextParamsMenu: TPopupMenu;
    mnTransformed: TMenuItem;
    mnOriginalText: TMenuItem;
    N13: TMenuItem;
    N8: TMenuItem;
    mnOEM: TMenuItem;
    mnANSI: TMenuItem;
    N11: TMenuItem;
    mnComma: TMenuItem;
    mnPointComma: TMenuItem;
    mnTab: TMenuItem;
    mnNull: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    PrintDialog1: TPrintDialog;
    ActionList1: TActionList;
    acCopy: TAction;
    acCopyValue: TAction;
    acCopyParamValue: TAction;
    acCopyTable: TAction;
    ImageList1: TImageList;
    XPManifest1: TXPManifest;
    OpenDialog1: TOpenDialog;
    acOpen: TAction;
    acSpravka: TAction;
    procedure DataModuleDestroy(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure acSpravkaExecute(Sender: TObject);
  private
    FIntFavorFiles: TStringList;
    FFavoriteFiles: TStringList;
    FavoritePath:string;
    FCaptionName: string;
    FDetail: string;
    FOnOpenFile: TOnOpenFile;
    FSpravkiSts: TStringList;
    function GetIntFavorFiles: TStringList;
    function GetFavoriteFiles: TStringList;
    procedure SetCaptionName(const Value: string);
    procedure SetDetail(const Value: string);
    procedure SetOnOpenFile(const Value: TOnOpenFile);
    function GetSpravkiSts: TStringList;
    procedure SetFileName(const Value: string);
    function GetIniFileName: string;
  public
    procedure FavorClick(Sender: TObject);
    procedure LoadExternalList(FileName: string);
    procedure ShowFavorite;
    property IntFavorFiles: TStringList read GetIntFavorFiles;
    property FavoriteFiles: TStringList read GetFavoriteFiles;
    property SpravkiSts: TStringList read GetSpravkiSts;
    property CaptionName: string read FCaptionName write SetCaptionName;
    property Detail: string read FDetail write SetDetail;
    property OnOpenFile:TOnOpenFile read FOnOpenFile write SetOnOpenFile;
    property IniFileName:string read GetIniFileName write SetFileName;
    procedure LoadIni;
  end;

function Options:TQFSOptions;

var
  DataModule3: TDataModule3;

implementation

uses QFLoadList, QFTemplate, ShellAPI, Windows, IniFiles, StrUtils, PublFile;

{$R *.dfm}
var
  FQFSOptions:TQFSOptions;
function Options:TQFSOptions;
begin
  if FQFSOptions=nil then FQFSOptions:=TQFSOptions.Create('');
  Result:=FQFSOptions;
end;

procedure TDataModule3.acOpenExecute(Sender: TObject);
begin
  CaptionName:='';
  if OpenDialog1.Execute and assigned(FOnOpenFile) then
    FOnOpenFile(OpenDialog1.FileName);
end;

procedure TDataModule3.LoadExternalList(FileName:string);
var
  sts:TStringList;
begin
  if not FileExists(FileName) then Exit;
  sts:=TStringList.Create;
  sts.LoadFromFile(FileName);
  FavoriteFiles.AddStrings(sts);
  sts.Free;
end;

procedure TDataModule3.acSpravkaExecute(Sender: TObject);
var
  it: TComponent;
  s:string;
//  OldSpt:Integer;
  tg:Integer;
  FSpravkaPath: string;
begin
  it:=TComponent(Sender);
  Tg:=it.Tag;
  FSpravkaPath:=SpravkiSts.ValueFromIndex[it.tag];
  if RightStr(FSpravkaPath,1)<>'\' then FSpravkaPath:=FSpravkaPath+'\';
  s:=SpravkiSts.Names[tg];
//  OldSpt:=SpravkaType;
//  if SameText(s,'ЕДК') then SpravkaType:=sptEDK;
//  if SameText(s,'Детские пособия') then SpravkaType:=sptChild;
//  if SameText(Copy(s,1,7),'Выплаты') then SpravkaType:=sptF5;
//  PagePanel.ActivePageIndex:=0;
//  if OldSpt<>SpravkaType then LastSearh:='';
//  lstMaster.Clear;
end;

procedure TDataModule3.DataModuleDestroy(Sender: TObject);
begin
  FIntFavorFiles.Free;
  FavoriteFiles.Free;
  SpravkiSts.Free;
end;

function TDataModule3.GetFavoriteFiles: TStringList;
begin
  if FFavoriteFiles=nil then FFavoriteFiles:=TStringList.Create;
  Result:=FFavoriteFiles;
end;

function TDataModule3.GetIniFileName: string;
begin
  Result:=Options.IniFileName;
end;

function TDataModule3.GetIntFavorFiles: TStringList;
begin
  if FIntFavorFiles=nil then FIntFavorFiles:=TStringList.Create;
  Result:=FIntFavorFiles;
end;

function TDataModule3.GetSpravkiSts: TStringList;
begin
  if FSpravkiSts=nil then FSpravkiSts:=TStringList.Create;
  Result:=FSpravkiSts;
end;

procedure TDataModule3.N10Click(Sender: TObject);
var
  s:string;
begin
  s:=ExtractFileName(ExtractFileDir(OpenDialog1.FileName));
  if s='' then Exit;
  if not InputQuery('Важная папка','Введите псевдоним папки',s) then Exit;
  IntFavorFiles.Add(S+'|*'+ExtractFileDir(OpenDialog1.FileName));
  IntFavorFiles.Sort;
  IntFavorFiles.SaveToFile(FavoritePath);
  FavoriteFiles.Clear;
  FavoriteFiles.AddStrings(IntFavorFiles);
  ShowFavorite;
end;

procedure TDataModule3.N14Click(Sender: TObject);
begin
  ShellExecute(0,'open',PChar(Detail),'','',SW_NORMAL);
end;

procedure TDataModule3.N15Click(Sender: TObject);
begin
  ShellExecute(0,'open','explorer.exe',PChar('/select,"'+Detail+'"'),'',SW_NORMAL);
//  Caption:='/select,"'+Detail+'"';
end;

procedure TDataModule3.N1Click(Sender: TObject);
var
  s:string;
begin
  s:=ExtractFileName(OpenDialog1.FileName);
  if s='' then Exit;
  if not InputQuery('Важный файл','Введите название для списка',s) then Exit;
  IntFavorFiles.Add(S+'|'+OpenDialog1.FileName);
  IntFavorFiles.Sort;
  IntFavorFiles.SaveToFile(FavoritePath);
  ShowFavorite;
end;

procedure TDataModule3.LoadIni;
var
//  Ini:TIniFile;
  I: Integer;
  it:TMenuItem;
begin
  if FileExists(FavoritePath)
  then begin
    IntFavorFiles.LoadFromFile(FavoritePath);
    FavoriteFiles.Assign(IntFavorFiles);
  end;
  Options.Load;
  DataModule3.SpravkiMenu.Items.Clear;
  for I := 0 to SpravkiSts.Count - 1 do begin
    it:=TMenuItem.Create(DataModule3.SpravkiMenu);
    it.Tag:=I;
    it.OnClick:=acSpravkaExecute;
    it.Caption:='&'+IntToStr(I+1)+' '+SpravkiSts.Names[I];
    DataModule3.SpravkiMenu.Items.add(it);
  end;
  LoadExternalList(Options.ExtFileList);
end;

procedure TDataModule3.ShowFavorite;
var
  I: Integer;
  it: TMenuItem;
  S: string;
  IsDir:boolean;
  LS: string;
begin
  LoadIni;
  for I := OpenFileMenu.Items.count - 1 downto 5 do
    OpenFileMenu.Items[I].Free;
  for I := 0 to FavoriteFiles.Count - 1 do
  begin
    LS:=GetLongHint(FavoriteFiles[I]);
    IsDir:=LS[1]='*';
    if IsDir then Continue;
    if not FileExists(GetLongHint(FavoriteFiles[I])) then Continue;
    it := TMenuItem.Create(OpenFileMenu);
    S:=GetShortHint(FavoriteFiles[I]);
    it.Caption := S;
    it.Tag := I;
    it.OnClick:=FavorClick;
    OpenFileMenu.Items.Add(it);
  end;
  it := TMenuItem.Create(OpenFileMenu);
  it.Caption := '-';
  OpenFileMenu.Items.Add(it);
  for I := 0 to FavoriteFiles.Count - 1 do
  begin
    LS:=GetLongHint(FavoriteFiles[I]);
    IsDir:=LS[1]='*';
    if not IsDir then Continue;
    System.Delete(LS,1,1);
    if not SysUtils.DirectoryExists(LS) then Continue;
    it := TMenuItem.Create(OpenFileMenu);
    S:=GetShortHint(FavoriteFiles[I]);
    S:='['+S+']';
    it.Caption := S;
    it.Tag := I;
    it.OnClick:=FavorClick;
    OpenFileMenu.Items.Add(it);
  end;
end;


procedure TDataModule3.FavorClick(Sender: TObject);
var
  Ind:Integer;
  S: string;
begin
  Ind:=TMenuItem(Sender).Tag;
  S:=GetLongHint(FavoriteFiles[Ind]);
  if S[1]='*' then begin
    System.Delete(S,1,1);
    OpenDialog1.FileName:='';
    OpenDialog1.InitialDir:=S;
    acOpen.Execute;
  end else begin
    CaptionName:=GetShortHint(FavoriteFiles[Ind]);
    OnOpenFile(S);
  end;
end;

procedure TDataModule3.N3Click(Sender: TObject);
var
  I: Integer;
begin
  Form10.List:=IntFavorFiles;
  if Form10.Execute then begin
    IntFavorFiles.Clear;
    for I := 0 to Form10.List.Count - 1 do
      if not Form10.Checked[I] then
        IntFavorFiles.Add(Form10.List[I]);
    IntFavorFiles.SaveToFile(FavoritePath);
    ShowFavorite;
  end;
end;

procedure TDataModule3.N5Click(Sender: TObject);
begin
  acOpen.Execute;
end;

procedure TDataModule3.N9Click(Sender: TObject);
begin
  if QFTemlateDlg.Execute then begin

  end;
end;

procedure TDataModule3.SetCaptionName(const Value: string);
begin
  FCaptionName := Value;
end;

procedure TDataModule3.SetDetail(const Value: string);
begin
  FDetail := Value;
end;

procedure TDataModule3.SetFileName(const Value: string);
begin
  Options.IniFileName := Value;
end;

procedure TDataModule3.SetOnOpenFile(const Value: TOnOpenFile);
begin
  FOnOpenFile := Value;
end;

{ TQFSOptions }

constructor TQFSOptions.Create(AIniFileName: string);
begin
  IniFileName:=AIniFileName;
end;

function TQFSOptions.GetSpravkiSts: TStringList;
begin
  if FSpravkiSts=nil then FSpravkiSts:=TStringList.Create;
  Result:=FSpravkiSts;
end;

procedure TQFSOptions.Load;
var
  Ini: TIniFile;
begin
  if not FileExists(FIniFileName) then Exit;
  Ini:=TIniFile.Create(IniFileName);
  Ini.ReadSectionValues('Spravki',SpravkiSts);
  FontSize:=Ini.ReadInteger('Customize','FontSize',10);
  WebProtocol:=Ini.ReadString('WebServer','Protocol','http');
  WebSite:=Ini.ReadString('WebServer','Address','server');
  ExtFileList:=Ini.ReadString('External','FileList','');
  FavoritePath:=Ini.ReadString('Local','FileList',ProgramPath+'\favorites.txt');
  Ini.Free;
end;

procedure TQFSOptions.Save;
var
  Ini: TIniFile;
begin
  Ini:=TIniFile.Create(IniFileName);
  Ini.WriteInteger('Customize','FontSize',FFontSize);
  Ini.Free;
end;

procedure TQFSOptions.SetExtFileList(const Value: string);
begin
  FExtFileList := Value;
end;

procedure TQFSOptions.SetFavoritePath(const Value: string);
begin
  FFavoritePath := Value;
end;

procedure TQFSOptions.SetFontSize(const Value: Integer);
begin
  FFontSize := Value;
end;

procedure TQFSOptions.SetIniFileName(const Value: string);
begin
  FIniFileName := Value;
  Load;
end;

procedure TQFSOptions.SetWebProtocol(const Value: string);
begin
  FWebProtocol := Value;
end;

procedure TQFSOptions.SetWebSite(const Value: string);
begin
  FWebSite := Value;
end;

end.
