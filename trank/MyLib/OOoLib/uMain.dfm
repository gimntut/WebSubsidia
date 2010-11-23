object fmMain: TfmMain
  Left = 272
  Top = 144
  Caption = 'fmMain'
  ClientHeight = 784
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 784
    Align = alLeft
    TabOrder = 0
    object btNewCalc: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = 'NewCalc'
      TabOrder = 0
      OnClick = btNewCalcClick
    end
    object btTestWrite: TButton
      Left = 8
      Top = 40
      Width = 97
      Height = 25
      Caption = 'TestWrite'
      TabOrder = 1
      OnClick = btTestWriteClick
    end
    object btGetPageScale: TButton
      Left = 8
      Top = 72
      Width = 97
      Height = 25
      Caption = 'GetPageScale'
      TabOrder = 2
      OnClick = btGetPageScaleClick
    end
    object btSetPageScale: TButton
      Left = 8
      Top = 104
      Width = 97
      Height = 25
      Caption = 'SetPageScale'
      TabOrder = 3
      OnClick = btSetPageScaleClick
    end
    object btGetScaleToPages: TButton
      Left = 8
      Top = 136
      Width = 97
      Height = 25
      Caption = 'GetScaleToPages'
      TabOrder = 4
      OnClick = btGetScaleToPagesClick
    end
    object btSetScaleToPages: TButton
      Left = 8
      Top = 168
      Width = 97
      Height = 25
      Caption = 'SetScaleToPages'
      TabOrder = 5
      OnClick = btSetScaleToPagesClick
    end
    object btPageStyle: TButton
      Left = 8
      Top = 200
      Width = 97
      Height = 25
      Caption = 'PageStyle'
      TabOrder = 6
      OnClick = btPageStyleClick
    end
    object btBorder: TButton
      Left = 8
      Top = 232
      Width = 97
      Height = 25
      Caption = 'Border'
      TabOrder = 7
      OnClick = btBorderClick
    end
    object btPrintMode: TButton
      Left = 8
      Top = 264
      Width = 97
      Height = 25
      Caption = 'PrintMode'
      TabOrder = 8
      OnClick = btPrintModeClick
    end
    object btCloseCalc: TButton
      Left = 112
      Top = 8
      Width = 97
      Height = 25
      Caption = 'CloseCalc'
      TabOrder = 9
      OnClick = btCloseCalcClick
    end
    object btCalcModified: TButton
      Left = 112
      Top = 40
      Width = 97
      Height = 25
      Caption = 'CalcModified'
      TabOrder = 10
      OnClick = btCalcModifiedClick
    end
    object btFillSeries: TButton
      Left = 112
      Top = 72
      Width = 97
      Height = 25
      Caption = 'FillSeries'
      TabOrder = 11
      OnClick = btFillSeriesClick
    end
    object btSave: TButton
      Left = 112
      Top = 104
      Width = 97
      Height = 25
      Caption = 'Save'
      TabOrder = 12
      OnClick = btSaveClick
    end
    object btFreeze: TButton
      Left = 112
      Top = 168
      Width = 97
      Height = 25
      Caption = 'Freeze'
      TabOrder = 13
      OnClick = btFreezeClick
    end
    object btExecMacro: TButton
      Left = 8
      Top = 328
      Width = 97
      Height = 25
      Caption = 'ExecMacro'
      TabOrder = 14
      OnClick = btExecMacroClick
    end
    object btExpandReferences: TButton
      Left = 8
      Top = 360
      Width = 97
      Height = 25
      Caption = 'ExpandReferences'
      TabOrder = 15
      OnClick = btExpandReferencesClick
    end
    object btShapesCount: TButton
      Left = 8
      Top = 416
      Width = 97
      Height = 25
      Caption = 'ShapesCount'
      TabOrder = 16
      OnClick = btShapesCountClick
    end
    object btShapes: TButton
      Left = 8
      Top = 448
      Width = 97
      Height = 25
      Caption = 'Shapes'
      TabOrder = 17
      OnClick = btShapesClick
    end
    object btSort: TButton
      Left = 112
      Top = 448
      Width = 97
      Height = 25
      Caption = 'Sort'
      TabOrder = 18
      OnClick = btSortClick
    end
    object btTransformation: TButton
      Left = 112
      Top = 480
      Width = 97
      Height = 25
      Caption = 'Transformation'
      TabOrder = 19
      OnClick = btTransformationClick
    end
    object btChart: TButton
      Left = 8
      Top = 480
      Width = 97
      Height = 25
      Caption = 'Chart'
      TabOrder = 20
      OnClick = btChartClick
    end
    object btCopySheet: TButton
      Left = 112
      Top = 328
      Width = 97
      Height = 25
      Caption = 'CopySheet'
      TabOrder = 21
      OnClick = btCopySheetClick
    end
    object btOpenDoc: TButton
      Left = 8
      Top = 512
      Width = 97
      Height = 25
      Caption = 'OpenDoc'
      TabOrder = 22
      OnClick = btOpenDocClick
    end
    object btConnectTo: TButton
      Left = 8
      Top = 544
      Width = 97
      Height = 25
      Caption = 'ConnectTo'
      TabOrder = 23
      OnClick = btConnectToClick
    end
    object btUsedArea: TButton
      Left = 112
      Top = 544
      Width = 97
      Height = 25
      Caption = 'UsedArea'
      TabOrder = 24
      OnClick = btUsedAreaClick
    end
    object btDateSeparator: TButton
      Left = 8
      Top = 606
      Width = 97
      Height = 25
      Caption = 'DateSeparator'
      TabOrder = 25
      OnClick = btDateSeparatorClick
    end
    object btLanguage: TButton
      Left = 8
      Top = 640
      Width = 97
      Height = 25
      Caption = 'Language'
      TabOrder = 26
      OnClick = btLanguageClick
    end
    object btTextCursor: TButton
      Left = 111
      Top = 606
      Width = 97
      Height = 25
      Caption = 'TextCursor'
      TabOrder = 27
      OnClick = btTextCursorClick
    end
    object btGetAnnotation: TButton
      Left = 111
      Top = 641
      Width = 96
      Height = 25
      Caption = 'GetAnnotation'
      TabOrder = 28
      OnClick = btGetAnnotationClick
    end
    object btSetAnnotation: TButton
      Left = 113
      Top = 672
      Width = 96
      Height = 25
      Caption = 'SetAnnotation'
      TabOrder = 29
      OnClick = btSetAnnotationClick
    end
  end
  object Panel2: TPanel
    Left = 249
    Top = 0
    Width = 353
    Height = 784
    Align = alLeft
    TabOrder = 1
    object btNewWriter: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = 'NewWriter'
      TabOrder = 0
      OnClick = btNewWriterClick
    end
    object btInsertRows: TButton
      Left = 8
      Top = 72
      Width = 97
      Height = 25
      Caption = 'InsertRows'
      TabOrder = 1
      OnClick = btInsertRowsClick
    end
    object btAppendRows: TButton
      Left = 8
      Top = 104
      Width = 97
      Height = 25
      Caption = 'AppendRows'
      TabOrder = 2
      OnClick = btAppendRowsClick
    end
    object btDeleteRows: TButton
      Left = 8
      Top = 136
      Width = 97
      Height = 25
      Caption = 'DeleteRows'
      TabOrder = 3
      OnClick = btDeleteRowsClick
    end
    object btInsertColumns: TButton
      Left = 8
      Top = 168
      Width = 97
      Height = 25
      Caption = 'InsertColumns'
      TabOrder = 4
      OnClick = btInsertColumnsClick
    end
    object btAppendColumns: TButton
      Left = 8
      Top = 200
      Width = 97
      Height = 25
      Caption = 'AppendColumns'
      TabOrder = 5
      OnClick = btAppendColumnsClick
    end
    object btDeleteColumns: TButton
      Left = 8
      Top = 232
      Width = 97
      Height = 25
      Caption = 'DeleteColumns'
      TabOrder = 6
      OnClick = btDeleteColumnsClick
    end
    object btMainTest: TButton
      Left = 8
      Top = 40
      Width = 97
      Height = 25
      Caption = 'Main test'
      TabOrder = 7
      OnClick = btMainTestClick
    end
    object btInsertDoc: TButton
      Left = 8
      Top = 288
      Width = 97
      Height = 25
      Caption = 'InsertDoc'
      TabOrder = 8
      OnClick = btInsertDocClick
    end
    object btSet2PageFormat: TButton
      Left = 8
      Top = 320
      Width = 97
      Height = 25
      Caption = 'Set2PageFormat'
      TabOrder = 9
      OnClick = btSet2PageFormatClick
    end
    object btPageStylesCount: TButton
      Left = 248
      Top = 136
      Width = 97
      Height = 25
      Caption = 'PageStylesCount'
      TabOrder = 10
      OnClick = btPageStylesCountClick
    end
    object btAddPageStyle: TButton
      Left = 248
      Top = 168
      Width = 97
      Height = 25
      Caption = 'AddPageStyle'
      TabOrder = 11
      OnClick = btAddPageStyleClick
    end
    object btDeletePageStyle: TButton
      Left = 248
      Top = 200
      Width = 97
      Height = 25
      Caption = 'DeletePageStyle'
      TabOrder = 12
      OnClick = btDeletePageStyleClick
    end
    object btRenamePageStyle: TButton
      Left = 248
      Top = 232
      Width = 97
      Height = 25
      Caption = 'RenamePageStyle'
      TabOrder = 13
      OnClick = btRenamePageStyleClick
    end
    object btLandscape: TButton
      Left = 248
      Top = 264
      Width = 97
      Height = 25
      Caption = 'Landscape'
      TabOrder = 14
      OnClick = btLandscapeClick
    end
    object cbPageStyleColor: TColorBox
      Left = 248
      Top = 296
      Width = 97
      Height = 22
      NoneColorColor = clWhite
      Selected = clWhite
      TabOrder = 15
      OnChange = cbPageStyleColorChange
    end
    object ckPageStyleTrans: TCheckBox
      Left = 240
      Top = 328
      Width = 105
      Height = 17
      Caption = 'PSBckClrTrans'
      TabOrder = 16
      OnClick = ckPageStyleTransClick
    end
    object btTableBorder: TButton
      Left = 8
      Top = 352
      Width = 97
      Height = 25
      Caption = 'TableBorder'
      TabOrder = 17
      OnClick = btTableBorderClick
    end
    object btTextFrame: TButton
      Left = 8
      Top = 448
      Width = 97
      Height = 25
      Caption = 'TextFrame'
      TabOrder = 18
      OnClick = btTextFrameClick
    end
    object btTextTableCursor: TButton
      Left = 8
      Top = 384
      Width = 97
      Height = 25
      Caption = 'TextTableCursor'
      TabOrder = 19
      OnClick = btTextTableCursorClick
    end
    object btSeparator: TButton
      Left = 8
      Top = 416
      Width = 97
      Height = 25
      Caption = 'Separator'
      TabOrder = 20
      OnClick = btSeparatorClick
    end
    object btTextGraphicFrames: TButton
      Left = 8
      Top = 480
      Width = 97
      Height = 25
      Caption = 'TextGraphicFrames'
      TabOrder = 21
      OnClick = btTextGraphicFramesClick
    end
    object btWriterModified: TButton
      Left = 112
      Top = 40
      Width = 97
      Height = 25
      Caption = 'WriterModified'
      TabOrder = 22
      OnClick = btWriterModifiedClick
    end
    object btCloseDoc: TButton
      Left = 112
      Top = 8
      Width = 97
      Height = 25
      Caption = 'CloseDoc'
      TabOrder = 23
      OnClick = btCloseDocClick
    end
    object btInsertDateTime: TButton
      Left = 112
      Top = 72
      Width = 97
      Height = 25
      Caption = 'InsertDateTime'
      TabOrder = 24
      OnClick = btInsertDateTimeClick
    end
    object btShowPreview: TButton
      Left = 112
      Top = 104
      Width = 97
      Height = 25
      Caption = 'ShowPreview'
      TabOrder = 25
      OnClick = btShowPreviewClick
    end
    object btClosePreview: TButton
      Left = 112
      Top = 136
      Width = 97
      Height = 25
      Caption = 'ClosePreview'
      TabOrder = 26
      OnClick = btClosePreviewClick
    end
    object btToPDF: TButton
      Left = 112
      Top = 288
      Width = 89
      Height = 25
      Caption = 'ToPDF'
      TabOrder = 27
      OnClick = btToPDFClick
    end
    object btVisible: TButton
      Left = 216
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Visible'
      TabOrder = 28
      OnClick = btVisibleClick
    end
    object btConnect: TButton
      Left = 216
      Top = 72
      Width = 89
      Height = 25
      Caption = 'Connect'
      TabOrder = 29
      OnClick = btConnectClick
    end
    object btInsertTable: TButton
      Left = 208
      Top = 384
      Width = 89
      Height = 25
      Caption = 'InsertTable'
      TabOrder = 30
      OnClick = btInsertTableClick
    end
    object btDeleteTable: TButton
      Left = 208
      Top = 416
      Width = 89
      Height = 25
      Caption = 'DeleteTable'
      TabOrder = 31
      OnClick = btDeleteTableClick
    end
    object btRemoveBookmark: TButton
      Left = 208
      Top = 448
      Width = 89
      Height = 25
      Caption = 'RemoveBookmark'
      TabOrder = 32
      OnClick = btRemoveBookmarkClick
    end
    object btGetVisible: TButton
      Left = 216
      Top = 40
      Width = 89
      Height = 25
      Caption = 'GetVisible'
      TabOrder = 33
      OnClick = btGetVisibleClick
    end
    object btFindFirst: TButton
      Left = 8
      Top = 544
      Width = 97
      Height = 25
      Caption = 'FindFirst'
      TabOrder = 34
      OnClick = btFindFirstClick
    end
    object btFindNext: TButton
      Left = 8
      Top = 575
      Width = 97
      Height = 25
      Caption = 'FindNext'
      TabOrder = 35
      OnClick = btFindNextClick
    end
  end
  object Panel3: TPanel
    Left = 602
    Top = 0
    Width = 320
    Height = 784
    Align = alClient
    TabOrder = 2
    object btGetPrinterName: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = 'GetPrinterName'
      TabOrder = 0
      OnClick = btGetPrinterNameClick
    end
    object cbPrinter: TComboBox
      Left = 8
      Top = 40
      Width = 97
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object btSetPrinterName: TButton
      Left = 8
      Top = 72
      Width = 97
      Height = 25
      Caption = 'SetPrinterName'
      TabOrder = 2
      OnClick = btSetPrinterNameClick
    end
    object btGetPaperSize: TButton
      Left = 8
      Top = 104
      Width = 97
      Height = 25
      Caption = 'GetPaperSize'
      TabOrder = 3
      OnClick = btGetPaperSizeClick
    end
    object btGetCopyCount: TButton
      Left = 8
      Top = 168
      Width = 97
      Height = 25
      Caption = 'GetCopyCount'
      TabOrder = 4
      OnClick = btGetCopyCountClick
    end
    object btPrint: TButton
      Left = 8
      Top = 232
      Width = 97
      Height = 25
      Caption = 'Print'
      TabOrder = 5
      OnClick = btPrintClick
    end
    object btPrintPages: TButton
      Left = 8
      Top = 200
      Width = 97
      Height = 25
      Caption = 'PrintPages'
      TabOrder = 6
      OnClick = btPrintPagesClick
    end
  end
end
