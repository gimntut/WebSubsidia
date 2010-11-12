object ImportDlg: TImportDlg
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1085#1086#1089' '#1073#1072#1079' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 360
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 532
    Height = 32
    Align = alTop
    TabOrder = 0
    Tabs.Strings = (
      #1044#1077#1090#1089#1082#1080#1077' '#1087#1086#1089#1086#1073#1080#1103
      #1045#1044#1050
      #1042#1099#1087#1083#1072#1090#1099)
    TabIndex = 0
    OnChange = TabControl1Change
  end
  object Panel1: TPanel
    Left = 0
    Top = 32
    Width = 532
    Height = 328
    Align = alClient
    TabOrder = 1
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 21
      Width = 524
      Height = 115
      Align = alTop
      Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
      TabOrder = 0
      DesignSize = (
        524
        115)
      object Memo1: TMemo
        Left = 8
        Top = 16
        Width = 508
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Color = cl3DLight
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          #1059#1082#1072#1078#1080#1090#1077' '#1087#1072#1087#1082#1091' '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1093#1088#1072#1085#1080#1090#1100#1089#1103' '#1073#1072#1079#1072' %s.'
          #1055#1072#1087#1082#1072' '#1076#1086#1083#1078#1085#1072' '#1085#1072#1079#1099#1074#1072#1090#1100#1089#1103' %s.')
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 8
        Top = 79
        Width = 427
        Height = 19
        Anchors = [akLeft, akTop, akRight]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        OnChange = Edit1Change
      end
      object Button1: TButton
        Left = 441
        Top = 76
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1073#1079#1086#1088'...'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object GroupBox2: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 142
      Width = 524
      Height = 115
      Align = alTop
      Caption = ' '#1050#1091#1076#1072' '#1089#1086#1093#1088#1072#1085#1103#1090#1100
      TabOrder = 1
      DesignSize = (
        524
        115)
      object Memo2: TMemo
        Left = 8
        Top = 16
        Width = 508
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Color = cl3DLight
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          #1059#1082#1072#1078#1080#1090#1077' '#1087#1072#1087#1082#1091' '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1093#1088#1072#1085#1080#1090#1100#1089#1103' '#1073#1072#1079#1072' %s.'
          #1055#1072#1087#1082#1072' '#1076#1086#1083#1078#1085#1072' '#1085#1072#1079#1099#1074#1072#1090#1100#1089#1103' %s.')
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 8
        Top = 79
        Width = 427
        Height = 19
        Anchors = [akLeft, akTop, akRight]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        OnChange = Edit2Change
      end
      object Button2: TButton
        Left = 441
        Top = 76
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1073#1079#1086#1088'...'
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 260
      Width = 530
      Height = 41
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 2
      DesignSize = (
        530
        41)
      object ExchangeBtn: TButton
        Left = 227
        Top = 8
        Width = 75
        Height = 25
        Anchors = []
        Caption = #1054#1073#1084#1077#1085
        TabOrder = 0
        OnClick = ExchangeBtnClick
      end
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 530
      Height = 17
      Align = alTop
      TabOrder = 3
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 488
    Top = 56
  end
  object XPManifest1: TXPManifest
    Left = 456
    Top = 56
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 16
    Top = 320
  end
end
