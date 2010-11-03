unit DateIntervalDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TOnChangeInterval = procedure (Sender:TObject; Memo:TMemo) of object;
  TPeriodDlg = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure PictResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TriggerClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FStartInterval: TDate;
    FEndInterval: TDate;
    FLeftEdge: Integer;
    FRightEdge: Integer;
    CellWidth:Integer;
    Rect1:TRect;
    flag: Boolean;
    FOnChangeInterval: TOnChangeInterval;
    FInfinitiMode: Boolean;
    procedure OutPicture;
    procedure SetEndInterval(const Value: TDate);
    procedure SetStartInterval(const Value: TDate);
    procedure SetLeftEdge(const Value: Integer);
    procedure SetRightEdge(const Value: Integer);
    procedure InitInterval;
    procedure SetOnChangeInterval(const Value: TOnChangeInterval);
    procedure SetInfinitiMode(const Value: Boolean);
    function GetEndInterval: TDate;
    function GetStartInterval: TDate;
    procedure ShowInfo;
    function GetTrigger(Index: Integer): Boolean;
    function GetTriggerText(Index: Integer): string;
    function GetTriggerVisible(Index: Integer): Boolean;
    procedure SetTrigger(Index: Integer; const Value: Boolean);
    procedure SetTriggerText(Index: Integer; const Value: string);
    procedure SetTriggerVisible(Index: Integer; const Value: Boolean);
    function GetCheckBox(Index: Integer): TCheckBox;
    { Private declarations }
  protected
    procedure DoChangeInterval(Memo:TMemo);
    property CheckBox[Index:Integer]:TCheckBox read GetCheckBox;
  public
    property StartInterval:TDate read GetStartInterval write SetStartInterval;
    property EndInterval:TDate read GetEndInterval write SetEndInterval;
    property LeftEdge:Integer read FLeftEdge write SetLeftEdge;
    property RightEdge:Integer read FRightEdge write SetRightEdge;
    property OnChangeInterval:TOnChangeInterval read FOnChangeInterval write SetOnChangeInterval;
    property InfinitiMode:Boolean read FInfinitiMode write SetInfinitiMode;
    property Trigger[Index:Integer]:Boolean read GetTrigger write SetTrigger;
    property TriggerVisible[Index:Integer]:Boolean read GetTriggerVisible write SetTriggerVisible;
    property TriggerText[Index:Integer]:string read GetTriggerText write SetTriggerText;
    procedure TriggersOff;
    function Execute:boolean;
  end;

var
  PeriodDlg: TPeriodDlg;
const
  ts=25;

implementation

uses
  Publ, DateUtils, Types;

{$R *.dfm}

procedure TPeriodDlg.TriggerClick(Sender: TObject);
begin
  ShowInfo;
end;

procedure TPeriodDlg.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TPeriodDlg.DoChangeInterval(Memo: TMemo);
begin
  if Assigned(FOnChangeInterval) then FOnChangeInterval(self,Memo);
end;

function TPeriodDlg.Execute: boolean;
begin
  ActiveControl:=Edit1;
  if Assigned(OnChangeInterval)
  then WindowState:=wsMaximized
  else begin
    Width:=400;
    Height:=350;
    WindowState:=wsNormal;
  end;
  ShowInfo;
  Result:=ShowModal=mrOk;
end;

procedure TPeriodDlg.ShowInfo;
begin
  OutPicture;
  if InfinitiMode then
  Label1.Caption:='Полный показ'
  else Label1.Caption:=format('%s - %s',[DateToStr(StartInterval),DateToStr(EndOfTheMonth(EndInterval))]);
  DoChangeInterval(Memo1);
end;

procedure TPeriodDlg.TriggersOff;
begin
  CheckBox1.Visible:=false;
  CheckBox2.Visible:=false;
  CheckBox3.Visible:=false;
  CheckBox1.Checked:=false;
  CheckBox2.Checked:=false;
  CheckBox3.Checked:=false;
end;

procedure TPeriodDlg.InitInterval;
begin
  FLeftEdge := YearOf(Date) - 3;
  FRightEdge := YearOf(Date) + 1;
  StartInterval := IncMonth(Date, -6);
end;

procedure TPeriodDlg.FormCreate(Sender: TObject);
begin
  InitInterval;
end;

procedure TPeriodDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sdt,edt:TDate;
  Delta:Integer;
