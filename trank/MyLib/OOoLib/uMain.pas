unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, Graphics,
  Dialogs, uOpenOffice, Math, Printers, Buttons, ExtCtrls, StdCtrls, Menus;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    btNewCalc: TButton;
    btTestWrite: TButton;
    Panel2: TPanel;
    btNewWriter: TButton;
    btInsertRows: TButton;
    btAppendRows: TButton;
    btDeleteRows: TButton;
    btInsertColumns: TButton;
    btAppendColumns: TButton;
    btDeleteColumns: TButton;
    btMainTest: TButton;
    btInsertDoc: TButton;
    btGetPageScale: TButton;
    btSetPageScale: TButton;
    btGetScaleToPages: TButton;
    btSetScaleToPages: TButton;
    btSet2PageFormat: TButton;
    btPageStylesCount: TButton;
    btAddPageStyle: TButton;
    btDeletePageStyle: TButton;
    btRenamePageStyle: TButton;
    btLandscape: TButton;
    Panel3: TPanel;
    btGetPrinterName: TButton;
    cbPrinter: TComboBox;
    btSetPrinterName: TButton;
    btGetPaperSize: TButton;
    btGetCopyCount: TButton;
    btPrint: TButton;
    btPrintPages: TButton;
    cbPageStyleColor: TColorBox;
    ckPageStyleTrans: TCheckBox;
    btPageStyle: TButton;
    btBorder: TButton;
    btTableBorder: TButton;
    btTextFrame: TButton;
    btPrintMode: TButton;
    btTextTableCursor: TButton;
    btSeparator: TButton;
    btTextGraphicFrames: TButton;
    btWriterModified: TButton;
    btCloseDoc: TButton;
    btCloseCalc: TButton;
    btCalcModified: TButton;
    btInsertDateTime: TButton;
    btFillSeries: TButton;
    btShowPreview: TButton;
    btClosePreview: TButton;
    btSave: TButton;
    btToPDF: TButton;
    btFreeze: TButton;
    btExecMacro: TButton;
    btExpandReferences: TButton;
    btShapesCount: TButton;
    btShapes: TButton;
    btSort: TButton;
    btTransformation: TButton;
    btChart: TButton;
    btCopySheet: TButton;
    btOpenDoc: TButton;
    btConnectTo: TButton;
    btVisible: TButton;
    btConnect: TButton;
    btInsertTable: TButton;
    btDeleteTable: TButton;
    btUsedArea: TButton;
    btRemoveBookmark: TButton;
    btGetVisible: TButton;
    btDateSeparator: TButton;
    btLanguage: TButton;
    btTextCursor: TButton;
    btFindFirst: TButton;
    btFindNext: TButton;
    btGetAnnotation: TButton;
    btSetAnnotation: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btNewCalcClick(Sender: TObject);
    procedure btTestWriteClick(Sender: TObject);
    procedure btNewWriterClick(Sender: TObject);
    procedure btInsertRowsClick(Sender: TObject);
    procedure btAppendRowsClick(Sender: TObject);
    procedure btDeleteRowsClick(Sender: TObject);
    procedure btInsertColumnsClick(Sender: TObject);
    procedure btAppendColumnsClick(Sender: TObject);
    procedure btDeleteColumnsClick(Sender: TObject);
    procedure btMainTestClick(Sender: TObject);
    procedure btInsertDocClick(Sender: TObject);
    procedure btGetPageScaleClick(Sender: TObject);
    procedure btSetPageScaleClick(Sender: TObject);
    procedure btGetScaleToPagesClick(Sender: TObject);
    procedure btSetScaleToPagesClick(Sender: TObject);
    procedure btSet2PageFormatClick(Sender: TObject);
    procedure btPageStylesCountClick(Sender: TObject);
    procedure btAddPageStyleClick(Sender: TObject);
    procedure btDeletePageStyleClick(Sender: TObject);
    procedure btRenamePageStyleClick(Sender: TObject);
    procedure btLandscapeClick(Sender: TObject);
    procedure btGetPrinterNameClick(Sender: TObject);
    procedure btSetPrinterNameClick(Sender: TObject);
    procedure btGetPaperSizeClick(Sender: TObject);
    procedure btGetCopyCountClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure btPrintPagesClick(Sender: TObject);
    procedure cbPageStyleColorChange(Sender: TObject);
    procedure ckPageStyleTransClick(Sender: TObject);
    procedure btPageStyleClick(Sender: TObject);
    procedure btBorderClick(Sender: TObject);
    procedure btTableBorderClick(Sender: TObject);
    procedure btTextFrameClick(Sender: TObject);
    procedure btPrintModeClick(Sender: TObject);
    procedure btTextTableCursorClick(Sender: TObject);
    procedure btSeparatorClick(Sender: TObject);
    procedure btTextGraphicFramesClick(Sender: TObject);
    procedure btCloseDocClick(Sender: TObject);
    procedure btCloseCalcClick(Sender: TObject);
    procedure btWriterModifiedClick(Sender: TObject);
    procedure btCalcModifiedClick(Sender: TObject);
    procedure btInsertDateTimeClick(Sender: TObject);
    procedure btFillSeriesClick(Sender: TObject);
    procedure btShowPreviewClick(Sender: TObject);
    procedure btClosePreviewClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btToPDFClick(Sender: TObject);
    procedure btFreezeClick(Sender: TObject);
    procedure btExecMacroClick(Sender: TObject);
    procedure btExpandReferencesClick(Sender: TObject);
    procedure btShapesCountClick(Sender: TObject);
    procedure btShapesClick(Sender: TObject);
    procedure btSortClick(Sender: TObject);
    procedure btTransformationClick(Sender: TObject);
    procedure btChartClick(Sender: TObject);
    procedure btCopySheetClick(Sender: TObject);
    procedure btOpenDocClick(Sender: TObject);
    procedure btConnectToClick(Sender: TObject);
    procedure btVisibleClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btInsertTableClick(Sender: TObject);
    procedure btDeleteTableClick(Sender: TObject);
    procedure btUsedAreaClick(Sender: TObject);
    procedure btRemoveBookmarkClick(Sender: TObject);
    procedure btGetVisibleClick(Sender: TObject);
    procedure btDateSeparatorClick(Sender: TObject);
    procedure btLanguageClick(Sender: TObject);
    procedure btTextCursorClick(Sender: TObject);
    procedure btFindFirstClick(Sender: TObject);
    procedure btFindNextClick(Sender: TObject);
    procedure btGetAnnotationClick(Sender: TObject);
    procedure btSetAnnotationClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OC:TOOCalc;
    OW:TOOWriter;
    procedure TestEvent(Sender: TObject);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
