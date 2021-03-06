unit CancelarItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmCancelarItem = class(TForm)
    Label1: TLabel;
    EdtIdItem: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCancelarItem: TFrmCancelarItem;
  estoque: double;
  quantidade : Double;




implementation

{$R *.dfm}

uses Modulo;

procedure TFrmCancelarItem.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  begin
      if key = 13 then
        begin
            if Trim(edtIdItem.Text) = '' then
            begin
               MessageDlg('Insira o C�digo do Item!', mtInformation, mbOKCancel, 0);
               edtIdItem.Text := '';
               edtIdItem.SetFocus;
               exit;
            end;

             //RECUPERAR A QUANTIDADE, VALOR e ID DO PRODUTO DO ITEM VENDIDO
             dm.query_coringa.Close;
             dm.query_coringa.SQL.Clear;
             dm.query_coringa.SQL.Add('SELECT * from detalhes_vendas where id = :id');
             dm.query_coringa.ParamByName('id').Value := edtIdItem.Text;
             dm.query_coringa.Open;

             if not dm.query_coringa.isEmpty then
               begin

                quantidade :=  dm.query_coringa['quantidade'];
                totalProdutos :=  dm.query_coringa['total'];
                idProduto := dm.query_coringa['id_produto'];

               end;

            //RECUPERAR O ESTOQUE DO PRODUTO EXCLUIDO
            dm.query_produtos.Close;
            dm.query_produtos.SQL.Clear;
            dm.query_produtos.SQL.Add('SELECT * from produtos where id = :id');
            dm.query_produtos.ParamByName('id').Value := idProduto;
            dm.query_produtos.Open;

             if not dm.query_produtos.isEmpty then
               begin
                estoque :=  dm.query_produtos['estoque'];
               end;

            //DEVOLVER  O PRODUTO PARA O ESTOQUE
             estoque := estoque + quantidade;

             dm.query_produtos.Close;
             dm.query_produtos.SQL.Clear;
             dm.query_produtos.SQL.Add('UPDATE produtos set estoque = :estoque where id = :id');
             dm.query_produtos.ParamByName('estoque').Value := estoque;

             dm.query_produtos.ParamByName('id').Value := idProduto;
             dm.query_produtos.ExecSQL;

             try
                 dm.query_coringa.Close;
                 dm.query_coringa.SQL.Clear;
                 dm.query_coringa.SQL.Add('DELETE from detalhes_vendas where id = :id');
                 dm.query_coringa.ParamByName('id').Value := edtIdItem.Text;
                 dm.query_coringa.ExecSQL;
                 close;

                 except
                 MessageDlg('C�digo do Produto Inv�lido!!', mtInformation, mbOKCancel, 0);
                 EdtIdItem.Text := '';
                 EdtIdItem.SetFocus;
                 exit;
             end;
        end;
  end;
end.
