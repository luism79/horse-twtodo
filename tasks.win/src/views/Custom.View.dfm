object frmCustomView: TfrmCustomView
  Left = 0
  Top = 0
  Caption = 'frmCustomView'
  ClientHeight = 323
  ClientWidth = 487
  Color = 16051948
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  StyleElements = []
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 487
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlHeader'
    Color = 3877150
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13159374
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = [seBorder]
    object lblHeaderTitle: TLabel
      Left = 10
      Top = 10
      Width = 125
      Height = 25
      Caption = 'lblHeaderTitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13159374
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 80
    Width = 487
    Height = 243
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlBody'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3877150
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 1
  end
end
