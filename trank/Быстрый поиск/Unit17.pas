unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFioDlg = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    Panel2: TPanel;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    procedure SetFIOPath(const Value: string);
    function GetFIOPath: string;
    { Private declarations }
  public
    function Execute:boolean;
    property FIOPath:string read GetFIOPath write SetFIOPath;
  end;

var
  FioDlg: TFioDlg;

implementation

{$R *.dfm}

{ TFioDlg }

procedure TFioDlg.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit1.Text:=OpenDialog1.FileName;
end;

function TFioDlg.Execute: boolean;
begin
  Result := ShowModal=mrOk;
end;

function TFioDlg.GetFIOPath: string;
begin
  Result := Edit1.Text;
end;

procedure TFioDlg.SetFIOPath(const Value: string);
begin
  Edit1.Text := Value;
end;

end.
