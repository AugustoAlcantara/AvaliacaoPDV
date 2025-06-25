unit Controle_Pedido;

interface

uses
  Datasnap.DBClient;

type
  TPedido = class
    protected
      private
        Class var
          FNumPedido  : Integer;
          FDataEmi    : TDateTime;
          FCodCli     : Integer;
          FVlrTotal   : Double;
      public
        class property NumPedido  : Integer     read FNumPedido    write FNumPedido;
        class property DataEmi    : TDateTime   read FDataEmi      write FDataEmi;
        class property CodCli     : Integer     read FCodCli       write FCodCli;
        class property VlrTotal   : Double      read FVlrTotal     write FVlrTotal;

        class function InserirPedido(CDSItem : TClientDataSet): Boolean;
        class function AlterarPedido(CDSItem : TClientDataSet): Boolean;
        class function ConsultarPedido: Boolean;
        class function ExcluirPedido: Boolean;
        class function GerarNumero: string;
  end;
  type
  TItemPedido = class
    protected
      private
        Class var
          FNumPedido  : Integer;
          FCodProd    : Integer;
          FQuant      : Double;
          FVlrUnit    : Double;
          FVlrTotal   : Double;

      public
        class property NumPedido  : Integer     read FNumPedido    write FNumPedido;
        class property CodProd    : Integer     read FCodProd      write FCodProd;
        class property Quant      : Double      read FQuant        write FQuant;
        class property VlrUnit    : Double      read FVlrUnit      write FVlrUnit;
        class property VlrTotal   : Double      read FVlrTotal     write FVlrTotal;

        class function ConsultarItemPedido(CDSRetorno : TClientDataSet) : Boolean;
        class procedure ExcluirItemPedido;

  end;



implementation

uses
  FireDAC.Comp.Client, U_DM, System.SysUtils;

{ TItemPedido }

class function TItemPedido.ConsultarItemPedido(CDSRetorno : TClientDataSet) : Boolean;
var QryConsultarItemPedido : TFDQuery;
        Conexao            : TFDConnection;
begin
   Conexao                 := DM.CriarConexao;
   QryConsultarItemPedido  := DM.CriarQuery(Conexao,'Select ped.*, prod.descricao as descricaoprod From tbitempedido  ped    ' +
                                                    'inner join tbproduto prod on prod.codigo = ped.codproduto               ' +
                                                    'Where idpedido = :idpedido                                              ');
   QryConsultarItemPedido.ParamByName('idpedido').Value := NumPedido;
   QryConsultarItemPedido.Open;
   Try
     if not QryConsultarItemPedido.IsEmpty then
     begin
       QryConsultarItemPedido.First;
       while not QryConsultarItemPedido.Eof do
       begin
         CDSRetorno.AppendRecord([QryConsultarItemPedido.FieldByName('idpedido').Value,
                                  QryConsultarItemPedido.FieldByName('codProduto').Value,
                                  QryConsultarItemPedido.FieldByName('quantidade').Value,
                                  QryConsultarItemPedido.FieldByName('vlrunitario').Value,
                                  QryConsultarItemPedido.FieldByName('vlrtotal').Value,
                                  QryConsultarItemPedido.FieldByName('descricaoprod').Value]);

         QryConsultarItemPedido.Next;
       end;
       Result   := True;
     end
     else
       Result   := False;
   Finally
     QryConsultarItemPedido.DisposeOf;
     DM.DestruirConexao(Conexao);
   End;
end;

class procedure TItemPedido.ExcluirItemPedido;
  var QryExcluirItPedido : TFDQuery;
      Conexao            : TFDConnection;
begin
  Conexao            := DM.CriarConexao;
  QryExcluirItPedido := DM.CriarQuery(Conexao,'delete From tbitempedido      ' +
                                              'Where idpedido = :id          ');
  try
    QryExcluirItPedido.ParamByName('id').Value := NumPedido;
    Try
      Conexao.StartTransaction;
      QryExcluirItPedido.ExecSQL;
      Conexao.Commit;
    except
      on E:Exception do
      begin
        raise Exception.Create(E.Message);
        Conexao.Rollback;
      end;
    end;
  finally
    QryExcluirItPedido.DisposeOf;
    DM.DestruirConexao(Conexao);
  end;
