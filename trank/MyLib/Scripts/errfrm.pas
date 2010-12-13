unit errfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, activescp;

type
  TErrorForm = class(TForm)
    DescriptionLabel: TLabel;
    Image1: TImage;
    DetailButton: TButton;
    OkButton: TButton;
    DetailStatic: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure DetailButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FScriptError: IActiveScriptError;
  public
    property ScriptError: IActiveScriptError read FScriptError write FScriptError;
  end;

var
  ErrorForm: TErrorForm;

implementation

{$R *.DFM}

uses
  ActiveX;

resourcestring
  rsDetailFormat = 'Строка: %d'#13#10'Позиция: %d'#13#10'%s';

procedure TErrorForm.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon.Handle := LoadIcon(0, IDI_HAND);
end;

procedure TErrorForm.DetailButtonClick(Sender: TObject);
begin
  Height := 200;
  OkButton.SetFocus;
  DetailButton.Enabled := false;
end;

procedure TErrorForm.FormShow(Sender: TObject);
var
  ei: EXCEPINFO;
  Context: DWORD;
  Line: UINT;
  Pos: integer;
  SourceLineW: WideString;
  SourceLine: string;
begin
  if FScriptError = nil then exit;
  FScriptError.GetExceptionInfo(ei);
  if @ei.pfnDeferredFillIn <> nil then ei.pfnDeferredFillIn(@ei);
  FScriptError.GetSourcePosition(Context, Line, Pos);
  FScriptError.GetSourceLineText(SourceLineW);
  SourceLine := SourceLineW;
  DescriptionLabel.Caption := ei.bstrDescription;
  Caption := ei.bstrSource;
  DetailStatic.Caption := Format(rsDetailFormat, [Line+1, Pos+1, SourceLine]);
  FScriptError := nil;
  MessageBeep(MB_ICONHAND);
end;

end.