var
  i:integer;
begin
  OC:=TOOCalc.Create;
  OW:=TOOWriter.Create;
  for i:=0 to Printer.Printers.Count-1 do
    cbPrinter.Items.Append(Printer.Printers[i]);
  if cbPrinter.Items.Count>0 then
    cbPrinter.ItemIndex:=0;
  btSetPrinterName.Enabled:=cbPrinter.Items.Count>0;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  OW.Free;
  OC.Free;
end;

procedure TfmMain.TestEvent(Sender: TObject);
begin
  ShowMessage('Event handler!');
end;

procedure TfmMain.btNewCalcClick(Sender: TObject);
begin
  OC.Connect:=true;
  if not OC.Connect then
    begin
      ShowMessage('Error! Not connected!');
      Exit;
    end;
  OC.OpenDocument('',[],ommAlways);
end;

procedure TfmMain.btTestWriteClick(Sender: TObject);
begin
  OC.Sheets.ActiveByIndex:=0;
  OC.PageStyles[0].HeaderIsOn:=true;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].Text:='Page ';
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].CollapseToEnd;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].InsertPageNumber;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].Text:=' of ';
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].CollapseToEnd;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].InsertPageCount;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].Text:='. ';
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].CollapseToEnd;
  OC.PageStyles[0].ModelCursor[ochRightPageHeaderCenter].InsertDateTime(true,true,0,0);
  OC.Sheets[0].CellByName['B1'].AsText:='Test string'+#13+'Second string';
  OC.Sheets[0].Cell[1,0].AsText:='Col 1';
  OC.Sheets[0].Cell[2,0].AsText:='Col 2';
  OC.Sheets[0].Cell[3,0].AsText:='Col 3';
  OC.Sheets[0].Cell[0,1].AsText:='Row 1';
  OC.Sheets[0].Cell[0,2].AsText:='Row 2';
  OC.Sheets[0].Cell[0,3].AsText:='Row 3';
  OC.Sheets[0].CellRange[0,0,3,0].BackColor:=clLime;
  OC.Sheets[0].CellRange[0,0,0,3].BackColor:=clLime;
  OC.Sheets[0].CellRange[0,0,0,0].SetAsTitleRows;
  OC.Sheets[0].CellRange[0,0,0,0].SetAsTitleColumns;

  OC.Sheets[0].Cell[1,1].AsNumber:=158.256;
  OC.Sheets[0].Cell[2,1].AsNumber:=975.691;
  OC.Sheets[0].Cell[1,2].AsNumber:=18242.48;
  OC.Sheets[0].Cell[2,2].AsNumber:=2.12;
  OC.Sheets[0].Cell[3,2].AsNumber:=210;
  OC.Sheets[0].CellByName['C10'].AsNumber:=167.98;
  OC.Sheets[0].CellByName['C11'].AsNumber:=45.589;
  OC.Sheets[0].Cell[1,3].AsFormula:='=COUNT(A2:B3)';
  //дата будет в соответствии с установкой Locale setting OpenOffice.org
//  OC.Cell[3,0].AsFormula:='=DATE(2004;12;31)';
//  OC.Cell[3,1].AsFormula:='=DATE(2004;12;27)';
//  OC.Cell[3,2].AsFormula:='=(C10-C11)';

  OC.Sheets[0].Cell[5,5].Format:=OC.NumberFormats.Add('DD.:.MM.:.YYYY');
  OC.Sheets[0].Cell[5,5].AsDate:=Now;
  OC.Sheets[0].Columns[7].IsVisible:=false;
  OC.Sheets[0].Rows[0].OptimalHeight:=true;
  OC.Sheets[0].Columns[2].OptimalWidth:=true;
  OC.Sheets[0].Rows[6].IsStartOfNewPage:=true;
  OC.Sheets[0].CellRange[1,0,5,9].Font.Height:=12;
  OC.Sheets[0].CellRange[1,0,5,9].Font.Weight:=ofwBold;
  OC.Sheets[0].CellRange[1,0,5,9].Font.Underline:=ofuWave;
  OC.Sheets[0].CellRange[1,0,5,9].Font.Posture:=ofpItalic;
end;

procedure TfmMain.btNewWriterClick(Sender: TObject);
begin
  OW.Connect:=true;
  if not OW.Connect then
    begin
      ShowMessage('Error! Not connected!');
      Exit;
    end;
  OW.OpenDocument('',[],ommNever);
  OW.AfterClose:=TestEvent;
end;

procedure TfmMain.btInsertRowsClick(Sender: TObject);
begin
  OW.Tables[0].Rows.Insert(2,3);
end;

procedure TfmMain.btAppendRowsClick(Sender: TObject);
begin
  OW.Tables[0].Rows.Append(3);
end;

procedure TfmMain.btDeleteRowsClick(Sender: TObject);
begin
  OW.Tables[0].Rows.Delete(2,2);
end;

procedure TfmMain.btInsertColumnsClick(Sender: TObject);
begin
  OW.Tables[0].Columns.Insert(2,3);
end;

procedure TfmMain.btAppendColumnsClick(Sender: TObject);
begin
  OW.Tables[0].Columns.Append(3);
end;

procedure TfmMain.btDeleteColumnsClick(Sender: TObject);
begin
  OW.Tables[0].Columns.Delete(1,1);
