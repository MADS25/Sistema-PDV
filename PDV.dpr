program PDV;

uses
  Vcl.Forms,
  Login in 'Login.pas' {FrmLogin},
  Menu in 'Menu.pas' {FrmMenu},
  Usuarios in 'Cadastros\Usuarios.pas' {FrmUsuarios},
  Funcionarios in 'Cadastros\Funcionarios.pas' {FrmFuncionarios},
  Cargos in 'Cadastros\Cargos.pas' {FrmCargos},
  Modulo in 'Modulo.pas' {dm: TDataModule},
  Fornecedores in 'Cadastros\Fornecedores.pas' {FrmFornecedores},
  ImprimirBarras in 'Cadastros\ImprimirBarras.pas' {FrmImprimirBarras},
  Produtos in 'Cadastros\Produtos.pas' {FrmProdutos},
  EntradasProdutos in 'Estoque\EntradasProdutos.pas' {FrmEntradaProdutos},
  SaidasProdutos in 'Estoque\SaidasProdutos.pas' {FrmSaidaProdutos},
  EstoqueBaixo in 'Estoque\EstoqueBaixo.pas' {FrmEstoqueBaixo},
  Vendas in 'Movimentações\Vendas.pas' {FrmVendas},
  CancelarItem in 'Movimentações\CancelarItem.pas' {FrmCancelarItem},
  Movimentacoes in 'Movimentações\Movimentacoes.pas' {FrmMovimentacoes},
  Gastos in 'Movimentações\Gastos.pas' {FrmGastos},
  ListarVendas in 'Movimentações\ListarVendas.pas' {FrmListarVendas},
  PagamentoFuncionario in 'Movimentações\PagamentoFuncionario.pas' {FrmPagamentoFuncionario},
  CertificadoDigital in 'Movimentações\CertificadoDigital.pas' {FrmCertificado},
  Caixa in 'Movimentações\Caixa.pas' {FrmCaixa},
  FluxoCaixa in 'Movimentações\FluxoCaixa.pas' {FrmFluxoCaixa},
  RelatoriosPorDatas in 'Relatórios\RelatoriosPorDatas.pas' {FrmRelDatas},
  ExcluirDados in 'Ferramentas\ExcluirDados.pas' {FrmExcluirDados};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmImprimirBarras, FrmImprimirBarras);
  Application.CreateForm(TFrmProdutos, FrmProdutos);
  Application.CreateForm(TFrmEntradaProdutos, FrmEntradaProdutos);
  Application.CreateForm(TFrmSaidaProdutos, FrmSaidaProdutos);
  Application.CreateForm(TFrmEstoqueBaixo, FrmEstoqueBaixo);
  Application.CreateForm(TFrmVendas, FrmVendas);
  Application.CreateForm(TFrmCancelarItem, FrmCancelarItem);
  Application.CreateForm(TFrmMovimentacoes, FrmMovimentacoes);
  Application.CreateForm(TFrmGastos, FrmGastos);
  Application.CreateForm(TFrmListarVendas, FrmListarVendas);
  Application.CreateForm(TFrmPagamentoFuncionario, FrmPagamentoFuncionario);
  Application.CreateForm(TFrmCertificado, FrmCertificado);
  Application.CreateForm(TFrmCaixa, FrmCaixa);
  Application.CreateForm(TFrmFluxoCaixa, FrmFluxoCaixa);
  Application.CreateForm(TFrmRelDatas, FrmRelDatas);
  Application.CreateForm(TFrmExcluirDados, FrmExcluirDados);
  Application.Run;
end.
