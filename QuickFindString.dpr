program QuickFindString;

{%File 'QFMain.txt'}
{%TogetherDiagram 'ModelSupport_QuickFindString\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\uSpravka\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\QFTemplate\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\uSpravkaEDK\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\QuickFindString\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\uImportBases\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\QFLoadList\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\Unit17\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\QFMain\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\uTime\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\DateIntervalDlg\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_QuickFindString\default.txvpck'}

uses
  Forms,
  QFMain in 'QFMain.pas' {Form9},
  QFLoadList in 'QFLoadList.pas' {Form10},
  QFTemplate in 'QFTemplate.pas' {QFTemlateDlg},
  DateIntervalDlg in 'DateIntervalDlg.pas' {PeriodDlg},
  uSpravkaEDK in 'uSpravkaEDK.pas',
  uSpravka in 'uSpravka.pas',
  uTime in 'uTime.pas',
  uImportBases in 'uImportBases.pas' {ImportDlg},
  Unit17 in 'Unit17.pas' {FioDlg};

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
  Application.Run;
end.
