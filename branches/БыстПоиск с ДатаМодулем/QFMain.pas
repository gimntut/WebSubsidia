unit QFMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, ComCtrls, StdCtrls, ToolWin,
  cgsCHPR, XPMan, ImgList, Menus, ActnList, AppEvnts, Contnrs, uPagePanel,
  Grids, superobject, httpsend, ViewLog{, uOpenOffice}, gsCatcher;

type
  TListBox=class(StdCtrls.TListBox)
  protected
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    //procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;

  end;

  THackWinControl=class(TWinControl)
  published
    property Font;
  end;
//  TMemo=class(StdCtrls.TMemo)
//    procedure SBM_SETRANGE(var Message: TMessage); message SBM_SETRANGE;
//  end;

  TForm9 = class(TForm)
    CheckBankBtn: TToolButton;
    Edit1: TEdit;
    ExcelAsIsBtn: TToolButton;
    ExcelFillBtn: TToolButton;
    lbReklama: TLabel;
    lstDetails: TListBox;
    lstMaster: TListBox;
    Memo1: TMemo;
    Memo3: TMemo;
    MemoModeBtn: TToolButton;
    mmHelp: TMemo;
    NewBtn: TToolButton;
    OpenBtn: TToolButton;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pnMaster: TPanel;
    pnDetails: TPanel;
    pnOutput: TPanel;
    Panel6: TPanel;
    pnFindList: TPanel;
    pnHelp: TPanel;
    pnMemo: TPanel;
    PrintBtn: TToolButton;
    SortBtn: TToolButton;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    SpravkaBtn: TToolButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TextModeBtn: TToolButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton11: TToolButton;
    ToolButton10: TToolButton;
    btnSplitMode: TToolButton;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure acCopyExecute(Sender: TObject);
    procedure acCopyParamValueExecute(Sender: TObject);
    procedure acCopyTableExecute(Sender: TObject);
    procedure acCopyValueExecute(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure CheckBankBtnClick(Sender: TObject);
    procedure DetailListMenuPopup(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ExcelAsIsBtnClick(Sender: TObject);
    procedure ExcelFillBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure JournalBtnClick(Sender: TObject);
    procedure lbReklamaClick(Sender: TObject);
    procedure lbReklamaMouseEnter(Sender: TObject);
    procedure lbReklamaMouseLeave(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstDetailsDblClick(Sender: TObject);
    procedure lstMasterDblClick(Sender: TObject);
    procedure MemoModeBtnClick(Sender: TObject);
    procedure mmHelpDblClick(Sender: TObject);
    procedure mnStateClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure pnMasterResize(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSplitModeClick(Sender: TObject);
  private
    Chpr:TChprList;
    Chpr2:TChprList;
    Chpr3:TChprList;
    Table:TStringList;
    TmpSts:TStringList;
    BankColumn:Integer;
    CaptionName: string;
    FSpravkaType: Integer;
    FSpravkaPath: string;
    FKey: Word;
    LastSearh: string;
    MaxWidth: Integer;
    MessageStr: string;
    ActList:TObjectList;
    PagePanel: TPagePanel;
    BankListType: Integer;
    HTTP: THTTPSend;
    WebSite: string;
    Catch: TgsCatcher;
    FHorzSplit: boolean;
    //procedure ShowSpravkaF5_2(Sender:TObject; Memo:StdCtrls.TMemo);
    function ChprIndex:Integer;
    function GetDetail: string;
    function GetFileNameForExcel: string;
    function GetFloatValue(J: Integer; S: string):Extended;
    function GetMemoMode: Boolean;
    function GetValidLS(s: string): string;
    function MaxStringLength(S:string):Integer;
    function PrepareEDKResult(s: string):boolean;
    function PrepareF5Result(s: string):boolean;
    function PrepareFindResult(s: string; Table2:string):boolean;
    procedure AddActToList(I: Integer;Event:TNotifyEvent);
    procedure CheckBank(Sender:TObject; Index:Integer; S:string; var Show:boolean);
    procedure JournalClick(Sender: TObject);
    procedure LinkChild;
    procedure LinkEDK;
    procedure OpenFile(FileName: string);
    procedure OutCaption;
    procedure OutFoundEDK(s:string);
    procedure OutFoundF5(s: string);
    procedure OutTable(NoDataText:string='��� ������');
    procedure PrintSpravka;
    procedure RegQF;
    procedure ResetEditMode;
    procedure ReturnClick;
    procedure SaveToTmpCsv;
    procedure SetFontSize(const Value: Integer);
    procedure SetMemoMode(const Value: Boolean);
    procedure SetNewFontSize(WinControl: TWinControl; const Value: Integer);
    procedure SetSpravkaType(const Value: Integer);
    procedure ShowFirstList;
    procedure ShowSpravkaEDK(Sender:TObject; Memo:StdCtrls.TMemo);
    procedure ShowSpravkaF5(Sender:TObject; Memo:StdCtrls.TMemo);
    procedure ShowSpravkaF5_1(Sender:TObject; Memo:StdCtrls.TMemo);
    procedure ShowSverka(Sender:TObject; Memo:StdCtrls.TMemo);
    procedure SolveF7(DateV: TDate; var LastOtvet: Extended; var Otvet: Extended);
    procedure SortClick(Sender: TObject);
    procedure TextState;
    procedure SetHorzSplit(const Value: boolean);
    function GetFontSize: Integer;
  protected
    procedure WMDropFiles(var Message: TMessage); message WM_DROPFILES;
    procedure SeparateDetail(Index:integer; out Parameter, Detail: string);
    //procedure GenerateFile;
    property Detail:string read GetDetail;
  public
    property SpravkaType:Integer read FSpravkaType write SetSpravkaType;
    property FontSize:Integer read GetFontSize write SetFontSize;
    property MemoMode:Boolean read GetMemoMode write SetMemoMode;
    property HorzSplit:boolean read FHorzSplit write SetHorzSplit;
    { Public declarations }
  end;

var
  Form9: TForm9;
const
  sptNone = 0;
  sptEDK = 1;
  sptChild = 2;
  sptF5 = 3;
  sptFirstList = 4;
  sptJournal = 5;
  // BankListType
  blNone = 0;
  blChoice = 1;
  blOldReestr = 2;
  blSV2 = 3;
  blReestr = 4;
  jrnFields:array[0..9] of string = ('ID','LCHET', 'DATEOBR', 'FIO', 'ADDRESS',
  'SUMMA', 'FACT', 'OTKAZ', 'SPEC', 'DateZap');
  jrnHeaders = ('"� �/�","� ����","���� ���������","���","�����","�����",'
  +'"����.������","������� ������","����������","���� ������"');
  
  FieldsEDK_DB1: string
                 =( 'FAMILY=�������,NAME=���,FATHER=��������,PN=���.�����,'+
                    'ST=�����,HOUSE=���,KORP=����,FLAT=��������,'+
                    'KODPEN=�������,IST=�����.,LCHET=�/�');

  FieldsTab:string =
  ('LCHET=LCHET,SUM=SUM,C=C,DO=DO,NOMER=NOMER,METKA=METKA,IST=IST,DATA=DATA,'+
  'SUM_DOUB=SUM_DOUB,SUM_NAZN=SUM_NAZN,NAZ_DOUB=NAZ_DOUB,ORGAN=ORGAN');

  FieldsF7_DB1: string
                 =( 'LCHET=LCHET,SUB_C=SUB_C,DATMP_F=DATMP_F,R_STS=R_STS,'+
                    'POLUCH=POLUCH,K_LGOT=K_LGOT,MIDSOULDOH=MIDSOULDOH,'+
                    'SDD_PRAVO=SDD_PRAVO,MIDSOULDOH=MIDSOULDOH,OLD_SUB=OLD_SUB,'+
                    'SUBSID=SUBSID,SV=SV,SOS_FAM=SOS_FAM,SOV_DOHL=SOV_DOHL,'+
                    'SUM_POTR=SUM_POTR');

implementation
uses Publ, PublFile, ShellAPI, ClipBrd, Printers, QFLoadList, ShFolder, Registry,
  StrUtils, PublStr, QFTemplate, IniFiles, DateIntervalDlg, DateUtils, Types,
  cdbf, Math, uTime, uImportBases, DM;
{$R *.dfm}

procedure TForm9.acCopyExecute(Sender: TObject);
var
  Ind:Integer;
  sts: TStrings;
  I: Integer;
  S: string;
begin
 Ind:=lstMaster.ItemIndex;
 if Ind=-1 then Exit;
 if Chpr.InnerDelimeter=#0
 then Clipboard.AsText:=lstMaster.Items[Ind]
 else begin
   Ind:=Integer(lstMaster.Items.Objects[Ind]);
   if Ind=-1 then Exit;
   sts:=Chpr.Values[Ind];
   for I := 0 to sts.Count - 1 do S:=ContStr(S,#9,sts[I]);
   Clipboard.AsText:=S;
 end;
end;

procedure TForm9.acCopyParamValueExecute(Sender: TObject);
var
  Ind:Integer;
  S: string;
begin
 Ind:=lstDetails.ItemIndex;
 if Ind=-1 then Exit;
 S:=lstDetails.Items[Ind];
 Clipboard.AsText:=PublStr.Trim(S);
end;

procedure TForm9.acCopyTableExecute(Sender: TObject);
var
  I: Integer;
  S,S1: string;
  Param, Detail: string;
begin
  S:='';
  for I := 0 to lstDetails.Count - 1 do begin
    S1:=PublStr.Trim(lstDetails.Items[I]);
    SeparateDetail(I,Param,Detail);
    S:=ContStr(S,CRLF,Param+#9+Detail);
  end;
  Clipboard.AsText:=S;
end;

procedure TForm9.acCopyValueExecute(Sender: TObject);
begin
  Clipboard.AsText:=Detail;
end;

procedure TForm9.ApplicationEvents1Hint(Sender: TObject);
begin
  mmHelp.Text:=Application.Hint;
end;

procedure TForm9.btnSplitModeClick(Sender: TObject);
begin
  HorzSplit:=not HorzSplit;
end;

procedure TForm9.CheckBank(Sender: TObject; Index: Integer; S: string;
  var Show: boolean);
var
  SkipLines: Integer;
  SkipEndLines: Integer;
begin
  if BankColumn=-1
  then
    Show:=not CheckBankNum(S)
  else begin
    SkipLines:=0;
    SkipEndLines:=0;
    case BankListType of
      blOldReestr: begin
       SkipLines:=11;
       SkipEndLines:=1;
      end;
      blReestr: begin
        SkipLines:=7;
        SkipEndLines:=2;
      end;
    end;
    s:=chpr.Values[Index][BankColumn];
    Show:=Index>=SkipLines;
    Show:=Show and (Index<chpr.Count-SkipEndLines);
    Show:=Show and not CheckBankNum(s);
  end;
end;

procedure TForm9.Edit1Change(Sender: TObject);
var
  SelStart: Integer;
  SelLength: Integer;
begin
  if pos(#9,Edit1.text)>0 then begin
    Edit1.OnChange:=nil;
    SelStart:=Edit1.SelStart;
    SelLength:=Edit1.SelLength;
    Edit1.Text:=AnsiReplaceStr(Edit1.Text,#9,' ');
    Edit1.SelStart:=SelStart;
    Edit1.SelLength:=SelLength;
    Edit1.OnChange:=Edit1Change;
  end;
  if FSpravkaType=sptNone then ;
  Exit;
  case SpravkaType of
    sptEDK: OutFoundEDK(Edit1.Text);
    sptChild: OutFoundEDK(Edit1.Text);
    sptF5: OutFoundF5(GetValidLS(Edit1.Text));
  end;
end;

procedure TForm9.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then Key:=0;
end;

procedure TForm9.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  ss,sl:Integer;
begin
  case ord(Key) of
    VK_RETURN: Key:=#0;
  end;
  if not (ActiveControl is TCustomEdit) and (PublStr.AnsiUpperCase(Key)[1] in ['0'..'9','A'..'Z','�'..'�'])
  then begin
    ss:=Edit1.SelStart;
    sl:=Edit1.SelLength;
    Edit1.SetFocus;
    Edit1.SelStart:=ss;
    Edit1.SelLength:=sl;
    Edit1.Perform(WM_CHAR,ord(Key),0);
  end;
  
end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Options.Save;
end;

procedure TForm9.FormCreate(Sender: TObject);
var
  FN:string;
begin
  Log('StartCatch');
  Catch := TgsCatcher.Create(self);
  Catch.CollectInfo := true;
  Catch.Enabled := true;
  Catch.GenerateScreenshot := true;
  Catch.JpegQuality := 100;
  Catch.OutPath := 'H:\������\������\Debug';
  Log('Set Drag');
  DragAcceptFiles(Handle, true);
  Log('Create Httpsend');
  HTTP:=THTTPSend.Create;
  HTTP.UserAgent:='WebSubsidii';
  Log('Create PagePanel');
  PagePanel:=Substitution(PageControl1);
  PagePanel.ActivePageIndex:=0;
  LogObjectAsText(PagePanel);
//  PagePanel.Name:='page';
//  PagePanel.Align:=alClient;
//  PagePanel.Parent:=self;
//  AddPage(pnFindList);
//  AddPage(pnMemo);
//  AddPage(pnJournal);
  Log('Reg QuickFind');
  RegQF;
  Log('Create TStrings');
  TmpSts:=TStringList.Create;
  Log('Create ChprLists');
  Chpr:=TChprList.Create;
  Chpr2:=TChprList.Create;
  Chpr3:=TChprList.Create;
  Table:=TStringList.Create;
  Log('Create ActList');
  ActList:=TObjectList.Create(true);
  Table.CommaText:=jrnHeaders;
  DataModule3.IniFileName:=ProgramPath+'\QFS.ini';
  DataModule3.LoadIni;
  Chpr.InnerDelimeter:=';';
  Chpr.IsOEMSource:=true;
  Chpr.IsTransformed:=true;
  Chpr.Filling:=true;
  Chpr.TableLength:=1000;
  DataModule3.n13.Enabled:=true;
  DataModule3.ShowFavorite;
  Synchronizing('http://'+WebSite+'/time.php');
  MessageStr:='������ ��� ������ �����, �������� ������ �� �������� ������ ������'
  +#13#10'��� �������� � ��������� ������� ������ ESC';
  FN:=ExpandFileName(ParamStr(1));
  if ParamCount>0 then begin
    // MessageBox('��������', '�����. ��� �������� ������...');
    OpenFile(FN);
  end else ShowFirstList;
  lbReklama.Caption:='������ �� �������� [ ������ '+GetFileVersion(ParamStr(0))+' ] '+lbReklama.Caption;
  HorzSplit:=true;
end;

procedure TForm9.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);
  ActList.Free;
  Chpr.Free;
  Chpr2.Free;
  Chpr3.Free;
  Table.Free;
  TmpSts.Free;
  HTTP.Free;
  Catch.Free; 
end;

procedure TForm9.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pnt: TPoint;
begin
  case ShortCut(Key,Shift) of
    VK_RETURN: ReturnClick;
    VK_DOWN, VK_UP, VK_NEXT, VK_PRIOR: begin
      if ActiveControl is TListBox then Exit;
      if ActiveControl is TMemo then Exit;
      if ActiveControl is TStringGrid then Exit;
      FKey:=Key;
      DataModule3.Timer1.Enabled:=true;
      Key:=0;
    end;
    VK_ESCAPE: begin
      Edit1.Text:='';
      SpeedButton1.Click;
    end;
    scCtrl+scShift+ORD('O'): begin
      pnt:=Point(OpenBtn.Left,OpenBtn.Top+OpenBtn.Height);
      Pnt:=ToolBar1.ClientToScreen(Pnt);
      OpenBtn.DropdownMenu.Popup(Pnt.X,Pnt.Y);
    end;
    scCtrl+ORD('N'): begin
      NewBtn.Click;
    end;
    scCtrl+ORD('O'): begin
      OpenBtn.Click;
    end;
    scCtrl+ORD('P'), VK_F9: begin
      PrintBtn.Click;
    end;
  end;
end;

procedure TForm9.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  pnt: TPoint;
begin
  case ShortCut(Key,Shift) of
    scAlt+VK_RETURN: if WindowState=wsMaximized
                     then WindowState:=wsNormal
                     else WindowState:=wsMaximized;
    scCtrl+VK_RETURN: PrintSpravka;
    VK_F2: begin
      pnt:=Point(SpravkaBtn.Left,SpravkaBtn.Top+SpravkaBtn.Height);
      Pnt:=ToolBar1.ClientToScreen(Pnt);

      SpravkaBtn.DropdownMenu.Popup(Pnt.X,Pnt.Y);

    end;
  end;
  Key:=0;
end;

procedure TForm9.FormShow(Sender: TObject);
begin
  ToolBar1.Width:=1;
end;

procedure TForm9.lbReklamaClick(Sender: TObject);
begin
  ShellExecute(0,'open','mailto:gimntut@list.ru','','',SW_SHOWNORMAL);
end;

procedure TForm9.ShowFirstList;
var
  sts:TStringList;
  I:Integer;
  LS: string;
  IsDir, flagFirst: Boolean;
  S: string;
begin
  MemoMode:=false;
  SpravkaType:=sptFirstList;
  PagePanel.ActivePageIndex:=0;
  ActList.Clear;
  Chpr.Mode:=mdCsv;
  sts:=TStringList.Create;
  sts.Text:='������������;���;�������';
//  sts.Add('������ �����������;;');
//  AddActToList(0,JournalClick);
//  sts.Add('--------------;-----;------------');
//  ActList.Add(nil);
  for I := 0 to DataModule3.SpravkiSts.Count - 1 do begin
    sts.Add(DataModule3.SpravkiSts.Names[I]+';�������;F2, '+IntToStr(I+1));
    AddActToList(I,DataModule3.acSpravka.OnExecute);
    //todo: �������� ������� �� �����
  end;
  flagFirst:=true;
  for I := 0 to DataModule3.FavoriteFiles.Count - 1 do
  begin
    LS:=GetLongHint(DataModule3.FavoriteFiles[I]);
    IsDir:=LS[1]='*';
    if not IsDir then Continue;
    System.Delete(LS,1,1);
    if not SysUtils.DirectoryExists(LS) then Continue;
    if flagFirst then begin
      sts.Add('--------------;-----;------------');
      ActList.Add(nil);
    end;
    flagFirst:=False;
    S:=GetShortHint(DataModule3.FavoriteFiles[I]);
    sts.Add(format('%s;�����;Ctrl+Shift+O',[S]));
    AddActToList(I,DataModule3.FavorClick);
  end;
  flagFirst:=true;
  for I := 0 to DataModule3.FavoriteFiles.Count - 1 do
  begin
    LS:=GetLongHint(DataModule3.FavoriteFiles[I]);
    IsDir:=LS[1]='*';
    if IsDir then Continue;
    if not FileExists(GetLongHint(DataModule3.FavoriteFiles[I])) then Continue;
    if flagFirst then begin
      sts.Add('--------------;-----;------------');
      ActList.Add(nil);
    end;
    flagFirst:=False;
    S:=GetShortHint(DataModule3.FavoriteFiles[I]);
    sts.Add(format('%s;����;Ctrl+Shift+O',[S]));
    AddActToList(I,DataModule3.FavorClick);
  end;
  Chpr.Text:=sts.Text;
  sts.Free;
  OutTable;
end;

function TForm9.ChprIndex:Integer;
begin
 Result:=lstMaster.ItemIndex;
 if OutSide(Result,lstMaster.Items.Count-1) then begin
   Result:=-1;
   Exit;
 end;
 Result:=Integer(lstMaster.Items.Objects[Result]);
 if OutSide(Result,Chpr.Count-1) then Result:=-1;
end;

procedure TForm9.DetailListMenuPopup(Sender: TObject);
var
  s:string;
begin
  s:=Detail;
  try
    DataModule3.n14.Visible:=DirectoryExists(s);
  except
    DataModule3.n14.Visible:=false;
  end;
  DataModule3.n15.Visible:=FileExists(s);
end;

function TForm9.GetFloatValue(J: Integer; S: string):Extended;
begin
  Result := Str2Float(AnsiReplaceStr(Chpr3.ValueByName[J, S], '.', DecimalSeparator));
end;

function TForm9.GetFontSize: Integer;
begin
  Result:=Options.FontSize;
end;

procedure TForm9.SortClick(Sender: TObject);
begin
  Chpr.SortedField:=TControl(Sender).Tag;
  OutTable;
end;

procedure TForm9.OpenFile(FileName: string);
var
  S:string;
  OldFileName: string;
begin
  PagePanel.ActivePageIndex:=3;
  PagePanel.Invalidate;
  DataModule3.OpenDialog1.FileName:=FileName;
  SpravkaType := sptNone;
  ResetEditMode;
  if SameText(ExtractFileExt(FileName),'.dbf') then begin
    OldFileName:=FileName;
    FileName:=TempPath+ChangeFileExt(ExtractFileName(FileName),'.csv');
    DbfToCsv(OldFileName,FileName,False);
  end;
  S:=Edit1.Text;
  Chpr.Clear;
  Chpr.OnCustomFilter:=nil;
  Chpr.Filter:='';
  Chpr.IsTransformed := false;
  Chpr.IsOEMSource := false;
  Chpr.LoadFromFile(FileName);
  Chpr.AutoConfig;
  DataModule3.n13.Enabled:=Chpr.IsTransformed;
  Edit1.Text:=S;
  Chpr.Filter:=S;
  TextState;
  MessageStr:='';
  OutTable;
  PagePanel.ActivePageIndex:=0;
end;

procedure TForm9.OutTable(NoDataText:string='��� ������');
var
  I: Integer;
  It: TMenuItem;
  SortItems: TMenuItem;
  MxL: Integer;
  MinPos: Integer;
  MaxPos: Integer;
  st: string;
begin
  Table.Assign(Chpr.AsTable);
  MemoModeBtn.Visible:=not Chpr.IsTransformed;
  SortBtn.Enabled:=(Chpr.Count>0) and (Chpr.FieldNames.Count>0);
  //Label1.Caption := Table[0];
  Memo3.Text:= Table[0];
  Table.Delete(1);
  Table.Delete(0);
  lstMaster.Items.BeginUpdate;
  lstMaster.Items := Table;
  if Table.Count=0 then begin
    lstMaster.Items.Text:=NoDataText;
    for I := 0 to lstMaster.Items.Count - 1 do
      lstMaster.Items.Objects[I]:=Pointer(-2);
  end;
  MxL:=0;
  for I := 0 to lstMaster.Items.Count - 1 do begin
    if Length(lstMaster.Items[I])>MxL then
      st:=lstMaster.Items[I];
      MxL:=Length(st);
  end;
  inc(MxL);
//  lstMaster.Items.SaveToFile('c:\---.---');
  lstMaster.Items.EndUpdate;
  SortItems:=DataModule3.SortMenu.Items;
  SortItems.Clear;
  for I := 0 to Chpr.FieldNames.Count - 1 do begin
    It:=TMenuItem.Create(DataModule3.SortMenu);
    It.Caption:=Chpr.FieldNames[I];
    It.OnClick:=SortClick;
    it.Tag:=I;
    SortItems.Add(it);
  end;
  if lstMaster.Count>0 then lstMaster.Selected[0]:=true;
  ListBoxClick(lstMaster);
  OutCaption;
  TextState;
  //ShowScrollBar(Memo3.Handle,SB_HORZ,True);
  lstMaster.Canvas.Font:=lstMaster.Font;
  SetScrollRange(Memo3.Handle,SB_HORZ,0,MxL*(lstMaster.Canvas.TextWidth('W')),TRUE);
  GetScrollRange(Memo3.Handle,SB_HORZ,MinPos,MaxPos);
  lstMaster.ScrollWidth:=MaxPos;
  ShowScrollBar(Memo3.Handle,SB_HORZ,False);
  pnMasterResize(nil);
//  Log('=== �������� ������� ===');
//  for i:=0 to 9 do begin
//    if i>lstMaster.count-1 then break;
//    LogFmt('%s:%s: %s',[ToZeroStr(i),ToZeroStr(i)]);
//  end;
end;

procedure TForm9.RegQF;
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
  Reg.RootKey:=HKEY_CLASSES_ROOT;
  Reg.OpenKey('*\shell\���������� ��� �������\command',true);
  Reg.WriteString('','"'+ParamStr(0)+'" "%1"');
  Reg.Free;
  except
   on exception do ;
  end;
end;

procedure TForm9.ResetEditMode;
begin
  MemoMode:=false;
end;

procedure TForm9.OutCaption;
var
  s: string;
  s2: string;
begin
  s := CaptionName;
  case SpravkaType of
    sptNone: begin
      if s = '' then
        s := ExtractFileName(DataModule3.OpenDialog1.FileName);
      if Edit1.Text <> '' then
        s2 := format('. ����� "%s" (%d/%d)', [Edit1.Text, Chpr.FilterCount-1, Chpr.Count-1]);
      Caption := format('������ �� ������� "%s"%s', [s, s2]);
      //Application.Title:=format('������ �� �������', [GetFileDate(ParamStr(0))]);
    end;
    sptFirstList: Caption:='������ �� ��������';
    sptEDK: Caption := '������� ���';
    sptChild: Caption := '������� ������� �������';
    sptF5: Caption := '������� ����� ������ ��������';
  end;
end;

procedure TForm9.LinkEDK;
begin
  Dummy;
end;

//procedure TForm9.GenerateFile;
//begin
//  // �������� ���������� �� ������ ��������
//  Caption := '';
//end;

procedure TForm9.SaveToTmpCsv;
var
  S: string;
  Dir: string;
begin
  S:=GetFileNameForExcel;
  try
    chpr.SaveToFile(S);
  except
    on Exception do Exception.Create('�������� ���� ��� �����. �������� Excel � ���������� �����');
  end;
  Dir := GetSpecialFolderPath(CSIDL_PERSONAL);
  ShellExecute(0, 'open', PAnsiChar(S), PAnsiChar(Dir), '', SW_NORMAL);
end;

procedure TForm9.SeparateDetail(Index:integer; out Parameter, Detail: string);
var
  Ind:Integer;
begin
  Detail:='';
  Parameter:='';
  if Index=-1
  then Ind:=lstDetails.ItemIndex
  else Ind:=Index;
  if OutSide(Ind,lstDetails.Count-1) then Exit;
  Detail:=lstDetails.Items[Ind];
  Parameter:=Copy(Detail,1,MaxWidth);
  System.Delete(Detail,1,MaxWidth+1);
  Detail:=PublStr.Trim(Detail);
end;

procedure TForm9.SetFontSize(const Value: Integer);
begin
  Options.FontSize := Value;
  SetNewFontSize(lstMaster, Value);
  SetNewFontSize(lstDetails, Value);
  SetNewFontSize(Memo1, Value);
  SetNewFontSize(Memo3, Value);
  Options.Save;
end;

procedure TForm9.SetHorzSplit(const Value: boolean);
var
  prc:Integer;
begin
  if FHorzSplit=Value then Exit;
  FHorzSplit := Value;
  if Value then begin
    prc:=pnDetails.Height*100 div pnMaster.Height;
    btnSplitMode.ImageIndex:=16;
    pnDetails.Align:=alBottom;
    pnDetails.Width:=pnOutput.Width*prc div 100;
    Splitter1.Align:=alBottom;
    lstDetails.Width:=lstDetails.Width+1;
  end else begin
    prc:=pnDetails.Width*100 div pnOutput.Width;
    btnSplitMode.ImageIndex:=17;
    pnDetails.Align:=alRight;
    pnDetails.Height:=pnOutput.Height*prc div 100+1;
    Splitter1.Align:=alRight;
  end;
end;

procedure TForm9.SetMemoMode(const Value: Boolean);
begin
  if Value
  then begin
    Memo1.Lines:=Chpr;
    PagePanel.ActivePageIndex:=1;
  end
  else begin
    PagePanel.ActivePageIndex:=0;
  end;
  MemoModeBtn.Down := Value;
end;

procedure TForm9.SetNewFontSize(WinControl: TWinControl; const Value: Integer);
begin
  THackWinControl(WinControl).Font.Size := Value;
  WinControl.Width:=WinControl.Width+1;
end;

procedure TForm9.SolveF7(DateV: TDate; var LastOtvet: Extended; var Otvet: Extended);
var
  I: Integer;
  DV: TDate;
  SposV: Integer;
  A: Extended;
  B: Extended;
  C: Extended;
  D: Extended;
  E: Extended;
  F: Extended;
begin
  Otvet := ImpossibleFloat;
//  ShowMessage(Chpr3.Text);
  for I := Chpr3.count - 2 downto 0 do
  begin
    DV := StrToDateDef(Chpr3.ValueByName[I, 'SUB_C'], 0);
    if not SameDate(DateV, DV) then Continue;
    A := GetFloatValue(I, 'R_STS');
    B := GetFloatValue(I, 'POLUCH');
    //Bb := GetFloatValue(J, 'SOS_FAM');
    C := GetFloatValue(I, 'K_LGOT');
    E := GetFloatValue(I, 'MIDSOULDOH');
    //E := RoundTo(Ee/Bb,-4);
    //E := Ee/Bb;
    F := GetFloatValue(I, 'SDD_PRAVO');
    //F := Ff/B;
    if F=0 then D:=1
    else D := RoundTo(E / F, -4);
    if D > 1 then
      D := 1;
    Otvet := A * B * C - E * D * B * 0.22;
    LastOtvet := Otvet;
    SposV := StrToInt(Chpr3.ValueByName[I, 'SV']);
    if SposV = 2 then break;
  end;
  if math.isNan(Otvet) then Otvet := LastOtvet;
end;

procedure TForm9.SetSpravkaType(const Value: Integer);
begin
  FSpravkaType := Value;
  case Value of
    sptNone: begin
      MessageStr:='������ �� �������!'
    end;
    sptEDK: LinkEDK;
    sptChild: LinkChild;
    else ;
  end;
  OutCaption;
end;

procedure TForm9.OutFoundEDK(s:string);
var
  FastBase:TFastFileStrList;
  p:Integer;
  message:string;
begin
  MemoMode:=false;
  FastBase:=TFastFileStrList.Create;
  try
    FastBase.ShowFields.CommaText:=FieldsEDK_DB1;
    FastBase.BaseName:=FSpravkaPath+'Base2.csv';
    FastBase.BaseIndexFile:=FSpravkaPath+'Base2.Index';
    p:=pos(' ',s);
    if p<2
    then begin
      FastBase.Filter:=s;
      s:='';
    end else begin
      FastBase.Filter:=LeftStr(s,p-1);
      System.Delete(s,1,p);
      s:=PublStr.Trim(s);
    end;
    Chpr.Mode:=mdCsv;
    Chpr.Text:=FastBase.Text;
    if s<>'' then chpr.Filter:=s;
    if length(s)<3
    then message:='������� ������� ��� ������ (�� ������ 2� ����)'
    else message:='������ �� �������';
    OutTable(message);
  finally
    FastBase.Free;
  end;
  LastSearh:=Edit1.Text;
end;

const
SpravkaEDK=
'                     �� � ��� �������� � ��� �� � �.�������'#13#10+
#13#10+
'                             ������� ���� N %s'#13#10+
'                         %s'#13#10+
'                ����. �� ������: %s'#13#10+
'                    ��� ������(�������) - %s �������� -  %s'#13#10+
'              ������� ������� �� ������ � %s �� %s';
Title:array[0..3,0..4] of string=(
 (('-------------------------'),('----------------------------------'),('-------------'),('-----------'),('--------------------------------------------')),
 (('�����        ����� �     '),('1 ������    ������ 1-�� ����.     '),('�����        '),(' ��������� '),('�������     �          ��          N ������ ')),
 (('�������      �������     '),('���.���                           '),('�������.     '),('           '),('�������                                     ')),
 (('-------------------------'),('----------------------------------'),('-------------'),('-----------'),('--------------------------------------------')));

type
  TStolbi=set of (std, R1, raz, ud);

procedure TForm9.OutFoundF5(s:string);
var
  FastBase:TFastFileStrList;
  p:Integer;
begin
  MemoMode:=false;
  FastBase:=TFastFileStrList.Create;
  try
    //FastBase.ShowFields.CommaText:=FieldsEDK_DB1;
    FastBase.BaseName:=FSpravkaPath+'fio.csv';
    FastBase.BaseIndexFile:=FSpravkaPath+'fio.Index';
    p:=pos(' ',s);
    if p<2
    then begin
      FastBase.Filter:=s;
      s:='';
    end else begin
      FastBase.Filter:=LeftStr(s,p-1);
      System.Delete(s,1,p);
      s:=PublStr.Trim(s);
    end;
    Chpr.Clear;
    Chpr.Mode:=mdCsv;
    Chpr.Text:=FastBase.Text;
    if s<>'' then chpr.Filter:=s;
    OutTable('������� � �� ��� ������');
  finally
    FastBase.Free;
  end;
  LastSearh:=Edit1.Text;
end;

function TForm9.GetMemoMode: Boolean;
begin
  Result:=MemoModeBtn.Down;
end;

const
SpravkaF5=
'     (%s)                                      ������������'+#13#10+
'  ����������� ������ �� ��������������� ����� �������� � �.�������'+#13#10+
'                                 �������'+#13#10#13#10+
'                     ���� � ���, ��� ����������'+#13#10+
'%s'+#13#10+
'                        ����������� �� ������'+#13#10+
'%s'+#13#10#13#10+
'      ������� �� ����� � ������� ���������� �������� ��������'+#13#10+
'     C %s � %s ��������� �������� �� ������ ���'+#13#10#13#10;

SpravkaF5Niz=
#13#10'     ������� ���� ��� ������������ � '+#13#10#13#10+
'     __________________________________________________________'+#13#10#13#10+
'       %s'+#13#10#13#10+
'    ��������____________________           �������_____________'+#13#10;


procedure TForm9.LinkChild;
begin
  Dummy;
end;

procedure TForm9.PrintSpravka;
var
  LC: string;
  Ind: Integer;
  D_Nazn: TDate;
begin
  Ind := lstMaster.ItemIndex;
  if OutSide(Ind, lstMaster.Items.Count - 1) then Exit;
  case FSpravkaType of
    sptEDK, sptChild:
      begin
        KeyPreview:=false;
        Ind := ChprIndex;
        if Ind = -1 then Exit;
        LC := Chpr.Values[Ind][10];
        PrepareEDKResult(LC);
        PeriodDlg.OnChangeInterval:=ShowSpravkaEDK;
        PeriodDlg.TriggersOff;
        if PeriodDlg.Execute then
        begin
          ShowSpravkaEDK(PeriodDlg,Memo1);
        end else begin
          MemoMode:=false;
        end;
        KeyPreview:=true;
      end;
    sptF5:
      begin
        KeyPreview:=false;
        Ind := ChprIndex;
        if Ind = -1 then Exit;
        LC := Chpr.Values[Ind][0];
        PrepareF5Result(LC);
        D_Nazn := StrToDate(TmpSts[10]);
        D_Nazn := IncMonth(D_Nazn-15,1);
        PeriodDlg.StartInterval:=D_Nazn;
        PeriodDlg.OnChangeInterval:=ShowSpravkaF5;
        PeriodDlg.TriggersOff;
        PeriodDlg.AddTriger('����� ������',true);
        if PeriodDlg.Execute then
        begin
          ShowSpravkaF5(PeriodDlg, Memo1);
        end else begin
          MemoMode:=false;
        end;
        KeyPreview:=true;
      end;
    sptFirstList: begin
      Ind:=ChprIndex;
      if (Ind=-1) or (ActList[Ind]=nil) then Exit;
      TAction(ActList[Ind]).Execute;
    end;
  end;
end;

procedure TForm9.ReturnClick;
var
  s: string;
  Ind: Integer;
  ChangedFindStr:boolean;
begin
  s := Edit1.Text;
  ChangedFindStr:= not ((Edit1.Text = LastSearh) and (Chpr.FilterCount <> 0)
                   and (lstMaster.ItemIndex <> -1));
  case SpravkaType of
    sptNone:
      begin
        if Chpr.count = 0 then
        ;
        //Exit;
        lstDetails.Clear;
        Chpr.Filter := s;
        OutTable(MessageStr);
        LastSearh := s;
      end;
    sptEDK, sptChild:
      begin
        if not ChangedFindStr and not MemoMode
        then PrintSpravka
        else OutFoundEDK(s);
      end;
    sptF5: begin
      if
        (s = LastSearh)
        and
        (Chpr.FilterCount <> 0)
        and
        (lstMaster.ItemIndex <> -1) and
        not MemoMode
      then PrintSpravka
      else begin
        s:=Edit1.Text;
        if s<>'' then Edit1.Text:=GetValidLS(s);
        OutFoundF5(Edit1.Text);
//        if lstMaster.Count>0 then
//          if Integer(lstMaster.Items[0])>0 then PrintSpravka;
      end;
    end;
    sptFirstList: begin
      if ChangedFindStr then begin
        lstDetails.Clear;
        Chpr.Filter := s;
        OutTable(MessageStr);
        LastSearh := s;
      end else begin
        Ind:=ChprIndex;
        if (Ind=-1) or (ActList[Ind]=nil) then Exit;
        TAction(ActList[Ind]).Execute;
      end;
    end;
  end;
end;

procedure TForm9.TextState;
var
  I: Integer;
const
  BankColumnName:array[0..2] of string = ('N ����� � �����','NCHETA','B');
begin
  if Chpr.IsTransformed then
    DataModule3.mnTransformed.Checked := true
  else
    DataModule3.mnOriginalText.Checked := true;
  DataModule3.n13.Enabled := Chpr.IsTransformed;
  if Chpr.IsOEMSource then
    DataModule3.mnOEM.Checked := true
  else
    DataModule3.mnANSI.Checked := true;
  case Chpr.InnerDelimeter of
    ',':
      DataModule3.mnComma.Checked := true;
    ';':
      DataModule3.mnPointComma.Checked := true;
     #9:
      DataModule3.mnTab.Checked := true;
     #0:
      DataModule3.mnNull.Checked := true;
  end;
  BankListType:=blNone;
  for I := 0 to 2 do begin
    BankColumn := chpr.FieldNames.IndexOf(BankColumnName[i]);
    if BankColumn=-1 then Continue;
    case I of
      0: BankListType:=blChoice;
      1: BankListType:=blSV2;
      2: begin
        if chpr.Values[0][0]='��������� ����' then begin
          BankListType:=blOldReestr;
        end else if chpr.Values[1][0]='� ���������� ��������� �' then begin
          BankListType:=blReestr;
        end;
      end;
    end;
    Chpr.TableLength:=15000;
    break;
  end;
  CheckBankBtn.Enabled := BankColumn <> -1;
end;

procedure TForm9.Timer1Timer(Sender: TObject);
begin
 if FKey=0 then begin
   DataModule3.Timer1.Enabled:=false;
   Exit;
 end;
 KeyPreview:=false;
 lstMaster.Perform(WM_KEYDOWN,FKey,0);
 lstMaster.Perform(WM_KEYUP,FKey,0);
 KeyPreview:=true;
 FKey:=0;
 //lstMaster.OnClick(lstMaster);
end;

procedure TForm9.ToolButton10Click(Sender: TObject);
begin
  chpr.SaveAsFlat('d:\!Test\test.flat');
end;

procedure TForm9.ToolButton2Click(Sender: TObject);
begin
  FontSize:=FontSize+1;
end;

procedure TForm9.ToolButton4Click(Sender: TObject);
begin
  if FontSize<=6 then Exit;
  FontSize:=FontSize-1;
end;

procedure TForm9.ToolButton9Click(Sender: TObject);
begin
  ImportDlg.Execute;
end;

procedure TForm9.WMDropFiles(var Message: TMessage);
var
  size: integer;
  Filename: string;
begin
  inherited;
  size := DragQueryFile(Message.WParam, 0 , nil, 0) + 1;
  SetLength(Filename,size);
  DragQueryFile(Message.WParam, 0 , PChar(Filename), size);
  DragFinish(Message.WParam);
  SetLength(Filename,size-1);
  OpenFile(Filename);
end;

procedure TForm9.NewBtnClick(Sender: TObject);
begin
  Options.Load;
  ShowFirstList;
end;

procedure TForm9.lbReklamaMouseEnter(Sender: TObject);
begin
  lbReklama.Font.Color:=clBlue;
  lbReklama.Font.Style:=[fsUnderline];
  lbReklama.Cursor:=crHandPoint;
end;

procedure TForm9.lbReklamaMouseLeave(Sender: TObject);
begin
  lbReklama.Font.Color:=clBlack;
  lbReklama.Font.Style:=[];
  lbReklama.Cursor:=crDefault;
end;

procedure TForm9.lstMasterDblClick(Sender: TObject);
begin
  PrintSpravka;
end;

procedure TForm9.lstDetailsDblClick(Sender: TObject);
var
  Ind:Integer;
  S: string;
  P: Integer;
begin
  Ind:=lstDetails.ItemIndex;
  if Ind=-1 then Exit;
  S:=lstDetails.Items[Ind];
  P:=pos(':',S);
  if P>0 then System.Delete(S,1,p+1);
  Edit1.Text:=PublStr.Trim(S);
  SpeedButton1.Click;
end;

procedure TForm9.ListBoxClick(Sender: TObject);
var
  Ind:Integer;
  I:Integer;
  sts:TStrings;
  FCnt: Integer;
  L: Integer;
begin
 Ind:=lstMaster.ItemIndex;
 if OutSide(Ind,lstMaster.Items.Count-1) then Exit;
 lstDetails.Clear;
 Ind := ChprIndex;
 if OutSide(Ind,Chpr.Count-1) then Exit;
 sts:=Chpr.Values[Ind];
 FCnt:=Chpr.FieldNames.Count;
 MaxWidth:=0;
 for I := 0 to sts.Count - 1 do begin
   if OutSide(I,FCnt-1)
   then L:=4
   else L:=Length(Chpr.FieldNames[I]);
   if MaxWidth<L then MaxWidth:=L;
 end;
 if MaxWidth>25 then MaxWidth:=25;
 for I := 0 to sts.Count - 1 do begin
   if OutSide(I,FCnt-1)
   then lstDetails.AddItem(format('%:*s: %s',[MaxWidth,'--- ',sts[I]]),nil)
   else lstDetails.AddItem(format('%:*s: %s',[MaxWidth,LeftStr(Chpr.FieldNames[I],25),sts[I]]),nil);
 end;
end;

procedure TForm9.ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Ind:integer;
  ListBox:TListBox;
begin
  if not (Sender is TListBox) then Exit;
  ListBox:=Sender as TListBox;
  Ind:=ListBox.ItemAtPos(Point(x,y),true);
  if Ind=-1 then Exit;
  ListBox.ItemIndex:=Ind;
end;

procedure TForm9.mmHelpDblClick(Sender: TObject);
begin
  DataModule3.OpenDialog1.FilterIndex:=1;
  if DataModule3.OpenDialog1.Execute then begin
    if DataModule3.OpenDialog1.FilterIndex<>1 then Exit;
    CreateIndexForCSV(DataModule3.OpenDialog1.FileName,DataModule3.OpenDialog1.FileName+'.Index',0);
    CreateIndexForTxt(DataModule3.OpenDialog1.FileName,DataModule3.OpenDialog1.FileName+'.BIndex');
  end;
end;

procedure TForm9.mnStateClick(Sender: TObject);
var
  mn:TControl;
begin
  mn:=TControl(Sender);
  case mn.Tag of
    11,12: begin
      Chpr.IsTransformed:=TControl(Sender).Tag=11;
      if Chpr.IsTransformed then
        ResetEditMode;
      DataModule3.n13.Enabled:=Chpr.IsTransformed;
    end;
    21,22: Chpr.IsOEMSource:=TControl(Sender).Tag=21;
    31: Chpr.InnerDelimeter:=',';
    32: Chpr.InnerDelimeter:=';';
    33: Chpr.InnerDelimeter:=#9;
    34: Chpr.InnerDelimeter:=#0;
  end;
  OutTable;
  TextState;
end;

procedure TForm9.SpeedButton1Click(Sender: TObject);
begin
  ReturnClick;
end;

procedure TForm9.SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then Chpr.TableLength:=10000;
end;

procedure TForm9.MemoModeBtnClick(Sender: TObject);
begin
  MemoMode:=MemoModeBtn.Down;
end;

procedure TForm9.OpenBtnClick(Sender: TObject);
begin
  CaptionName:='';
  if DataModule3.OpenDialog1.Execute then
    OpenFile(DataModule3.OpenDialog1.FileName);
end;

procedure TForm9.CheckBankBtnClick(Sender: TObject);
var
  OldFilling:Boolean;
begin
  OldFilling:=Chpr.Filling;
  Chpr.Filling:=true;
  chpr.OnCustomFilter:=CheckBank;
  OutTable('��� ����� ����������');
  chpr.OnCustomFilter:=nil;
  Chpr.Filling:=OldFilling;
end;

procedure TForm9.ShowSpravkaEDK(Sender: TObject; Memo: StdCtrls.TMemo);
var
  LC:string;
  Adres:string;
  FIO:string;
  Pens:string;
  Ist:string;
  C:string;
  Po:string;
  RSts:TStringList;
  ResultStr:string;
  I: Integer;
  DateVipl,SumVipl,Bank,R1Sum,R1Date,RazSum, RazFrom, RazTo, RazNum:string;
  DateV:TDate;
  Stolbi:TStolbi;
  J: Integer;
  L: Integer;
  IntervalDlg:TPeriodDlg;
  ChprTmp: TChprList;
  Sum, SV, SR1, SRaz:Currency;
  SumR1, SumRaz:Currency;
  bbb,eee:TDate;
  TotalSum:Currency;
  UdSum: string;
  sts:TStrings;
  Value: Integer;
  procedure OutPeriod;
  var
    s, sy:string;
    sb,se:string;
  begin
    sy:=Float2Str(YearOf(bbb),0);
    sb:=AnsiReplaceStr(DateToStr(bbb),'.'+sy,'');
    se:=AnsiReplaceStr(DateToStr(eee),'.'+sy,'');
    RSts.Add(format('%s (%s-%s):',[sy,sb,se]));
    S:=format('%24.2f',[Sum]);
    if R1 in Stolbi then
      S:=S+format('%12.2f %11s',[SumR1,'']);
    S:=S+format('%12s ',['']);
    if raz in Stolbi then
      S:=S+format('%12.2f',[SumRaz]);
    TotalSum:=TotalSum+Sum+SumR1+SumRaz;
    RSts.Add(s);
  end;

begin{ TODO -o����� : ������ �������� ��������1 }
  IntervalDlg:=TPeriodDlg(Sender);
  LC:=TmpSts[10];
  FIO:=format('%s %s %s',[TmpSts[0],TmpSts[1],TmpSts[2]]);
  Adres:=format('%s ��.%s, �.%s',[TmpSts[3],TmpSts[4],ContStr(ContStr(TmpSts[5],'/',TmpSts[6]),' ��.',TmpSts[7])]);
  Pens:=TmpSts[8];
  Ist:=TmpSts[9];
  ChprTmp:= TChprList.Create;
  ChprTmp.Mode:=mdCSv;
  ChprTmp.Text:=//ResultStr;
  Chpr2.Text;
  C:=DateToStr(IntervalDlg.StartInterval);
  Po:=DateToStr(EndOfTheMonth(IntervalDlg.EndInterval));
  ResultStr:=format(SpravkaEDK,[LC,FIO,Adres,Pens,Ist,C,Po]);
  RSts:=TStringList.Create;
  RSts.Add('');
  Stolbi:=[std];
  for I := 0 to ChprTmp.Count - 2 do begin
    DateVipl:=ChprTmp.Values[i][1];
    DateV:=StrToDate(DateVipl);
    if not ((DateV>IntervalDlg.StartInterval-0.5) and (DateV<IntervalDlg.EndInterval+0.5))
    then Continue;
    RSts.Add(Float2Str(DateV,0)+ChprTmp[i+1]);
    if (ChprTmp.Values[i][3]<>'0.00') or (ChprTmp.Values[i][4]<>'') then Stolbi:=Stolbi+[R1];
    if (ChprTmp.Values[i][8]<>'0.00') or (ChprTmp.Values[i][10]<>'') or (ChprTmp.Values[i][11]<>'0') then Stolbi:=Stolbi+[raz];
    if (ChprTmp.Values[i][5]<>'') then Stolbi:=Stolbi+[ud];
  end;
  RSts.Sort;
  for I:=0 to RSts.Count-1 do
    RSts[i]:=Copy(RSts[i],6,MaxInt);
  ChprTmp.Text:=RSts.Text;
  RSts.Clear;
  ResultStr:=ResultStr+#13#10;
  for I := 0 to 3 do begin
    for J := 0 to 4 do begin
      case J of
        1: if [R1]*Stolbi=[] then Continue;
        3: if [ud]*Stolbi=[] then Continue;
        4: if [raz]*Stolbi=[] then Continue;
      end;
      ResultStr:=ResultStr+Title[I,J];
    end;
    ResultStr:=ResultStr+#13#10;
  end;
  Sum:=0;
  SumR1:=0;
  SumRaz:=0;
  bbb:=-1;
  DateV := -1;
  TotalSum:=0;
  for I := 0 to ChprTmp.Count - 2 do begin
    DateVipl:=ChprTmp.Values[I][1];
    DateV := StrToDate(DateVipl);
    SumVipl:=ChprTmp.Values[I][2];
    SV:=StrToCurr(AnsiReplaceStr(SumVipl,'.',DecimalSeparator));
    SR1:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][3],'.',DecimalSeparator));
    SRaz:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][8],'.',DecimalSeparator));
    Bank:=ChprTmp.Values[I][7];
    if bbb<>-1 then
      if YearOf(DateV)<>YearOf(bbb) then begin
        eee:=StartOfTheMonth(DateV)-1;
        OutPeriod;
        bbb:=-1;
      end;
    Sum:=Sum+SV;
    SumR1:=SumR1+SR1;
    SumRaz:=SumRaz+SRaz;
    if bbb=-1 then begin
      Sum:=SV;
      SumR1:=SR1;
      SumRaz:=SRaz;
      bbb:=StartOfTheMonth(DateV);
    end;
    ResultStr:=ResultStr+format('%s %13s ',[DateVipl,SumVipl]);
    if R1 in Stolbi then begin
      R1Sum:=ChprTmp.Values[I][3];
      R1Date:=ChprTmp.Values[I][4];
      if R1Date<>''
      then R1Date:=format('%s-%s',[R1Date,ChprTmp.Values[I][14]]);
      ResultStr:=ResultStr+format('%11s %-21s ',[R1Sum,R1Date]);
    end;
    ResultStr:=ResultStr+format('%-12s ',[Bank]);
    if ud in Stolbi then begin
      UdSum:=ChprTmp.Values[I][5];
      ResultStr:=ResultStr+format('%9s',[UdSum]);
    end;
    if raz in Stolbi then begin
      RazSum:=ChprTmp.Values[I][8];
      RazFrom:=ChprTmp.Values[I][9];
      RazTo:=ChprTmp.Values[I][10];
      RazNum:=ChprTmp.Values[I][12];
      if RazNum='' then RazNum:=ChprTmp.Values[I][11]
      else repeat
        L:=Length(RazNum);
        RazNum:=AnsiReplaceStr(RazNum,'  ',' ');
      until Length(RazNum)=L;
      ResultStr:=ResultStr+format('%11s %-10s %-11s %-15s',[RazSum,RazFrom,RazTo,RazNum]);
    end;
    for J := 0 to Chpr3.Count - 2 do begin
      sts:=Chpr3.Values[J];
      Value:=StrToInt(sts[0]);
      if Trunc(Value-DayOf(Value)+1)=Trunc(DateV) then begin
        ResultStr:=ResultStr+#13#10+format('         * ���.�/�. (��� ������� - %s): '#13#10+
        '         * %13s'#13#10+
        '         * %s-%s ������ �%s',[sts[7],sts[2],sts[3],sts[4],sts[5]]);
      end;
    end;
    ResultStr:=ResultStr+#13#10;
  end;
  if bbb<>-1 then begin
    eee:=EndOfTheMonth(DateV);
    OutPeriod;
  end;
  if RSts.Count>2 then
    ResultStr := ResultStr +#13#10'����� �� ��������:'#13#10+ RSts.Text;
  if RSts.Count>1 then
    ResultStr := ResultStr+format(#13#10'�����: %.2f'#13#10,[TotalSum]);
  MemoMode:=true;
  Memo.Text:=ResultStr;
//  Memo.Lines.AddStrings(Chpr2.asTable);
//  Memo.Lines.AddStrings(Chpr3.asTable);
  RSts.Free;
  ChprTmp.Free;
end;

procedure TForm9.ShowSpravkaF5(Sender: TObject; Memo: StdCtrls.TMemo);
var
  IntervalDlg:TPeriodDlg;
begin
  IntervalDlg:=TPeriodDlg(Sender);
  if IntervalDlg.Trigger[1]
  then ShowSverka(Sender,Memo)
  else ShowSpravkaF5_1(Sender,Memo);
end;

procedure TForm9.ShowSpravkaF5_1;
var
  DateVipl: string;
  LC: string;
  FIO: string;
  Adres: string;
  EyEmu: string;
  D_Nazn: string;
  ResultStr: string;
  DateV: TDate;
  SumVipl: string;
  SV:Currency;
  Month: string;
  RSts: TStringList;
  I: Integer;
  IntervalDlg:TPeriodDlg;
  ChprTmp: TChprList;
  Sum:Currency;
  Dopl:Currency;
begin
  IntervalDlg:=TPeriodDlg(Sender);
  LC := TmpSts[0];
  FIO := format('%s %s %s', [TmpSts[1], TmpSts[2], TmpSts[3]]);
  Adres := format('%s ��.%s, �.%s', [TmpSts[4], TmpSts[5], ContStr(ContStr(TmpSts[6], '/', TmpSts[7]), ' ��.', TmpSts[8])]);
  FIO := AnsiUpperCase(FIO);
  FIO := StringOfChar(' ', 33 - Length(FIO) div 2) + FIO;
  Adres := AnsiUpperCase(Adres);
  Adres := StringOfChar(' ', 33 - Length(Adres) div 2) + Adres;
  if SameText(TmpSts[9], '�') then
    EyEmu := '��'
  else
    EyEmu := '���';
  D_Nazn := TmpSts[10];
  ResultStr := format(SpravkaF5, [LC, FIO, Adres, D_Nazn, EyEmu]);
  RSts := TStringList.Create;
  RSts.Add('');
  for I := 0 to Chpr2.Count - 2 do
  begin
//    DateVipl := DbfDateToPlainDate(chpr2.Values[i][1]);
    DateVipl := chpr2.Values[i][1];
    DateV := StrToDate(DateVipl);
    if not ((DateV > IntervalDlg.StartInterval - 0.5) and (DateV < IntervalDlg.EndInterval + 0.5)) then
      Continue;
    //if chpr.Values[i][0]<>s then Continue;
    RSts.Add(Float2Str(DateV, 0) + chpr2[i + 1]);
  end;
  RSts.Sort;
  for I := 0 to RSts.Count - 1 do
    RSts[i] := Copy(RSts[i], 6, MaxInt);
  ChprTmp:= TChprList.Create;
  ChprTmp.Mode := mdCsv;
  ChprTmp.Text := RSts.Text;
  RSts.Clear;
  ResultStr := ResultStr + #13#10;
  Sum:=0;
  for I := 0 to ChprTmp.Count - 2 do
  begin
    //    DateVipl := DbfDateToPlainDate(ChprTmp.Values[I][1]);
    DateVipl := ChprTmp.Values[I][1];
    DateV := StrToDate(DateVipl);
    SumVipl := ChprTmp.Values[I][2];
    SV:=StrToCurr(AnsiReplaceStr(Sumvipl,'.',DecimalSeparator));
    Dopl:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][15],'.',DecimalSeparator));
    Sum:=Sum+SV;
    Month := AnsiUpperCase(LongMonthNames[MonthOf(DateV)]);
    ResultStr := ResultStr + format('     %-9s %10s  �� ������ � %s �� %s', [Month, SumVipl, DateVipl, DateToStr(EndOfTheMonth(DateV))]);
    if Dopl<>0 then
      if dopl<0
      then ResultStr := ResultStr + format(' (�����. %.2f)',[Abs(dopl)])
      else ResultStr := ResultStr + format(' (����.  %.2f)',[Abs(dopl)]);
    //      ResultStr:=ResultStr+format('%-12s ',[Bank]);
    ResultStr := ResultStr + #13#10;
  end;
    ResultStr := ResultStr +format(#13#10'  �����: %.2f'#13#10,[Sum]);
  ResultStr := ResultStr + format(SpravkaF5Niz, [DateToStr(Date)]);
  if Memo=Memo1 then begin
    MemoMode := True;
  end;
  Memo.Text := ResultStr;
  RSts.Free;
  ChprTmp.Free;
end;

{$REGION 'f5_2'}
  //procedure TForm9.ShowSpravkaF5_2(Sender: TObject; Memo: StdCtrls.TMemo);
  //var
  //  DateVipl: string;
  //  LC: string;
  //  FIO: string;
  //  D_Nazn: string;
  //  ResultStr: string;
  //  DateV: TDate;
  //  SumVipl: string;
  //  SV:Currency;
  //  Month: string;
  //  C_, Po_:string;
  //  RSts: TStringList;
  //  I: Integer;
  //  IntervalDlg:TPeriodDlg;
  //  ChprTmp: TChprList;
  //  Sum:Currency;
  //  Dopl: Extended;
  //  SumDopl: string;
  //  Adres: string;
  //begin
  //  IntervalDlg:=TPeriodDlg(Sender);
  //  LC := TmpSts[0];
  //  FIO := AnsiUpperCase(format('%s %s %s', [TmpSts[1], TmpSts[2], TmpSts[3]]));
  //  Adres := format('%s ��.%s, �.%s', [TmpSts[4], TmpSts[5], ContStr(ContStr(TmpSts[6], '/', TmpSts[7]), ' ��.', TmpSts[8])]);
  //  Adres := AnsiUpperCase(Adres);
  //  D_Nazn := TmpSts[10];
  //  C_:=DateToStr(IntervalDlg.StartInterval);
  //  Po_:=DateToStr(IntervalDlg.EndInterval);
  //  ResultStr := '';
  //  RSts := TStringList.Create;
  //  RSts.Add('');
  //  for I := 0 to Chpr2.Count - 2 do
  //  begin
  //    DateVipl := chpr2.Values[i][1];
  //    DateV := StrToDate(DateVipl);
  //    if not ((DateV > IntervalDlg.StartInterval - 0.5) and (DateV < IntervalDlg.EndInterval + 0.5)) then
  //      Continue;
  //    RSts.Add(Float2Str(DateV, 0) + chpr2[i + 1]);
  //  end;
  //  RSts.Sort;
  //  for I := 0 to RSts.Count - 1 do
  //    RSts[i] := Copy(RSts[i], 6, MaxInt);
  //  ChprTmp:= TChprList.Create;
  //  ChprTmp.Mode := mdCsv;
  //  ChprTmp.Text := RSts.Text;
  //  RSts.Clear;
  //  Sum:=0;
  //  ResultStr := '         ������ ����������� �������� � �������� ���������� ��������';
  //  ResultStr := ResultStr + #13#10;
  //  ResultStr := ResultStr + #13#10'� ������� ����   '+LC;
  //  ResultStr := ResultStr + #13#10'�.�.�.           '+FIO;
  //  ResultStr := ResultStr + #13#10'�����            '+Adres;
  //  ResultStr := ResultStr + #13#10'���� ���������   '+D_Nazn;
  //  ResultStr := ResultStr + format(#13#10'��������� �������� �� ������ � %s �� %s',[C_, Po_]);
  //  ResultStr := ResultStr + #13#10;
  //  ResultStr := ResultStr + #13#10'|---|---------|------------|----------------|-------------------------------|-------------|';
  //  ResultStr := ResultStr + #13#10'| � | �����,  | ������     | � ��� �����    | ����������� ������� �� ������ | � ��������� |';
  //  ResultStr := ResultStr + #13#10'|   | ���     | ���������� | ���������,     | ��� (����������  �����, ���,  |             |';
  //  ResultStr := ResultStr + #13#10'|   |         | ��������   | ��������       | ����, ��.�������, ���������)  |             |';
  //  ResultStr := ResultStr + #13#10'|   |         |            |                | �� �����                      |             |';
  //  ResultStr := ResultStr + #13#10'|---|---------|------------|----------------|-------------------------------|-------------|';
  //  for I := 0 to ChprTmp.Count - 2 do
  //  begin
  //    DateVipl := ChprTmp.Values[I][1];
  //    DateV := StrToDate(DateVipl);
  //    SumVipl := ChprTmp.Values[I][2];
  //    SV:=StrToCurr(AnsiReplaceStr(Sumvipl,'.',DecimalSeparator));
  //    Dopl:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][15],'.',DecimalSeparator));
  //    SumDopl:='';
  //    if Dopl<>0 then
  //      if dopl<0
  //      then SumDopl:= format('�����. %.2f',[Abs(dopl)])
  //      else SumDopl:= format('����. %.2f',[Abs(dopl)]);
  //    Sum:=Sum+SV;
  //    Month := format('%s.%s',[ToZeroStr(MonthOf(DateV),2),IntToStr(YearOf(DateV))]);
  //    ResultStr := ResultStr + format(#13#10'| %d | %7s | %10s | %6s |--------|--------|--------|--------|--------|-------|------|',[I+1,Month,SumVipl,SumDopl]);
  //    if I=ChprTmp.Count-2
  //    then
  //      ResultStr := ResultStr + #13#10'|==========================================================================================|'
  //    else
  //      ResultStr := ResultStr + #13#10'|----|---------|------------|----------------|-------------------------------|-------------|';
  //  end;
  //  ResultStr := ResultStr + format(#13#10'| �����        | %10.2g |                |                               |             |',[Sum]);
  //  ResultStr := ResultStr + #13#10'============================================================================================';
  //  ResultStr := ResultStr + #13#10'|   ���ר��    |____________|________________|_______________________________|_____________|';
  //  ResultStr := ResultStr + #13#10'|              |            |                |                               |             |';
  //  ResultStr := ResultStr + #13#10'============================================================================================';
  //  ResultStr := ResultStr + #13#10'';
  //  ResultStr := ResultStr + #13#10'� ��������� __________________���.';
  //  ResultStr := ResultStr + #13#10'';
  //  ResultStr := ResultStr + #13#10'���������� ___________________';
  //  ResultStr := ResultStr + #13#10'';
  //  ResultStr := ResultStr + #13#10'��������   ___________________';
  //  ResultStr := ResultStr + #13#10'';
  //  ResultStr := ResultStr + #13#10'�.�.';
  //
  ////  ResultStr := ResultStr +format(#13#10'  �����: %.2f'#13#10,[Sum]);
  ////  ResultStr := ResultStr + format(SpravkaF5Niz, [DateToStr(Date)]);
  //  if Memo=Memo1 then begin
  //    MemoModeBtn.Down := True;
  //    Panel4.Visible := False;
  //  end;
  //  Memo.Text := ResultStr;
  //  RSts.Free;
  //  ChprTmp.Free;
  //end;
  
{$ENDREGION}
const
  Golova1:string =
          '         ������ ����������� �������� � �������� ���������� ��������'
  + #13#10
  + #13#10'� ������� ����   %s'
  + #13#10'�.�.�.           %s'
  + #13#10'�����            %s'
  + #13#10'���� ���������   %s';

  Golova2:string = #13#10'��������� �������� �� ������ � %s �� %s';

  Golova3:string = #13#10
  + #13#10'|----|---------|-------------|-------------|----------------|--------|--------|--------|--------|--------|--------|--------|--------|'
  + #13#10'| �  | �����,  | ������      |  ������     | � ��� �����    |        |        | �����- | ����-  |        | �����  |        |        |'
  + #13#10'|    | ���     | ��������    |  ���������� | ���������,     |  ���   |  ���   | ������-| ����-  | ������ |  ���.  | ����-  |  ���-  |'
  + #13#10'|    |         | �� �������  |  ��������   | ��������       |        |        |  ���   | �����  |        | ������ | �����  |  ����  |'
  + #13#10'|    |         |             |             |                |        |        |        |        |        |        |        |        |'
  + #13#10'|----|---------|-------------|-------------|----------------|--------|--------|--------|--------|--------|--------|--------|--------|';
                                                                                                                                             
  Hvost:string =                                                                                                                             
    #13#10'====================================================================================================================================='
  + #13#10'|   ���ר��    |_____________|_____________|________________|________|________|________|________|________|________|________|________|'
  + #13#10'|              |             |             |                |        |        |        |        |        |        |        |        |'
  + #13#10'====================================================================================================================================='
  + #13#10''
  + #13#10'� ��������� __________________���.'
  + #13#10''
  + #13#10'� �������   __________________���.'
  + #13#10''
  + #13#10'���������� ___________________'
  + #13#10''
  + #13#10'��������   ___________________'
  + #13#10''
  + #13#10'�.�.';

  sep1:string = #13#10'|===================================================================================================================================|';

  sep2:string = #13#10'|----|---------|-------------|-------------|----------------|--------|--------|--------|--------|--------|--------|--------|--------|';

  Itog:string = #13#10'| �����        | %11s | %11.2g |                |        |        |        |        |        |        |        |        |';

procedure TForm9.ShowSverka(Sender: TObject; Memo: StdCtrls.TMemo);
var
  DateVipl: string;
  LC: string;
  FIO: string;
  D_Nazn: string;
  ResultStr: string;
  DateV: TDate;
  SumVipl: string;
  SV:Currency;
  Month: string;
  C_, Po_:string;
  RSts: TStringList;
  I: Integer;
  IntervalDlg:TPeriodDlg;
  ChprTmp: TChprList;
  Sum:Currency;
  Dopl: Extended;
  SumDopl: string;
  Adres: string;
  LastOtvet:Extended;
  Otvet: Extended;
begin
  IntervalDlg:=TPeriodDlg(Sender);
  LC := TmpSts[0];
  FIO := AnsiUpperCase(format('%s %s %s', [TmpSts[1], TmpSts[2], TmpSts[3]]));
  Adres := format('%s ��.%s, �.%s', [TmpSts[4], TmpSts[5], ContStr(ContStr(TmpSts[6], '/', TmpSts[7]), ' ��.', TmpSts[8])]);
  Adres := AnsiUpperCase(Adres);
  D_Nazn := TmpSts[10];
  C_:=DateToStr(IntervalDlg.StartInterval);
  Po_:=DateToStr(IntervalDlg.EndInterval);
  ResultStr := '';
  RSts := TStringList.Create;
  RSts.Add('');
  for I := 0 to Chpr2.Count - 2 do
  begin
    DateVipl := chpr2.Values[i][1];
    DateV := StrToDate(DateVipl);
    if not ((DateV > IntervalDlg.StartInterval - 0.5) and (DateV < IntervalDlg.EndInterval + 0.5)) then
      Continue;
    RSts.Add(Float2Str(DateV, 0) + chpr2[i + 1]);
  end;
  RSts.Sort;
  for I := 0 to RSts.Count - 1 do
    RSts[i] := Copy(RSts[i], 6, MaxInt);
  ChprTmp:= TChprList.Create;
  ChprTmp.Mode := mdCsv;
  ChprTmp.Text := RSts.Text;
  RSts.Clear;
  Sum:=0;
  ResultStr := ResultStr + format(Golova1,[LC,FIO,Adres,D_Nazn]);
  ResultStr := ResultStr + format(Golova2,[C_, Po_]);
  ResultStr := ResultStr + Golova3;
  LastOtvet:=0;
  for I := 0 to ChprTmp.Count - 2 do
  begin
    DateVipl := ChprTmp.Values[I][1];
    DateV := StrToDate(DateVipl);
    SolveF7(DateV, LastOtvet, Otvet);
    SumVipl := ChprTmp.Values[I][2];
    SV:=StrToCurr(AnsiReplaceStr(Sumvipl,'.',DecimalSeparator));
    Dopl:=StrToCurr(AnsiReplaceStr(ChprTmp.Values[I][15],'.',DecimalSeparator));
    SumDopl:='';
    if Dopl<>0 then
      if dopl<0
      then SumDopl:= format('�����. %.2f',[Abs(dopl)])
      else SumDopl:= format('����. %.2f',[Abs(dopl)]);
    Sum:=Sum+SV;
    Month := format('%s.%s',[ToZeroStr(MonthOf(DateV),2),IntToStr(YearOf(DateV))]);
    ResultStr := ResultStr + format(#13#10'| %2d | %6s | %11.2f | %11s | %14s |        |        |        |        |        |        |        |        |',[I+1,Month,Otvet,SumVipl,SumDopl]);
    if I=ChprTmp.Count-2
    then
      ResultStr := ResultStr + sep1
    else
      ResultStr := ResultStr + sep2;
  end;
  ResultStr := ResultStr + format(Itog,['',Sum]);
  ResultStr := ResultStr + Hvost;
  //ResultStr := ResultStr + #13#10+Chpr3.Text;
  if Memo=Memo1 then begin
    MemoMode := True;
  end;
  Memo.Text := ResultStr;
  RSts.Free;
  ChprTmp.Free;
end;

procedure TForm9.pnMasterResize(Sender: TObject);
begin
  Memo3.Margins.Right:=lstMaster.Width-lstMaster.ClientWidth;
end;

function TForm9.PrepareEDKResult(s: string): boolean;
begin
  Result:=PrepareFindResult(s,'base1');
end;

function TForm9.PrepareF5Result(s: string):boolean;
begin
  Result:=PrepareFindResult(s, 'f5');
end;

function F7Sort(List: TStringList; Index1, Index2: Integer): Integer;
var
 n1,n2:string;
 s1,s2:string;
 d1,d2:TDate;
 v1,v2:Extended;
 Lst:TChprList;
begin
  Result:=Math.CompareValue(Index1,Index2);
  if (Index1=0) or (Index2=0) then Exit;
  if not (List is TChprList) then Exit;
  dec(Index1);
  dec(Index2);
  Lst:=TChprList(List);
  n1:=lst.ValueByName[Index1,'N'];
  n2:=lst.ValueByName[Index2,'N'];
  Result:=CompareStr(n1,n2);
  if Result=0 then Exit;
  s1:=lst.ValueByName[Index1,'SUB_C'];
  s2:=lst.ValueByName[Index2,'SUB_C'];
  d1:=StrToDateDef(s1,0);
  d2:=StrToDateDef(s2,0);
  Result:=CompareDate(d1,d2);
  if Result<>0 then Exit;
  s1:=lst.ValueByName[Index1,'DATMP_F'];
  s2:=lst.ValueByName[Index2,'DATMP_F'];
  d1:=StrToDateDef(s1,0);
  d2:=StrToDateDef(s2,0);
  Result:=CompareDate(d1,d2);
  if Result<>0 then Exit;
  s1:=lst.ValueByName[Index1,'OLD_SUB'];
  s1:=AnsiReplaceStr(s1,'.',DecimalSeparator);
  s2:=lst.ValueByName[Index2,'SUBSID'];
  s2:=AnsiReplaceStr(s2,'.',DecimalSeparator);
  v1:=StrToFloatDef(s1,0);
  v2:=StrToFloatDef(s2,-1);
  if Math.SameValue(v1,v2) then begin
    s2:=lst.ValueByName[Index1,'SUBSID'];
    s2:=AnsiReplaceStr(s2,'.',DecimalSeparator);
    v2:=StrToFloatDef(s2,-1);
    Result:=IfThen(Math.SameValue(v1,v2),0,1);
  end;
  if Result<>0 then Exit;
//  s1:=lst.ValueByName[Index2,'OLD_SUB'];
//  s1:=AnsiReplaceStr(s1,'.',DecimalSeparator);
//  s2:=lst.ValueByName[Index1,'SUBSID'];
//  s2:=AnsiReplaceStr(s2,'.',DecimalSeparator);
//  v1:=StrToFloatDef(s1,0);
//  v2:=StrToFloatDef(s2,-1);
//  if Math.SameValue(v1,v2) then begin
//    s2:=lst.ValueByName[Index2,'SUBSID'];
//    s2:=AnsiReplaceStr(s2,'.',DecimalSeparator);
//    v2:=StrToFloatDef(s2,-1);
//    Result:=IfThen(Math.SameValue(v1,v2),0,-1);
//  end;
//  if Result<>0 then Exit;
  Result:=CompareStr(n1,n2);
end;

function TForm9.PrepareFindResult(s, Table2: string): boolean;
var
  Ind: Integer;
  FastBase: TFastFileStrList;
  I: integer;
  DateX: string;
  DateDo: string;
begin
  Result:=false;
  { TODO -o����� : ������ �������� ��������1 }
  Ind := lstMaster.ItemIndex;
  if OutSide(Ind, lstMaster.Items.Count - 1) then Exit;
  Ind := ChprIndex;
  if Ind = -1 then Exit;
  TmpSts.Assign(Chpr.values[Ind]);
  FastBase := TFastFileStrList.Create;
  try
    FastBase.BaseName := FSpravkaPath + Table2 + '.csv';
    FastBase.BaseIndexFile := FSpravkaPath + Table2 +'.Index';
    FastBase.Filter := s;
    if Table2='base1' then begin
      for I := 0 to FastBase.Count - 1 do begin
        if I = 0
        then FastBase[I] := FastBase[I]+';DO'
        else FastBase[I] := FastBase[I]+';';
      end;
    end;
    Chpr2.Clear;
    Chpr2.Mode := mdCsv;
    Chpr2.Text := {ResultStr;} FastBase.Text;
  finally
    FastBase.Free;
  end;

  if Table2='f5' then begin
    FastBase := TFastFileStrList.Create;
    try
      FastBase.ShowFields.CommaText:=FieldsF7_DB1;
      FastBase.BaseName := FSpravkaPath + 'f7' + '.csv';
      FastBase.BaseIndexFile := FSpravkaPath + 'f7' +'.Index';
      FastBase.Filter := s;
      for I := 0 to FastBase.Count - 1 do begin
        if I = 0
        then FastBase[I] := 'N;' + FastBase[I]
        else FastBase[I] := IntToHex(I,8) + ';' + FastBase[I];
      end;
      Chpr3.Clear;
      Chpr3.Mode := mdCsv;
      Chpr3.Text := {ResultStr;} FastBase.Text;
      //    ShowMessage('Log1.csv');
      //    chpr3.SaveToFile('Log1.csv');
      Chpr3.CustomSort(F7Sort);
    finally
      FastBase.Free;
    end;
//    ShowMessage('Log2.csv');
//    chpr3.SaveToFile('Log2.csv');
  end;
  if Table2='base1' then begin
    for I := 0 to chpr2.Count - 2 do begin
      DateX:=chpr2.Values[I][4];
      if DateX<>'' then begin
        DateDo:=DateToStr(StrToDateDef(chpr2.Values[I][1],1)-1);
        chpr2[I+1]:=chpr2[I+1]+DateDo;
      end;
    end;

    FastBase := TFastFileStrList.Create;
    try
      FastBase.ShowFields.CommaText:=FieldsTab;
      FastBase.BaseName := FSpravkaPath + 'base3' + '.csv';
      FastBase.BaseIndexFile := FSpravkaPath + 'base3' +'.Index';
      FastBase.Filter := s;
      FastBase[0] := 'DateC;'+FastBase[0];
      Chpr3.Clear;
      Chpr3.Mode := mdCsv;
      Chpr3.Text := FastBase.Text;
    finally
      //Chpr3.CustomSort(F7Sort);
      FastBase.Free;
    end;

    for I := 0 to Chpr3.Count - 2 do begin
      Chpr3[I+1] := IntToStr(Trunc(StrToDateDef(Chpr3.Values[I][7],0)))+';'+Chpr3[I+1];
    end;
    chpr3.Text := Chpr3.Text;
    chpr3.SortedField:=0;
  end;
  Result:=true;
end;

function TForm9.GetValidLS(s: string): string;
begin
  Result:=s;
  if length(s)>8 then Exit;
  Result := LeftStr('9000000', 7 - length(s)) + s;
end;

procedure TForm9.JournalBtnClick(Sender: TObject);
begin
  JournalClick(nil);
end;

procedure TForm9.JournalClick(Sender: TObject);
begin
  PagePanel.ActivePageIndex:=2;
  FSpravkaType:=sptJournal;
end;

function TForm9.GetDetail: string;
var
  Param:string;
begin
  SeparateDetail(-1,Param,Result);
end;

procedure TForm9.AddActToList(I: Integer;Event:TNotifyEvent);
var
  Action: TAction;
begin
  Action := TAction.Create(nil);
  Action.OnExecute := Event;
  Action.Tag := I;
  ActList.Add(Action);
end;

function TForm9.GetFileNameForExcel: string;
begin
  if GetKeyState(VK_CONTROL)<0 then
    if GetKeyState(VK_LSHIFT)<0 then
      Result := DataModule3.OpenDialog1.FileName + '.txt'
    else
      Result := DataModule3.OpenDialog1.FileName + '.csv'
  else
    Result := TempPath + ExtractFileName(DataModule3.OpenDialog1.FileName) + '.csv';
end;

function TForm9.MaxStringLength(S:string):Integer;
var
  Lines: TStringList;
  I: Integer;
  L: Integer;
begin
  Lines := TStringList.Create;
  Lines.Text:=S;
  Result:=0;
  for I := 0 to Lines.Count - 1 do begin
    L:=Length(TrimRight(Lines[i]));
    if L>Result then Result:=L;
  end;
  Lines.Free;
end;

procedure TForm9.PrintBtnClick(Sender: TObject);
var
  I: Integer;
  MaxLength: Integer;
  s:string;
  st:string;
  Lines:TStrings;
  st1: string;
  fn: string;
  sts: TStringList;
  TmpStr:string;
  IsDbfReestr:Boolean;
begin
  fn:=AnsiUpperCase(ExtractFileName(DataModule3.OpenDialog1.FileName));
  IsDbfReestr:=(fn<>'') and (fn[1] in ['F','T'])
  and (ExtractFileExt(fn)='.DBF') and (Chpr.Filter='');

  if MemoMode or IsDbfReestr
  then Lines:=Memo1.Lines
  else Lines:=lstMaster.Items;

  if IsDbfReestr then begin
    Lines.BeginUpdate;
    sts := TStringList.Create;
    sts.Assign(Chpr);
    TmpStr:=sts.Text;
    sts.Delete(0);
    Lines.Clear;
    for I := 4 downto 0 do begin
      Lines.add(AnsiReplaceStr(sts[i],';',' '));
      sts.Delete(I);
    end;
    Chpr.Text:=sts.Text;
    sts.Free;
    Chpr.IsOEMSource:=false;
    Lines.AddStrings(Chpr.AsTable);
    Lines.Add('');
    Lines.Add('������������:___________________');
    Lines.Add('');
    Lines.Add('��������:_______________________');
    Lines.EndUpdate;
    // PagePanel.ActivePageIndex:=1
  end;

  MaxLength:=MaxStringLength(Lines.Text);
  if MaxLength>=100
    then Printer.Orientation:=poLandscape
    else Printer.Orientation:=poPortrait;

  if DataModule3.PrintDialog1.Execute then begin
    s:=Lines.Text;
    if not MemoMode and not IsDbfReestr
    then begin
      st:=Memo3.Text;
      // if Memo3.Lines[Memo3.Lines.Count-1]='' then;
      st1:=st;
      for I := 1 to length(st) do
        if st[i]<>'|' then st1[i]:='-';
      s:=st+#13#10+st1+#13#10+s;
      if DataModule3.n13.Enabled and DataModule3.n13.Checked then s:=Chpr.Head+#13#10+s;
      if Edit1.Text<>'' then
        s:=format('�� ���������� ������� "%s" ������� %d �� %d �������:'#13#10+
        #13#10+
        '%s',[Edit1.Text,Chpr.FilterCount-1,Chpr.Count-1,s]);
    end;

    if Pos('EPSON',AnsiUpperCase(Printer.Printers[Printer.PrinterIndex]))>0 then begin
      PrintToEpson(S);
    end else PrintToLaser2(S,DataModule3.OpenDialog1.FileName,Memo1.Font.Name);
    if IsDbfReestr then begin
      Chpr.Text:=TmpStr;
    end;
  end;
end;

procedure TForm9.ExcelAsIsBtnClick(Sender: TObject);
begin
  chpr.Filling:=false;
  SaveToTmpCsv;
  chpr.Filling:=true;
end;

procedure TForm9.ExcelFillBtnClick(Sender: TObject);
begin
  chpr.Filling:=true;
  SaveToTmpCsv;
end;

{ TListBox }

procedure TListBox.WMHScroll(var Message: TWMHScroll);
begin
  if Message.ScrollCode=SB_THUMBPOSITION then begin;
    //Form9.lbReklama.Caption:=format('%d/%d',[Message.Pos,Form9.lstMaster.ClientWidth]);
    SendMessage(Form9.Memo3.Handle,WM_HSCROLL,SB_THUMBPOSITION +Message.Pos shl 16,0);
    //SetScrollPos(Form9.Memo3.Handle,SB_HORZ,Message.Pos,True);
  end;
  inherited;
end;

{ TMemo }

//procedure TMemo.SBM_SETRANGE(var Message: TMessage);
//begin
//  inherited;
//  Form9.Caption:='!';
//end;

initialization
  LogLock;
  LogWindowActivate;
end.

