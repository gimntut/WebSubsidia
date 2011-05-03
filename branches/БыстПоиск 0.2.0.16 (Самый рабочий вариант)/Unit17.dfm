object FioDlg: TFioDlg
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1082#1072' '#1089#1087#1080#1089#1082#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
  ClientHeight = 358
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 599
    Height = 358
    Align = alClient
    TabOrder = 0
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 591
      Height = 309
      Align = alTop
      Caption = ' '#1048#1089#1090#1086#1095#1085#1080#1082' '
      TabOrder = 0
      DesignSize = (
        591
        309)
      object Memo1: TMemo
        Left = 8
        Top = 19
        Width = 575
        Height = 250
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = cl3DLight
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Lines.Strings = (
          '1. '#1042' '#1040#1056#1052' '#1057#1091#1073#1089#1080#1076#1080#1080' '#1074#1099#1087#1086#1083#1085#1080#1090#1077' '#1074#1099#1073#1086#1088#1082#1091':'
          #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090' = 0-9999999'
          ''
          #1056#1072#1089#1087#1077#1095#1072#1090#1072#1081#1090#1077' '#1074#1099#1073#1086#1088#1082#1091' '#1074' '#1092#1072#1081#1083', '#1074#1099#1076#1077#1083#1080#1074' '#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1087#1091#1085#1082#1090#1099':'
          '* '#1051#1080#1094'.'#1089#1095#1077#1090','
          '* '#1060#1072#1084#1080#1083#1080#1103', '#1048#1084#1103', '#1054#1090#1095#1077#1089#1090#1074#1086
          '* '#1043#1086#1088#1086#1076', '#1059#1083#1080#1094#1072', '#1044#1086#1084', '#1050#1086#1088#1087#1091#1089', '#1050#1074#1072#1088#1090#1080#1088#1072
          '* '#1055#1086#1083
          '* '#1044#1072#1090#1072' '#1086#1073#1088#1072#1097#1077#1085#1080#1103
          ''
          '2. '#1042' '#1101#1090#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1077':'
          #1053#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' ['#1054#1073#1079#1086#1088'...], '#1095#1090#1086#1073#1099' '#1085#1072#1081#1090#1080' '#1087#1086#1083#1091#1095#1080#1074#1096#1091#1102#1089#1103' '#1074#1099#1073#1086#1088#1082#1091'.'
          '('#1053#1072#1087#1088#1080#1084#1077#1088', d:\subsidii\!Work\DBFW002\TEXT\Chpr.101)'
          ''
          #1055#1086#1089#1083#1077' '#1101#1090#1086#1075#1086' '#1084#1086#1078#1085#1086' '#1085#1072#1078#1072#1090#1100' '#1082#1085#1086#1087#1082#1091' ['#1054#1073#1084#1077#1085']'
          ''
          #1055#1056#1048#1052#1045#1063#1040#1053#1048#1045':'
          '   '#1055#1077#1088#1077#1076' '#1086#1073#1084#1077#1085#1086#1084' '#1078#1077#1083#1072#1090#1077#1083#1100#1085#1086' '#1074#1089#1077#1084' '#1074#1099#1081#1090#1080' '#1080#1079' '#1040#1056#1052' '#1057#1091#1073#1089#1080#1076#1080#1080)
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 8
        Top = 278
        Width = 494
        Height = 19
        Anchors = [akLeft, akRight, akBottom]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
      end
      object Button1: TButton
        Left = 508
        Top = 275
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #1054#1073#1079#1086#1088'...'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 316
      Width = 597
      Height = 41
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 1
      DesignSize = (
        597
        41)
      object Button4: TButton
        Left = 261
        Top = 8
        Width = 75
        Height = 25
        Anchors = []
        Caption = #1054#1073#1084#1077#1085
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1042#1099#1073#1086#1088#1082#1080'|*.0*;*.1*;*.2*;*.3*;*.4*;*.5*;*.6*;*.7*;*.8*;*.9*'
    Left = 288
    Top = 64
  end
end
