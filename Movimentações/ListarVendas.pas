unit ListarVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.StdCtrls,ACBrUtil, ACBrNFeNotasFiscais, pcnConversao, pcnConversaoNFe,
  ACBrNFSe, pcnNFe, pnfsConversao, System.Math, Vendas;

type
  TFrmListarVendas = class(TForm)
    Label3: TLabel;
    cbEntradaSaida: TComboBox;
    Label1: TLabel;
    dataInicial: TDateTimePicker;
    Label2: TLabel;
    dataFinal: TDateTimePicker;
    grid: TDBGrid;
    BtnCancelar: TSpeedButton;
    btnComprovante: TSpeedButton;
    btnNota: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure cbEntradaSaidaChange(Sender: TObject);
    procedure dataInicialChange(Sender: TObject);
    procedure dataFinalChange(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnComprovanteClick(Sender: TObject);
    procedure btnNotaClick(Sender: TObject);
  private
    { Private declarations }


    procedure buscarData;
  public
    { Public declarations }
  end;

var
  FrmListarVendas: TFrmListarVendas;
  idVenda : string;
  quantItem: integer;
  id_produto: integer;
  estoque : integer;
  estoqueP : integer;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmListaVendas }

procedure TFrmListarVendas.BtnCancelarClick(Sender: TObject);
begin
    if MessageDlg('Deseja Cancelar a venda?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
    dm.query_vendas.Close;
    dm.query_vendas.SQL.Clear;
    dm.query_vendas.SQL.Add('UPDATE vendas set status = :status where id = :id') ;

    dm.query_vendas.ParamByName('status').Value :=  'Cancelada';
    dm.query_vendas.ParamByName('id').Value :=  idVenda;
    dm.query_vendas.ExecSql;


   //DELETAR TAMBÉM NA TABELA DE MOVIMENTAÇÕES
    dm.query_mov.Close;
    dm.query_mov.SQL.Clear;
    dm.query_mov.SQL.Add('DELETE FROM movimentacoes where id_movimento = :id');
    dm.query_mov.ParamByName('id').Value := idVenda;
    dm.query_mov.ExecSQL;


    //DEVOLVER OS ITENS DA VENDA AO ESTOQUE
    dm.query_det_vendas.Close;
    dm.query_det_vendas.SQL.Clear;
    dm.query_det_vendas.SQL.Add('SELECT * from detalhes_vendas where id_venda = :id');
    dm.query_det_vendas.ParamByName('id').Value := idVenda;
    dm.query_det_vendas.Open;

    if not dm.query_det_vendas.isEmpty then
    begin
      while not dm.query_det_vendas.Eof do
      begin


         id_produto :=  dm.query_det_vendas['id_produto'];
         quantItem :=  dm.query_det_vendas['quantidade'];

       //ATUALIZAR O ESTOQUE

       //RECUPERAR O ESTOQUE ATUAL
         dm.query_produtos.Close;
         dm.query_produtos.SQL.Clear;
         dm.query_produtos.SQL.Add('select * from produtos where id = :id');
         dm.query_produtos.ParamByName('id').Value := id_produto;
         dm.query_produtos.Open;

      if not dm.query_produtos.isEmpty then
       begin
         estoqueP :=  dm.query_produtos['estoque'];

       end;

        estoque := estoqueP + quantItem;

        dm.query_produtos.Close;
        dm.query_produtos.SQL.Clear;
        dm.query_produtos.SQL.Add('UPDATE produtos set estoque = :estoque where id = :id');
        dm.query_produtos.ParamByName('estoque').Value := estoque;
        dm.query_produtos.ParamByName('id').Value := id_produto;
        dm.query_produtos.ExecSQL;

        dm.query_det_vendas.Next;
      end;
    end;
    MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);
 end;

  BtnCancelar.Enabled := false;
  btnNota.Enabled := false;
  btnComprovante.Enabled := false;
  buscarData;
end;

