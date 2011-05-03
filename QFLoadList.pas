unit QFLoadList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls;

type
  TForm10 = class(TForm)
    Panel1: TPanel;
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FCheckList:TStrings;
    function GetChecked(Index: Integer): Boolean;
    procedure SetList(const Value: TStrings);
    procedure OutList;
  public
    function Execute:boolean;
    property List:TStrings read FCheckList write SetList;
    property Checked[Index:Integer]:Boolean read GetChecked;
  end;

var
  Form10: TForm10;

implementation

uses
  Publ, ShellAPI, PublFile;

{$R *.dfm}

{ TForm10 }

procedure TForm10.Button3Click(Sender: TObject);
begin
  ShellExecute(0,'open',PChar(ProgramPath+'\favorites.txt'),'','',SW_NORMAL);
end;

procedure TForm10.CheckListBox1Click(Sender: TObject);
var
  ind: Integer;
begin
  ind:=CheckListBox1.ItemIndex;
  if ind=-1 then Exit;
  Label2.Caption:=GetLongHint(FCheckList[Ind]);
end;

function TForm10.Execute: boolean;
begin
  Result:=ShowModal=mrOk;
end;

procedure TForm10.OutList;
var
  I:Integer;
  S: string;
  maxL:Integer;
  L: Integer;
begin
  maxL:=0;
  for I:=0 to FCheckList.Count-1 do begin
    S:=FCheckList[I];
    L:=Length(GetShortHint(S));
    if L>maxL then MaxL:=L;
  end;

  for I:=0 to FCheckList.Count-1 do begin
    S:=FCheckList[I];
    CheckListBox1.Items[I]:=format('%-*s %s',[maxL,GetShortHint(S),GetLongHint(S)]);
    CheckListBox1.Checked[I]:=not FileExists(GetLongHint(S));
  end;
end;

procedure TForm10.FormCreate(Sender: TObject);
begin
  //
  FCheckList:=TStringList.Create;
end;

procedure TForm10.FormDestroy(Sender: TObject);
begin
  FCheckList.Free;
end;

function TForm10.GetChecked(Index: Integer): Boolean;
begin
  Result:=false;
  if Outside(Index,CheckListBox1.Count-1) then Exit;
  Result:=CheckListBox1.Checked[Index];
end;

procedure TForm10.SetList(const Value: TStrings);
var
  I: Integer;
begin
  FCheckList.Assign(Value);
  CheckListBox1.Items:=Value;
  for I:=0 to FCheckList.Count-1 do
    CheckListBox1.Checked[I]:=false;
  OutList;
end;

end.
