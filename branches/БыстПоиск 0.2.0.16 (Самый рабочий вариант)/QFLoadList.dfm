object Form10: TForm10
  Left = 0
  Top = 0
  ActiveControl = CheckListBox1
  Caption = #1057#1087#1080#1089#1086#1082' '#1073#1099#1089#1090#1088#1086#1081' '#1079#1072#1075#1088#1091#1079#1082#1080
  ClientHeight = 357
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 496
    Height = 13
    Align = alTop
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1082#1080#1077' '#1092#1072#1081#1083#1099' '#1091#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1073#1099#1089#1090#1088#1086#1081' '#1079#1072#1075#1088#1091#1079#1082#1080':'
    WordWrap = True
    ExplicitWidth = 315
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 300
    Width = 496
    Height = 13
    Align = alBottom
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1082#1080#1077' '#1092#1072#1081#1083#1099' '#1091#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1073#1099#1089#1090#1088#1086#1081' '#1079#1072#1075#1088#1091#1079#1082#1080':'
    WordWrap = True
    ExplicitWidth = 315
  end
  object Panel1: TPanel
    Left = 0
    Top = 316
    Width = 502
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      502
      41)
    object Button1: TButton
      Left = 343
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 424
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 5
      Top = 8
      Width = 75
      Height = 25
      Caption = #1060#1072#1081#1083'...'
      ModalResult = 2
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 19
    Width = 502
    Height = 278
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ItemHeight = 11
    ParentFont = False
    TabOrder = 1
    OnClick = CheckListBox1Click
  end
end
