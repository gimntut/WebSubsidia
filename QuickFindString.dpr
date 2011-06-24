program QuickFindString;

{%TogetherDiagram 'ModelSupport_QuickFindString\default.txaPackage'}

uses
  Forms,
  QFMain in 'QFMain.pas' {Form9},
  QFLoadList in 'QFLoadList.pas' {Form10},
  QFTemplate in 'QFTemplate.pas' {QFTemlateDlg},
  DateIntervalDlg in 'DateIntervalDlg.pas' {PeriodDlg},
  uTime in 'uTime.pas',
  uImportBases in 'uImportBases.pas' {ImportDlg},
  Unit17 in 'Unit17.pas' {FioDlg},
  uQFSObj in 'uQFSObj.pas',
  uFieldsDlg in 'uFieldsDlg.pas' {FieldsDlg};

{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Работа со списками';
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TQFTemlateDlg, QFTemlateDlg);
  Application.CreateForm(TPeriodDlg, PeriodDlg);
  Application.CreateForm(TImportDlg, ImportDlg);
  Application.CreateForm(TFioDlg, FioDlg);
  Application.CreateForm(TFieldsDlg, FieldsDlg);
  Application.Run;
end.
