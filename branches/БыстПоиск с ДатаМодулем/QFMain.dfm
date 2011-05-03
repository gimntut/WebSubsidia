object Form9: TForm9
  Left = 256
  Top = 192
  Caption = #1056#1072#1073#1086#1090#1072' '#1089#1086' '#1089#1087#1080#1089#1082#1072#1084#1080
  ClientHeight = 512
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = Edit1KeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbReklama: TLabel
    Left = 0
    Top = 499
    Width = 763
    Height = 13
    Hint = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'|'#1053#1072#1078#1084#1080#1090#1077' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1080#1089#1100#1084#1072' '#1072#1074#1090#1086#1088#1091' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Align = alBottom
    Alignment = taCenter
    Caption = 
      #1056#1072#1079#1088#1072#1073#1086#1090#1072#1083' '#1043#1080#1084#1072#1077#1074' '#1053#1072#1080#1083#1100' '#1076#1083#1103' '#1052#1077#1078#1088#1072#1081#1086#1085#1085#1086#1075#1086' '#1092#1080#1083#1080#1072#1083#1072' '#1043#1059' '#1056#1077#1089#1087#1091#1073#1083#1080#1082#1072#1085#1089 +
      #1082#1080#1081' '#1094#1077#1085#1090#1088' '#1089#1091#1073#1089#1080#1076#1080#1081' '#1074' '#1075'.'#1058#1091#1081#1084#1072#1079#1099
    OnClick = lbReklamaClick
    OnMouseEnter = lbReklamaMouseEnter
    OnMouseLeave = lbReklamaMouseLeave
    ExplicitWidth = 533
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 41
    Width = 763
    Height = 26
    AutoSize = True
    BorderWidth = 1
    Caption = 'ToolBar1'
    GradientEndColor = clGreen
    GradientStartColor = clLime
    Images = DataModule3.ImageList1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object NewBtn: TToolButton
      Left = 0
      Top = 0
      Hint = #1053#1072#1095#1072#1090#1100' '#1089#1085#1086#1074#1072'|'#1055#1077#1088#1077#1081#1090#1080' '#1082' '#1074#1099#1073#1086#1088#1091' '#1089#1087#1080#1089#1082#1086#1074' '#1080' '#1089#1087#1088#1072#1074#1086#1082
      Caption = 'NewBtn'
      ImageIndex = 11
      OnClick = NewBtnClick
    end
    object OpenBtn: TToolButton
      Left = 23
      Top = 0
      Hint = 
        #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083'|'#1047#1085#1072#1095#1086#1082' "'#1055#1072#1087#1082#1072'" - '#1086#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' (Ctrl+O), "'#1057#1090#1088#1077#1083#1082#1072' '#1074#1085 +
        #1080#1079'" - '#1079#1072#1087#1086#1084#1080#1085#1072#1077#1090' '#1086#1090#1082#1088#1099#1090#1099#1077' '#1092#1072#1081#1083#1099' '#1080' '#1087#1072#1087#1082#1080', '#1086#1090#1082#1088#1099#1074#1072#1077#1090' '#1079#1072#1087#1086#1084#1085#1077#1085#1099#1077' '#1092#1072 +
        #1081#1083#1099' '#1080#1083#1080' '#1087#1072#1087#1082#1080' (Ctrl+Shift+O)'
      AutoSize = True
      Caption = 'OpenBtn'
      ImageIndex = 0
      Style = tbsDropDown
      OnClick = OpenBtnClick
    end
    object SpravkaBtn: TToolButton
      Left = 59
      Top = 0
      Hint = #1057#1087#1088#1072#1074#1082#1080' (F2)'
      Caption = 'SpravkaBtn'
      ImageIndex = 10
    end
    object PrintBtn: TToolButton
      Left = 82
      Top = 0
      Hint = 
        #1055#1077#1095#1072#1090#1100'|'#1055#1077#1095#1072#1090#1100' '#1087#1086#1083#1085#1086#1075#1086' '#1089#1087#1080#1089#1082#1072', '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074' '#1087#1086#1080#1089#1082#1072' '#1080#1083#1080' '#1080#1079#1084#1077#1085#1105#1085#1086#1075#1086' ' +
        #1086#1088#1080#1075#1080#1085#1072#1083#1072' (Ctrl+P '#1080#1083#1080' F9)'
      Caption = 'PrintBtn'
      ImageIndex = 1
      OnClick = PrintBtnClick
    end
    object ToolButton3: TToolButton
      Left = 105
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 4
      Style = tbsSeparator
    end
    object CheckBankBtn: TToolButton
      Left = 113
      Top = 0
      Hint = 
        #1055#1086#1080#1089#1082' '#1085#1077#1074#1077#1088#1085#1099#1093' '#1073#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1089#1095#1077#1090#1086#1074'|'#1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1085#1072' '#1101#1090#1091' '#1082#1085#1086#1087#1082#1091' '#1074' '#1089#1087#1080 +
        #1089#1082#1077' '#1086#1089#1090#1072#1102#1090#1089#1103' '#1090#1086#1083#1100#1082#1086' '#1090#1077' '#1079#1072#1087#1080#1089#1080', '#1082#1086#1090#1086#1088#1099#1077' '#1089#1086#1076#1077#1088#1078#1072#1090' '#1086#1096#1080#1073#1082#1080' '#1074' '#1073#1072#1085#1082#1086#1074#1089 +
        #1082#1080#1093' '#1089#1095#1077#1090#1072#1093
      Caption = 'CheckBankBtn'
      ImageIndex = 3
      OnClick = CheckBankBtnClick
    end
    object ExcelAsIsBtn: TToolButton
      Left = 136
      Top = 0
      Hint = 
        #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel '#1086#1076#1080#1085' '#1082' '#1086#1076#1085#1086#1084#1091'|'#1069#1082#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1080#1089#1082#1072' '#1074' Excel '#1074' '#1089#1086 +
        #1086#1090#1074#1077#1090#1089#1090#1074#1080#1080' '#1089' '#1074#1099#1073#1086#1088#1082#1086#1081', '#1073#1077#1079' '#1080#1079#1084#1077#1085#1077#1085#1080#1081
      Caption = 'ExcelAsIsBtn'
      ImageIndex = 4
      OnClick = ExcelAsIsBtnClick
    end
    object ExcelFillBtn: TToolButton
      Left = 159
      Top = 0
      Hint = 
        #1069#1082#1089#1087#1086#1088#1090' '#1074' Excel '#1089' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077#1084'|'#1069#1082#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1080#1089#1082#1072' '#1074' Excel '#1089' '#1079#1072 +
        #1087#1086#1083#1085#1077#1085#1080#1077#1084' '#1085#1077#1076#1086#1089#1090#1072#1102#1097#1080#1093' '#1076#1072#1085#1085#1099#1093' '#1085#1072' '#1086#1089#1085#1086#1074#1077' '#1089#1086#1089#1077#1076#1085#1080#1093' '#1079#1072#1087#1080#1089#1077#1081
      Caption = 'ExcelFillBtn'
      ImageIndex = 5
      OnClick = ExcelFillBtnClick
    end
    object ToolButton7: TToolButton
      Left = 182
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object TextModeBtn: TToolButton
      Left = 190
      Top = 0
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1077#1082#1089#1090#1072'|'#1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082' '#1086#1090#1082#1088#1099#1090#1086#1075#1086' '#1092#1072#1081#1083#1072
      AllowAllUp = True
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1077#1082#1089#1090#1072
      ImageIndex = 2
    end
    object SortBtn: TToolButton
      Left = 213
      Top = 0
      Hint = 
        #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072'|'#1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1089#1087#1080#1089#1082#1072' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1087#1086#1083#1102'. '#1053#1045' '#1056#1040#1041#1054#1058#1040#1045#1058'. '#1048#1089 +
        #1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1085#1077' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103'.'
      Caption = #1055#1086#1083#1103' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
      ImageIndex = 8
    end
    object ToolButton11: TToolButton
      Left = 236
      Top = 0
      Width = 8
      Caption = 'ToolButton11'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object MemoModeBtn: TToolButton
      Left = 244
      Top = 0
      Hint = 
        #1055#1088#1072#1074#1082#1072' '#1086#1088#1080#1075#1080#1085#1072#1083#1072'|'#1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1088#1080#1075#1080#1085#1072#1083' '#1087#1077#1088#1077#1076' '#1087#1077#1095#1072#1090#1100#1102'. '#1048#1079#1084#1077#1085#1080#1077' '#1086#1088#1080#1075#1080#1085 +
        #1072#1083#1072' '#1074#1083#1080#1103#1077#1090' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1087#1077#1095#1072#1090#1100', '#1092#1072#1081#1083' '#1080' '#1089#1087#1080#1089#1086#1082' '#1079#1072#1087#1080#1089#1077#1081' '#1086#1089#1090#1072#1102#1090#1089#1103' '#1085#1077#1080#1079 +
        #1084#1077#1085#1085#1099#1084#1080'.'
      Caption = 'MemoModeBtn'
      ImageIndex = 9
      Style = tbsCheck
      Visible = False
      OnClick = MemoModeBtnClick
    end
    object ToolButton1: TToolButton
      Left = 267
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 10
      Style = tbsSeparator
    end
    object ToolButton2: TToolButton
      Left = 275
      Top = 0
      Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1096#1088#1080#1092#1090'| '#1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1096#1088#1080#1092#1090' '#1074#1086' '#1074#1089#1077#1093' '#1089#1087#1080#1089#1082#1072#1093' '#1080' '#1089#1087#1088#1072#1074#1082#1072#1093
      Caption = 'ToolButton2'
      ImageIndex = 12
      OnClick = ToolButton2Click
    end
    object ToolButton4: TToolButton
      Left = 298
      Top = 0
      Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1096#1088#1080#1092#1090'| '#1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1096#1088#1080#1092#1090' '#1074#1086' '#1074#1089#1077#1093' '#1089#1087#1080#1089#1082#1072#1093' '#1080' '#1089#1087#1088#1072#1074#1082#1072#1093
      Caption = 'ToolButton4'
      ImageIndex = 13
      OnClick = ToolButton4Click
    end
    object ToolButton5: TToolButton
      Left = 321
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 14
      Style = tbsSeparator
    end
    object ToolButton9: TToolButton
      Left = 329
      Top = 0
      Caption = 'ToolButton9'
      ImageIndex = 15
      OnClick = ToolButton9Click
    end
    object ToolButton10: TToolButton
      Left = 352
      Top = 0
      Caption = 'ToolButton10'
      Visible = False
      OnClick = ToolButton10Click
    end
    object btnSplitMode: TToolButton
      Left = 375
      Top = 0
      Caption = '**'
      ImageIndex = 16
      OnClick = btnSplitModeClick
    end
  end
  object pnHelp: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 1
    object mmHelp: TMemo
      Left = 0
      Top = 0
      Width = 763
      Height = 41
      Align = alClient
      Color = clGreen
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnDblClick = mmHelpDblClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 67
    Width = 763
    Height = 432
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    Visible = False
    object TabSheet1: TTabSheet
      Caption = #1055#1086#1080#1089#1082
      object pnFindList: TPanel
        Left = 0
        Top = 0
        Width = 755
        Height = 404
        Align = alClient
        TabOrder = 0
        object Panel1: TPanel
          Left = 1
          Top = 1
          Width = 753
          Height = 36
          Align = alTop
          TabOrder = 0
          DesignSize = (
            753
            36)
          object SpeedButton1: TSpeedButton
            Left = 726
            Top = 6
            Width = 23
            Height = 22
            Hint = #1055#1086#1080#1089#1082'|'#1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1080#1089#1082
            Anchors = [akTop, akRight]
            Flat = True
            Glyph.Data = {
              E6040000424DE604000000000000360000002800000014000000140000000100
              180000000000B0040000C40E0000C40E00000000000000000000C9DEE1E6EFF1
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFDFCFEFDFCFE
              FAFCFCFDFCFDFCFFFFFEFFFFFFFDFEFEE7F0F1C9DEE1EBF3F5D0E1D0297B290E
              670E126C12136C13156C15136B16166F151972181B741B157916147A140F7611
              097309057103016B02207420CFDFCFEBF3F5FEFEFE298829147F141C821C2287
              22268826278927258925248B24248B24238B221893191592140F950F0B950A05
              9205038B02017B01207320FFFFFFFFFFFF0F840F1D8C1D299229309630349834
              359935329932329A313298322A9A2A229D221B9F1A14A1140EA60E09A408039D
              03018901016801FFFFFFFFFFFF158A152693263298323A9D3A3E9F3E3EA03E3C
              A03C3AA13AA4D4A4FFFFFF29A32821A52019A91912AA120CAB0C06A506039203
              026C02FFFFFFFFFFFF198C192F972F3B9D3B43A14347A34746A44644A44440A5
              42FFFFFFFFFFFFFFFFFF25AB251DAD1D16B0160FAF0F0BA90A069506036F03FF
              FFFFFFFFFF1F8F1F379B3743A0434AA44A4DA64D4BA64B48A64945A74641A843
              FFFFFFFFFFFFFFFFFF1FB12019B21913B0130EA90E0C960C077107FFFFFFFFFF
              FF2693263E9E3E49A3494FA64F51A8514FA84F4CA74C48A84847A8483EAA40FF
              FFFFFFFFFFFFFFFF1BB01B17AF1714A7141197110B720BFFFFFFFFFFFF2C952C
              45A1454FA74F53A85354A95452A9524EA84E49A74947A84741AA3E34AC34FFFF
              FFFFFFFFFFFFFF19AC1918A619179715107610FFFFFFFFFFFF2C952C45A1454F
              A74FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFF19A619179816107512FFFFFFFFFFFF2C952C45A1454FA74FFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF19A519179817107412FFFFFFFFFFFF3398334CA54C55A95557AA5756AA56
              53A8534FA74E4AA64A46A64640A74038A738FFFFFFFFFFFFFFFFFF1EA51D1DA1
              1D1C961D167413FFFFFFFFFFFF389B3852A85258AB585AAB5A58AA5854A85350
              A7514DA64D49A64943A643FFFFFFFFFFFFFFFFFF29A12725A025239F23229422
              187217FFFFFFFFFFFF4EA64E6FB76F71B9716BB56B63AF635CAB5B55A85651A7
              514DA74DFFFFFFFFFFFFFFFFFF36A1352F9E2E2D9B2C2E972D2D8E2D1E721EFF
              FFFFFFFFFF53A8537ABD7A7DBE7D72B97268B36861AE615DAB5C58A858FFFFFF
              FFFFFFFFFFFF44A4443EA13E389E38339A333197312D8D2D1E721EFFFFFFFFFF
              FF59AC5989C4898DC68D80BF8072B8726BB46B65B1655FAE5FB5DAB5FFFFFF51
              A9524BA64C46A34641A0413B9D3B3599352B8C2B196F19FFFFFFFFFFFF66B266
              97CB979ACD9A89C4897BBD7B73B9736EB66E69B36966B2675EAF6057AB5850A8
              524DA74E4BA44B44A144389A38298B29166C16FFFFFFFFFFFF77BB7790C89094
              CA9485C28576BB766FB76F69B46967B26767B16765B26556AC5953A95550A64F
              4AA54A40A040339833248924317F31FCFEFEEDF5F7DCEDDC74B97461B06156AA
              564EA64E49A34943A04345A14545A24546A1463D9D3C359A35349A3431983229
              942A208D20358F35D2E3D2EDF5F7D8EBEEEDF5F7FCFEFEFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFEEF6F7D8EBEE}
            OnClick = SpeedButton1Click
            OnMouseUp = SpeedButton1MouseUp
            ExplicitLeft = 668
          end
          object Edit1: TEdit
            Left = 8
            Top = 8
            Width = 712
            Height = 21
            Hint = 
              #1055#1086#1080#1089#1082#1086#1074#1099#1081' '#1079#1072#1087#1088#1086#1089'|'#1055#1056#1054#1041#1045#1051' - '#1088#1072#1079#1076#1077#1083#1103#1077#1090' '#1089#1083#1086#1074#1072', "_" - '#1080#1097#1077#1090' '#1087#1088#1086#1073#1077#1083#1099', "' +
              '=" '#1087#1077#1088#1077#1076' '#1089#1083#1086#1074#1086#1084' - '#1080#1097#1077#1090' '#1089#1083#1086#1074#1086' '#1085#1072' '#1074#1089#1102' '#1082#1083#1077#1090#1082#1091', "-" '#1087#1077#1088#1077#1076' '#1089#1083#1086#1074#1086#1084' - '#1091 +
              #1073#1080#1088#1072#1077#1090' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1089#1090#1088#1086#1082#1080' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1077' '#1089#1083#1086#1074#1086'. '#1057#1083#1086#1074#1086' '#1084#1086#1078#1077#1090' '#1089#1086#1089#1090#1086#1103#1090#1100' '#1080 +
              #1079' '#1073#1091#1082#1074' '#1080' '#1094#1080#1092#1088'.'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnChange = Edit1Change
            OnKeyDown = Edit1KeyDown
            OnKeyPress = Edit1KeyPress
          end
        end
        object pnOutput: TPanel
          Left = 1
          Top = 37
          Width = 753
          Height = 366
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Splitter1: TSplitter
            Left = 0
            Top = 192
            Width = 753
            Height = 3
            Cursor = crVSplit
            Align = alBottom
            ExplicitTop = 106
            ExplicitWidth = 334
          end
          object pnMaster: TPanel
            Left = 0
            Top = 0
            Width = 753
            Height = 192
            Align = alClient
            TabOrder = 0
            TabStop = True
            OnResize = pnMasterResize
            object lstMaster: TListBox
              Left = 1
              Top = 20
              Width = 751
              Height = 171
              Hint = 
                #1057#1087#1080#1089#1086#1082' '#1079#1072#1087#1080#1089#1077#1081'|'#1055#1086#1083#1085#1099#1081' '#1089#1087#1080#1089#1086#1082' '#1080#1083#1080' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1087#1086#1080#1089#1082#1072' '#1087#1086' '#1089#1087#1080#1089#1082#1091'. '#1044#1083 +
                #1103' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1087#1086#1083#1085#1086#1075#1086' '#1089#1087#1080#1089#1082#1072' '#1085#1091#1078#1085#1086' '#1085#1072#1078#1072#1090#1100' Esc.'
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alClient
              Color = clWhite
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Lucida Console'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnClick = ListBoxClick
              OnDblClick = lstMasterDblClick
              OnMouseDown = ListBoxMouseDown
            end
            object Panel6: TPanel
              Left = 1
              Top = 1
              Width = 751
              Height = 19
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object Memo3: TMemo
                AlignWithMargins = True
                Left = 4
                Top = 0
                Width = 747
                Height = 19
                Margins.Left = 4
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alClient
                BorderStyle = bsNone
                Ctl3D = False
                Font.Charset = RUSSIAN_CHARSET
                Font.Color = 12517376
                Font.Height = -13
                Font.Name = 'Lucida Console'
                Font.Style = []
                ParentColor = True
                ParentCtl3D = False
                ParentFont = False
                ReadOnly = True
                TabOrder = 0
                WordWrap = False
                OnDblClick = mmHelpDblClick
              end
            end
          end
          object pnDetails: TPanel
            Left = 0
            Top = 195
            Width = 753
            Height = 171
            Align = alBottom
            TabOrder = 1
            TabStop = True
            object lstDetails: TListBox
              Left = 1
              Top = 1
              Width = 751
              Height = 169
              Hint = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1090#1077#1082#1091#1097#1077#1081' '#1079#1072#1087#1080#1089#1080'|'#1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1090#1077#1082#1091#1097#1077#1081' '#1079#1072#1087#1080#1089#1080
              Align = alClient
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Lucida Console'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              TabWidth = 100
              OnDblClick = lstDetailsDblClick
              OnMouseDown = ListBoxMouseDown
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1056#1077#1076#1072#1082#1090#1086#1088
      ImageIndex = 1
      object pnMemo: TPanel
        Left = 0
        Top = 0
        Width = 755
        Height = 404
        Align = alClient
        TabOrder = 0
        object Memo1: TMemo
          Left = 1
          Top = 1
          Width = 753
          Height = 402
          Hint = 
            #1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1077#1082#1089#1090#1072'|'#1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1077#1082#1089#1090#1072' '#1073#1077#1079' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1080' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1088#1077#1079#1091#1083 +
            #1100#1090#1072#1090#1072'. '#1055#1088#1077#1076#1085#1072#1079#1085#1072#1095#1077#1085' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1080#1079#1084#1077#1085#1105#1085#1086#1075#1086' '#1090#1077#1082#1089#1090#1072'. '#1055#1056#1048#1052#1045#1063#1040#1053#1048#1045': '#1044#1083 +
            #1103' '#1090#1086#1075#1086', '#1095#1090#1086#1073#1099' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1089#1090#1088#1086#1082#1091' '#1074' '#1090#1077#1082#1089#1090' '#1085#1091#1078#1085#1086' '#1085#1072#1078#1080#1084#1072#1090#1100' Ctrl+' +
            'Enter, '#1074#1084#1077#1089#1090#1086' Enter.'
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Lucida Console'
          Font.Style = []
          Lines.Strings = (
            'Memo1')
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1054#1078#1080#1076#1072#1085#1080#1077' '#1086#1090#1082#1088#1099#1090#1080#1103
      ImageIndex = 3
      object Label1: TLabel
        AlignWithMargins = True
        Left = 2
        Top = 2
        Width = 753
        Height = 402
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        Caption = #1046#1076#1080#1090#1077', '#13#10#1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#13#10#1086#1090#1082#1088#1099#1090#1080#1077' '#1092#1072#1081#1083#1072'...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clAqua
        Font.Height = -48
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        ExplicitWidth = 462
        ExplicitHeight = 174
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 753
        Height = 402
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Alignment = taCenter
        Caption = #1046#1076#1080#1090#1077', '#13#10#1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#13#10#1086#1090#1082#1088#1099#1090#1080#1077' '#1092#1072#1081#1083#1072'...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -48
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        ExplicitWidth = 462
        ExplicitHeight = 174
      end
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 755
        Height = 404
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Alignment = taCenter
        Caption = #1046#1076#1080#1090#1077', '#13#10#1074#1099#1087#1086#1083#1085#1103#1077#1090#1089#1103' '#13#10#1086#1090#1082#1088#1099#1090#1080#1077' '#1092#1072#1081#1083#1072'...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -48
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        ExplicitWidth = 462
        ExplicitHeight = 174
      end
    end
  end
end
