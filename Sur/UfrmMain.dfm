object frmMain: TfrmMain
  Left = 196
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#25509#25910#26381#21153
  ClientHeight = 400
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 577
    Height = 25
    AutoSize = True
    Bands = <
      item
        Break = False
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 21
        Width = 573
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 312
      Height = 21
      Align = alNone
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 72
      Caption = 'ToolBar1'
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      ShowCaptions = True
      TabOrder = 0
      object ToolButton7: TToolButton
        Left = 0
        Top = 0
        Caption = #36830#25509#25968#25454#24211
        ImageIndex = 3
        OnClick = ToolButton7Click
      end
      object ToolButton8: TToolButton
        Left = 72
        Top = 0
        Width = 8
        Caption = 'ToolButton8'
        ImageIndex = 6
        Style = tbsSeparator
      end
      object ToolButton2: TToolButton
        Left = 80
        Top = 0
        Caption = #21442#25968#35774#32622
        ImageIndex = 5
        OnClick = ToolButton2Click
      end
      object ToolButton9: TToolButton
        Left = 152
        Top = 0
        Width = 8
        Caption = 'ToolButton9'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton5: TToolButton
        Left = 160
        Top = 0
        Caption = #27880#20876
        ImageIndex = 3
        OnClick = ToolButton5Click
      end
      object ToolButton4: TToolButton
        Left = 232
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton3: TToolButton
        Left = 240
        Top = 0
        AutoSize = True
        Caption = #36864#20986'(Esc)'
        ImageIndex = 2
        OnClick = N3Click
      end
    end
  end
  object Memo1: TMemo
    Left = 16
    Top = 40
    Width = 425
    Height = 337
    ImeName = #19975#33021#20116#31508'EXE'#22806#25346#29256
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 456
    Top = 48
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 456
    Top = 80
    Width = 75
    Height = 25
    Caption = #28165#31354
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object Button1: TButton
    Left = 456
    Top = 112
    Width = 75
    Height = 25
    Caption = #27979#35797
    TabOrder = 4
    OnClick = Button1Click
  end
  object LYTray1: TLYTray
    Icon.Data = {
      0000010002002020000000000000A80800002600000010100000000000006805
      0000CE0800002800000020000000400000000100080000000000000400000000
      0000000000000001000000000000557FFF00555FAA00555F2A00559F0000AA9F
      000000BF550055BFAA00AA3F2A0055BF5500009F020000BFFF00007FFF00FF9F
      0000003FFF00FFFFFF00C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000101010101010101010101010101010101010
      1010101010101010101010101010101010101010101010101010101010101010
      1010101010101010101010101010101010101010101010101010101010101010
      1010101010101010101010101010101010101010101010101010101010100808
      0810101010101010101010101010101010101010101010101010101010080808
      08101010100A0A0A101010101010101010101010101010101010101008080808
      081010100A0A0A0A0A1010101010101010101010101010101010100808080808
      08100A0A0A0A0A0A0A1010101010101010101010101010101010080808080808
      08060A0A0A0A0A0A0A0A10101010101010101010101010101008080808080808
      02010A0A0A0A0A0A0A0A0A101010101010101010101010101008050909050808
      07010A0A0A0A0A0A0A0A0A101010101010101010101010100909090909090907
      07010A0A0A0A0A0A0A0A0A0A10101010101010101010100C0909090909090207
      07000B0B0B0B0B0B0B0A0A0A101010101010101010100C0C0909090909090707
      070B0B0B0B0B0B0B0B0B0A0A1010101010101010100C0C0C0909090909020707
      070B0B0B0B0B0B0B0B0B0B0A10101010101010100C0C0C0C0309090909070707
      010B0B0B0B0B0B0B0B0B0B0A101010101010100C0C0C0C0C0409090909070707
      0B0B0B0B0B0B0B0B0B0B0B001010101010100C0C0C0C0C0C0C03090902070701
      0B0B0B0B0B0B0B0B0B0B0B0D1010101010100C0C0C0C0C0C0C0C030902070700
      0B0B0B0B0B0B0B0B0B0B0D0D10101010100C0C0C0C0C0C0C0C0C0C040707010B
      0B0B0B0B0B0B0B000B0D0D0D0D1010100C0C0C0C0C0C0C0C0C0C0C0C07070D0D
      0000000000000D0D0D0D0D0D0D1010100C0C0C0C0C0C0C0C0C0C0C10070D0D0D
      0D0D0D0D0D0D0D0D0D0D0D0D0D10100C0C0C0C0C0C0C0C0C0C0C101010100D0D
      0D0D0D0D0D0D0D0D0D0D0D0D0D10100C0C0C0C0C0C0C0C0C0C10101010100D0D
      0D0D0D0D0D0D0D0D0D0D0D0D0D10100C0C0C0C0C0C0C0C10101010101010100D
      0D0D0D0D0D0D0D0D0D0D0D0D0D10100C0C0C0C0C0C1010101010101010101010
      0D0D0D0D0D0D0D0D0D0D0D0D0D1010100C0C1010101010101010101010101010
      100D0D0D0D0D0D0D0D0D0D0D0D10101010101010101010101010101010101010
      10100D0D0D0D0D0D0D0D0D0D0D10101010101010101010101010101010101010
      1010100D0D0D0D0D0D0D0D0D1010101010101010101010101010101010101010
      10101010100D0D0D0D0D0D0D1010101010101010101010101010101010101010
      101010101010100D0D0D0D101010101010101010101010101010101010101010
      1010101010101010101010101010101010101010101010101010101010101010
      1010101010101010101010101010FFFFFFFFFFFFFFFFFFFFFFFFFFFF1FFFFFFE
      1E3FFFFC1C1FFFF8101FFFF0000FFFE00007FFE00007FFC00003FF800003FF00
      0003FE000003FC000003F8000003F0000003F0000003E0000001C0000001C004
      0001800F0001801F0001807F800181FFC001CFFFE001FFFFF001FFFFF803FFFF
      FE03FFFFFF87FFFFFFFFFFFFFFFF280000001000000020000000010008000000
      0000400100000000000000000000000000000000000000000000000080000080
      000000808000800000008000800080800000C0C0C000C0DCC000F0CAA6000404
      0400080808000C0C0C0011111100161616001C1C1C0022222200292929005555
      55004D4D4D004242420039393900807CFF005050FF009300D600FFECCC00C6D6
      EF00D6E7E70090A9AD000000330000006600000099000000CC00003300000033
      330000336600003399000033CC000033FF000066000000663300006666000066
      99000066CC000066FF00009900000099330000996600009999000099CC000099
      FF0000CC000000CC330000CC660000CC990000CCCC0000CCFF0000FF660000FF
      990000FFCC00330000003300330033006600330099003300CC003300FF003333
      00003333330033336600333399003333CC003333FF0033660000336633003366
      6600336699003366CC003366FF00339900003399330033996600339999003399
      CC003399FF0033CC000033CC330033CC660033CC990033CCCC0033CCFF0033FF
      330033FF660033FF990033FFCC0033FFFF006600000066003300660066006600
      99006600CC006600FF00663300006633330066336600663399006633CC006633
      FF00666600006666330066666600666699006666CC0066990000669933006699
      6600669999006699CC006699FF0066CC000066CC330066CC990066CCCC0066CC
      FF0066FF000066FF330066FF990066FFCC00CC00FF00FF00CC00999900009933
      9900990099009900CC009900000099333300990066009933CC009900FF009966
      00009966330099336600996699009966CC009933FF0099993300999966009999
      99009999CC009999FF0099CC000099CC330066CC660099CC990099CCCC0099CC
      FF0099FF000099FF330099CC660099FF990099FFCC0099FFFF00CC0000009900
      3300CC006600CC009900CC00CC0099330000CC333300CC336600CC339900CC33
      CC00CC33FF00CC660000CC66330099666600CC669900CC66CC009966FF00CC99
      0000CC993300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC3300CCCC
      6600CCCC9900CCCCCC00CCCCFF00CCFF0000CCFF330099FF6600CCFF9900CCFF
      CC00CCFFFF00CC003300FF006600FF009900CC330000FF333300FF336600FF33
      9900FF33CC00FF33FF00FF660000FF663300CC666600FF669900FF66CC00CC66
      FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC0000FFCC
      3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300CCFF6600FFFF9900FFFF
      CC006666FF0066FF660066FFFF00FF666600FF66FF00FFFF66002100A5005F5F
      5F00777777008686860096969600CBCBCB00B2B2B200D7D7D700DDDDDD00E3E3
      E300EAEAEA00F1F1F100F8F8F800F0FBFF00A4A0A000808080000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
      0000000000000000000000000000970000000000000000000000000000979797
      0038380000000000000000009797979738383800000000000000009797979786
      38383838000000000000002D2D2D868638383838380000000000D32D2D2D862C
      2C2C2C383800000000D3D32D2D86862C2C2C2C2C38000000D3D3D32D2D866E2C
      2C2C2C2C260000D3D3D3D3D32D862C2C2C2C2C26260000D3D3D3D3D300262626
      26262626260000D3D3D3D3000000262626262626260000D3D300000000000026
      2626262626000000000000000000000026262626260000000000000000000000
      00002626000000000000000000000000000000000000FFFF0000FF7F0000FE27
      0000FC070000F8030000F8010000F0010000E0010000C0010000800100008201
      0000870100009F810000FFC10000FFF30000FFFF0000}
    Hint = #25968#25454#25509#25910#26381#21153
    PopupMenu = PopupMenu1
    ActButton = abRightButton
    Left = 102
    Top = 26
  end
  object PopupMenu1: TPopupMenu
    OwnerDraw = True
    Left = 138
    Top = 26
    object N1: TMenuItem
      Caption = #35774#32622
      ImageIndex = 1
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #36864#20986
      ImageIndex = 0
      OnClick = N3Click
    end
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 210
    Top = 26
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    Left = 174
    Top = 26
  end
  object ActionList1: TActionList
    Left = 70
    Top = 26
    object editpass: TAction
      Caption = 'editpass'
      ShortCut = 113
    end
    object about: TAction
      Caption = 'about'
      ShortCut = 112
    end
    object stop: TAction
      Caption = 'stop'
      ShortCut = 27
      OnExecute = N3Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 240
    Top = 26
  end
  object ComPort1: TComPort
    BaudRate = Br1200
    Port = 'COM1'
    Parity.Bits = PrEven
    StopBits = SbOneStopBit
    DataBits = DbEight
    Events = [EvRxChar, EvTxEmpty, EvRxFlag, EvRing, EvBreak, EvCTS, EvDSR, EvError, EvRLSD, EvRx80Full]
    FlowControl.OutCTSFlow = True
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = DtrEnable
    FlowControl.ControlRTS = RtsHandshake
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DSRSensitivity = True
    StoredProps = [SpBasic]
    TriggersOnRxChar = False
    OnAfterOpen = ComPort1AfterOpen
    Left = 72
    Top = 104
  end
  object ComDataPacket1: TComDataPacket
    ComPort = ComPort1
    IncludeStrings = True
    MaxBufferSize = 3000
    OnPacket = ComDataPacket1Packet
    Left = 104
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    Left = 272
    Top = 26
  end
end
