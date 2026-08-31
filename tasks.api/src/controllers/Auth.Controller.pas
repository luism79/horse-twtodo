unit Auth.Controller;

interface

uses
  Horse, IAuth.Service;

type
  TAuthController = class
  private
    class var FService: IAuthService;
  public
    class procedure Post(AReq: THorseRequest; ARes: THorseResponse);

    class property Service: IAuthService read FService write FService;
  end;

implementation

uses
  System.SysUtils, System.JSON, System.JSON.Serializers, App.Console, App.Utils, App.Response, Auth.DTO;

{ TAuthController }

class procedure TAuthController.Post(AReq: THorseRequest; ARes: THorseResponse);
const
  HTTPStatusError: array[Boolean] of THTTPStatus = (THTTPStatus.InternalServerError, THTTPStatus.Unauthorized);
var
  lInput: TAuthDTO;
  lExec: Boolean;
  lToken: string;
begin
  lExec := False;
  try
    try
      lInput := TJsonSerializer
        .Create
        .Deserialize<TAuthDTO>(AReq.Body);
    except
      on E: Exception do
      begin
        lExec := True;
        raise Exception.Create('Formato Json inválido');
      end;
    end;

    lExec := FService.Login(lInput);

    if lExec and not lInput.IsLoggedIn then
      raise Exception.Create(lInput.MsgAuth);

    lToken := FService.GenerateToken(lInput.Email);

    ARes.Send<TJSONObject>(
      TAppResponse.Success('Autenticação realizada com sucesso',
        TJSONObject.Create
          .AddPair('user_id', lInput.Id)
          .AddPair('access_token', lToken)
          .AddPair('expires_in_minutes', TJSONNumber.Create(TAppConsole.HorseParams.TokenExpiration))
        ))
        .Status(THTTPStatus.OK);
  except
    on E: Exception do
    begin
      ARes.Send<TJSONObject>(
        TAppResponse.Error('Falha na atenticação', TJSONPair.Create('error', E.Message)
      ))
      .Status(HTTPStatusError[lExec]);
    end;
  end;
end;

end.