end;

procedure TfmMain.btMainTestClick(Sender: TObject);
var
  V:variant;
  x,y:integer;
begin
  OW.PageStyles[0].HeaderIsOn:=true;
  OW.PageStyles[0].ModelCursor[owhHeader].Text:='Test header  '#13'line2';
  OW.PageStyles[0].ModelCursor[owhHeader].Font.Posture:=ofpItalic;
  OW.PageStyles[0].ModelCursor[owhHeader].Para.HoriAlignment:=ophCenter;
  OW.PageStyles[0].ModelCursor[owhHeader].CollapseToEnd;
  OW.PageStyles[0].ModelCursor[owhHeader].Text:='Page ';
  OW.PageStyles[0].ModelCursor[owhHeader].CollapseToEnd;
  OW.PageStyles[0].ModelCursor[owhHeader].InsertPageNumber;
  OW.PageStyles[0].ModelCursor[owhHeader].Text:=' of ';
  OW.PageStyles[0].ModelCursor[owhHeader].CollapseToEnd;
  OW.PageStyles[0].ModelCursor[owhHeader].InsertPageCount;

  OW.PageStyles[0].HeaderBottomBorder:=BLine(clRed,0,30,0);
  OW.PageStyles[0].HeaderTopBorder:=BLine(clBlue,0,30,0);
  OW.Tables.Insert(5,9,'',OW.ViewCursor);
  OW.Tables[0].CellByName['A1'].AsText:='Test';
  OW.Tables[0].CellByName['A2'].AsNumber:=12.5678;
  OW.Tables[0].CellByName['A4'].AsDate:=Now;
  OW.Tables[0].CellByName['A4'].Format:=OW.NumberFormats.Add('DD.MM.YYYY');
  OW.Tables[0].CellByName['A4'].BackColor:=clSilver;

  V:=VarArrayCreate([1,3,1,2],VarVariant);
  for x:=1 to 3 do
    for y:=1 to 2 do
      V[x,y]:=IntToStr(x*y+1);
  OW.Tables[0].CellRange[0,1,2,2].Para.HoriAlignment:=ophCenter;

  OW.Tables[0].CellRange[0,1,2,2].Para.Margin.Top:=500;
  OW.Tables[0].CellRange[0,1,2,2].Para.Margin.Left:=500;
  OW.Tables[0].CellRange[0,1,2,2].Para.Margin.Right:=500;
  OW.Tables[0].CellRange[0,1,2,2].Para.Margin.Bottom:=500;

  OW.ViewCursor.GotoEnd(false);
  OW.ViewCursor.Font.FontName:='Times New Roman';
  OW.ViewCursor.Font.Height:=12;
  OW.ViewCursor.Para.FirstLineIndent:=1000;
  OW.ViewCursor.Para.HoriAlignment:=ophLeft;
  OW.ViewCursor.Text:='Задача - в программе на D7 формируется прайс-лист.'+#13+
                  'Ранее я выводил его в DBF, открывал Excel-ем, и там макросом форматировал как надо.'+#13;
  OW.ViewCursor.CollapseToEnd;
  OW.ViewCursor.Para.LineSpacing:=LSpacing(olsProp,150);
  OW.ViewCursor.Para.DropCapFormat:=DCFormat(2,1,1);
  OW.ViewCursor.Text:='Потом что бы не связываться с макросами (ну не перевариваю я этим объекты экселя) '+
                  'стал делать так - вывожу в html с форматированием и открываю его Excel-ем. Даже формулы работают.';
  OW.ViewCursor.GotoEnd(false);
  OW.Tables.Insert(3,35,'',OW.ViewCursor);
  OW.Tables[1].HoriOrient:=ofhoLeft;
  OW.Tables[1].Width:=12000;
  OW.Tables[1].RepeatHeadline:=true;
  OW.Tables[1].HeaderRowCount:=2;
  OW.Tables[1].Rows[0].BackColor:=clGreen;
  OW.Tables[1].Rows[0].AutoHeight:=false;
  OW.Tables[1].Rows[0].Height:=2000;
  OW.Tables[1].Cell[0,0].AsText:='String1';
  OW.Tables[1].Cell[1,0].AsText:='String2'+#13+'String3';
  OW.Tables[1].Cell[0,1].AsText:='1';
  OW.Tables[1].Cell[1,1].AsText:='2';
  OW.Tables[1].Cell[2,1].AsText:='3';
  OW.Tables[1].CellRange[0,1,2,1].Para.HoriAlignment:=ophCenter;
  OW.Tables[1].Cell[0,0].VertAlignment:=ofvoCenter;
  OW.Tables[1].Cell[0,0].Font.Posture:=ofpItalic;
  OW.Tables[1].Cell[0,0].Font.Weight:=ofwBold;
  OW.Tables[1].Cell[0,0].Font.Underline:=ofuDoubleWave;
//  ShowMessage('Page count = '+IntToStr(OW.PageCount));
  OW.ViewCursor.GotoEnd(false);
  OW.ViewCursor.Para.BreakType:=obtPageBefore;
  OW.ViewCursor.Text:='Test 3 page';
end;

procedure TfmMain.btInsertDocClick(Sender: TObject);
begin
  OW.InsertDocument('c:\test.rtf',oipEndNewPage);
end;

procedure TfmMain.btGetPageScaleClick(Sender: TObject);
begin
  ShowMessage(IntToStr(OC.PageStyles[0].PageScale));
end;

procedure TfmMain.btSetPageScaleClick(Sender: TObject);
begin
  OC.PageStyles[0].PageScale:=120;
end;

procedure TfmMain.btGetScaleToPagesClick(Sender: TObject);
begin
//  ShowMessage(IntToStr(OC.ScaleToPages));
end;

procedure TfmMain.btSetScaleToPagesClick(Sender: TObject);
begin
//  OC.ScaleToPages:=3;
end;

