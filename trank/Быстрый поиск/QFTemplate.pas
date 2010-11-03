unit QFTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TQFTemlateDlg = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
  private

  public
    function Execute:boolean;
  end;

var
  QFTemlateDlg: TQFTemlateDlg;

implementation

{$R *.dfm}

{ TQFTemlateDlg }

function TQFTemlateDlg.Execute: boolean;
begin
  Result:=ShowModal=mrOk;
end;

end.
