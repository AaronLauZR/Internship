object Form1: TForm1
  Left = 225
  Top = 0
  Caption = 'Frequently Bought Togather Item'
  ClientHeight = 614
  ClientWidth = 1122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1122
    614)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 19
    Height = 15
    Caption = 'Top'
  end
  object Label2: TLabel
    Left = 84
    Top = 12
    Width = 194
    Height = 15
    Align = alCustom
    Caption = 'products based on Confidence Score'
  end
  object cxSpinButton1: TcxSpinButton
    Left = 60
    Top = 8
    AutoSize = False
    Properties.AssignedValues.MinValue = True
    Properties.OnChange = cxSpinButton1PropertiesChange
    TabOrder = 0
    Value = 5
    Height = 23
    Width = 19
  end
  object Edit1: TEdit
    Left = 33
    Top = 8
    Width = 32
    Height = 23
    TabOrder = 1
    Text = '5'
    OnKeyDown = Edit1KeyDown
  end
  object cxGrid1: TcxGrid
    AlignWithMargins = True
    Left = 8
    Top = 37
    Width = 1106
    Height = 556
    Margins.Right = 11
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    LockedStateImageOptions.Text = '+'
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      FilterBox.Visible = fvNever
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataModeController.GridModeBufferCount = 5
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.OnFilterRecord = cxGrid1DBTableView1DataControllerFilterRecord
      OptionsBehavior.NavigatorHints = True
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.ColumnsQuickCustomizationSorted = True
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellEndEllipsis = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GridLineColor = clMedGray
      OptionsView.GroupByBox = False
      OptionsView.GroupFooterMultiSummaries = True
      OptionsView.HeaderEndEllipsis = True
      OptionsView.Indicator = True
      OptionsView.RowSeparatorColor = clBlack
      Styles.ContentEven = cxStyle1
      object cxGrid1DBTableView1ItemCode: TcxGridDBColumn
        Caption = 'Item Code'
        DataBinding.FieldName = 'ItemCode'
        DataBinding.IsNullValueType = True
        Width = 50
      end
      object cxGrid1DBTableView1Description: TcxGridDBColumn
        DataBinding.FieldName = 'Description'
        DataBinding.IsNullValueType = True
        Width = 100
      end
      object cxGrid1DBTableView1ConfidenceScore: TcxGridDBColumn
        DataBinding.FieldName = 'ConfidenceScore'
        DataBinding.IsNullValueType = True
        OnGetDisplayText = cxGrid1DBTableView1ConfidenceScoreGetDisplayText
        Width = 65
      end
      object cxGrid1DBTableView1CoOccurrenceFrequency: TcxGridDBColumn
        Caption = 'CoOccurrence Frequency'
        DataBinding.FieldName = 'Occurence'
        DataBinding.IsNullValueType = True
        Width = 65
      end
      object cxGrid1DBTableView1AvgQty: TcxGridDBColumn
        Caption = 'Avg Qty'
        DataBinding.FieldName = 'AvgQty'
        DataBinding.IsNullValueType = True
        OnGetDisplayText = cxGrid1DBTableView1AvgQtyGetDisplayText
        Width = 65
      end
      object cxGrid1DBTableView1TotalQty: TcxGridDBColumn
        DataBinding.FieldName = 'TotalQty'
        DataBinding.IsNullValueType = True
        Visible = False
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object Button1: TButton
    Left = 552
    Top = 6
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 3
    OnClick = Button1Click
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 184
    Top = 8
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = clHoneydew
    end
  end
end