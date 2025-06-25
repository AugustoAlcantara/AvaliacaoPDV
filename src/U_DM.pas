unit U_DM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, IniFiles;

type
  TDM = class(TDataModule)
    fdCon: TFDConnection;
    QyPesqCli: TFDQuery;
    QyPesqProd: TFDQuery;
    QyPesqPed: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    QyPesqClicodigo: TIntegerField;
    QyPesqClinome: TStringField;
    QyPesqClicidade: TStringField;
    QyPesqCliuf: TStringField;
    QyPesqProdcodigo: TIntegerField;
    QyPesqProddescricao: TStringField;
    QyPesqProdprecovenda: TSingleField;
    QyPesqPedidpedido: TIntegerField;
    QyPesqPeddataemissao: TDateTimeField;
    QyPesqPedcodcliente: TIntegerField;
    QyPesqPedvalortotal: TSingleField;
    procedure DataModuleCreate(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
    const SqlPesqIdPedido =  'SELECT * FROM tbpedido WHERE idPedido = :idPedido';
    const SqlPesqPedido   =  'SELECT * FROM tbpedido ';

    function CriarConexao: TFDConnection;
    function CriarQuery(Conexao: TFDConnection; Sql: string): TFDQuery;
    procedure DestruirConexao(var Conexao: TFDConnection);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


{ TDM }

function TDM.CriarQuery(Conexao: TFDConnection; Sql: string): TFDQuery;
begin
  Result            := TFDQuery.Create(Self);
  Result.Connection := Conexao;
  Result.SQL.Clear;
  Result.SQL.Text   := Sql;
end;

 function TDM.CriarConexao: TFDConnection;
begin
  Result                               := TFDConnection.Create(Self);
  Result.Params.Text                   := fdCon.Params.Text;
  Result.FetchOptions.Mode             := fmAll;
  Result.ResourceOptions.AutoReconnect := True;
  Result.LoginPrompt                   := False;
  Result.Connected                     := True;
end;


procedure TDM.DataModuleCreate(Sender: TObject);
var
  Ini: TIniFile;
  ConfigPath: string;
  Server, Port, Database, Username, Password, VendorLib: string;
begin
  ConfigPath := ExtractFilePath(ParamStr(0)) + 'config.ini';
  Ini := TIniFile.Create(ConfigPath);
  try
    Server     := Ini.ReadString('DATABASE', 'Server', 'localhost');
    Port       := Ini.ReadString('DATABASE', 'Port', '3306');
    Database   := Ini.ReadString('DATABASE', 'Database', '');
    Username   := Ini.ReadString('DATABASE', 'Username', '');
    Password   := Ini.ReadString('DATABASE', 'Password', '');
    VendorLib  := Ini.ReadString('DATABASE', 'VendorLib', 'libmysql.dll');

    FDPhysMySQLDriverLink1.VendorLib := IncludeTrailingPathDelimiter(GetCurrentDir) + VendorLib;

    fdCon.Params.Clear;
    fdCon.Params.DriverID := 'MySQL';
    fdCon.Params.Database := Database;
    fdCon.Params.UserName := Username;
    fdCon.Params.Password := Password;
    fdCon.Params.Add('Server=' + Server);
    fdCon.Params.Add('Port=' + Port);

  finally
    Ini.Free;
  end;
end;

procedure TDM.DestruirConexao(var Conexao: TFDConnection);
begin
  Conexao.Close;
  FreeAndNil(Conexao);
end;

end.
