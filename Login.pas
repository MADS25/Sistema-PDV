unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Buttons, Caixa;

type
  TFrmLogin = class(TForm)
    Panel1: TPanel;
    imgFundo: TImage;
    pnlLogin: TPanel;
    imgLogin: TImage;
    EdtUsuario: TEdit;
    EdtSenha: TEdit;
    btnLogin: TSpeedButton;
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure btnLoginClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure centralizarPainel;
    procedure login;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses Menu, Modulo;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
begin
    if Trim(EdtUsuario.Text) = '' then
    begin
      MessageDlg('Preencha o Usuário!', mtInformation, mbOKCancel, 0);
      EdtUsuario.SetFocus;
      exit;
    end;

    if Trim(EdtSenha.Text) = '' then
    begin
      MessageDlg('Preencha o Senha!', mtInformation, mbOKCancel, 0);
      EdtSenha.SetFocus;
      exit;
    end;

    login;
end;

procedure TFrmLogin.centralizarPainel;
begin
    pnlLogin.Top := (Self.Height div 2) - (pnlLogin.Height div 2);
    pnlLogin.Left := (Self.Width div 2) - (pnlLogin.Width div 2);
end;

procedure TFrmLogin.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  centralizarPainel;
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 13 then
   login;

end;

procedure TFrmLogin.login;
begin
  //Aqui codigo de Login


  dm.query_usuarios.Close;
  dm.query_usuarios.SQL.Clear;
  dm.query_usuarios.SQL.Add('SELECT * FROM usuarios WHERE usuario = :usuario and senha = :senha');
  dm.query_usuarios.ParamByName('usuario').Value := EdtUsuario.Text;
  dm.query_usuarios.ParamByName('senha').Value := EdtSenha.Text;
  dm.query_usuarios.Open;

  if not dm.query_usuarios.IsEmpty then
     begin
       nomeUsuario := dm.query_usuarios['usuario'];
       cargoUsuario := dm.query_usuarios['cargo'];

       //Verificar quem esta logando

       if cargoUsuario = 'Operador de Caixa' then
       begin
        FrmCaixa := TFrmCaixa.Create(FrmLogin);
        EdtSenha.Text := '';
        statusCaixa:= 'Abertura';
        FrmCaixa.ShowModal;
        exit
       end;

       FrmMenu := TFrmMenu.Create(FrmLogin);
       EdtSenha.Text := '';
       FrmMenu.ShowModal;
     end
     else
     Begin
        MessageDlg('Os dados estão incorretos!!', mtInformation, mbOKCancel, 0);
        EdtUsuario.Text := '';
        EdtSenha.Text := '';
        EdtUsuario.SetFocus;
     End;

end;


end.
