object frmPref: TfrmPref
  Left = 527
  Top = 470
  BorderStyle = bsDialog
  Caption = 'Autosave Preferences'
  ClientHeight = 82
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 41
    Width = 606
    Height = 41
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvSpace
    TabOrder = 0
    object btnOK: TButton
      Left = 13
      Top = 5
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 94
      Top = 5
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cbbServer: TComboBox
    Left = 8
    Top = 8
    Width = 202
    Height = 21
    Sorted = True
    TabOrder = 1
    Text = 'Server'
    OnChange = cbbServerChange
  end
  object edPath: TEdit
    Left = 216
    Top = 8
    Width = 361
    Height = 21
    TabOrder = 2
    Text = 'Path'
  end
  object btnSelectPath: TButton
    Left = 575
    Top = 7
    Width = 21
    Height = 21
    Caption = '...'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    OnClick = btnSelectPathClick
  end
end