procedure TFrmListarVendas.btnComprovanteClick(Sender: TObject);
begin
      dm.query_vendas.Close;
      dm.query_vendas.SQL.Clear;
      dm.query_vendas.SQL.Add('SELECT * from vendas where id = :id');
      dm.query_vendas.ParamByName('id').Value := idVenda;
      dm.query_vendas.Open;

       dm.query_det_vendas.Close;
      dm.query_det_vendas.SQL.Clear;
      dm.query_det_vendas.SQL.Add('SELECT * from detalhes_vendas where id_venda = :id');
      dm.query_det_vendas.ParamByName('id').Value := idVenda;
      dm.query_det_vendas.Open;

      //Chamar o Relatório
      dm.rel_comprovante.LoadFromFile(GetCurrentDir + '\rel\comprovante.fr3');
      dm.rel_comprovante.ShowReport();
      //dm.rel_comprovante.Print;

      btnComprovante.Enabled := false;
      btnNota.Enabled := false;

      buscarData;
end;

procedure TFrmListarVendas.btnNotaClick(Sender: TObject);
Var
NotaF: NotaFiscal;
item : integer;
Produto: TDetCollectionItem;
InfoPgto: TpagCollectionItem;

begin

  btnComprovante.Enabled := false;
  btnNota.Enabled := false;


 FrmVendas.nfce.NotasFiscais.Clear;
 NotaF := FrmVendas.nfce.NotasFiscais.Add;


  //DADOS DA NOTA FISCAL

  NotaF.NFe.Ide.natOp     := 'VENDA';
  NotaF.NFe.Ide.indPag    := ipVista;
  NotaF.NFe.Ide.modelo    := 65;
  NotaF.NFe.Ide.serie     := 1;
  NotaF.NFe.Ide.nNF       := StrToInt(idVenda);
  NotaF.NFe.Ide.dEmi      := Date;
  NotaF.NFe.Ide.dSaiEnt   := Date;
  NotaF.NFe.Ide.hSaiEnt   := Now;
  NotaF.NFe.Ide.tpNF      := tnSaida;
  NotaF.NFe.Ide.tpEmis    := teNormal;
  NotaF.NFe.Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta variável quando for para ambiente de produção
  NotaF.NFe.Ide.verProc   := '1.0.0.0'; //Versão do seu sistema
  NotaF.NFe.Ide.cUF       := 31;    //CODIGO DA CIDADE
  NotaF.NFe.Ide.cMunFG    := 0624123;   //VOCE PRECISA ALTERAR DE ACORDO COM O CODIGO DE EMISSAO DE NFCE PARA SEU MUNICIPIO
  NotaF.NFe.Ide.finNFe    := fnNormal;


  //DADOS DO EMITENTE

  NotaF.NFe.Emit.CNPJCPF           := '18311776000198';
  NotaF.NFe.Emit.IE                := '';
  NotaF.NFe.Emit.xNome             := 'Q-Cursos Networks';
  NotaF.NFe.Emit.xFant             := 'Q-Cursos';

  NotaF.NFe.Emit.EnderEmit.fone    := '(31)3333-3333';
  NotaF.NFe.Emit.EnderEmit.CEP     := 30512660;
  NotaF.NFe.Emit.EnderEmit.xLgr    := 'Rua A';
  NotaF.NFe.Emit.EnderEmit.nro     := '325';
  NotaF.NFe.Emit.EnderEmit.xCpl    := '';
  NotaF.NFe.Emit.EnderEmit.xBairro := 'Santa Monica';
  NotaF.NFe.Emit.EnderEmit.cMun    := 0624123;
  NotaF.NFe.Emit.EnderEmit.xMun    := 'Belo Horizonte';
  NotaF.NFe.Emit.EnderEmit.UF      := 'MG';
  NotaF.NFe.Emit.enderEmit.cPais   := 1058;
  NotaF.NFe.Emit.enderEmit.xPais   := 'BRASIL';

  NotaF.NFe.Emit.IEST              := '';
 // NotaF.NFe.Emit.IM                := '2648800'; // Preencher no caso de existir serviços na nota
  //NotaF.NFe.Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se é permitido
                                // a inclusão de serviços na NFe
  NotaF.NFe.Emit.CRT               := crtSimplesNacional;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)



  //DADOS DO DESTINATÁRIO

  // NotaF.NFe.Dest.CNPJCPF           := '05481336000137';
  // NotaF.NFe.Dest.IE                := '687138770110';
  // NotaF.NFe.Dest.ISUF              := '';
  // NotaF.NFe.Dest.xNome             := 'D.J. COM. E LOCAÇÃO DE SOFTWARES LTDA - ME';

  //
  //  NotaF.NFe.Dest.EnderDest.Fone    := '1532599600';
  //  NotaF.NFe.Dest.EnderDest.CEP     := 18270170;
  //  NotaF.NFe.Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
  //  NotaF.NFe.Dest.EnderDest.nro     := '973';
  //  NotaF.NFe.Dest.EnderDest.xCpl    := '';
  //  NotaF.NFe.Dest.EnderDest.xBairro := 'Centro';
  //  NotaF.NFe.Dest.EnderDest.cMun    := 3554003;
  //  NotaF.NFe.Dest.EnderDest.xMun    := 'Tatui';
  //  NotaF.NFe.Dest.EnderDest.UF      := 'SP';
  //  NotaF.NFe.Dest.EnderDest.cPais   := 1058;
  //  NotaF.NFe.Dest.EnderDest.xPais   := 'BRASIL';



  //ITENS DA VENDA NA NOTA

  //RELACIONANDO OS ITENS COM A  VENDA
  item := 1;
  dm.query_det_vendas.Close;
  dm.query_det_vendas.SQL.Clear;
  dm.query_det_vendas.SQL.Add('select * from detalhes_vendas WHERE id_venda = :num order by id asc') ;
  dm.query_det_vendas.ParamByName('num').Value :=  idVenda;
  dm.query_det_vendas.Open;
   dm.query_det_vendas.First;

   while not dm.query_det_vendas.eof do
   begin
    Produto := NotaF.NFe.Det.New;
    Produto.Prod.nItem    := item; // Número sequencial, para cada item deve ser incrementado
    Produto.Prod.cProd    := '123456';
    Produto.Prod.cEAN     := '7896523206646';
    Produto.Prod.xProd    := dm.query_det_vendas.FieldByName('produto').Value;
    Produto.Prod.NCM      := '94051010'; // Tabela NCM disponível em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
    Produto.Prod.EXTIPI   := '';
    Produto.Prod.CFOP     := '5101';
    Produto.Prod.uCom     := 'UN';
    Produto.Prod.qCom     := dm.query_det_vendas.FieldByName('quantidade').Value;
    Produto.Prod.vUnCom   := dm.query_det_vendas.FieldByName('valor').Value;
    Produto.Prod.vProd    := dm.query_det_vendas.FieldByName('total').Value;


    //INFORMAÇÕES DE IMPOSTOS SOBRE OS PRODUTOS
    Produto.Prod.cEANTrib  := '7896523206646';
    Produto.Prod.uTrib     := 'UN';
    Produto.Prod.qTrib     := 1;
    Produto.Prod.vUnTrib   := 100;

    Produto.Prod.vOutro    := 0;
    Produto.Prod.vFrete    := 0;
    Produto.Prod.vSeg      := 0;
    Produto.Prod.vDesc     := 0;

    Produto.Prod.CEST := '1111111';

    Produto.infAdProd := 'Informacao Adicional do Produto';


     // lei da transparencia nos impostos
    Produto.Imposto.vTotTrib := 0;
    Produto.Imposto.ICMS.CST          := cst00;
    Produto.Imposto.ICMS.orig    := oeNacional;
    Produto.Imposto.ICMS.modBC   := dbiValorOperacao;
    Produto.Imposto.ICMS.vBC     := 100;
    Produto.Imposto.ICMS.pICMS   := 18;
    Produto.Imposto.ICMS.vICMS   := 18;
    Produto.Imposto.ICMS.modBCST := dbisMargemValorAgregado;
    Produto.Imposto.ICMS.pMVAST  := 0;
    Produto.Imposto.ICMS.pRedBCST:= 0;
    Produto.Imposto.ICMS.vBCST   := 0;
    Produto.Imposto.ICMS.pICMSST := 0;
    Produto.Imposto.ICMS.vICMSST := 0;
    Produto.Imposto.ICMS.pRedBC  := 0;

         // partilha do ICMS e fundo de probreza
    Produto.Imposto.ICMSUFDest.vBCUFDest      := 0.00;
    Produto.Imposto.ICMSUFDest.pFCPUFDest     := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSUFDest    := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSInter     := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSInterPart := 0.00;
    Produto.Imposto.ICMSUFDest.vFCPUFDest     := 0.00;
    Produto.Imposto.ICMSUFDest.vICMSUFDest    := 0.00;
    Produto.Imposto.ICMSUFDest.vICMSUFRemet   := 0.00;



    item := item + 1;
    dm.query_det_vendas.Next;
   end;

   //totalizando




    NotaF.NFe.Total.ICMSTot.vBC     := 100;
  NotaF.NFe.Total.ICMSTot.vICMS   := 18;
  NotaF.NFe.Total.ICMSTot.vBCST   := 0;
  NotaF.NFe.Total.ICMSTot.vST     := 0;
  NotaF.NFe.Total.ICMSTot.vProd   := totalVenda;
  NotaF.NFe.Total.ICMSTot.vFrete  := 0;
  NotaF.NFe.Total.ICMSTot.vSeg    := 0;
  //NotaF.NFe.Total.ICMSTot.vDesc   := strToFloat(edtDesconto.Text);
  NotaF.NFe.Total.ICMSTot.vII     := 0;
  NotaF.NFe.Total.ICMSTot.vIPI    := 0;
  NotaF.NFe.Total.ICMSTot.vPIS    := 0;
  NotaF.NFe.Total.ICMSTot.vCOFINS := 0;
  NotaF.NFe.Total.ICMSTot.vOutro  := 0;
  NotaF.NFe.Total.ICMSTot.vNF     := totalcomDesconto;

    // lei da transparencia de impostos
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // partilha do icms e fundo de probreza
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;


  NotaF.NFe.Transp.modFrete := mfSemFrete;  //SEM FRETE

  // YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag := ipVista;
  InfoPgto.tPag   := fpDinheiro;
  InfoPgto.vPag   := totalcomDesconto;

  //RECUPERAR O NUMERO DE SERIE DO CERTIFICADO
  FrmVendas.nfce.Configuracoes.Certificados.NumeroSerie := certificadoDig;

  FrmVendas.nfce.NotasFiscais.Assinar;
  FrmVendas.nfce.Enviar(Integer(idVenda));
  ShowMessage(FrmVendas.nfce.WebServices.StatusServico.Msg);
end;

procedure TFrmListarVendas.buscarData;
begin

  dm.query_vendas.Close;
  dm.query_vendas.SQL.Clear;
  dm.query_vendas.SQL.Add('select * from vendas where data >= :dataInicial and data <= :dataFinal and status = :status order by id desc');
  dm.query_vendas.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  dm.query_vendas.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  dm.query_vendas.ParamByName('status').Value :=  cbEntradaSaida.Text;
  dm.query_vendas.Open;
end;


procedure TFrmListarVendas.cbEntradaSaidaChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmListarVendas.dataFinalChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmListarVendas.dataInicialChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmListarVendas.FormShow(Sender: TObject);
begin
  cbEntradaSaida.ItemIndex := 0;
  dm.tb_vendas.Active := True;
  dataInicial.Date := Date;
  dataFinal.Date := Date;
  buscarData;
end;

procedure TFrmListarVendas.gridCellClick(Column: TColumn);
begin
  BtnCancelar.Enabled := true;
  btnNota.Enabled := true;
  btnComprovante.Enabled := true;
  idVenda := dm.query_vendas.FieldByName('id').Value;
end;

end.
