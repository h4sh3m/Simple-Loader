object Form1: TForm1
  Left = 240
  Top = 146
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Sample Loader'
  ClientHeight = 256
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnExecute: TBitBtn
    Left = 8
    Top = 222
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnExecuteClick
  end
  object gpInputFile: TGroupBox
    Left = 8
    Top = 8
    Width = 208
    Height = 49
    Caption = ' [ Select File ] '
    TabOrder = 1
    object edtPath: TEdit
      Left = 8
      Top = 20
      Width = 167
      Height = 21
      TabOrder = 0
    end
    object btnOpen: TBitBtn
      Left = 176
      Top = 20
      Width = 27
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btnOpenClick
    end
  end
  object gpDelay: TGroupBox
    Left = 8
    Top = 58
    Width = 208
    Height = 47
    Caption = ' [ Delay ] '
    TabOrder = 2
    object Label1: TLabel
      Left = 72
      Top = 22
      Width = 13
      Height = 13
      Caption = 'ms'
    end
    object edtDelay: TEdit
      Left = 8
      Top = 17
      Width = 57
      Height = 21
      TabOrder = 0
      Text = '1500'
    end
  end
  object gpPatchBytes: TGroupBox
    Left = 8
    Top = 111
    Width = 208
    Height = 105
    Caption = '[ Patch Bytes ]'
    TabOrder = 3
    object memPatch: TMemo
      Left = 2
      Top = 15
      Width = 204
      Height = 88
      Align = alClient
      Lines.Strings = (
        'RVA:Byte')
      TabOrder = 0
      ExplicitLeft = 20
      ExplicitTop = 24
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object opn: TOpenDialog
    Filter = 'Application|*.exe'
    Left = 112
  end
end
