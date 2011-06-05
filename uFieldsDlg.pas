unit uFieldsDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMyDlg, ExtCtrls, StdCtrls, CheckLst, ComCtrls, cgsCHPR, Buttons;

type
  TFieldsDlg = class(TMyDlg)
    HeaderControl1: THeaderControl;
    chlFields: TCheckListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chlFieldsClickCheck(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FFullList: TStringList;
    FOutList: TStringList;
    FInCHPR: TChprList;
    procedure SetOutList(const Value: string);
    procedure Merge;
    procedure ShowList;
    function GetOutList: string;
    procedure SetInCHPR(const Value: TChprList);
    procedure ReCheck;
  public
    property InCHPR:TChprList read FInCHPR write SetInCHPR;
    property OutList:string read GetOutList write SetOutList;
  end;

var
  FieldsDlg: TFieldsDlg;

implementation

{$R *.dfm}

{ TFieldsDlg }

procedure TFieldsDlg.chlFieldsClickCheck(Sender: TObject);
begin
  ReCheck;
end;

procedure TFieldsDlg.FormCreate(Sender: TObject);
begin
  inherited;
  FFullList:=TStringList.Create;
  FOutList:=TStringList.Create;
end;

procedure TFieldsDlg.FormDestroy(Sender: TObject);
begin
  FFullList.Free;
  FOutList.Free;
end;

function TFieldsDlg.GetOutList: string;
begin
  Result:=FOutList.CommaText;
end;

procedure TFieldsDlg.Merge;
var
  s:string;
  I: Integer;
begin
  s:=InCHPR.ShowFields.CommaText;
  OutList:=s;
  if s='' then
    for I := 0 to InCHPR.FieldNames.Count - 1 do 
      FOutList.Add(InCHPR.FieldNames[I]+'='+InCHPR.FieldNames[I]);
end;

procedure TFieldsDlg.SetInCHPR(const Value: TChprList);
begin
  FInCHPR := Value;
  Merge;
  ShowList;
end;

procedure TFieldsDlg.ReCheck;
var
  I: Integer;
  s: string;
begin
  FOutList.Clear;
  for I := 0 to chlFields.Items.Count - 1 do
  begin
    s := chlFields.Items[I];
    if chlFields.Checked[I] then
      FOutList.Add(s + '=' + s);
  end;
end;

procedure TFieldsDlg.SetOutList(const Value: string);
begin
  FOutList.CommaText:=Value;
end;

procedure TFieldsDlg.ShowList;
var
  I: Integer;
  s: string;
  ind: Integer;
begin
  chlFields.Clear;
  for I := 0 to FInCHPR.FieldNames.Count - 1 do begin
    s := FInCHPR.FieldNames[I];
    ind:=chlFields.Items.Add(s);
    chlFields.Checked[Ind]:=FOutList.Values[s]<>'';
  end;
end;

procedure TFieldsDlg.SpeedButton1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chlFields.Items.Count - 1 do begin
    chlFields.Checked[I]:=false;
  end;
  ReCheck;
end;

procedure TFieldsDlg.SpeedButton2Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chlFields.Items.Count - 1 do begin
    chlFields.Checked[I]:=true;
  end;
  ReCheck;
end;

end.
