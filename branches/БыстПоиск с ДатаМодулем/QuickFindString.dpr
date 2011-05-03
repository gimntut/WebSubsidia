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
  QFMainLite in 'QFMainLite.pas' {Form9Lite},
  DM in 'DM.pas' {DataModule3: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Работа со списками';
  Application.CreateForm(TDataModule3, DataModule3);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TQFTemlateDlg, QFTemlateDlg);
  Application.CreateForm(TPeriodDlg, PeriodDlg);
  Application.CreateForm(TImportDlg, ImportDlg);
  Application.CreateForm(TFioDlg, FioDlg);
  Application.Run;
end.
