unit EstoqueBaixo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFrmEstoqueBaixo = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure listar;
  public
    { Public declarations }
  end;

var
  FrmEstoqueBaixo: TFrmEstoqueBaixo;

implementation

{$R *.dfm}

uses Modulo, EntradasProdutos;

procedure TFrmEstoqueBaixo.listar;
begin
  dm.query_produtos.Close;
  dm.query_produtos.SQL.Clear;
  dm.query_produtos.SQL.Add('SELECT * FROM produtos WHERE estoque <= 10');
  dm.query_produtos.Open;
end;

procedure TFrmEstoqueBaixo.DBGrid1DblClick(Sender: TObject);
begin
  idProduto      := dm.query_produtos.FieldByName('id').Value;
  nomeProduto    := dm.query_produtos.FieldByName('nome').Value;
  estoqueProduto := dm.query_produtos.FieldByName('estoque').Value;
  chamada := 'Ent';
  FrmEntradaProdutos := TFrmEntradaProdutos.Create(self);
  FrmEntradaProdutos.Show;
end;

procedure TFrmEstoqueBaixo.FormActivate(Sender: TObject);
begin
  listar;
end;

procedure TFrmEstoqueBaixo.FormShow(Sender: TObject);
begin
  listar;
end;

end.