procedure TfmMain.btSet2PageFormatClick(Sender: TObject);
const
  STL='TestStyle';
begin
  //Добавим новый стиль страницы с форматом А5
  OW.PageStyles.Append(STL);
  OW.PageStyles.ItemsByName[STL].Landscape:=false;
  OW.PageStyles.ItemsByName[STL].Width:=14800;
  OW.PageStyles.ItemsByName[STL].Height:=21000;

  OW.ViewCursor.Text:='Page 1'+#13;
  OW.ViewCursor.CollapseToEnd;
  OW.ViewCursor.BreakType:=obtPageBefore;

  OW.ViewCursor.Text:='Page 2'+#13;
  OW.ViewCursor.PageStyleName:=STL;
  OW.ViewCursor.CollapseToEnd;
  OW.ViewCursor.BreakType:=obtPageBefore;

  OW.ViewCursor.Text:='Page 3'+#13;
  OW.ViewCursor.PageStyleName:='Standard';
  OW.ViewCursor.CollapseToEnd;
end;

procedure TfmMain.btSetAnnotationClick(Sender: TObject);
begin
  OC.Sheets[0].Cell[0,0].Annotation:='';
end;

procedure TfmMain.btPageStylesCountClick(Sender: TObject);
begin
  ShowMessage(IntToStr(OW.PageStyles.Count));
end;

procedure TfmMain.btAddPageStyleClick(Sender: TObject);
begin
  OW.PageStyles.Append('TestStyle');
end;

procedure TfmMain.btDeletePageStyleClick(Sender: TObject);
begin
  OW.PageStyles.DeleteByName('TestStyle');
end;

procedure TfmMain.btRenamePageStyleClick(Sender: TObject);
begin
  OW.PageStyles.ItemsByName['TestStyle'].Name:='NewTestStyleName';
end;

procedure TfmMain.btLandscapeClick(Sender: TObject);
begin
  OW.PageStyles.ItemsByName['TestStyle'].Landscape:=not OW.PageStyles.ItemsByName['TestStyle'].Landscape;
end;

procedure TfmMain.btGetPrinterNameClick(Sender: TObject);
begin
  ShowMessage(OW.Printer.Name);
end;

procedure TfmMain.btSetPrinterNameClick(Sender: TObject);
begin
  OW.Printer.Name:=cbPrinter.Text;
end;

procedure TfmMain.btGetPaperSizeClick(Sender: TObject);
begin
//  OW.PaperFormat:=opfA4;
  ShowMessage('Width='+IntToStr(OW.Printer.PaperSize.Width)+', Height='+IntToStr(OW.Printer.PaperSize.Height));
end;

procedure TfmMain.btGetAnnotationClick(Sender: TObject);
begin
  ShowMessage(OC.Sheets[0].Cell[0,0].Annotation)
end;

procedure TfmMain.btGetCopyCountClick(Sender: TObject);
begin
  ShowMessage('CopyCount='+IntToStr(OW.Printer.CopyCount));
end;

procedure TfmMain.btPrintClick(Sender: TObject);
begin
  OW.Printer.CopyCount:=3;
  OW.Printer.Pages:='1';
  OW.Printer.Print([optCopyCount,optPages]);
end;

procedure TfmMain.btPrintPagesClick(Sender: TObject);
begin
  OW.ViewCursor.GotoEnd(false);
  OW.ViewCursor.Font.FontName:='Times New Roman';
  OW.ViewCursor.Font.Height:=14;
  OW.ViewCursor.Text:='1111111111';
  OW.ViewCursor.CollapseToEnd;
  OW.ViewCursor.BreakType:=obtPageBefore;
  OW.ViewCursor.Text:=#13+'2222222222';
  OW.ViewCursor.CollapseToEnd;
  OW.Printer.Landscape:=true;
  OW.Printer.PrintPages([]);
end;

procedure TfmMain.cbPageStyleColorChange(Sender: TObject);
begin
  OW.PageStyles.ItemsByName['TestStyle'].BackColor:=cbPageStyleColor.Selected;
end;

procedure TfmMain.ckPageStyleTransClick(Sender: TObject);
begin
  OW.PageStyles.ItemsByName['TestStyle'].BackColorTransparent:=ckPageStyleTrans.Checked;
end;

procedure TfmMain.btBorderClick(Sender: TObject);
begin
//  OC.CellRangeByName['A1:C5'].Border.Left:=BLine(clRed,20,20,50);
//  OC.CellRangeByName['A1:C5'].Border.Right:=BLine(clGreen,20,20,50);
//  OC.CellRangeByName['A1:C5'].Border.Top:=BLine(clBlue,20,20,50);
//  OC.CellRangeByName['A1:C5'].Border.Bottom:=BLine(clBlack,20,20,50);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Left:=BLine(clRed,20,20,50);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Right:=BLine(clGreen,20,20,50);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Top:=BLine(clBlue,20,20,50);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Bottom:=BLine(clBlack,20,20,50);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Vertical:=BLine(clBlack,40,40,80);
  OC.Sheets[0].CellRangeByName['A1:C5'].TableBorder.Horizontal:=BLine(clRed,40,40,80);
end;

procedure TfmMain.btTableBorderClick(Sender: TObject);
begin
  OW.Tables.Insert(5,8,'NewTable',OW.ViewCursor);
//  OW.Tables.ItemsByName['NewTable'].CellRangeByName['A1:B3'].Border.Left:=BLine(clRed,20,20,50);
//  OW.Tables.ItemsByName['NewTable'].CellRangeByName['A1:B3'].Border.Right:=BLine(clGreen,20,20,50);
//  OW.Tables.ItemsByName['NewTable'].CellRangeByName['A1:B3'].Border.Top:=BLine(clBlue,20,20,50);
//  OW.Tables.ItemsByName['NewTable'].CellRangeByName['A1:B3'].Border.Bottom:=BLine(clBlack,20,20,50);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Left:=BLine(clRed,20,20,50);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Right:=BLine(clGreen,20,20,50);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Top:=BLine(clBlue,20,20,50);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Bottom:=BLine(clBlack,20,20,50);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Vertical:=BLine(clBlack,0,0,0);
  OW.Tables.ItemsByName['NewTable'].TableBorder.Horizontal:=BLine(clRed,40,40,80);
  OW.ViewCursor.GotoEnd(false);
  OW.ViewCursor.Text:='Test'+#13;
  OW.ViewCursor.GotoEnd(false);
  OW.Tables.Insert(5,8,'Table11',OW.ViewCursor);
  OW.Tables.ItemsByName['Table11'].TableBorder.SetAll(BLine(clRed,20,20,50),otbOuterHori);
