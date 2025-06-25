unit Controle_Pessoa;

interface
  type
    TCliente = class
      private
        Class var
          FCodigo : Integer;
          FNome   : string;
          FCidade : String;
          FUF     : String;
      public
        class property  Codigo : Integer  read FCodigo  write FCodigo;
        class property  Nome   : string   read FNome    write FNome;
        class property  Cidade : String   read FCidade  write FCidade;
        class property  UF     : String   read FUF      write FUF;

        class function ConsultarCliente: Boolean;


    end;

implementation

uses
  U_DM, FireDAC.Comp.Client;

{ TCliente }

class function TCliente.ConsultarCliente: Boolean;
var QryConCli  : TFDQuery;
    Conexao    : TFDConnection;
begin
   Conexao    := DM.CriarConexao;
   QryConCli  := DM.CriarQuery(Conexao,'Select * From tbcliente Where codigo = :codigo');
   QryConCli.ParamByName('codigo').Value := Codigo;
   QryConCli.Open;
   Try
     if not QryConCli.IsEmpty then
     begin
       Nome      := QryConCli.FieldByName('Nome').Value;
       Cidade    := QryConCli.FieldByName('Cidade').Value;
       UF        := QryConCli.FieldByName('UF').Value;
       Result := True;
     end
     else
       Result := False;
   Finally
     QryConCli.DisposeOf;
     DM.DestruirConexao(Conexao);
   End;
end;

end.