end;

{ TPedido }

class function TPedido.AlterarPedido(CDSItem : TClientDataSet): Boolean;
  var QryAlterarPedido : TFDQuery;
      QryAlterarItPdo  : TFDQuery;
      Conexao          : TFDConnection;
      ItemPedido       : TItemPedido;
begin
  Conexao          := DM.CriarConexao;
  QryAlterarPedido := DM.CriarQuery(Conexao,'');
  QryAlterarItPdo  := DM.CriarQuery(Conexao,'');
  Try
    try
      Conexao.StartTransaction;
      //Insere os dados gerais do pedido(cabeçalho)
      QryAlterarPedido.SQL.Text := 'UPDATE tbpedido SET codcliente = :codcliente, ' +
                                   'valortotal     = :valortotal                  ' +
                                   'Where idpedido = :idpedido;                   ' ;
      QryAlterarPedido.ParamByName('idpedido').Value     := NumPedido;
      QryAlterarPedido.ParamByName('codcliente').Value   := CodCli;
      QryAlterarPedido.ParamByName('valortotal').Value   := VlrTotal;
      QryAlterarPedido.ExecSQL;

      //Insere os Itens do pedido
      ItemPedido           := TItemPedido.Create;
      ItemPedido.NumPedido := NumPedido;
      ItemPedido.ExcluirItemPedido;
      CDSItem.First;
      while not CDSItem.Eof do
      begin
        QryAlterarItPdo.SQL.Text :='INSERT INTO tbitempedido                                        ' +
                                   '(idpedido, codproduto, quantidade, vlrunitario, vlrtotal)       ' +
                                   'VALUES                                                          ' +
                                   '(:idpedido, :codproduto, :quantidade, :vlrunitario, :vlrtotal); ' ;

        QryAlterarItPdo.ParamByName('idpedido').Value      := NumPedido;
        QryAlterarItPdo.ParamByName('codproduto').Value    := CDSItem.FieldByName('CodProduto').Value;
        QryAlterarItPdo.ParamByName('quantidade').Value    := CDSItem.FieldByName('Quantidade').Value;
        QryAlterarItPdo.ParamByName('vlrunitario').Value   := CDSItem.FieldByName('VlrUnitario').Value;
        QryAlterarItPdo.ParamByName('vlrtotal').Value      := CDSItem.FieldByName('VlrTotal').Value;

        QryAlterarItPdo.ExecSQL;
        CDSItem.Next;
      end;
      Conexao.Commit;
      Result := True;
    except
      on E:Exception do
      begin
         raise Exception.Create(E.Message);
         Conexao.Rollback;
         Result := False;
      end;
    end;
  Finally
    QryAlterarPedido.DisposeOf;
    QryAlterarItPdo.DisposeOf;
    DM.DestruirConexao(Conexao);
  End;
end;

class function TPedido.ConsultarPedido: Boolean;
  var QryConsultarPedido : TFDQuery;
      Conexao            : TFDConnection;
begin
   Conexao             := DM.CriarConexao;
   QryConsultarPedido  := DM.CriarQuery(Conexao,'Select * From tbpedido      ' +
                                                'Where idpedido = :idpedido  ');
   QryConsultarPedido.ParamByName('idpedido').Value := NumPedido;
   QryConsultarPedido.Open;
   Try
     if not QryConsultarPedido.IsEmpty then
     begin
       DataEmi  := QryConsultarPedido.FieldByName('dataemissao').Value;
       CodCli   := QryConsultarPedido.FieldByName('codcliente').Value;
       VlrTotal := QryConsultarPedido.FieldByName('valortotal').Value;
       Result   := True;
     end
     else
       Result   := False;
   Finally
     QryConsultarPedido.DisposeOf;
     DM.DestruirConexao(Conexao);
   End;
end;

class function TPedido.ExcluirPedido: Boolean;
  var QryExcluirPedido : TFDQuery;
      Conexao          : TFDConnection;
