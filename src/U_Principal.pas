unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.DBCtrls, Datasnap.DBClient, Vcl.Imaging.pngimage;

type
  TFrm_Principal = class(TForm)
    pnCliente: TPanel;
    dbgItensPedido: TDBGrid;
    Panel2: TPanel;
    pnBotoes: TPanel;
    btExcluirPedido: TButton;
    btConsultarPedido: TButton;
    edCodCliente: TEdit;
    edCidade: TEdit;
    edUF: TEdit;
    edNomeCliente: TEdit;
    lbCodCliente: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel5: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    edCodProduto: TEdit;
    edPrecoTabela: TEdit;
    edDescricaoProduto: TEdit;
    btGravarPedido: TButton;
    dsItensPedido: TDataSource;
    CDSItem: TClientDataSet;
    CDSItemIdPedido: TIntegerField;
    CDSItemCodProduto: TIntegerField;
    CDSItemQuantidade: TFloatField;
    CDSItemVlrUnitario: TFloatField;
    CDSItemVlrTotal: TFloatField;
    CDSItemDescricaoProd: TStringField;
    DBNavigator2: TDBNavigator;
    pnRodaPe: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edNumPedido: TEdit;
    btConfCli: TButton;
    dtDataEmi: TDateTimePicker;
    pnPedido: TPanel;
    CDSItemCalcVlrTotal: TAggregateField;
    CDSItemCalcQuantidade: TAggregateField;
    btNovoPedido: TButton;
    CDSItemcontrole: TAutoIncField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    Panel1: TPanel;
    Label9: TLabel;
    Label12: TLabel;
    sbConsultaCliente: TButton;
    Label13: TLabel;
    sbConsultaProduto: TButton;
    Panel3: TPanel;
    Panel6: TPanel;
    imgCheio: TImage;
    imgVazio: TImage;
    Panel7: TPanel;
    Label11: TLabel;
    edQuantPedida: TEdit;
    Label16: TLabel;
    edPrecoVenda: TEdit;
    btAdicionarItem: TButton;
    Label6: TLabel;
    lbValorTotal: TLabel;
    Label7: TLabel;
    lbQuantidadeTotal: TLabel;
    lblDica: TLabel;
    lbValorTotal2: TLabel;
    Label15: TLabel;
    lbQuantidadeTotal2: TLabel;
    Label18: TLabel;
    procedure btGravarPedidoClick(Sender: TObject);
    procedure btConfCliClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSItemAfterInsert(DataSet: TDataSet);
    procedure btExcluirPedidoClick(Sender: TObject);
    procedure btConsultarPedidoClick(Sender: TObject);
    procedure sbConsultaClienteClick(Sender: TObject);
    procedure sbConsultaProdutoClick(Sender: TObject);
    procedure edCodClienteExit(Sender: TObject);
    procedure edCodProdutoExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edQuantPedidaExit(Sender: TObject);
    procedure DBNavigator5BeforeAction(Sender: TObject;
      Button: TNavigateBtn);
    procedure DBNavigator1BeforeAction(Sender: TObject;
      Button: TNavigateBtn);
    procedure edQuantPedidaChange(Sender: TObject);
    procedure CDSItemAfterPost(DataSet: TDataSet);
    procedure dbgItensPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btAdicionarItemClick(Sender: TObject);
    procedure edPrecoVendaExit(Sender: TObject);
    procedure dbgItensPedidoEnter(Sender: TObject);
    procedure btNovoPedidoClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    procedure PedidoEmInclusaoEdicao(EmInclusao: Boolean);
    function ConsultarCliente(AID: Integer): Boolean;
    function ConsultarProduto(AID: Integer): Boolean;
    procedure ConfirmarSelecaoCliente;
    procedure PreparaParaNovoItem;
    procedure GravarItens;
    function CalculaValorTotalItem(AQuantidade: Double): Double;
    procedure AtualizaTotais;
    procedure LimparCampos;
    procedure CarregaItemEdicao(AID: Integer);
    procedure Dica(texto: String);
    { Private declarations }
  public
    { Public declarations }
     var IdPedido, IdCliente, IdProduto  : Integer;
         iCodRetorno, icontrole : Integer;
         bPedEdicao, bItemEdicao, bpedidoEmAndamento,
         bCancelarPedido : boolean;
  end;

var
  Frm_Principal: TFrm_Principal;


implementation

