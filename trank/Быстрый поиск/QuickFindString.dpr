program QuickFindString;

{%File 'QFMain.txt'}
{%TogetherDiagram 'ModelSupport_QuickFindString\default.txaPackage'}

uses
  Forms,
  QFMain in 'QFMain.pas' {Form9},
  QFLoadList in 'QFLoadList.pas' {Form10},
  QFTemplate in 'QFTemplate.pas' {QFTemlateDlg},
  DateIntervalDlg in 'DateIntervalDlg.pas' {PeriodDlg},
  uSpravkaEDK in 'uSpravkaEDK.pas',
  uSpravka in 'uSpravka.pas',
  uTime in 'uTime.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Работа со списками';
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TQFTemlateDlg, QFTemlateDlg);
  Application.CreateForm(TPeriodDlg, PeriodDlg);
  Application.Run;
end.
