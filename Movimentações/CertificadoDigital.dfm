object FrmCertificado: TFrmCertificado
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Certificado Digital'
  ClientHeight = 213
  ClientWidth = 898
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 898
    Height = 168
    Align = alClient
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing]
    TabOrder = 0
    ExplicitWidth = 658
    ExplicitHeight = 192
  end
  object Panel1: TPanel
    Left = 0
    Top = 168
    Width = 898
    Height = 45
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 192
    ExplicitWidth = 658
    DesignSize = (
      898
      45)
    object BitBtn1: TBitBtn
      Left = 676
      Top = 5
      Width = 88
      Height = 30
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 436
    end
    object BitBtn2: TBitBtn
      Left = 788
      Top = 5
      Width = 88
      Height = 30
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 548
    end
  end
end
