unit Login.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Custom.View, Vcl.ExtCtrls, Vcl.StdCtrls, crStaticText, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxCoreGraphics, cxTextEdit, cxMaskEdit, cxButtonEdit,
  System.ImageList, Vcl.ImgList, IAuth.Service, Login.DTO, Vcl.Buttons;

type
  TfrmLogin = class(TfrmCustomView)
    lblHeaderSubTitle: TLabel;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblPassword: TLabel;
    edtPassword: TcxButtonEdit;
    ilPassword: TImageList;
    pnlFooter: TPanel;
    btnConfirm: TcrStaticText;
    btnCancel: TcrStaticText;
    edtErrorMsg: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure edtPasswordPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure btnConfirmClick(Sender: TObject);
  private
    { Private declarations }
    FService: IAuthService;

    procedure ResetData;
    procedure ResetError;
    procedure SetGlyphPassword(const Show: Boolean);
    procedure SetServive(AService: IAuthService);
  public
    { Public declarations }

    property Service: IAuthService read FService;
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  App.Win;

const
  MSG_ERROR_SERVICE = 'Não foi instanciado o serviço de autenticação';

{$R *.dfm}

procedure TfrmLogin.btnConfirmClick(Sender: TObject);

  function _loginInput: TLoginInputDTO;
  begin
    Result.Email := edtEmail.Text;
    Result.Password := edtPassword.Text;
  end;

begin
  ResetError;
  try
    if not Assigned(FService) then
      raise Exception.Create(MSG_ERROR_SERVICE);

    FService.Login(_loginInput);
    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      edtErrorMsg.Text := E.Message;
      ActiveControl := edtEmail;
    end;
  end;
end;

procedure TfrmLogin.edtPasswordPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  SetGlyphPassword(edtPassword.Tag = 1);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  SetServive(TAppWin.AuthService);
  ResetData;
end;

procedure TfrmLogin.ResetData;
begin
  edtEmail.Clear;
  edtPassword.Clear;
  SetGlyphPassword(False);
  ResetError;
end;

procedure TfrmLogin.ResetError;
begin
  edtErrorMsg.Clear;
end;

procedure TfrmLogin.SetGlyphPassword(const Show: Boolean);
const
  ImgIndex: array[Boolean] of Integer = (0, 1);
  EditMode: array[Boolean] of TcxEditEchoMode = (eemPassword, eemNormal);
begin
  edtPassword.Properties.Buttons.Items[0].ImageIndex := ImgIndex[Show];
  edtPassword.Properties.EchoMode := EditMode[Show];
  edtPassword.Tag := Integer(not Show);
end;

procedure TfrmLogin.SetServive(AService: IAuthService);
begin
  if not Assigned(AService) then
    raise Exception.Create(MSG_ERROR_SERVICE);

  FService := AService;
end;

end.
