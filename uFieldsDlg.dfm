object FieldsDlg: TFieldsDlg
  Left = 0
  Top = 0
  Caption = 'FieldsDlg'
  ClientHeight = 297
  ClientWidth = 271
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 297
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object chlFields: TCheckListBox
      Left = 1
      Top = 18
      Width = 239
      Height = 278
      OnClickCheck = chlFieldsClickCheck
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
    object HeaderControl1: THeaderControl
      Left = 1
      Top = 1
      Width = 239
      Height = 17
      Sections = <
        item
          ImageIndex = -1
          Text = #1057#1090#1086#1083#1073#1077#1094
          Width = 100
        end
        item
          AutoSize = True
          ImageIndex = -1
          Text = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 189
        end>
    end
  end
  object Panel2: TPanel
    Left = 241
    Top = 0
    Width = 30
    Height = 297
    Align = alRight
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 4
      Top = 18
      Width = 23
      Height = 22
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 4
      Top = 46
      Width = 23
      Height = 22
      OnClick = SpeedButton2Click
    end
  end
end
