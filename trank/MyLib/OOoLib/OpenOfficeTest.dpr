program OpenOfficeTest;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uOpenOffice in 'uOpenOffice.pas',
  uOpenOffice_TLB in 'uOpenOffice_TLB.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