end;

procedure TfmMain.btTextFrameClick(Sender: TObject);
begin
  OW.TextFrames.Append('Test',OW.ViewCursor);
  OW.TextFrames[0].AutoHeight:=false;
  OW.TextFrames[0].Width:=6000;
  OW.TextFrames[0].Height:=4000;
  OW.TextFrames[0].ModelCursor.Text:='Test string for text frame';
  OW.TextFrames[0].ModelCursor.GotoStart(false);
  OW.TextFrames[0].ModelCursor.GotoNextWord(true);
  OW.TextFrames[0].ModelCursor.Font.Height:=16;
  OW.TextFrames[0].ModelCursor.Font.Posture:=ofpItalic;
end;

procedure TfmMain.btPageStyleClick(Sender: TObject);
begin
  ShowMessage(OC.Sheets[0].PageStyle);
  OC.PageStyles.Append('CalcTestStyle');
  OC.PageStyles.ItemsByName['CalcTestStyle'].Width:=21000;
  OC.PageStyles.ItemsByName['CalcTestStyle'].Height:=29700;
  OC.PageStyles.ItemsByName['CalcTestStyle'].PageStyleLayout:=oplAll;
  OC.PageStyles.ItemsByName['CalcTestStyle'].HeaderIsShared:=false;
  OC.PageStyles.ItemsByName['CalcTestStyle'].ModelCursor[ochRightPageHeaderLeft].Text:='Test string for Calc header';
  OC.PageStyles.ItemsByName['CalcTestStyle'].ModelCursor[ochRightPageHeaderLeft].Font.Height:=14;
  OC.PageStyles.ItemsByName['CalcTestStyle'].Margin.Left:=5000;
  OC.Sheets[0].PageStyle:='CalcTestStyle';
end;

procedure TfmMain.btPrintModeClick(Sender: TObject);
begin
  OC.PageStyles.Append('CalcTestStyle');
  OC.PageStyles.ItemsByName['CalcTestStyle'].Width:=21000;
  OC.PageStyles.ItemsByName['CalcTestStyle'].Height:=29700;
  OC.PageStyles.ItemsByName['CalcTestStyle'].PageScale:=80;
  OC.Sheets[0].PageStyle:='CalcTestStyle';
  ShowMessage('Посмотрите в свойствах: печать на 80%');
  OC.PageStyles.ItemsByName['CalcTestStyle'].ScaleToPages:=3;
  ShowMessage('Посмотрите в свойствах: подогнать на 3 страницы');
  OC.PageStyles.ItemsByName['CalcTestStyle'].ScaleToPagesX:=2;
  OC.PageStyles.ItemsByName['CalcTestStyle'].ScaleToPagesY:=3;
end;

procedure TfmMain.btTextTableCursorClick(Sender: TObject);
begin
  OW.Tables.Insert(5,8,'NewTable',OW.ViewCursor);
  OW.Tables.ItemsByName['NewTable'].CellByName['A1'].AsText:='Test A1';
  OW.Tables.ItemsByName['NewTable'].CellByName['A2'].AsText:='Test A2';
  OW.Tables.ItemsByName['NewTable'].CellByName['A3'].AsText:='Test A3';

  OW.Tables.ItemsByName['NewTable'].TextTableCursor.GotoStart(false);
  OW.Tables.ItemsByName['NewTable'].TextTableCursor.GotoCellByName('A2',true);
  OW.Tables.ItemsByName['NewTable'].TextTableCursor.Font.Height:=14;

  OW.ModelCursor.GotoEnd(false);
  OW.ModelCursor.Text:='Test string';

  OW.Tables.Insert(5,8,'NewTable1',OW.ViewCursor);
  OW.Tables.ItemsByName['NewTable1'].CellByName['A1'].AsText:='Test A1';
  OW.Tables.ItemsByName['NewTable1'].CellByName['A2'].AsText:='Test A2';
  OW.Tables.ItemsByName['NewTable1'].CellByName['A3'].AsText:='Test A3';
  OW.Tables.ItemsByName['NewTable1'].TextTableCursor.GotoStart(false);
  OW.Tables.ItemsByName['NewTable1'].TextTableCursor.GotoCellByName('A2',true);
  OW.Tables.ItemsByName['NewTable1'].TextTableCursor.Font.Underline:=ofuBoldDashDotDot;
end;

procedure TfmMain.btSeparatorClick(Sender: TObject);
begin
  OW.Tables.Insert(5,8,'NewTable',OW.ViewCursor);
  OW.Tables.ItemsByName['NewTable'].Separator[1]:=3000;
  ShowMessage('Check');
  OW.Tables.ItemsByName['NewTable'].Rows[1].Separator[0]:=1500;
end;

