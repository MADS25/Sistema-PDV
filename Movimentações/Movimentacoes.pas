unit Movimentacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls;

type
  TFrmMovimentacoes = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTotal: TLabel;
    Label7: TLabel;
    lblVlrEntradas: TLabel;
    Label8: TLabel;
    lblVlrSaidas: TLabel;
    dataInicial: TDateTimePicker;
    gridVendas: TDBGrid;
    dataFinal: TDateTimePicker;
    cbEntradaSaida: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure cbEntradaSaidaChange(Sender: TObject);
    procedure dataInicialChange(Sender: TObject);
    procedure dataFinalChange(Sender: TObject);
  private
    { Private declarations }

     procedure buscarTudo;

    procedure buscarData;
    procedure totalizarEntradas;
    procedure totalizarSaidas;
    procedure totalizar;
    procedure formatarGrid;
  public
    { Public declarations }
  end;

var
  FrmMovimentacoes: TFrmMovimentacoes;
   TotEntradas: real;
  TotSaidas: real;

implementation

{$R *.dfm}

uses Modulo;

procedure TFrmMovimentacoes.buscarData;
begin

 totalizarEntradas;
totalizarSaidas;
totalizar;


 dm.query_mov.Close;
  dm.query_mov.SQL.Clear;
  if cbEntradaSaida.Text = 'Tudo' then
  begin
    dm.query_mov.SQL.Add('select * from movimentacoes where data >= :dataInicial and data <= :dataFinal order by id desc') ;
    end
    else
    begin
     dm.query_mov.SQL.Add('select * from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = :tipo order by id desc') ;
     dm.query_mov.ParamByName('tipo').Value :=  cbEntradaSaida.Text;
  end;


  dm.query_mov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
   dm.query_mov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  dm.query_mov.Open;
  formatarGrid;

end;

procedure TFrmMovimentacoes.buscarTudo;
begin
 totalizarEntradas;
    totalizarSaidas;
    totalizar;

   dm.query_mov.Close;
   dm.query_mov.SQL.Clear;
   dm.query_mov.SQL.Add('select * from movimentacoes WHERE data = curDate() order by id desc') ;
   dm.query_mov.Open;
   TFloatField( dm.query_mov.FieldByName('valor')).DisplayFormat:='R$ #,,,,0.00';
  formatarGrid;
end;

procedure TFrmMovimentacoes.cbEntradaSaidaChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmMovimentacoes.dataFinalChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmMovimentacoes.dataInicialChange(Sender: TObject);
begin
  buscarData;
end;

procedure TFrmMovimentacoes.formatarGrid;
begin
gridVendas.Columns.Items[0].FieldName := 'id';
gridVendas.Columns.Items[0].Title.Caption := 'Id';
gridVendas.Columns.Items[0].Visible := false;

gridVendas.Columns.Items[1].FieldName := 'tipo';
gridVendas.Columns.Items[1].Title.Caption := 'Tipo';

gridVendas.Columns.Items[2].FieldName := 'movimento';
gridVendas.Columns.Items[2].Title.Caption := 'Movimento';

gridVendas.Columns.Items[3].FieldName := 'valor';
gridVendas.Columns.Items[3].Title.Caption := 'Valor';

gridVendas.Columns.Items[4].FieldName := 'funcionario';
gridVendas.Columns.Items[4].Title.Caption := 'Funcion�rio';

gridVendas.Columns.Items[5].FieldName := 'data';
gridVendas.Columns.Items[5].Title.Caption := 'Data';

gridVendas.Columns.Items[6].Visible := false;
end;

procedure TFrmMovimentacoes.FormShow(Sender: TObject);
begin

lblVlrEntradas.Caption := FormatFloat('R$ #,,,,0.00', strToFloat(lblVlrEntradas.Caption));
lblVlrSaidas.Caption := FormatFloat('R$ #,,,,0.00', strToFloat(lblVlrSaidas.Caption));
lblTotal.Caption := FormatFloat('R$ #,,,,0.00', strToFloat(lblTotal.Caption));

cbEntradaSaida.ItemIndex := 0;

dm.tb_mov.Active := False;
dm.tb_mov.Active := True;



dataInicial.Date := Date;
dataFinal.Date := Date;

totalizarEntradas;
totalizarSaidas;
totalizar;
buscarTudo;
end;

procedure TFrmMovimentacoes.totalizar;
var
tot: real;
begin
tot := TotEntradas - TotSaidas;
if tot >= 0 then
begin
  lblTotal.Font.Color := clGreen;
  end
  else
  begin
  lblTotal.Font.Color := clRed;
end;

lblTotal.Caption := FormatFloat('R$ #,,,,0.00', tot);




end;

procedure TFrmMovimentacoes.totalizarEntradas;
var
tot: real;
begin
  dm.query_mov.Close;
  dm.query_mov.SQL.Clear;
  dm.query_mov.SQL.Add('select sum(valor) as total from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = "Entrada" ') ;
  dm.query_mov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  dm.query_mov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  dm.query_mov.Prepare;
  dm.query_mov.Open;
  tot := dm.query_mov.FieldByName('total').AsFloat;
  TotEntradas := tot;
  lblVlrEntradas.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

procedure TFrmMovimentacoes.totalizarSaidas;
var
tot: real;
begin
  dm.query_mov.Close;
  dm.query_mov.SQL.Clear;
  dm.query_mov.SQL.Add('select sum(valor) as total from movimentacoes where data >= :dataInicial and data <= :dataFinal and tipo = "Sa�da" ') ;
  dm.query_mov.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
  dm.query_mov.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
  dm.query_mov.Prepare;
  dm.query_mov.Open;
  tot := dm.query_mov.FieldByName('total').AsFloat;
  TotSaidas := tot;
  lblVlrSaidas.Caption := FormatFloat('R$ #,,,,0.00', tot);

end;

end.
