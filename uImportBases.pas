unit uImportBases;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, XPMan, StdCtrls, AppEvnts, uSprConst;

type
  TImportDlg = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    TabControl1: TTabControl;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    XPManifest1: TXPManifest;
    GroupBox2: TGroupBox;
    Memo2: TMemo;
    Edit2: TEdit;
    Button2: TButton;
    Panel2: TPanel;
    ExchangeBtn: TButton;
    ApplicationEvents1: TApplicationEvents;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ExchangeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    dir: string;
    Src: TStringList;
    Trg: TStringList;
    function GetMode: Integer;
    function GetModeStr: string;
    function GetTabNumStr:string;
    procedure CopyEDK;
    procedure CopyViplata;
    procedure LoadOptions;
    procedure SaveOptions;
  protected
    procedure WMProgressstop(var Message: TMessage); message WM_ProgressStop;
    procedure WMProgressprc(var Message: TMessage); message WM_ProgressPrc;
    procedure WMProgressstart(var Message: TMessage); message WM_ProgressStart;
  public
    property Mode:Integer read GetMode;
    property ModeStr:string read GetModeStr;
    function Execute:boolean;
  end;

const
  SourceStr   = 'Укажите папку в которой храниться база %s.'#13#10+
                'Папка должна называться ''%s.''';
  SourceStrV  = 'Укажите папку в которой храниться база %s.'#13#10+
                'Папка должна называться ''%s.'''#13#10+
                'Рекомендуется использовать папку со свежей копией базы, (например, D:\!Arhiv\DBFSOZ)';
  TargetStr   = 'Укажите папку в которую будет записан результат.';
  IniFileName = 'Pathes.ini';
var
  ImportDlg: TImportDlg;
  FileName:string = 'd:\списки\выплаты\fio.csv';
  FieldNum:integer = 0;

implementation

uses cgsCHPR, FileCtrl, cdbf, IniFiles, PublFile, Unit17, uAutoComplete,
  uEdkThread, uViplataThread, Publ;
{$R *.dfm}

procedure TImportDlg.Edit1Change(Sender: TObject);
begin
  Src.Values[GetTabNumStr]:=Edit1.Text;
  //caption:=Sender.ClassName;
end;

procedure TImportDlg.Edit2Change(Sender: TObject);
begin
  Trg.Values[GetTabNumStr]:=Edit2.Text;
end;

procedure TImportDlg.FormActivate(Sender: TObject);
begin
  TabControl1Change(Sender);
  // ToolButton1.click;
  // Close;
end;

procedure TImportDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptions;
end;

procedure TImportDlg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  CanClose:=ExchangeBtn.Enabled or (MessageDlg(
  'Идёт перенос баз данных.'#13#10+
  'Если закрыть окно, то данные будут повреждены'#13#10+
  'Вы уверены, что хотите прервать перенос?',mtWarning,[mbYes,mbNo],0,mbNo)=mrYes);

end;

procedure TImportDlg.FormCreate(Sender: TObject);
begin
  Src:=TStringList.Create;
  Trg:=TStringList.Create;
  Src.CommaText:=',,';
  Trg.CommaText:=',,';
  LoadOptions;
  AllEditsToACEdits(self);
end;

procedure TImportDlg.FormDestroy(Sender: TObject);
begin
  Src.Free;
  Trg.Free;
end;

function TImportDlg.GetMode: Integer;
begin
  Result:=TabControl1.TabIndex;
end;

function TImportDlg.GetModeStr: string;
begin
  Result:= IntToStr(Mode);
end;

function TImportDlg.GetTabNumStr: string;
begin
  Result:=IntToStr(TabControl1.TabIndex);
end;

procedure TImportDlg.CopyViplata;
var
  sPath: string;
  tPath: string;
  thViplata:TViplataThread;
begin
  sPath:=Src.Values['2'];
  tPath:=Trg.Values['2'];
  if not FioDlg.Execute then Exit;
//  if not PrepareFIO then Exit;

  thViplata:=TViplataThread.Create(true);
  thViplata.WinHandle:=Handle;
  thViplata.SourcePath:=sPath;
  thViplata.TargetPath:=tPath;
  thViplata.FIOPath:=FioDlg.FIOPath;
  thViplata.FreeOnTerminate:=true;
  thViplata.Resume;

//  CreateIndexForCSV(tPath+'\fio.csv', tPath+'\fio.Index', 0);
//  CreateIndexForTxt(tPath+'\fio.csv', tPath+'\fio.BIndex');
//  CreateTextBase(sPath+'\bux\ARHIVSUM.DBF', tPath+'\f5.csv', 0);
//  CreateTextBase(sPath+'\SUBS\ARXSUB.DBF', tPath+'\f7.csv', 0);
end;

procedure TImportDlg.CopyEDK;
var
  thEDK:TEdkThread;