begin
  sdt:=FStartInterval;
  edt:=FEndInterval;
  case ShortCut(Key,Shift) of
    scCtrl+VK_SPACE: begin
      InfinitiMode:=not FInfinitiMode;
    end;
    VK_LEFT: begin
      sdt:=IncMonth(sdt,-1);
      edt:=IncMonth(edt,-1);
    end;
    VK_RIGHT: begin
      sdt:=IncMonth(sdt,1);
      edt:=IncMonth(edt,1);
    end;
    VK_UP: begin
      sdt:=IncYear(sdt,-1);
      edt:=IncYear(edt,-1);
    end;
    VK_DOWN: begin
      sdt:=IncYear(sdt,1);
      edt:=IncYear(edt,1);
    end;
    scCtrl+VK_LEFT: begin
      edt:=IncMonth(edt,-1);
    end;
    scCtrl+VK_RIGHT: begin
      edt:=IncMonth(edt,1);
    end;
    VK_SPACE: begin
      InitInterval;
      Exit;
    end;
    scCtrl+Ord('1')..scCtrl+Ord('3'): begin
      CheckBox[Key-Ord('0')].Checked:=not CheckBox[Key-Ord('0')].Checked;
    end;
    else Exit;
  end;
  Key:=0;
  if YearOf(sdt)<LeftEdge then begin
    Delta:=LeftEdge-YearOf(sdt);
    FLeftEdge:=FLeftEdge-Delta;
    FRightEdge:=FRightEdge-Delta;
    if YearOf(edt)>RightEdge then edt:=EncodeDate(RightEdge,12,31);
  end;
  if YearOf(edt)>RightEdge then begin
    Delta:=RightEdge-YearOf(sdt);
    FRightEdge:=FRightEdge-Delta;
    FLeftEdge:=FLeftEdge-Delta;
    if YearOf(sdt)<LeftEdge then sdt:=EncodeDate(LeftEdge,1,1);
  end;
  if edt<sdt then Exit;
  FStartInterval:=sdt;
  FEndInterval:=edt;
  ShowInfo;
end;

function TPeriodDlg.GetCheckBox(Index: Integer): TCheckBox;
begin
  Result:=nil;
  case Index of
    1: Result:=CheckBox1;
    2: Result:=CheckBox2;
    3: Result:=CheckBox3;
  end;
end;

function TPeriodDlg.GetEndInterval: TDate;
begin
  if FInfinitiMode then Result:=1e6 else Result:=FEndInterval;
end;

function TPeriodDlg.GetStartInterval: TDate;
begin
  if FInfinitiMode then Result:=1 else Result:=FStartInterval;
end;

function TPeriodDlg.GetTrigger(Index: Integer): Boolean;
begin
  Result:=false;
  if CheckBox[Index]=nil then Exit;
  Result:=CheckBox[Index].Checked;
end;

function TPeriodDlg.GetTriggerText(Index: Integer): string;
begin
  Result:='';
  if CheckBox[Index]=nil then Exit;
  Result:=CheckBox[Index].Caption;
end;

function TPeriodDlg.GetTriggerVisible(Index: Integer): Boolean;
begin
  Result:=false;
  if CheckBox[Index]=nil then Exit;
  Result:=CheckBox[Index].Visible;
end;

procedure TPeriodDlg.PictResize(Sender: TObject);
begin
  Image1.Picture.Bitmap.Width:=Image1.Width;
  Image1.Picture.Bitmap.Height:=Image1.Height;
  OutPicture;
end;

procedure TPeriodDlg.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  flag:=true;
end;

procedure TPeriodDlg.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  m,year:integer;
  Im: Boolean;
begin
  if not flag then Exit;
  if PtInRect(Rect1,point(x,y)) then begin
    x:=x-Rect1.Left;
    y:=y-Rect1.Top;
    year:=y div CellWidth+LeftEdge;
    m:=x div CellWidth+1;
    Im:=FInfinitiMode;
    FInfinitiMode:=false;
    if Shift=[ssCtrl]
    then EndInterval:=EncodeDate(year,m,1)
    else StartInterval:=EncodeDate(year,m,1);
    FInfinitiMode:=Im;
  end
end;

procedure TPeriodDlg.OutPicture;
var
  Year1,Month1,Day1:Word;
  Year2,Month2,Day2:Word;
  n1:Integer;
  dx: Integer;
  I: Integer;
  r1: TRect;
  s:string;
  J: Integer;