procedure TfmMain.btTextGraphicFramesClick(Sender: TObject);
begin
  OW.TextFrames.Append('Test',OW.ViewCursor);
  OW.TextFrames.ItemsByName['Test'].Width:=5000;
  OW.TextFrames.ItemsByName['Test'].ModelCursor.Text:='Test text frame';
  OW.ViewCursor.GotoEnd(false);
  OW.ViewCursor.Font.FontName:='Times New Roman';
  OW.ViewCursor.Font.Height:=14;
  OW.ViewCursor.Text:='1111111111'+#13+'33333333'+#13;
  OW.ViewCursor.CollapseToEnd;
  OW.GraphicFrames.Append('Test1',OW.ViewCursor);
  OW.GraphicFrames[0].Width:=8000;
  OW.GraphicFrames[0].Height:=5000;
  OW.GraphicFrames[0].IsInverted:=true;
  OW.GraphicFrames[0].Surround:=owmNone;
  OW.GraphicFrames[0].LoadFromFile(ExtractFilePath(ParamStr(0))+'post.gif');
  OW.ViewCursor.GotoEnd(true);
  OW.ViewCursor.Text:='22222222'+#13;
  OW.ViewCursor.CollapseToEnd;
end;

procedure TfmMain.btCloseDocClick(Sender: TObject);
begin
  OW.CloseDocument;
end;

procedure TfmMain.btCloseCalcClick(Sender: TObject);
begin
  OC.CloseDocument;
end;

procedure TfmMain.btWriterModifiedClick(Sender: TObject);
begin
  ShowMessage('Modified : '+BoolToStr(OW.Modified,true));
end;

procedure TfmMain.btCalcModifiedClick(Sender: TObject);
begin
  ShowMessage('Modified : '+BoolToStr(OC.Modified,true));
end;

procedure TfmMain.btInsertDateTimeClick(Sender: TObject);
begin
  OW.ModelCursor.InsertDateTime(true,false,OW.NumberFormats.Add('DD.MM.YYYY HH:MM:SS'),1440);
end;

procedure TfmMain.btFillSeriesClick(Sender: TObject);
begin
  OC.Sheets[0].CellByName['B10'].AsNumber:=13.589;
  OC.Sheets[0].CellByName['C10'].AsNumber:=-89;
  OC.Sheets[0].CellRangeByName['B10:C20'].FillSeries(ofdToBottom,ofmLinear,ofdmDay,1.345,1e10);
end;

procedure TfmMain.btFindFirstClick(Sender: TObject);
begin
  if not OW.FindFirst('Test',[ospWholeWords]) then
    ShowMessage('Match not found!')
  else
    begin
      OW.ViewCursor.SyncFrom(OW.ModelCursor);
      ShowMessage(OW.ModelCursor.Text);
    end
end;

procedure TfmMain.btFindNextClick(Sender: TObject);
begin
  if not OW.FindNext then
    ShowMessage('Match not found!')
  else
    begin
      OW.ViewCursor.SyncFrom(OW.ModelCursor);
      ShowMessage(OW.ModelCursor.Text);
    end
end;

procedure TfmMain.btShowPreviewClick(Sender: TObject);
begin
  OW.ShowPreview;
end;

procedure TfmMain.btClosePreviewClick(Sender: TObject);
begin
  OW.ClosePreview;
end;

procedure TfmMain.btSaveClick(Sender: TObject);
begin
  OC.SaveDocument('e:\filename.xls','');
  OC.SaveDocument('e:\filename.ods','Calc');
end;

procedure TfmMain.btToPDFClick(Sender: TObject);
begin
  OW.ExportToPDF('e:\test1.pdf');
end;

procedure TfmMain.btFreezeClick(Sender: TObject);
begin
  OC.FreezeAtCurrentSheet(1,2);
end;

procedure TfmMain.btExecMacroClick(Sender: TObject);
begin
  OC.ExecMacro('Standard.Module1.Main111');
end;

procedure TfmMain.btExpandReferencesClick(Sender: TObject);
begin
  ShowMessage(BoolToStr(OC.ExpandReferences,true));
  OC.ExpandReferences:=true;
  ShowMessage(BoolToStr(OC.ExpandReferences,true));
end;

procedure TfmMain.btShapesCountClick(Sender: TObject);
var
  i:integer;
begin
  i:=OC.Sheets[0].LineShapes.Count;
  ShowMessage('Кол-во линий : '+IntToStr(i));
  OC.Sheets[0].LineShapes.Append(1000,1000,5000,5000,'Line'+IntToStr(i));
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.StartName:='Квадрат';
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.EndName:='Стрелка';
  OC.Sheets[0].GraphicShapes.Append(2000,8000,2000,4000,'Graphic1');
  OC.Sheets[0].GraphicShapes[0].LoadFromFile('e:\works\tip.gif');

  OC.Sheets[0].LineShapes.Append(2000,1000,4000,4000,'Line11');
  OC.Sheets[0].LineShapes.Append(3000,1000,0,2000,'Line12');
  OC.Sheets[0].LineShapes.ItemsByName['Line12'].Line.Joint:=osljRound;
end;

procedure TfmMain.btShapesClick(Sender: TObject);
begin
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.Color:=clRed;
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.Width:=50;
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.Style:=oslsDash;
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.Dash:=LDash(osdsRect,5,100,2,300,100);
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Line.DashName:='Стиль линии 9';
//  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Caption:='Test'+#13+'проба';
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Cursor.Text:='Test'+#13+'проба';
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Cursor.GotoEnd(false);
  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Cursor.GoLeft(3,true);
  //должно вывести 'оба'
  ShowMessage(OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Cursor.Text);

  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.AnimationKind:=osakBlink;
  OC.Sheets[0].GraphicShapes.ItemsByName['Graphic1'].LoadFromFile('e:\post.gif');
  OC.Sheets[0].GraphicShapes.ItemsByName['Graphic1'].Size:=PSize(6000,5000);
  OC.Sheets[0].GraphicShapes.ItemsByName['Graphic1'].Text.Cursor.Text:='New text';
  OC.Sheets[0].GraphicShapes.ItemsByName['Graphic1'].Transparence:=50;

  OC.Sheets[0].LineShapes.ItemsByName['Line0'].Text.Cursor.Text:='new';

  OC.Sheets[0].RectangleShapes.Append(2000,16000,4000,3000,'Rect1');
  OC.Sheets[0].RectangleShapes[0].CornerRadius:=300;
  OC.Sheets[0].RectangleShapes[0].Fill.Color:=clRed;
  OC.Sheets[0].RectangleShapes[0].Fill.Transparence:=70;

  OC.Sheets[0].MeasureShapes.Append(2000,20000,4000,0,'Measure1');
  OC.Sheets[0].MeasureShapes[0].TextVerticalPosition:=osmvEast;
  ShowMessage('osmvEast');
  OC.Sheets[0].MeasureShapes[0].TextVerticalPosition:=osmvBreakedLine;
  ShowMessage('osmvBreakedLine');
  OC.Sheets[0].MeasureShapes[0].TextVerticalPosition:=osmvWest;
  ShowMessage('osmvWest');
  OC.Sheets[0].MeasureShapes[0].TextVerticalPosition:=osmvCentered;
  ShowMessage('osmvCentered');

  ShowMessage(OC.Sheets[0].MeasureShapes[0].Text.Cursor.Text);

  OC.Sheets[0].EllipseShapes.Append(10000,5000,2000,1500,'E1');
  OC.Sheets[0].EllipseShapes[0].StartAngle:=0;
  OC.Sheets[0].EllipseShapes[0].EndAngle:=6000;
  OC.Sheets[0].EllipseShapes[0].Kind:=osckSection;
