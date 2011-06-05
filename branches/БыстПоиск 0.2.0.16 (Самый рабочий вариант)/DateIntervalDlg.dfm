object PeriodDlg: TPeriodDlg
  Left = 0
  Top = 0
  ActiveControl = Panel1
  Caption = #1042#1099#1073#1086#1088' '#1080#1085#1090#1077#1088#1074#1072#1083#1072' '#1076#1072#1090
  ClientHeight = 430
  ClientWidth = 859
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 401
    Top = 0
    Width = 4
    Height = 389
    Beveled = True
    Color = clGradientInactiveCaption
    ParentColor = False
    ExplicitTop = 25
    ExplicitHeight = 364
  end
  object Edit1: TEdit
    Left = 8
    Top = 401
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Panel1: TPanel
    Left = 0
    Top = 389
    Width = 859
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      859
      41)
    object btnOK: TButton
      Left = 692
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 773
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 389
    Align = alLeft
    BevelInner = bvLowered
    TabOrder = 3
    OnResize = PictResize
    ExplicitTop = 25
    ExplicitHeight = 364
    object Image1: TImage
      Left = 2
      Top = 96
      Width = 397
      Height = 239
      Align = alClient
      OnMouseDown = Image1MouseDown
      OnMouseUp = Image1MouseUp
      ExplicitLeft = 1
      ExplicitTop = 3
      ExplicitWidth = 412
      ExplicitHeight = 257
    end
    object Label2: TLabel
      Left = 2
      Top = 335
      Width = 397
      Height = 52
      Align = alBottom
      Caption = 
        #1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072' '#1082#1083#1080#1082#1085#1080#1090#1077' '#1084#1099#1096#1100#1102' '#1080#1083#1080' '#1085#1072#1078#1080#1084#1072#1081#1090#1077' '#1082#1083#1072#1074#1080#1096#1080' '#1089 +
        #1090#1088#1077#1083#1086#1082'. '#1050#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072' '#1074#1099#1073#1080#1088#1072#1077#1090#1089#1103' '#1072#1085#1072#1083#1086#1075#1080#1095#1085#1086', '#1085#1086' '#1089' '#1085#1072#1078#1072#1090#1086#1081' '#1082#1083#1072#1074#1080#1096 +
        #1077#1081' Ctrl. '#1055#1056#1054#1041#1045#1051' - '#1074#1099#1073#1080#1088#1072#1077#1090' 6 '#1084#1077#1089#1103#1094#1077#1074' '#1087#1077#1088#1077#1076' '#1090#1077#1082#1091#1097#1080#1084'. Ctrl+'#1055#1056#1054#1041#1045#1051' ' +
        '- '#1087#1086#1082#1072#1079#1099#1074#1072#1077#1090' '#1074' '#1089#1087#1088#1072#1074#1082#1077' '#1074#1089#1077' '#1089#1091#1084#1084#1099' ('#1055#1086#1083#1085#1099#1081' '#1087#1086#1082#1072#1079').'
      WordWrap = True
      ExplicitTop = 310
      ExplicitWidth = 381
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 391
      Height = 19
      Align = alTop
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 5
    end
    object CheckBox1: TCheckBox
      AlignWithMargins = True
      Left = 5
      Top = 76
      Width = 391
      Height = 17
      Align = alTop
      Caption = 'CheckBox1'
      TabOrder = 0
      Visible = False
      OnClick = TriggerClick
      ExplicitTop = 51
    end
    object CheckBox2: TCheckBox
      AlignWithMargins = True
      Left = 5
      Top = 53
      Width = 391
      Height = 17
      Align = alTop
      Caption = 'CheckBox1'
      TabOrder = 1
      Visible = False
      OnClick = TriggerClick
      ExplicitTop = 28
    end
    object CheckBox3: TCheckBox
      AlignWithMargins = True
      Left = 5
      Top = 30
      Width = 391
      Height = 17
      Align = alTop
      Caption = 'CheckBox1'
      TabOrder = 2
      Visible = False
      OnClick = TriggerClick
      ExplicitTop = 5
    end
  end
  object Memo1: TMemo
    Left = 405
    Top = 0
    Width = 454
    Height = 389
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitTop = 25
    ExplicitHeight = 364
  end
end
