unit Auth.Service;

interface

uses
  System.Classes, System.SysUtils, System.JSON, Custom.Service, IAuth.Service, Params.Model, Login.DTO;

type
  TAuthService = class(TCustomService, IAuthService)
  private
    FLogin: TLoginDTO;

    function GetExpirationDateTime: TDateTime;
    function GetUserId: string;
    function GetLoggedIn: Boolean;
    function GetLoggedEmail: string;
    function GetToken: string;
    function GetTokenValid: Boolean;
    procedure SetLogin(AJson: TJSONObject);
  protected

  public
    constructor Create(AParams: TParamsModel); override;

    function Login(const ALogin: TLoginInputDTO): Boolean;
    procedure Logout;

    property UserId: string read GetUserId;
    property IsLoggedIn: Boolean read GetLoggedIn;
    property IsTokenValid: Boolean read GetTokenValid;
    property LoggedEmail: string read GetLoggedEmail;
    property Token: string read GetToken;
  end;

implementation

uses
  System.DateUtils, System.Net.URLClient, System.Net.HttpClient, App.Utils;

{ TAuthService }

constructor TAuthService.Create(AParams: TParamsModel);
begin
  FRoute := '/auth';

  inherited Create(AParams);
end;

function TAuthService.GetUserId: string;
begin
  Result := FLogin.user_id;
end;

function TAuthService.GetExpirationDateTime: TDateTime;
const
  EXPIRATION_SAFETY_MARGIN_MINUTES = 1;
begin
  Result := IncMinute(FLogin.LoggedAt, FLogin.ExpiresInMinutes - EXPIRATION_SAFETY_MARGIN_MINUTES);
end;

function TAuthService.GetLoggedEmail: string;
begin
  Result := FLogin.Email;
end;

function TAuthService.GetLoggedIn: Boolean;
begin
  Result := FLogin.IsLoggedIn;
end;

function TAuthService.GetToken: string;
begin
  Result := FLogin.TokenAcess;
end;

function TAuthService.GetTokenValid: Boolean;
begin
  if not FLogin.IsLoggedIn or
     FLogin.TokenAcess.Trim.IsEmpty or
     (FLogin.LoggedAt = 0) then
    Exit(False);

  Result := Now < GetExpirationDateTime;
end;

function TAuthService.Login(const ALogin: TLoginInputDTO): Boolean;
var
  lRequestJSON: TJSONObject;
  lJson: TJSONObject;
  lBody: TStringStream;
  lResponse: IHTTPResponse;
begin
  ResetStatemant;

  lRequestJSON := TAppUtils.ConvertRecordToJSON<TLoginInputDTO>(ALogin);
  lBody := RequestBody(lRequestJSON);
  try
    lResponse := Http.Post(
      PathUrl,
      lBody,
      nil,
      Headers
    );

    if not (lResponse.StatusCode in [200]) then
      raise ExceptionApiService(lResponse);

    lJson := TJSONObject.ParseJSONValue(lResponse.ContentAsString) as TJSONObject;

    SetLogin(lJson.AddPair('e-mail', ALogin.Email));
  finally
    Result := FLogin.IsLoggedIn;
  end;
end;

procedure TAuthService.Logout;
begin
  FLogin := Default(TLoginDTO);
end;

procedure TAuthService.SetLogin(AJson: TJSONObject);
begin
  AJson.TryGetValue<Boolean>('success', FLogin.IsLoggedIn);
  if FLogin.IsLoggedIn then
    FLogin.LoggedAt := Now;
  AJson.TryGetValue<string>('e-mail', FLogin.Email);
  AJson.TryGetValue<string>('data.user_id', FLogin.user_id);
  AJson.TryGetValue<string>('data.access_token', FLogin.TokenAcess);
  AJson.TryGetValue<Integer>('data.expires_in_minutes', FLogin.ExpiresInMinutes);
end;

end.
