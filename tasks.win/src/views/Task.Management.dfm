inherited frmTaskManagement: TfrmTaskManagement
  BorderStyle = bsDialog
  Caption = 'Tarefa'
  ClientHeight = 468
  ClientWidth = 492
  DoubleBuffered = True
  ExplicitWidth = 508
  ExplicitHeight = 507
  TextHeight = 15
  inherited pnlHeader: TPanel
    Width = 492
    Height = 70
    ExplicitWidth = 492
    ExplicitHeight = 70
    object lblHeaderSubTitle: TLabel
      Left = 10
      Top = 45
      Width = 93
      Height = 15
      Caption = 'lblHeaderSubTitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13159374
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
  end
  inherited pnlBody: TPanel
    Top = 70
    Width = 492
    Height = 334
    ParentColor = True
    StyleElements = [seBorder]
    ExplicitTop = 70
    ExplicitWidth = 492
    ExplicitHeight = 334
    object lblTitle: TLabel
      Left = 10
      Top = 10
      Width = 32
      Height = 15
      Caption = 'T'#237'tulo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblMsgErrorTitle: TLabel
      Left = 10
      Top = 60
      Width = 161
      Height = 13
      Caption = 'Informe um t'#237'tulo para a tarefa.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2574837
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      StyleElements = [seClient, seBorder]
    end
    object lblDescription: TLabel
      Left = 10
      Top = 83
      Width = 54
      Height = 15
      Caption = 'Descri'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblPriority: TLabel
      Left = 10
      Top = 226
      Width = 57
      Height = 15
      Caption = 'Prioridade'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblStatus: TLabel
      Left = 252
      Top = 226
      Width = 35
      Height = 15
      Caption = 'Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblCreatedAt: TLabel
      Left = 10
      Top = 281
      Width = 111
      Height = 15
      Caption = 'Data/Hora da tarefa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblUpdatedAt: TLabel
      Left = 252
      Top = 281
      Width = 134
      Height = 15
      Caption = 'Data e hora da altera'#231#227'o'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      StyleElements = [seClient, seBorder]
    end
    object lblMsgErrorDescription: TLabel
      Left = 10
      Top = 198
      Width = 187
      Height = 13
      Caption = 'Informe uma descri'#231#227'o para a tarefa.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2574837
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      StyleElements = [seClient, seBorder]
    end
    object edtTitle: TEdit
      Left = 10
      Top = 30
      Width = 472
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      StyleElements = [seBorder]
    end
    object cbPriority: TComboBox
      Left = 10
      Top = 246
      Width = 230
      Height = 25
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      StyleElements = []
    end
    object cbStatus: TComboBox
      Left = 252
      Top = 246
      Width = 230
      Height = 25
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      StyleElements = []
      OnClick = cbStatusClick
    end
    object mmoDescription: TMemo
      Left = 10
      Top = 103
      Width = 472
      Height = 90
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
      StyleElements = [seBorder]
    end
    object edtCreatedAt: TEdit
      Tag = 1
      Left = 10
      Top = 301
      Width = 230
      Height = 23
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
      Text = 'edtCreatedAt'
      StyleElements = [seFont, seBorder]
    end
    object edtUpdatedAt: TEdit
      Tag = 1
      Left = 252
      Top = 301
      Width = 230
      Height = 23
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 5
      Text = 'edtCreatedAt'
      StyleElements = [seFont, seBorder]
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 404
    Width = 492
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlFooter'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 2
    StyleElements = [seBorder]
    DesignSize = (
      492
      64)
    object btnConfirm: TcrStaticText
      Left = 272
      Top = 10
      Width = 100
      Height = 44
      OptionsImage.Layout = blGlyphLeft
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.FocusRect = True
      Properties.TabOrder = 0
      Properties.TabStop = True
      Style.Color = 15426341
      Style.TextColor = clWhite
      Style.HotTrack = True
      StyleDisable.Color = 14211288
      StyleDisable.TextColor = 10132122
      StyleFocused.BorderStyle.BorderColor = 7746075
      StyleFocused.BorderStyle.Border = cbsSingle
      StyleFocused.Color = 11485214
      StyleFocused.TextColor = clWhite
      StyleHotTrack.BorderStyle.BorderColor = 9385243
      StyleHotTrack.BorderStyle.Border = cbsSingle
      StyleHotTrack.Color = 14175773
      StyleHotTrack.TextColor = clWhite
      Anchors = [akTop, akRight]
      Caption = 'Confirmar'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      OnClick = btnConfirmClick
      ParentFont = False
    end
    object btnCancel: TcrStaticText
      Left = 382
      Top = 10
      Width = 100
      Height = 44
      OptionsImage.Layout = blGlyphLeft
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.FocusRect = True
      Properties.TabOrder = 1
      Properties.TabStop = True
      Style.Color = 16051948
      Style.TextColor = 3877150
      Style.HotTrack = True
      StyleDisable.TextColor = 3877150
      StyleFocused.BorderStyle.BorderColor = 7891040
      StyleFocused.BorderStyle.Border = cbsSingle
      StyleFocused.Color = 13681339
      StyleFocused.TextColor = 3877150
      StyleHotTrack.BorderStyle.BorderColor = 10522760
      StyleHotTrack.BorderStyle.Border = cbsSingle
      StyleHotTrack.Color = 14866643
      StyleHotTrack.TextColor = 3877150
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
    end
  end
end
