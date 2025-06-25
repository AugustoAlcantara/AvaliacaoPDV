unit Controle_Produto;

interface
  type
    TProduto = class
      private
        class var
          FCodigo     : Integer;
          FDescricao  : string;
          FPrecoVenda : Double;
      public
        class property Codigo     : Integer  read  FCodigo     write FCodigo;
        class property Descricao  : string   read  FDescricao  write FDescricao;
        class property PrecoVenda : Double   read  FPrecoVenda write FPrecoVenda;

        class function ConsultarProduto: Boolean;
    end;

implementation

uses
  FireDAC.Comp.Client, U_DM;

{ TProduto }

class function TProduto.ConsultarProduto: Boolean;
var QryConProd  : TFDQuery;
    Conexao     : TFDConnection;
begin
   Conexao    := DM.CriarConexao;
   QryConProd := DM.CriarQuery(Conexao,'Select * From tbproduto Where codigo = :codigo');
   QryConProd.ParamByName('codigo').Value := Codigo;
   QryConProd.Open;
   Try
   if not QryConProd.IsEmpty then
   begin
     Descricao    := QryConProd.FieldByName('Descricao').Value;
     PrecoVenda   := QryConProd.FieldByName('PrecoVenda').Value;
     Result := True;
   end
   else
     Result := False;
   Finally
     QryConProd.DisposeOf;
     DM.DestruirConexao(Conexao);
   End;
end;

end.
