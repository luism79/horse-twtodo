unit User.Controller;

interface

uses
  Horse, IUser.Service;

type
  TUserController = class
  private
    class var FService: IUserService;
  public
    class procedure Post(AReq: THorseRequest; ARes: THorseResponse);
    class procedure GetByEmail(AReq: THorseRequest; ARes: THorseResponse);

    class property Service: IUserService read FService write FService;
  end;

implementation

uses
  System.SysUtils, System.JSON, System.JSON.Serializers, User.DTO, App.Utils, App.Response;

{ TUsuarioController }

class procedure TUserController.GetByEmail(AReq: THorseRequest;
  ARes: THorseResponse);
const
  HTTPStatusError: array[Boolean] of THTTPStatus = (THTTPStatus.BadRequest, THTTPStatus.NotFound);
var
  lEmail: string;
  lUsuario: TUserViewDTO;
  lResponse: TJSONObject;
  lFound: Boolean;
begin
  lFound := False;
  try
    lEmail := AReq.Params['e-mail'];

    lUsuario := FService.FindByEmail(lEmail);

    lFound := not lUsuario.Id.IsEmpty;

    if not lFound then
      raise Exception.Create('Registro não encontrado');

    lResponse := TAppUtils.ConvertRecordToJSON<TUserViewDTO>(lUsuario);

    ARes.Send<TJSONObject>(
      TAppResponse.Success('Usuário encontrado',
         lResponse
    ))
    .Status(THTTPStatus.OK);
  except
    on E: Exception do
      ARes.Send<TJSONObject>(
        TAppResponse.Error('Falha ao localizar o registro', TJSONPair.Create('error', E.Message)
      ))
      .Status(HTTPStatusError[lFound]);
  end;

end;

class procedure TUserController.Post(AReq: THorseRequest;
  ARes: THorseResponse);
var
  lInput: TUserDTO;
  lResponse: TJSONObject;
  lId: string;
begin
  try
    lInput := TJsonSerializer.Create
      .Deserialize<TUserDTO>(AReq.Body);

    lId := FService.Add(lInput);

    lResponse := TJSONObject.Create
      .AddPair(
        'id', lId
      );

    ARes.Send<TJSONObject>(
      TAppResponse.Success('Registro criado com sucesso', lResponse))
        .Status(THTTPStatus.Created);
  except
    on E: Exception do
      ARes.Send<TJSONObject>(
        TAppResponse.Error('Falha na inclusão', TJSONPair.Create('error', E.Message)
      ))
      .Status(THTTPStatus.BadRequest);
  end;
end;

end.