begin
  if InfinitiMode
  then Image1.Canvas.Brush.Color:=$ff0000
  else Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.Brush.Style:=bsSolid;
  Image1.Canvas.Pen.Color:=clWhite;
  Image1.Canvas.Pen.Style:=psSolid;
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
  Image1.Canvas.Pen.Color:=clBlack;
  DecodeDate(FStartInterval,Year1,Month1,Day1);
  DecodeDate(FEndInterval,Year2,Month2,Day2);
  n1:=RightEdge-LeftEdge;
  CellWidth:=Min((Image1.Width-ts) div 12,Image1.Height div (n1+1));
//  w:=w div 2;
  dx:=ts;
  for I := 0 to n1 do begin
    for J := 0 to 11 do begin
      Image1.Canvas.Brush.Style:=bsSolid;
      r1:=Rect(dx+J*CellWidth,I*CellWidth,dx+CellWidth*(J+1),(I+1)*CellWidth);
      if ((Year1=I+LeftEdge) and (Month1=J+1)) or ((Year2=I+LeftEdge) and (Month2=J+1))
      then Image1.Canvas.Brush.Color:=clLime
      else if (EncodeDate(I+FLeftEdge,J+1,1)+1>FStartInterval)
           and (EncodeDate(I+FLeftEdge,J+1,1)-1<FEndInterval)
           then Image1.Canvas.Brush.Color:=clYellow
           else Image1.Canvas.Brush.Color:=$ddffdd;
      image1.Canvas.Rectangle(r1);
      Image1.Canvas.Brush.Style:=bsClear;
      s:=IntToStr(J+1);
      image1.Canvas.TextRect(r1,s,[tfCenter,tfVerticalCenter]);
    end;
    s:=IntToStr(I+LeftEdge);
    r1:=Rect(0,I*CellWidth,dx,(I+1)*CellWidth);
    image1.Canvas.TextRect(r1,s,[tfRight,tfVerticalCenter]);
  end;
  Rect1:=Rect(dx,0,dx+CellWidth*12,(n1+1)*CellWidth);
end;

procedure TPeriodDlg.SetEndInterval(const Value: TDate);
begin
  if Value < FStartInterval then begin
    Image1.Canvas.Brush.Color:=clRed;
    Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
    Application.ProcessMessages;
    sleep(100);
    ShowInfo;
    Exit;
  end;
  FEndInterval := EncodeDate(YearOf(Value),MonthOf(Value),1);
  ShowInfo;
end;

procedure TPeriodDlg.SetInfinitiMode(const Value: Boolean);
begin
  FInfinitiMode := Value;
  ShowInfo;
end;

procedure TPeriodDlg.SetLeftEdge(const Value: Integer);
begin
  FLeftEdge := Value;
end;

procedure TPeriodDlg.SetOnChangeInterval(const Value: TOnChangeInterval);
var
  us: Boolean;
  wd2:Integer;
begin
  us:=Assigned(Value);
  if us then begin
    if not Assigned(FOnChangeInterval) then begin
      wd2:=Width div 2;
      Panel2.Align:=alLeft;
      Panel2.Width:=wd2;
      Splitter1.Left:=wd2;
      Memo1.Left:=wd2+4;
    end;
    Memo1.Visible:=us;
    Splitter1.Visible:=us;
  end else begin
    Splitter1.Visible:=us;
    Memo1.Visible:=us;
    Panel2.Align:=alClient;
  end;
  FOnChangeInterval := Value;
end;

procedure TPeriodDlg.SetRightEdge(const Value: Integer);
begin
  FRightEdge := Value;
end;

procedure TPeriodDlg.SetStartInterval(const Value: TDate);
begin
  FStartInterval := EncodeDate(YearOf(Value),MonthOf(Value),1);
  EndInterval := IncMonth(FStartInterval,5);
end;

procedure TPeriodDlg.SetTrigger(Index: Integer; const Value: Boolean);
begin
  if CheckBox[Index]=nil then Exit;
  CheckBox[Index].Checked:=Value;
end;

procedure TPeriodDlg.SetTriggerText(Index: Integer; const Value: string);
begin
  if CheckBox[Index]=nil then Exit;
  CheckBox[Index].Caption:=Value;
end;

procedure TPeriodDlg.SetTriggerVisible(Index: Integer; const Value: Boolean);
begin
  if CheckBox[Index]=nil then Exit;
  CheckBox[Index].Visible:=Value;
end;

end.