uses
  U_DM, U_Consulta, Controle_Pessoa, Controle_Pedido, Controle_Produto,
  System.SysUtils;

{$R *.dfm}

procedure TFrm_Principal.btConfCliClick(Sender: TObject);
begin
  ConfirmarSelecaoCliente;
end;

procedure TFrm_Principal.ConfirmarSelecaoCliente;
begin
  if edCodCliente.Text = '' then
  begin
    edCodCliente.SetFocus;
    Exit;
  end;
  if Application.MessageBox('Confirma a seleção do cliente para o pedido?','Confirmação',
                            mb_YesNo+MB_ICONQUESTION+MB_DEFBUTTON1) = IDYES then
  begin

    edNumPedido.Text   := TPedido.GerarNumero;
    dtDataEmi.Date     := Date;
    if CDSItem.State IN [dsInactive] then
    CDSItem.CreateDataSet;
   
    PedidoEmInclusaoEdicao(True);
    edCodProduto.SetFocus;
  end;
end;


procedure TFrm_Principal.btConsultarPedidoClick(Sender: TObject);
var
  Pedido: TPedido;
  ItemPedido: TItemPedido;
  sInput: string;
  iPedido: Integer;
begin
  try
    if InputQuery('Consulta de Pedido', 'Informe o número do pedido (ou deixe em branco para listar todos):', sInput) then
    begin
      DM.QyPesqPed.Close;
      DM.QyPesqPed.SQL.Clear;

      if Trim(sInput) <> '' then
      begin
        if not TryStrToInt(sInput, iPedido) then
        begin
          ShowMessage('Número do pedido inválido.');
          Exit;
        end;

        DM.QyPesqPed.SQL.Text := DM.SqlPesqIdPedido;
        DM.QyPesqPed.ParamByName('idPedido').AsInteger := iPedido;
      end
      else
      begin
        DM.QyPesqPed.SQL.Text := DM.SqlPesqPedido;
      end;

      DM.QyPesqPed.Open;

      if not DM.QyPesqPed.IsEmpty then
      begin
        Application.CreateForm(TFrm_Consulta, Frm_Consulta);
        Frm_Consulta.ds.DataSet := DM.QyPesqPed;
        Frm_Consulta.ShowModal;

        if iCodRetorno <> 0 then
        begin
          Pedido := TPedido.Create;
          try
            Pedido.NumPedido := iCodRetorno;
            if Pedido.ConsultarPedido then
            begin
              edNumPedido.Text     := Pedido.NumPedido.ToString;
              dtDataEmi.Date       := Pedido.DataEmi;
              lbValorTotal.Caption := Pedido.VlrTotal.ToString;
              lbValorTotal2.Caption := lbValorTotal.Caption;

              ConsultarCliente(Pedido.CodCli);

              ItemPedido := TItemPedido.Create;
              try
                ItemPedido.NumPedido := Pedido.NumPedido;

                if CDSItem.State in [dsInactive] then
                  CDSItem.CreateDataSet;

                CDSItem.AfterInsert := nil;
                ItemPedido.ConsultarItemPedido(CDSItem);
              finally
                CDSItem.AfterInsert  := CDSItemAfterInsert;
                PedidoEmInclusaoEdicao(True);
                btNovoPedido.Visible := True;
                btGravarPedido.Left  := 145;
                bPedEdicao           := True;

                Dica('Selecione o item na LISTA e pressione ENTER para editar ou DEL para excluir');
                ItemPedido.Free;
              end;
            end
            else
              ShowMessage('Pedido não localizado');
          finally
            Pedido.Free;
            Frm_Consulta.Free;
            DM.QyPesqPed.Close;
          end;
        end;
      end
      else
        ShowMessage('Nenhum pedido encontrado.');
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao consultar pedido. ERRO: ' + E.Message);
  end;
end;

procedure TFrm_Principal.Dica(texto : String);
begin
  if texto <> '' then
  begin
    lblDica.Caption :='Dica: ' + texto;
    lblDica.Visible := True;
  end
  else
  begin
    lblDica.Caption := texto;
    lblDica.Visible := False;
  end;
end;

procedure TFrm_Principal.btExcluirPedidoClick(Sender: TObject);
var
  Pedido: TPedido;
  sInput: string;
  iPedido: Integer;
