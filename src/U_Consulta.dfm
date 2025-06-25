object Frm_Consulta: TFrm_Consulta
  Left = 0
  Top = 0
  Caption = 'Consultar'
  ClientHeight = 178
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object pnConsulta: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 178
    Align = alClient
    TabOrder = 0
    object Panel8: TPanel
      Left = 1
      Top = 145
      Width = 534
      Height = 32
      Align = alBottom
      TabOrder = 1
      object SpeedButton3: TSpeedButton
        Left = 194
        Top = 3
        Width = 63
        Height = 26
        Caption = 'Confirmar'
        OnClick = SpeedButton3Click
      end
      object SpeedButton1: TSpeedButton
        Left = 282
        Top = 3
        Width = 63
        Height = 26
        Caption = 'Voltar'
        OnClick = SpeedButton1Click
      end
    end
    object gridpesq: TDBGrid
      Left = 1
      Top = 1
      Width = 534
      Height = 144
      Align = alClient
      DataSource = ds
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object ds: TDataSource
    Left = 176
    Top = 88
  end
end
