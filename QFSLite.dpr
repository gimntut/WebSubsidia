program QFSLite;



{%TogetherDiagram 'ModelSupport_QFSLite\default.txaPackage'}

uses
//  MemControl,
  Forms,
  QFLoadList in 'QFLoadList.pas' {Form10},
  QFTemplate in 'QFTemplate.pas' {QFTemlateDlg},
  DateIntervalDlg in 'DateIntervalDlg.pas' {PeriodDlg},
  uTime in 'uTime.pas',
  uImportBases in 'uImportBases.pas' {ImportDlg},
  Unit17 in 'Unit17.pas' {FioDlg},
  uQFSObj in 'uQFSObj.pas',
  QFMainLite in 'QFMainLite.pas' {Form9Lite};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Работа со списками';
  Application.CreateForm(TForm9Lite, Form9Lite);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TQFTemlateDlg, QFTemlateDlg);
  Application.CreateForm(TPeriodDlg, PeriodDlg);
  Application.CreateForm(TImportDlg, ImportDlg);
  Application.CreateForm(TFioDlg, FioDlg);
  Application.Run;
end.