end;

procedure TfmMain.btSortClick(Sender: TObject);
var
  A:TOpenSortFields;
begin
  OC.Sheets[0].Cell[0,0].AsNumber:=4;
  OC.Sheets[0].Cell[0,1].AsNumber:=2;
  OC.Sheets[0].Cell[0,2].AsNumber:=1;
  OC.Sheets[0].Cell[0,3].AsNumber:=3;
  OC.Sheets[0].Cell[1,0].AsNumber:=3;
  OC.Sheets[0].Cell[1,1].AsNumber:=1;
  OC.Sheets[0].Cell[1,2].AsNumber:=5;
  OC.Sheets[0].Cell[1,3].AsNumber:=4;
  SetLength(A,1);
  A[0]:=ASortField(10,true,false,osrAuto);
//  OC.Sheets[0].CellRange[0,0,1,3].Sort(true,false,A);
  OC.Sheets[0].CellRange[0,1,1,2].SortTo(0,0,10,true,true,false,A);
end;

procedure TfmMain.btTransformationClick(Sender: TObject);
var
  M:TOpenMatrix;
begin
  OC.Sheets[0].RectangleShapes.Append(2000,1000,4000,2500,'Rect1');
  OC.Sheets[0].RectangleShapes[0].CornerRadius:=300;
  OC.Sheets[0].RectangleShapes[0].Fill.Color:=clRed;
  OC.Sheets[0].RectangleShapes[0].Fill.Transparence:=80;

  M:=OC.Sheets[0].RectangleShapes[0].Transformation;
  ShowMessage(FloatToStr(M.L1.C1)+' '#9+FloatToStr(M.L1.C2)+' '#9+FloatToStr(M.L1.C3)+#13+
              FloatToStr(M.L2.C1)+' '#9+FloatToStr(M.L2.C2)+' '#9+FloatToStr(M.L2.C3)+#13+
              FloatToStr(M.L3.C1)+' '#9+FloatToStr(M.L3.C2)+' '#9+FloatToStr(M.L3.C3));
  M.L2.C3:=M.L2.C3*2;
  OC.Sheets[0].RectangleShapes[0].Transformation:=M;
  M:=OC.Sheets[0].RectangleShapes[0].Transformation;
  ShowMessage(FloatToStr(M.L1.C1)+' '#9+FloatToStr(M.L1.C2)+' '#9+FloatToStr(M.L1.C3)+#13+
              FloatToStr(M.L2.C1)+' '#9+FloatToStr(M.L2.C2)+' '#9+FloatToStr(M.L2.C3)+#13+
              FloatToStr(M.L3.C1)+' '#9+FloatToStr(M.L3.C2)+' '#9+FloatToStr(M.L3.C3));
end;

procedure TfmMain.btChartClick(Sender: TObject);
var
  Ar:TOpenRangeAddresses;
begin
  OC.Sheets[0].Cell[0,0].AsText:='Value1';
  OC.Sheets[0].Cell[0,1].AsNumber:=2;
  OC.Sheets[0].Cell[0,2].AsNumber:=1;
  OC.Sheets[0].Cell[0,3].AsNumber:=3;
  OC.Sheets[0].Cell[0,4].AsNumber:=4;
  OC.Sheets[0].Cell[0,5].AsNumber:=1;
  OC.Sheets[0].Cell[0,6].AsNumber:=5;
  OC.Sheets[0].Cell[0,7].AsNumber:=4;
  OC.Sheets[0].Cell[2,0].AsText:='Value2';
  OC.Sheets[0].Cell[2,1].AsNumber:=22;
  OC.Sheets[0].Cell[2,2].AsNumber:=11;
  OC.Sheets[0].Cell[2,3].AsNumber:=23;
  OC.Sheets[0].Cell[2,4].AsNumber:=34;
  OC.Sheets[0].Cell[2,5].AsNumber:=21;
  OC.Sheets[0].Cell[2,6].AsNumber:=15;
  OC.Sheets[0].Cell[2,7].AsNumber:=24;
  SetLength(Ar,2);
  Ar[0]:=RAddress(0,0,0,0,7);
  Ar[1]:=RAddress(0,2,0,2,7);
  OC.Sheets[0].BarCharts.Append('Test',PRect(8000,1000,10000,5000),Ar,true,false);
  OC.Sheets[0].BarCharts[0].HasMainTitle:=true;
  OC.Sheets[0].BarCharts[0].MainTitle.Text:='Main title text';

  OC.Sheets[0].BarCharts[0].HasSubTitle:=true;
  OC.Sheets[0].BarCharts[0].SubTitle.Text:='Subtitle text';

  OC.Sheets[0].BarCharts[0].HasLegend:=true;
  OC.Sheets[0].BarCharts[0].Legend.Alignment:=olpBottom;
  OC.Sheets[0].BarCharts[0].Legend.Font.Height:=14;
  OC.Sheets[0].BarCharts[0].Legend.Line.Style:=oslsSolid;
  OC.Sheets[0].BarCharts[0].Legend.Line.Width:=40;
  OC.Sheets[0].BarCharts[0].Stacked:=true;
  OC.Sheets[0].BarCharts[0].Dim3D:=true;
  OC.Sheets[0].BarCharts[0].Deep:=true;
  OC.Sheets[0].BarCharts[0].DataPoint[1,2].Bar3DType:=ocstCylinder;
  OC.Sheets[0].BarCharts[0].DataPoint[1,2].Fill.Color:=clBlue;
  OC.Sheets[0].BarCharts[0].DataPoint[1,2].DataCaption:=ocdcValue;
  OC.Sheets[0].BarCharts[0].DataPoint[1,2].LabelRotation:=4500;

  OC.Sheets[0].AreaCharts.Append('TestAreaChart',PRect(8000,8000,10000,5000),Ar,true,false);
  OC.Sheets[0].AreaCharts[0].Dim3D:=true;
  OC.Sheets[0].AreaCharts[0].DataRow[0].DataPoints.DataCaption:=ocdcValue;
  OC.Sheets[0].AreaCharts[0].DataRow[0].DataPoints.Font.Height:=14;
  OC.Sheets[0].AreaCharts[0].DataRow[0].DataPoints.Font.Weight:=ofwBold;
  OC.Sheets[0].AreaCharts[0].Deep:=true;
  OC.Sheets[0].AreaCharts[0].Vertical:=false;
end;

procedure TfmMain.btCopySheetClick(Sender: TObject);
begin
  OC.Sheets[0].Copy('New',10);
end;

procedure TfmMain.btOpenDocClick(Sender: TObject);
var
  Ar:TOpenRangeAddresses;
begin
  OC.Connect:=true;
  if not OC.Connect then
    begin
      ShowMessage('Error! Not connected!');
      Exit;
    end;
  OC.OpenDocument('e:\Works\OpenOffice\charts.ods',[],ommAlways);
  SetLength(Ar,1);
  Ar[0]:=RAddress(4,0,4,2,18);
  OC.Sheets[4].BarCharts.Append('Test',PRect(8000,1000,10000,5000),Ar,true,true);
//  OC.Sheets[4].BarCharts.ItemsByName['Test'].DiagramType:=odgLine;
end;

procedure TfmMain.btConnectToClick(Sender: TObject);
var
  b:boolean;
begin
  OC.Connect:=true;
  if not OC.Connect then
    begin
      ShowMessage('Error! Not connected!');
      Exit;
    end;
  b:=OC.ConnectTo('e:\Works\OpenOffice\charts.ods');
  ShowMessage('ConnectTo - '+BoolToStr(b,true));
end;

procedure TfmMain.btVisibleClick(Sender: TObject);
begin
  OW.Visible:=true;
end;

procedure TfmMain.btConnectClick(Sender: TObject);
begin
  OW.Connect:=true;
  if not OW.Connect then
    begin
      ShowMessage('Error! Not connected!');
    end;
end;

procedure TfmMain.btInsertTableClick(Sender: TObject);
begin
  OW.Tables.Insert(4,3,'Table1',OW.ViewCursor);
  OW.Tables[0].CellByName['A1'].AsText:='Col1';
  OW.Tables[0].CellByName['B1'].AsText:='Col2';
  OW.Tables[0].CellByName['C1'].AsText:='Col3';
end;

procedure TfmMain.btDeleteTableClick(Sender: TObject);
begin
//  OW.Tables.RemoveByName('Table1');
  OW.Tables.DeleteByIndex(0);
end;

procedure TfmMain.btUsedAreaClick(Sender: TObject);
var
  RA:TOpenRangeAddress;
begin
  RA:=OC.Sheets[0].UsedArea;
  ShowMessage('UsedArea:'+#13+
              'Sheet : '+IntToStr(RA.Sheet)+#13+
              'StartColumn : '+IntToStr(RA.StartColumn)+#13+
              'StartRow : '+IntToStr(RA.StartRow)+#13+
              'EndColumn : '+IntToStr(RA.EndColumn)+#13+
              'EndRow : '+IntToStr(RA.EndRow));
end;

procedure TfmMain.btRemoveBookmarkClick(Sender: TObject);
begin
  OW.Bookmarks.DeleteByIndex(0);
end;

procedure TfmMain.btGetVisibleClick(Sender: TObject);
begin
  ShowMessage('Writer visible : '+BoolToStr(OW.Visible,true));
end;

procedure TfmMain.btDateSeparatorClick(Sender: TObject);
begin
  ShowMessage(OC.GlobalLocale.DecimalSeparator+' '+OC.GlobalLocale.MeasurementSystem);
end;

procedure TfmMain.btLanguageClick(Sender: TObject);
begin
  ShowMessage(OC.DocLocale.Language+' '+OC.DocLocale.Country+' '+OC.DocLocale.Variant);
end;

procedure TfmMain.btTextCursorClick(Sender: TObject);
begin
  OC.Sheets[0].Cell[1,1].AsText:='H20 Test string';
  OC.Sheets[0].Cell[1,1].TextCursor.GotoStart(false);
  OC.Sheets[0].Cell[1,1].TextCursor.GoRight(1,false);
  OC.Sheets[0].Cell[1,1].TextCursor.GoRight(1,true);
  OC.Sheets[0].Cell[1,1].TextCursor.Font.Escapement:=-25;
  OC.Sheets[0].Cell[1,1].TextCursor.Font.EscapementHeight:=75;
  OC.Sheets[0].Cell[1,1].TextCursor.GotoEnd(false);
  if OC.Sheets[0].Cell[1,1].TextCursor.IsCollapsed then
    ShowMessage('Collapsed');
  OC.Sheets[0].Cell[1,1].TextCursor.Text:='TEST ';
end;

end.
