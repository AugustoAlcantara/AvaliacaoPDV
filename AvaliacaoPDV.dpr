program AvaliacaoPDV;

uses
  Vcl.Forms,
  U_Consulta in 'src\U_Consulta.pas' {Frm_Consulta},
  U_DM in 'src\U_DM.pas' {DM: TDataModule},
  U_Principal in 'src\U_Principal.pas' {Frm_Principal},
  Controle_Pedido in 'src\Controles\Controle_Pedido.pas',
  Controle_Pessoa in 'src\Controles\Controle_Pessoa.pas',
  Controle_Produto in 'src\Controles\Controle_Produto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
