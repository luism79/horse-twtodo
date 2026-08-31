unit Auth.Service;

interface

uses
  IAuth.Service, IUser.Service, Config.JWT, Auth.DTO, User.DTO;

type
  TAuthService = class(TInterfacedObject, IAuthService)
  private
    FUserService: IUserService;
    FConfig: TConfigJWT;

    procedure ValidateLogin(AUserAuth: TAuthDTO); overload;
    function ValidateLogin(AUserAuth: TAuthDTO; AUser: TUserDTO): Boolean; overload;
  public
    constructor Create(AConfig: TConfigJWT; AUserService: IUserService);

    function GenerateToken(const AUserMail: string): string;
    function Login(var AUser: TAuthDTO): Boolean;
    function ValidToken(const AToken: string): Boolean;
  end;

implementation

uses
  System.SysUtils, System.JSON, Jose.Core.JWT, Jose.Core.JWS, JOSE.Core.JWK, JOSE.Core.JWA, Jose.Types.JSON,
  JOSE.Types.Bytes, JOSE.Core.Builder, System.DateUtils, App.Utils, System.StrUtils;

{ TAuthService }

constructor TAuthService.Create(AConfig: TConfigJWT; AUserService: IUserService);
begin
  FUserService := AUserService;
  FConfig := AConfig;
end;

function TAuthService.GenerateToken(const AUserMail: string): string;
var
  lJwtToken: TJWT;
  lKey: TJWK;
  lSigner: TJWS;
begin
  lJwtToken := TJWT.Create;
  try
    lJwtToken.Claims.Subject := AUserMail;
    lJwtToken.Claims.IssuedAt := Now;
    lJwtToken.Claims.Issuer := FConfig.Issuer;
    lJwtToken.Claims.Expiration := IncMinute(Now, FConfig.TokenExpiration);

    lKey := TJWK.Create(FConfig.JWTKey);
    lSigner := TJWS.Create(lJwtToken);
    try
      lSigner.SkipKeyValidation := True;
      lSigner.Sign(lKey, TJOSEAlgorithmId.HS256);

      Result := lSigner.CompactToken;
    finally
      FreeAndNil(lKey);
      FreeAndNil(lSigner);
    end;
  finally
    FreeAndNil(lJwtToken);
  end;  // try
end;

function TAuthService.Login(var AUser: TAuthDTO): Boolean;
var
  lUser: TUserDTO;
begin
  try
    //***************************************************************//
    //* Atenção: ValidateLogin não deve retornar StatusCode 500     *//
    //*          Para que isso não ocorra, o resultado deve         *//
    //*          retornar True                                      *//
    //***************************************************************//
    ValidateLogin(AUser);
  except
    on E: Exception do
    begin
      AUser.MsgAuth := E.Message;
      Exit(True);
    end;
  end;
  lUser := FUserService.Login(AUser.Email);

  AUser.Id := lUser.Id;
  AUser.IsLoggedIn := ValidateLogin(AUser, lUser);
  if not AUser.IsLoggedIn then
    AUser.MsgAuth := 'Verificar! Usuário ou senha inválidos';
  Result := True;

end;

function TAuthService.ValidateLogin(AUserAuth: TAuthDTO; AUser: TUserDTO): Boolean;
begin
  Result := not AUser.Id.IsEmpty
            and SameText(TAppUtils.ConvertTextToHash(AUserAuth.Password), AUser.Password);
end;

procedure TAuthService.ValidateLogin(AUserAuth: TAuthDTO);
var
  sMsg: string;
begin
  sMsg := '';
  if AUserAuth.Email.IsEmpty then
    sMsg := 'o e-mail';

  if AUserAuth.Password.IsEmpty then
    sMsg := IfThen(sMsg.IsEmpty, 'a senha', Format('%s/senha', [sMsg]));

  if not sMsg.IsEmpty then
    raise Exception.CreateFmt('Informar %s para continuar', [sMsg]);
end;

function TAuthService.ValidToken(const AToken: string): Boolean;
var
  lJwt: TJWT;
begin
  lJwt := TJOSE.Verify(FConfig.JWTKey, AToken);
  try
    if not Assigned(lJwt) then
      raise Exception.Create('Token não informado ou corrompido');

    Result := lJwt.Verified;
    if not Result then
      raise Exception.Create('Assinatura do token inválida');

  finally
    FreeAndNil(lJwt);
  end;
end;

end.
