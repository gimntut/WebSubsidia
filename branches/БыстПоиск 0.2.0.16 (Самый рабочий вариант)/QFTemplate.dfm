object QFTemlateDlg: TQFTemlateDlg
  Left = 0
  Top = 0
  Caption = 'QFTemlateDlg'
  ClientHeight = 206
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 165
    Width = 339
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 136
    ExplicitTop = 144
    ExplicitWidth = 185
    DesignSize = (
      339
      41)
    object Button1: TButton
      Left = 177
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 23
    end
    object Button2: TButton
      Left = 258
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 104
    end
  end
end
