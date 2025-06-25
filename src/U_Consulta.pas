unit U_Consulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrm_Consulta = class(TForm)
    pnConsulta: TPanel;
    Panel8: TPanel;
    SpeedButton3: TSpeedButton;
    gridpesq: TDBGrid;
    ds: TDataSource;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Consulta: TFrm_Consulta;

implementation

uses
  U_Principal;

{$R *.dfm}

procedure TFrm_Consulta.SpeedButton1Click(Sender: TObject);
begin
  Frm_Principal.iCodRetorno := 0;
  Close;
end;

procedure TFrm_Consulta.SpeedButton3Click(Sender: TObject);
begin
  Frm_Principal.iCodRetorno := gridpesq.Fields[0].Value;
  Close;
end;

end.
