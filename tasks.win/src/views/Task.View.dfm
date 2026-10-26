inherited frmTaskView: TfrmTaskView
  Caption = 'Tarefas'
  ClientHeight = 464
  ClientWidth = 730
  Constraints.MinHeight = 460
  Constraints.MinWidth = 730
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 746
  ExplicitHeight = 503
  TextHeight = 15
  inherited pnlBody: TPanel [0]
    Top = 199
    Width = 730
    Height = 265
    TabOrder = 0
    ExplicitTop = 199
    ExplicitWidth = 730
    ExplicitHeight = 265
    object scrlbxTasks: TScrollBox
      Left = 0
      Top = 0
      Width = 730
      Height = 265
      Align = alClient
      BorderStyle = bsNone
      Color = clWhite
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      ParentBackground = True
      ParentColor = False
      TabOrder = 0
      StyleElements = []
    end
  end
  object pnlFlters: TPanel [1]
    Left = 0
    Top = 136
    Width = 730
    Height = 63
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlFlters'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 2
    StyleElements = [seBorder]
    DesignSize = (
      730
      63)
    object lblStatus: TLabel
      Left = 10
      Top = 10
      Width = 32
      Height = 15
      Caption = 'Status'
      StyleElements = [seClient, seBorder]
    end
    object lblPriority: TLabel
      Left = 201
      Top = 10
      Width = 54
      Height = 15
      Caption = 'Prioridade'
      StyleElements = [seClient, seBorder]
    end
    object cbStatus: TComboBox
      Left = 10
      Top = 30
      Width = 170
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object cbPriority: TComboBox
      Left = 200
      Top = 30
      Width = 170
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      StyleElements = [seClient, seBorder]
    end
    object btnAdd: TcrStaticText
      Left = 620
      Top = 10
      Width = 100
      Height = 44
      OptionsImage.Layout = blGlyphLeft
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.FocusRect = True
      Properties.TabOrder = 3
      Properties.TabStop = True
      Style.Color = 15426341
      Style.TextColor = clWhite
      Style.HotTrack = True
      StyleFocused.BorderStyle.BorderColor = 7746075
      StyleFocused.BorderStyle.Border = cbsSingle
      StyleFocused.Color = 11485214
      StyleFocused.TextColor = clWhite
      StyleHotTrack.BorderStyle.BorderColor = 9385243
      StyleHotTrack.BorderStyle.Border = cbsSingle
      StyleHotTrack.Color = 14175773
      StyleHotTrack.TextColor = clWhite
      Anchors = [akTop, akRight]
      Caption = 'Adicionar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      OnClick = btnAddClick
      ParentFont = False
    end
    object btnSearch: TcrStaticText
      Left = 510
      Top = 10
      Width = 100
      Height = 44
      OptionsImage.Layout = blGlyphLeft
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.FocusRect = True
      Properties.TabOrder = 2
      Properties.TabStop = True
      Style.Color = 16051948
      Style.TextColor = 3877150
      Style.HotTrack = True
      StyleFocused.BorderStyle.BorderColor = 7891040
      StyleFocused.BorderStyle.Border = cbsSingle
      StyleFocused.Color = 13681339
      StyleFocused.TextColor = 3877150
      StyleHotTrack.BorderStyle.BorderColor = 10522760
      StyleHotTrack.BorderStyle.Border = cbsSingle
      StyleHotTrack.Color = 14866643
      StyleHotTrack.TextColor = 3877150
      Anchors = [akTop, akRight]
      Caption = 'Pesquisar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3877150
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      OnClick = btnSearchClick
      ParentFont = False
    end
  end
  inherited pnlHeader: TPanel [2]
    Width = 730
    Height = 136
    TabOrder = 1
    StyleElements = []
    ExplicitWidth = 730
    ExplicitHeight = 136
    object pnlTasksTotal: TPanel
      Left = 10
      Top = 53
      Width = 120
      Height = 73
      BevelOuter = bvNone
      Caption = 'pnlTasksTotal'
      TabOrder = 0
      StyleElements = [seClient]
      object shpTasksTotal: TShape
        Left = 0
        Top = 0
        Width = 120
        Height = 73
        Brush.Color = 3877150
        Pen.Color = 13159374
        Shape = stRoundRect
      end
      object lblTasksTotal: TLabel
        Left = 10
        Top = 10
        Width = 90
        Height = 20
        Caption = 'lblTasksTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
      object lblCountTotal: TLabel
        Left = 7
        Top = 31
        Width = 154
        Height = 32
        Caption = 'lblCountTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
    end
    object pnlTasksPending: TPanel
      Left = 140
      Top = 53
      Width = 120
      Height = 73
      BevelOuter = bvNone
      Caption = 'pnlTasksTotal'
      TabOrder = 1
      StyleElements = [seClient]
      object shpTasksPending: TShape
        Left = 0
        Top = 0
        Width = 120
        Height = 73
        Brush.Color = 3877150
        Pen.Color = 13159374
        Shape = stRoundRect
      end
      object lblTasksPending: TLabel
        Left = 10
        Top = 10
        Width = 121
        Height = 20
        Caption = 'lblTasksTitleTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
      object lblCountPending: TLabel
        Left = 9
        Top = 31
        Width = 145
        Height = 32
        Caption = 'lblTasksTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
    end
    object pnlTasksInProgress: TPanel
      Left = 270
      Top = 53
      Width = 120
      Height = 73
      BevelOuter = bvNone
      Caption = 'pnlTasksTotal'
      TabOrder = 2
      StyleElements = [seClient]
      object shpTasksInProgress: TShape
        Left = 0
        Top = 0
        Width = 120
        Height = 73
        Brush.Color = 3877150
        Pen.Color = 13159374
        Shape = stRoundRect
      end
      object lblTasksInProgress: TLabel
        Left = 10
        Top = 10
        Width = 121
        Height = 20
        Caption = 'lblTasksTitleTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
      object lblCountInProgress: TLabel
        Left = 9
        Top = 31
        Width = 145
        Height = 32
        Caption = 'lblTasksTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
    end
    object pnlTasksCompleted: TPanel
      Left = 400
      Top = 53
      Width = 120
      Height = 73
      BevelOuter = bvNone
      Caption = 'pnlTasksTotal'
      TabOrder = 3
      StyleElements = [seClient]
      object shpTasksCompleted: TShape
        Left = 0
        Top = 0
        Width = 120
        Height = 73
        Brush.Color = 3877150
        Pen.Color = 13159374
        Shape = stRoundRect
      end
      object lblTasksCompleted: TLabel
        Left = 10
        Top = 10
        Width = 121
        Height = 20
        Caption = 'lblTasksTitleTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
      object lblCountCompleted: TLabel
        Left = 9
        Top = 31
        Width = 145
        Height = 32
        Caption = 'lblTasksTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
    end
    object pnlTasksCancelled: TPanel
      Left = 530
      Top = 53
      Width = 120
      Height = 73
      BevelOuter = bvNone
      Caption = 'pnlTasksTotal'
      TabOrder = 4
      StyleElements = [seClient]
      object shpTasksCancelled: TShape
        Left = 0
        Top = 0
        Width = 120
        Height = 73
        Brush.Color = 3877150
        Pen.Color = 13159374
        Shape = stRoundRect
      end
      object lblTasksCancelled: TLabel
        Left = 10
        Top = 10
        Width = 121
        Height = 20
        Caption = 'lblTasksTitleTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
      object lblCountCancelled: TLabel
        Left = 9
        Top = 31
        Width = 145
        Height = 32
        Caption = 'lblTasksTotal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 13159374
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = []
      end
    end
  end
end