begin
  thEDK:=TEdkThread.Create(true);
  thEDK.SourcePath:=Src.Values[ModeStr];
  thEDK.TargetPath:=Trg.Values[ModeStr];
  thEDK.WinHandle:=Handle;
  thEDK.FreeOnTerminate:=true;
  thEDK.Resume;
end;

procedure TImportDlg.LoadOptions;
var
  Ini:TIniFile;
begin
  Ini:=TIniFile.Create(ProgramPath+IniFileName);
  Src.Values['0']:=Ini.ReadString('Source','0','');
  Src.Values['1']:=Ini.ReadString('Source','1','');
  Src.Values['2']:=Ini.ReadString('Source','2','');
  Trg.Values['0']:=Ini.ReadString('Target','0','');
  Trg.Values['1']:=Ini.ReadString('Target','1','');
  Trg.Values['2']:=Ini.ReadString('Target','2','');
  Ini.Free;
end;

procedure TImportDlg.SaveOptions;
var
  Ini:TIniFile;
begin
  Ini:=TIniFile.Create(ProgramPath+IniFileName);
  Ini.WriteString('Source','0',Src.Values['0']);
  Ini.WriteString('Source','1',Src.Values['1']);
  Ini.WriteString('Source','2',Src.Values['2']);
  Ini.WriteString('Target','0',Trg.Values['0']);
  Ini.WriteString('Target','1',Trg.Values['1']);
  Ini.WriteString('Target','2',Trg.Values['2']);
  Ini.Free;
end;

procedure TImportDlg.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  Panel1.Enabled:=true;
  //Show;
  raise E;
end;

procedure TImportDlg.Button1Click(Sender: TObject);
var
  Dir:string;
begin
  if not SelectDirectory('Выберите папку с базой','',Dir,[sdNewUI,sdNewFolder]) then Exit;
  Edit1.Text:=Dir;
end;

procedure TImportDlg.Button2Click(Sender: TObject);
var
  Dir:string;
begin
  if not SelectDirectory('Выберите папку с базой','',Dir,[sdNewUI,sdNewFolder]) then Exit;
  Edit2.Text:=Dir;
end;

procedure TImportDlg.Button3Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TImportDlg.ExchangeBtnClick(Sender: TObject);
begin
  Panel1.Enabled:=false;
  case Mode of
    0,1: CopyEDK;
    2: CopyViplata;
  end;
  Panel1.Enabled:=true;
end;

function TImportDlg.Execute: boolean;
begin
  Result:=ShowModal=mrOk;
end;

procedure TImportDlg.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: begin
      Memo1.Text:=format(SourceStr,['по Детским пособиям','INSO']);
      Memo2.Text:=TargetStr;
    end;
    1: begin
      Memo1.Text:=format(SourceStr,['по ЕДК','INSO_EDK']);
      Memo2.Text:=TargetStr;
    end;
    2: begin
      Memo1.Text:=format(SourceStrV,['по Субсидиям','DBFSOZ']);
      Memo2.Text:=TargetStr;
    end;
  end;
  Edit1.Text:=Src.Values[GetTabNumStr];
  Edit2.Text:=Trg.Values[GetTabNumStr];
end;

procedure TImportDlg.ToolButton1Click(Sender: TObject);
begin
  // CreateIndexForTxt(FileName,FileName+'.'+IntToStr(FieldNum)+'.BIndex',FieldNum);
  if not SelectDirectory('Выберите папку ЕДК или Детских пособий','',Dir,[sdNewUI,sdNewFolder]) then Exit;
  CopyEDK;
end;

//const
//  FieldsEDK_DB1: string
//                 =( 'FAMILY=Фамилия,NAME=Имя,FATHER=Отчество,PN=Нас.Пункт,'+
//                    'ST=Улица,HOUSE=Дом,KORP=Корп,FLAT=Квартира,'+
//                    'KODPEN=КодПенс,IST=Источ.,LCHET=Л/С');

procedure TImportDlg.ToolButton2Click(Sender: TObject);
begin
  // CreateIndexForTxt(FileName,FileName+'.'+IntToStr(FieldNum)+'.BIndex',FieldNum);
  if not SelectDirectory('Выберите папку DBFSOZ','',Dir,[sdNewUI,sdNewFolder]) then Exit;
  CopyViplata;
end;

procedure TImportDlg.WMProgressprc(var Message: TMessage);
begin
  ProgressBar1.Max:=Message.LParam;
  ProgressBar1.Position:=Message.WParam;
end;

procedure TImportDlg.WMProgressstart(var Message: TMessage);
begin
  ExchangeBtn.Enabled:=false;
  ExchangeBtn.Caption:='Ждите...';
end;

procedure TImportDlg.WMProgressstop(var Message: TMessage);
begin
  ProgressBar1.Max:=100;
  ProgressBar1.Position:=100;
  MessageDlg('Обмен завершен', mtInformation, [mbOK], 0);
  ExchangeBtn.Enabled:=true;
  ExchangeBtn.Caption:='Обмен';
end;

end.
