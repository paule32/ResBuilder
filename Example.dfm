object Form1: TForm1
  Left = 548
  Top = 143
  Width = 507
  Height = 351
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 115
  TextHeight = 16
  object Button1: TButton
    Left = 32
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object RichEdit1: TRichEdit
    Left = 32
    Top = 80
    Width = 417
    Height = 161
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 1
  end
  object z: TJvZlibMultiple
    Left = 120
    Top = 24
  end
end