begin
  try
    if InputQuery('Excluir Pedido', 'Informe o número do pedido (ou deixe em branco para listar todos):', sInput) then
    begin
      DM.QyPesqPed.Close;
      DM.QyPesqPed.SQL.Clear;

      if Trim(sInput) <> '' then
      begin
        if not TryStrToInt(sInput, iPedido) then
        begin
          ShowMessage('Número do pedido inválido.');
          Exit;
        end;

        DM.QyPesqPed.SQL.Text :=  DM.SqlPesqIdPedido;
        DM.QyPesqPed.ParamByName('idPedido').AsInteger := iPedido;
      end
      else
      begin
        DM.QyPesqPed.SQL.Text :=  DM.SqlPesqPedido;
      end;

      DM.QyPesqPed.Open;

      if not DM.QyPesqPed.IsEmpty then
      begin
        Application.CreateForm(TFrm_Consulta, Frm_Consulta);
        try
          Frm_Consulta.ds.DataSet := DM.QyPesqPed;
          Frm_Consulta.Caption := 'Excluir Pedido';
          Frm_Consulta.ShowModal;

          if iCodRetorno <> 0 then
          begin
            if MessageDlg('Deseja realmente excluir o pedido ' + IntToStr(iCodRetorno) + '?',
                          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
              Pedido := TPedido.Create;
              try
                Pedido.NumPedido := iCodRetorno;
                if Pedido.ExcluirPedido then
                  ShowMessage('Pedido excluído com sucesso.')
                else
                  ShowMessage('Pedido não pode ser excluído.');
              finally
                Pedido.Free;
              end;
            end;
          end;
        finally
          Frm_Consulta.Free;
          DM.QyPesqPed.Close;
        end;
      end
      else
        ShowMessage('Nenhum pedido encontrado.');
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao excluir pedido. ERRO: ' + E.Message);
  end;
end;


procedure TFrm_Principal.btGravarPedidoClick(Sender: TObject);
var Pedido     : TPedido;
  NumPedido: Integer;
  CodCli: Integer;
  VlrTotal: Double;
begin
  Try

    if CDSItem.RecordCount = 0 then
    begin
      ShowMessage('Confirme um produto antes de prosseguir');
      Exit;
    end;

    Pedido  := TPedido.Create;
    Try
      Pedido.NumPedido := StrToInt(edNumPedido.Text);
      Pedido.DataEmi   := dtDataEmi.Date;
      Pedido.CodCli    := StrToInt(edCodCliente.Text);
      Pedido.VlrTotal  := StrToFloat(lbValorTotal.Caption);
      if bPedEdicao then
      begin
        Pedido.AlterarPedido(CDSItem);
      end
      else
      begin
        Pedido.InserirPedido(CDSItem);
      end;
      ShowMessage('Pedido n° '+Pedido.NumPedido.ToString+' gravado com sucesso');
      LimparCampos;
    Finally
      Pedido.Free;
      CDSItem.EmptyDataSet;
      CDSItem.Close;
    End;
  except
    on E:Exception do
    begin
      ShowMessage('Erro ao gravar pedido. ERRO:'+ E.Message);
    end;
  End;
end;

procedure TFrm_Principal.btNovoPedidoClick(Sender: TObject);
begin
  LimparCampos;
  Dica('');
end;

procedure TFrm_Principal.btAdicionarItemClick(Sender: TObject);
begin
  GravarItens;
end;

procedure TFrm_Principal.CDSItemAfterInsert(DataSet: TDataSet);
begin
  edCodProduto.SetFocus;
end;

procedure TFrm_Principal.CDSItemAfterPost(DataSet: TDataSet);
begin
  AtualizaTotais;
end;

procedure TFrm_Principal.edCodClienteExit(Sender: TObject);
begin
  if (ActiveControl = btConsultarPedido)  or
     (ActiveControl = btExcluirPedido)    or
     (bCancelarPedido = True) then
  begin
    bCancelarPedido := False;
    Exit;
  end;

  if Trim(edCodCliente.Text) <> '' then
  begin
    If not ConsultarCliente(StrToInt(edCodCliente.Text)) then
      sbConsultaClienteClick(sbConsultaCliente)
    else
    begin
      btConfCli.Enabled := True;
      ConfirmarSelecaoCLiente;
    end;
  end;

//  if Trim(edCodCliente.Text) = '' then
//  begin
//    sbConsultaClienteClick(sbConsultaCliente);
//  end
//  else
//  begin
//    If not ConsultarCliente(StrToInt(edCodCliente.Text)) then
//      sbConsultaClienteClick(sbConsultaCliente)
//    else
//    begin
//      btConfCli.Enabled := True;
//      ConfirmarSelecaoCLiente;
//    end;
//  end;
end;

procedure TFrm_Principal.edCodProdutoExit(Sender: TObject);
begin

  if  (ActiveControl = dbgItensPedido)  or
      (ActiveControl = btGravarPedido)    or
      (bCancelarPedido = True) then
  begin
    bCancelarPedido := False;
    Exit;
  end;

   if Trim(edCodProduto.Text) <> '' then
  begin
    If not ConsultarProduto(StrToInt(edCodProduto.Text)) then
    sbConsultaProdutoClick(sbConsultaProduto);
  end;
//  if Trim(edCodProduto.Text) = '' then
//  begin
//    sbConsultaProdutoClick(sbConsultaProduto);
//  end
//  else
//  begin
//    If not ConsultarProduto(StrToInt(edCodProduto.Text)) then
//    sbConsultaProdutoClick(sbConsultaProduto);
//  end;
end;

procedure TFrm_Principal.edPrecoVendaExit(Sender: TObject);
var Quantidade : string;
begin
  if StrToFloat(edPrecoVenda.Text) < StrToFloat(edPrecoTabela.Text) then
  begin
    ShowMessage('Valor total não pode ser inferior ao preço de tabela');
    edPrecoVenda.Text      := edPrecoTabela.Text;
    edPrecoVenda.SetFocus;
    edPrecoVenda.SelectAll;
    Exit;
  end;
  Quantidade := FloatToStr(StrToFloat(edPrecoVenda.Text) / StrToFloat(edPrecoTabela.Text));
  try
    StrToInt(Quantidade);
    edQuantPedida.OnChange := nil;
    edQuantPedida.Text := Quantidade;
    edQuantPedida.OnChange := edQuantPedidaChange;
  except
    ShowMessage('Valor total informado se refere a uma quandidade fracionada do produto, operação não permitida');
    edQuantPedida.OnChange := nil;
    edQuantPedida.Text     := '1';
    edQuantPedida.OnChange := edQuantPedidaChange;
    edPrecoVenda.Text      := edPrecoTabela.Text;
    edPrecoVenda.SetFocus;
    edPrecoVenda.SelectAll;
    Exit;
  end;
end;

procedure TFrm_Principal.edQuantPedidaChange(Sender: TObject);
begin
  if (edQuantPedida.Text <> '') and (edQuantPedida.Text <> '0')then
  begin
    edPrecoVenda.Text := FormatFloat('###0.00',CalculaValorTotalItem(StrToFloat(edQuantPedida.Text)));
  end;
end;

function TFrm_Principal.CalculaValorTotalItem(AQuantidade : Double): Double;
begin
  Result := (StrToFloat(edPrecoTabela.Text) * AQuantidade);
end;

procedure TFrm_Principal.edQuantPedidaExit(Sender: TObject);
begin
  btAdicionarItem.SetFocus;
end;

procedure TFrm_Principal.GravarItens;
begin
  if bItemEdicao then
  begin
    CDSItem.Filtered         := False;
    CDSItem.Filter           := '';
    CDSItem.Locate('controle',icontrole,[]);
    CDSItem.Delete;
    CDSItem.Append;
    CDSItem.AppendRecord([StrToInt(edNumPedido.Text),
                          StrToInt(edCodProduto.Text),
                          StrToFloat(edQuantPedida.Text),
                          StrToFloat(edPrecoTabela.Text),
                          StrToFloat(edPrecoVenda.Text),
                          edDescricaoProduto.Text]);
    PreparaParaNovoItem;
    bItemEdicao := False;
  end
  else
  begin
    if edCodProduto.Text = '' then
    begin
      edCodProduto.SetFocus;
      Exit;
    end;

    Try
      CDSItem.AppendRecord([StrToInt(edNumPedido.Text),
                          StrToInt(edCodProduto.Text),
                          StrToFloat(edQuantPedida.Text),
                          StrToFloat(edPrecoTabela.Text),
                          StrToFloat(edPrecoVenda.Text),
                          edDescricaoProduto.Text]);
      PreparaParaNovoItem;
    except
      on E:Exception do
      begin
       ShowMessage('Ocorreu um erro ao adicionar o item.   '+#13#10+'ERRO:'+E.Message);
      end;
    End;
  end;
end;

procedure TFrm_Principal.PreparaParaNovoItem;
begin
  edCodProduto.Text         := '';
  edQuantPedida.Text        := '';
  edPrecoTabela.Text        := '';
  edPrecoVenda.Text         := '';
  edDescricaoProduto.Text   := '';
end;

procedure TFrm_Principal.LimparCampos;
begin
  edNumPedido.Text          := '';
  edCodCliente.Text         := '';
  edNomeCliente.Text        := '';
  edCodProduto.Text         := '';
  edCidade.Text             := '';
  edUF.Text                 := '';
  lbValorTotal.Caption      := 'R$0,00';
  lbQuantidadeTotal.Caption := '000';
  lbQuantidadeTotal2.Caption := lbQuantidadeTotal.Caption;
  lbValorTotal2.Caption       := lbValorTotal.Caption;


  imgVazio.Visible := True;
  imgCheio.Visible := False;

  if not (CDSItem.State in [dsInactive]) then
  begin
    CDSItem.EmptyDataSet;
  end;
  PreparaParaNovoItem;
  PedidoEmInclusaoEdicao(False);
  btNovoPedido.Visible      := False;
  bPedEdicao                 := False;
  edCodCliente.SetFocus;
end;

function TFrm_Principal.ConsultarCliente(AID : Integer): Boolean;
var Cliente : TCliente;
begin
  Cliente   := TCliente.Create;
  Try
    Cliente.Codigo := AID;
    If Cliente.ConsultarCliente then
    begin
      edCodCliente.Text  := Cliente.Codigo.ToString;
      edNomeCliente.Text := Cliente.Nome;
      edCidade.Text      := Cliente.Cidade;
      edUF.Text          := Cliente.UF;
      Result := True;
    end
    else
    begin
      ShowMessage('Cliente não localizado');
      Result := False;
    end;
  Finally
    Cliente.Free;
  End;
end;

procedure TFrm_Principal.PageControl1Change(Sender: TObject);
begin
  bCancelarPedido := False;
end;

procedure TFrm_Principal.PedidoEmInclusaoEdicao(EmInclusao : Boolean);
begin
  btGravarPedido.Visible      := EmInclusao;
  pnPedido.Enabled            := EmInclusao;
  btConsultarPedido.Visible   := not(EmInclusao);
  btExcluirPedido.Visible     := not(EmInclusao);
end;

procedure TFrm_Principal.sbConsultaClienteClick(Sender: TObject);
begin
  DM.QyPesqCli.Open;
  if not DM.QyPesqCli.IsEmpty then
  begin
    Application.CreateForm(TFrm_Consulta,Frm_Consulta);
    Try
      Frm_Consulta.ds.DataSet := DM.QyPesqCli;
      Frm_Consulta.Caption    := 'Consultar Clientes';
      Frm_Consulta.ShowModal;
      if iCodRetorno <> 0 then
      begin
        ConsultarCliente(iCodRetorno);
        btConfCli.Enabled := True;
        btConfCli.SetFocus;
      end;
    Finally
      Frm_Consulta.Free;
      DM.QyPesqCli.Close;
    End;
  end
  else
  ShowMessage('Não existem clientes a serem consultado');
end;

procedure TFrm_Principal.sbConsultaProdutoClick(Sender: TObject);
begin
  DM.QyPesqProd.Open;
  if not DM.QyPesqProd.IsEmpty then
  begin
    Application.CreateForm(TFrm_Consulta,Frm_Consulta);
    Try
      Frm_Consulta.ds.DataSet := DM.QyPesqProd;
      Frm_Consulta.Caption    := 'Consultar Produto';
      Frm_Consulta.ShowModal;
      if iCodRetorno <> 0 then
      ConsultarProduto(iCodRetorno);
    Finally
      Frm_Consulta.Free;
      DM.QyPesqProd.Close;
    End;
  end
  else
  ShowMessage('Não existem clientes a serem consultado');
end;

function TFrm_Principal.ConsultarProduto(AID : Integer): Boolean;
var Produto : TProduto;
begin
  Produto := TProduto.Create;
  Try
    Produto.Codigo := AID;
    If Produto.ConsultarProduto then
    begin
      edCodProduto.Text       := Produto.Codigo.ToString;
      edDescricaoProduto.Text := Produto.Descricao;
      edPrecoTabela.Text      := FormatFloat('##0.00',TProduto.PrecoVenda);
      edPrecoVenda.Text       := edPrecoTabela.Text;
      edQuantPedida.Text      := '1';
      edPrecoVenda.SetFocus;
      edPrecoVenda.SelectAll;
      Result := True;
    end
    else
    begin
      ShowMessage('Produto não localizado');
      Result := False;
    end;
  Finally
    Produto.Free;
  End;
end;

procedure TFrm_Principal.dbgItensPedidoEnter(Sender: TObject);
var I : Integer;
begin
  Dica('Pressione Enter para editar um item ou Delete para excluir');
end;

procedure TFrm_Principal.dbgItensPedidoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = vk_delete then
  begin
    if Application.MessageBox('Confirma a exclusão do produto selecionado?','Exclusão',
       mb_YesNo+MB_ICONQUESTION+MB_DEFBUTTON2) = IDYES then
    begin
      CDSItem.Delete;
      AtualizaTotais;
    end;
  end;

  if Key = vk_return then
  begin
    bItemEdicao := True;
    CarregaItemEdicao(dbgItensPedido.Fields[6].Value);
    Dica('Ao fim da edição do item, pressione GRAVAR para salvar as alterações');
  end;
end;

procedure TFrm_Principal.CarregaItemEdicao(AID : Integer);
begin
  icontrole                 := AID;
  CDSItem.Filtered         := False;
  CDSItem.Filter           := '';
  CDSItem.Filter           := 'controle = '+ IntToStr(AID);
  CDSItem.Filtered         := True;
  edCodProduto.Text        := CDSItemCodProduto.AsString;
  edDescricaoProduto.Text  := CDSItemDescricaoProd.AsString;
  edPrecoTabela.Text       := CDSItemVlrUnitario.AsString;
  edPrecoVenda.Text        := CDSItemVlrTotal.AsString;
  edQuantPedida.OnChange   := nil;
  edQuantPedida.Text       := CDSItemQuantidade.AsString;
  edPrecoVenda.SetFocus;
  edPrecoVenda.SelectAll;
  edQuantPedida.OnChange   := edQuantPedidaChange;
end;

procedure TFrm_Principal.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  If Button = nbDelete then
  begin
    if Application.MessageBox('Confirma a exclusão do produto selecionado?','Exclusão',mb_YesNo+MB_ICONQUESTION+MB_DEFBUTTON2) = IDNo then
      Abort
    else
    begin
      AtualizaTotais;
    end;
  end;
end;

procedure TFrm_Principal.AtualizaTotais;
begin
  if CDSItemCalcVlrTotal.AsString <> '' then
  begin
    lbValorTotal.Caption      := CDSItemCalcVlrTotal.AsString;
    lbQuantidadeTotal.Caption := CDSItemCalcQuantidade.AsString;
    lbQuantidadeTotal2.Caption := lbQuantidadeTotal.Caption;
    lbValorTotal2.Caption       := lbValorTotal.Caption;

    imgVazio.Visible := False;
    imgCheio.Visible := True;
  end
  else
  begin
    lbValorTotal.Caption      := 'R$0,00';
    lbQuantidadeTotal.Caption := '000';
    lbQuantidadeTotal2.Caption := lbQuantidadeTotal.Caption;
    lbValorTotal2.Caption       := lbValorTotal.Caption;

    imgVazio.Visible := True;
    imgCheio.Visible := False;
  end;
end;

procedure TFrm_Principal.DBNavigator5BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  if Button = nbPost then
  begin
     GravarItens;
  end;
end;

procedure TFrm_Principal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if KEY = #13 then
  begin
    if PageControl1.ActivePageIndex = 0 then
    begin
      PageControl1.ActivePageIndex := 1;
      edCodCliente.SetFocus;

      imgVazio.Visible := True;
      imgCheio.Visible := False;
      Exit;
    end;

    SelectNext(ActiveControl, True, True);
    Key := #0;
  end;

  if KEY = #27  then
  begin
    if PageControl1.ActivePageIndex = 1 then
    begin
      if MessageDlg('Gostaria de cancelar a inclusão do pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        bCancelarPedido := True;
        ShowMessage('Inclusão cancelada.');
        LimparCampos;
        PageControl1.ActivePageIndex := 0;
        Exit;
      end;
    end;
  end;

end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
  PedidoEmInclusaoEdicao(False);
  btNovoPedido.Visible:= False;
  bPedidoEmAndamento   := False;
  btConfCli.Enabled   := True;
  bPedEdicao           := False;
  PageControl1.ActivePageIndex := 0;
  bCancelarPedido := False;
  Dica('');
end;

end.
