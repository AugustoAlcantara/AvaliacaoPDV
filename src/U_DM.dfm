object DM: TDM
  OnCreate = DataModuleCreate
  Height = 281
  Width = 327
  object fdCon: TFDConnection
    Params.Strings = (
      'Database=pdv_simples'
      'User_Name=root'
      'Password=admin'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 136
    Top = 16
  end
  object QyPesqCli: TFDQuery
    Connection = fdCon
    SQL.Strings = (
      'select * from tbcliente')
    Left = 56
    Top = 128
    object QyPesqClicodigo: TIntegerField
      DisplayWidth = 7
      FieldName = 'codigo'
      Required = True
    end
    object QyPesqClinome: TStringField
      DisplayWidth = 50
      FieldName = 'nome'
      Required = True
      Size = 100
    end
    object QyPesqClicidade: TStringField
      DisplayWidth = 20
      FieldName = 'cidade'
      Required = True
      Size = 45
    end
    object QyPesqCliuf: TStringField
      FieldName = 'uf'
      Required = True
      Size = 2
    end
  end
  object QyPesqProd: TFDQuery
    Connection = fdCon
    SQL.Strings = (
      'select * from tbproduto')
    Left = 134
    Top = 128
    object QyPesqProdcodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyPesqProddescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 45
    end
    object QyPesqProdprecovenda: TSingleField
      FieldName = 'precovenda'
      Origin = 'precovenda'
      Required = True
    end
  end
  object QyPesqPed: TFDQuery
    Connection = fdCon
    SQL.Strings = (
      'select * from tbpedido')
    Left = 212
    Top = 128
    object QyPesqPedidpedido: TIntegerField
      FieldName = 'idpedido'
      Origin = 'idpedido'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QyPesqPeddataemissao: TDateTimeField
      FieldName = 'dataemissao'
      Origin = 'dataemissao'
      Required = True
    end
    object QyPesqPedcodcliente: TIntegerField
      FieldName = 'codcliente'
      Origin = 'codcliente'
      Required = True
    end
    object QyPesqPedvalortotal: TSingleField
      FieldName = 'valortotal'
      Origin = 'valortotal'
      Required = True
    end
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'D:\BKPSISTEMAS\Projetos diversos auxiliares\PDV_Simples\libmysql' +
      '.dll'
    Left = 128
    Top = 184
  end
end
