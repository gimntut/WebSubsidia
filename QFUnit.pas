unit QFUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, ComCtrls, StdCtrls, ToolWin,
  cgsCHPR, XPMan, ImgList, Menus;

type
  TForm9 = class(TForm)
    ToolBar1: TToolBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Edit1: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ToolButton1: TToolButton;
    Splitter1: TSplitter;
    SpeedButton1: TSpeedButton;
    TrackBar1: TTrackBar;
    OpenDialog1: TOpenDialog;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    ToolButton2: TToolButton;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    ToolButton4: TToolButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Label2: TLabel;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ToolButton2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FavorClick(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolButton8Click(Sender: TObject);
  private
    Chpr:TChprList;
    Table:TStringList;
    p: Integer;
    FavoriteFiles:TStringList;
    FavoritePath:string;
    procedure ShowFavorite;
    procedure OpenFile(FileName: string);
    procedure OutTable;
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation
uses Publ, PublFile, ShellAPI;
{$R *.dfm}

procedure TForm9.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then Key:=0;
  
end;

procedure TForm9.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  case ord(Key) of
    VK_RETURN: Key:=#0;
  end;
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  //
  Chpr:=TChprList.Create;
  Chpr.InnerDelimeter:=';';
  Chpr.IsOEMSource:=true;
  Chpr.IsTransformed:=true;
  Chpr.Filling:=true;
  Table:=TStringList.Create;
  FavoriteFiles:=TStringList.Create;
  FavoritePath:=ProgramPath+'\favorites.txt';
  if FileExists(FavoritePath)
  then FavoriteFiles.LoadFromFile(FavoritePath);
  ShowFavorite;
end;

procedure TForm9.FormDestroy(Sender: TObject);
begin
  Chpr.Free;
  Table.Free;
  FavoriteFiles.Free;
end;

procedure TForm9.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case ShortCut(Key,Shift) of
    VK_RETURN: SpeedButton1.Click;
    scAlt+VK_RETURN: if WindowState=wsMaximized
                     then WindowState:=wsNormal
                     else WindowState:=wsMaximized;
    VK_DOWN: begin
      if ActiveControl is TListBox then Exit;
      if OutSide(ListBox1.ItemIndex,-1,ListBox1.Items.Count-2) then Exit;
      ListBox1.ItemIndex:=ListBox1.ItemIndex+1;
      ListBox1.OnClick(ListBox1);
    end;
    VK_UP: begin
      if ActiveControl is TListBox then Exit;
      if OutSide(ListBox1.ItemIndex,1,MaxInt) then Exit;
      ListBox1.ItemIndex:=ListBox1.ItemIndex-1;
      ListBox1.OnClick(ListBox1);
    end;
    scCtrl+ORD('O'): begin
      ToolButton1.Click;
    end;
    VK_ESCAPE: begin
      Edit1.Text:='';
      SpeedButton1.Click;
    end;
  end;
  Key:=0;
end;

procedure TForm9.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'open','mailto:gimntut@list.ru','','',SW_SHOWNORMAL);
end;

procedure TForm9.ShowFavorite;
var
  I: Integer;
  it: TMenuItem;
begin
  for I := PopupMenu1.Items.count - 4 to 0 do
    PopupMenu1.Items.Delete(I);
  for I := 0 to FavoriteFiles.Count - 1 do
  begin
    it := TMenuItem.Create(PopupMenu1);
    it.Caption := GetShortHint(FavoriteFiles[I]);
    it.Tag := I;
    it.OnClick:=FavorClick;
    PopupMenu1.Items.Insert(I, it);
  end;
end;

procedure TForm9.OpenFile(FileName: string);
begin
  if AnsiUpperCase(ExtractFileExt(FileName)) = '.CSV' then
  begin
    Chpr.IsTransformed := false;
    Chpr.IsOEMSource := false;
    ToolButton8.Down := false;
  end
  else
  begin
    Chpr.IsTransformed := true;
    Chpr.IsOEMSource := true;
    ToolButton8.Down := true;
  end;
  Chpr.LoadFromFile(FileName);
  ToolButton2.Enabled := chpr.FieldNames.IndexOf('N счета в банке') <> -1;
  OutTable;
