unit PagamentoFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmPagamentoFuncionario = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    BtnExcluir: TSpeedButton;
    Label3: TLabel;
    btnBuscarFun: TSpeedButton;
    EdtFuncionario: TEdit;
    grid: TDBGrid;
    edtValor: TEdit;
    dataBuscar: TDateTimePicker;
    Label4: TLabel;
    EdtMotivo: TEdit;

    procedure btnNovoClick(Sender: TObject);
    procedure btnBuscarFunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);


    procedure BtnExcluirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
  private
    procedure associarCampos;
    procedure listar;
    procedure limpar;
    //procedure buscarData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPagamentoFuncionario: TFrmPagamentoFuncionario;
    idPagamento : string;
implementation

{$R *.dfm}

uses Funcionarios, Modulo;

procedure TFrmPagamentoFuncionario.limpar;
begin
  EdtFuncionario.Text := '';
    EdtFuncionario.Enabled := false;
    edtMotivo.Text := '';
    edtMotivo.Enabled := false;
    edtValor.Text := '';
    edtValor.Enabled := false;
    btnSalvar.Enabled := false;
end;

procedure TFrmPagamentoFuncionario.btnBuscarFunClick(Sender: TObject);
begin
  chamada := 'Func';
  FrmFuncionarios := TFrmFuncionarios.Create(self);
  FrmFuncionarios.Show;
end;

procedure TFrmPagamentoFuncionario.BtnExcluirClick(Sender: TObject);
begin
 if MessageDlg('Deseja Excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      dm.tb_pagaFun.Delete;
    //DELETAR TAMBÉM NA TABELA DE MOVIMENTAÇÕES
        dm.query_mov.Close;
        dm.query_mov.SQL.Clear;
        dm.query_mov.SQL.Add('DELETE FROM movimentacoes where id_movimento = :id');
        dm.query_mov.ParamByName('id').Value := idPagamento;
        dm.query_mov.ExecSQL;

       MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);
       listar;

       BtnExcluir.Enabled := false;
       edtMotivo.Text := '';
       edtValor.Text  := '';
       EdtFuncionario.Text := '';
    end;
end;

procedure TFrmPagamentoFuncionario.btnNovoClick(Sender: TObject);
begin
  btnSalvar.Enabled := true;
  btnBuscarFun.Enabled := true;
  edtMotivo.Enabled := true;
  EdtFuncionario.Enabled := true;
  edtValor.Enabled := true;
  edtMotivo.Text := '';
  edtMotivo.SetFocus;
  dm.tb_pagaFun.Insert;
end;

procedure TFrmPagamentoFuncionario.btnSalvarClick(Sender: TObject);
begin
    if Trim(EdtMotivo.Text) = '' then
     begin
       MessageDlg('Preencha o Motivo!', mtInformation, mbOKCancel, 0);
       EdtMotivo.SetFocus;
       exit;
     end;

     if Trim(EdtValor.Text) = '' then
     begin
       MessageDlg('Preencha o Valor!', mtInformation, mbOKCancel, 0);
       EdtValor.SetFocus;
       exit;
     end;

    associarCampos;
    dm.tb_pagaFun.Post;

    //RECUPERAR O ID DO ULTIMO GASTO INSERIDO
    dm.query_pagafun.Close;
    dm.query_pagafun.SQL.Clear;
    dm.query_pagafun.SQL.Add('SELECT * from pagamento_funcionario order by id desc');
    dm.query_pagafun.Open;

     if not dm.query_pagafun.isEmpty then
     begin
       idPagamento :=  dm.query_pagafun['id'];
     end;


    //LANÇAR O VALOR DO GASTO NAS MOVIMENTAÇÕES
    dm.query_mov.Close;
    dm.query_mov.SQL.Clear;
    dm.query_mov.SQL.Add('INSERT INTO movimentacoes (tipo, movimento, valor, funcionario, data, id_movimento) VALUES (:tipo, :movimento, :valor, :funcionario, curDate(), :id_movimento)');
    dm.query_mov.ParamByName('tipo').Value := 'Saída';
    dm.query_mov.ParamByName('movimento').Value := 'Gasto';
    dm.query_mov.ParamByName('valor').Value := edtValor.Text;
    dm.query_mov.ParamByName('funcionario').Value := EdtFuncionario.Text;
    dm.query_mov.ParamByName('id_movimento').Value := idPagamento;
    dm.query_mov.ExecSQL;

    MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);
    limpar;
    listar;
    exit
end;


procedure TFrmPagamentoFuncionario.FormActivate(Sender: TObject);
begin
  EdtFuncionario.Text := nomeFunc;
end;

procedure TFrmPagamentoFuncionario.FormCreate(Sender: TObject);
begin
 dm.tb_pagaFun.Active := true;
 listar;
 limpar;
end;

procedure TFrmPagamentoFuncionario.gridCellClick(Column: TColumn);
begin
  btnExcluir.Enabled := true;
  idPagamento := dm.query_pagafun.FieldByName('id').Value;
end;

procedure TFrmPagamentoFuncionario.listar;
begin
 dm.query_pagafun.Close;
 dm.query_pagafun.SQL.Clear;
 dm.query_pagafun.SQL.Add('SELECT * from pagamento_funcionario order by data desc');
 dm.query_pagafun.Open;
end;

procedure TFrmPagamentoFuncionario.associarCampos;
begin
  dm.tb_pagaFun.FieldByName('motivo').Value := EdtMotivo.Text;
  dm.tb_pagaFun.FieldByName('valor').Value := EdtValor.Text;
  dm.tb_pagaFun.FieldByName('funcionario').Value := EdtFuncionario.Text;
  dm.tb_pagaFun.FieldByName('data').Value := DateToStr(Date);
end;


end.
