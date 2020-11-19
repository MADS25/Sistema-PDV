unit ImprimirBarras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TFrmImprimirBarras = class(TForm)
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    img5: TImage;
    img6: TImage;
    img7: TImage;
    img8: TImage;
    img9: TImage;
    img10: TImage;
    PrintDialog1: TPrintDialog;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
      procedure GerarCodigo(codigo: string; canvas: TCanvas);
  public
    { Public declarations }
  end;

var
  FrmImprimirBarras: TFrmImprimirBarras;

implementation

{$R *.dfm}

uses Modulo;



procedure TFrmImprimirBarras.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 13 then
   begin
     if(PrintDialog1.Execute) then
      begin
        Print;
      end;
   end;

end;

procedure TFrmImprimirBarras.FormShow(Sender: TObject);
begin
  GerarCodigo(codigoProduto, img1.Canvas);
  GerarCodigo(codigoProduto, img2.Canvas);
  GerarCodigo(codigoProduto, img3.Canvas);
  GerarCodigo(codigoProduto, img4.Canvas);
  GerarCodigo(codigoProduto, img5.Canvas);
  GerarCodigo(codigoProduto, img6.Canvas);
  GerarCodigo(codigoProduto, img7.Canvas);
  GerarCodigo(codigoProduto, img8.Canvas);
  GerarCodigo(codigoProduto, img9.Canvas);
  GerarCodigo(codigoProduto, img10.Canvas);
end;

procedure TFrmImprimirBarras.GerarCodigo(codigo: string; canvas: TCanvas);
const
  digitos : array['0'..'9'] of string[5]= ('00110', '10001', '01001', '11000',
  '00101', '10100', '01100', '00011', '10010', '01010');
  var s : string;
  i, j, x, t : Integer;
begin
  // Gerar o valor para desenhar o código de barras
  // Caracter de início
  s := '0000';
  for i := 1 to length(codigo) div 2 do
  for j := 1 to 5 do
  s := s + Copy(Digitos[codigo[i * 2 - 1]], j, 1) + Copy(Digitos[codigo[i * 2]], j, 1);
  // Caracter de fim
  s := s + '100';
  // Desenhar em um objeto canvas
  // Configurar os parâmetros iniciais
  x := 0;
  // Pintar o fundo do código de branco
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clWhite;
  Canvas.Rectangle(0,0, 2000, 79);
  // Definir as cores da caneta
  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := clBlack;
  // Escrever o código de barras no canvas
  for i := 1 to length(s) do
    begin
    // Definir a espessura da barra
    t := strToInt(s[i]) * 2 + 1;
    // Imprimir apenas barra sim barra não (preto/branco - intercalado);
    if i mod 2 = 1 then
    Canvas.Rectangle(x, 0, x + t, 79);
    // Passar para a próxima barra
    x := x + t;
    end;
end;

end.