end;

procedure TForm9.OutTable;
begin
  Table.Assign(Chpr.AsTable);
  Label1.Caption := Table[0];
  Table.Delete(1);
  Table.Delete(0);
  ListBox1.Items.BeginUpdate;
  ListBox1.Items := Table;
  ListBox1.Items.EndUpdate;
end;

procedure TForm9.Label2MouseEnter(Sender: TObject);
begin
  Label2.Font.Color:=clBlue;
  Label2.Font.Style:=[fsUnderline];
  Label2.Cursor:=crHandPoint;
end;

procedure TForm9.Label2MouseLeave(Sender: TObject);
begin
  Label2.Font.Color:=clBlack;
  Label2.Font.Style:=[];
  Label2.Cursor:=crDefault;
end;

procedure TForm9.ListBox1Click(Sender: TObject);
var
  Ind:Integer;
  I:Integer;
  sts:TStrings;
  FCnt: Integer;
begin
 Ind:=ListBox1.ItemIndex;
 if OutSide(Ind,ListBox1.Items.Count-1) then Exit;
 ListBox2.Clear;
 Ind:=Integer(ListBox1.Items.Objects[Ind]);
 if OutSide(Ind,Chpr.Count-1) then Exit;
 sts:=Chpr.Values[Ind];
 FCnt:=Chpr.FieldNames.Count;
 for I := 0 to sts.Count - 1 do begin
   if OutSide(I,FCnt-1)
   then ListBox2.AddItem('--- :'#9+sts[I],nil)
   else ListBox2.AddItem(Chpr.FieldNames[I]+':'#9+sts[I],nil);
 end;
end;

procedure TForm9.N1Click(Sender: TObject);
var
  s:string;
begin
  s:=ExtractFileName(OpenDialog1.FileName);
  if s='' then Exit;
  if not InputQuery('Важный файл','Введите название для списка',s) then Exit;
  FavoriteFiles.Add(S+'|'+OpenDialog1.FileName);
  FavoriteFiles.SaveToFile(FavoritePath);
  ShowFavorite;
end;

procedure TForm9.FavorClick(Sender: TObject);
var
  Ind:Integer;
begin
  Ind:=TMenuItem(Sender).Tag;
  OpenDialog1.FileName:=GetLongHint(FavoriteFiles[Ind]);
  OpenFile(OpenDialog1.FileName);
end;

procedure TForm9.SpeedButton1Click(Sender: TObject);
begin
  if Chpr.count=0 then Exit;
  ListBox2.Clear;
  Chpr.Filter:=Edit1.Text;
  OutTable;
end;

procedure TForm9.ToolButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    OpenFile(OpenDialog1.FileName);
end;

procedure TForm9.ToolButton2Click(Sender: TObject);
Var
  I:Integer;
  sts:TStringList;
  Col:Integer;
  sts2:TStrings;
  OldFilling:Boolean;
begin
  Col:=chpr.FieldNames.IndexOf('N счета в банке');
  sts:=TStringList.Create;
  if col=-1 then
    for I := 0 to chpr.Count - 1 do begin
      if not Check(chpr[I]) then sts.AddObject(chpr[I],pointer(I));
    end
  else begin
    OldFilling:=Chpr.Filling;
    Chpr.Filling:=true;
    sts2:=chpr.AsTable;
    sts.AddObject(sts2[0],pointer(-2));
    sts.AddObject(sts2[1],pointer(-2));
    for I := 1 to chpr.Count - 1 do begin
      if not Check(chpr.Values[I-1][Col]) then sts.AddObject(sts2[I+1],sts2.Objects[I+1]);
    end;
    Chpr.Filling:=OldFilling;
  end;
  ListBox1.Items.Assign(sts);
  Label1.Caption:=Format('Неправильных счетов = %d',[sts.Count-2]);
  sts.Free;
end;

procedure TForm9.ToolButton8Click(Sender: TObject);
begin
  Chpr.IsOEMSource:=ToolButton8.Down;
end;

procedure TForm9.TrackBar1Change(Sender: TObject);
begin
  ListBox2.TabWidth:=TrackBar1.Position;
end;

end.