begin
  Conexao          := DM.CriarConexao;
  QryExcluirPedido := DM.CriarQuery(Conexao,'delete From tbpedido      ' +
                                            'Where idpedido = :id      ');
  try
    QryExcluirPedido.ParamByName('id').Value := NumPedido;
    Try
      Conexao.StartTransaction;
      QryExcluirPedido.ExecSQL;
      Conexao.Commit;
      Result := True;
    except
      on E:Exception do
      begin
        raise Exception.Create(E.Message);
        Conexao.Rollback;
        Result := False;
      end;
    end;
  finally
    QryExcluirPedido.DisposeOf;
    DM.DestruirConexao(Conexao);
  end;
end;

class function TPedido.GerarNumero: string;
var QryNovoId  : TFDQuery;
    Conexao    : TFDConnection;
    NovoId     : Integer;
    IdAtual    : string;
begin
  Conexao   := DM.CriarConexao;
  QryNovoId := DM.CriarQuery(Conexao,'Select Max(idpedido) as id From tbPedido');
  QryNovoId.Open;
  IdAtual   := copy(QryNovoId.FieldByName('id').AsString,5,4);
  Try
    if IdAtual <> '' then
    begin
      NovoId := StrToInt(IdAtual) + 1;
      Result := FormatDateTime('yymm',Date) + FormatFloat('0000',NovoId);
    end
    else
    Result := FormatDateTime('yymm',Date) + '0001';
  Finally
    QryNovoId.DisposeOf;
    DM.DestruirConexao(Conexao);
  End;
end;

class function TPedido.InserirPedido(CDSItem : TClientDataSet): Boolean;
    var QryInserirPedido : TFDQuery;
        QryInserirItPdo  : TFDQuery;
        Conexao          : TFDConnection;
begin
  Conexao          := DM.CriarConexao;
  QryInserirPedido := DM.CriarQuery(Conexao,'');
  QryInserirItPdo  := DM.CriarQuery(Conexao,'');
  Try
    try
      Conexao.StartTransaction;
      //Insere os dados gerais do pedido(cabeçalho)
      QryInserirPedido.SQL.Text := 'insert into tbpedido (idpedido, dataemissao, codcliente, valortotal) ' +
                                   'values(:idpedido, :dataemissao, :codcliente, :valortotal);           ' ;
      QryInserirPedido.ParamByName('idpedido').Value     := NumPedido;
      QryInserirPedido.ParamByName('dataemissao').Value  := DataEmi;
      QryInserirPedido.ParamByName('codcliente').Value   := CodCli;
      QryInserirPedido.ParamByName('valortotal').Value   := VlrTotal;
      QryInserirPedido.ExecSQL;

      //Insere os Itens do pedido
      CDSItem.First;
      while not CDSItem.Eof do
      begin

        QryInserirItPdo.SQL.Text :='INSERT INTO tbitempedido                                        ' +
                                   '(idpedido, codproduto, quantidade, vlrunitario, vlrtotal)       ' +
                                   'VALUES                                                          ' +
                                   '(:idpedido, :codproduto, :quantidade, :vlrunitario, :vlrtotal); ' ;

        QryInserirItPdo.ParamByName('idpedido').Value      := NumPedido;
        QryInserirItPdo.ParamByName('codproduto').Value    := CDSItem.FieldByName('CodProduto').Value;
        QryInserirItPdo.ParamByName('quantidade').Value    := CDSItem.FieldByName('Quantidade').Value;
        QryInserirItPdo.ParamByName('vlrunitario').Value   := CDSItem.FieldByName('VlrUnitario').Value;
        QryInserirItPdo.ParamByName('vlrtotal').Value      := CDSItem.FieldByName('VlrTotal').Value;

        QryInserirItPdo.ExecSQL;
        CDSItem.Next;
      end;
      Conexao.Commit;
      Result := True;
    except
      on E:Exception do
      begin
         raise Exception.Create(E.Message);
         Conexao.Rollback;
         Result := False;
      end;
    end;
  Finally
    QryInserirPedido.DisposeOf;
    QryInserirItPdo.DisposeOf;
    DM.DestruirConexao(Conexao);
  End;
end;

end.
