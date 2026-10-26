unit Task.Service;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections, Params.Model, Custom.Service,
  ITask.Service, IAuth.Service, Task.Model, Task.DTO;

type
  TTaskService = class(TCustomService, ITaskService)
  private
    FAuthService: IAuthService;

    function GetAuthService: IAuthService;
    procedure SetAutService(const Value: IAuthService);
  protected
    procedure PrepareHeaders; override;
    procedure PrepareQueryParams(AStrings: TStrings = nil); override;
  public
    constructor Create(AAuthService: IAuthService; AParams: TParamsModel); reintroduce;

    function Add(ATask: TTaskAddInputDTO): string;
    function FindAll(AQueryParams: TStrings): TObjectList<TCustomTaskModel>;
    function Remove(const AId: string): Boolean;
    function Update(ATask: TTaskUptInputDTO): Boolean;
    procedure ValidateAuthentication;

    property AuthService: IAuthService read GetAuthService;
  end;

implementation

uses
  System.Net.HttpClient, App.Utils, System.Net.URLClient, System.NetConsts, Custom.Exceptions;

const
  CLASS_TASK_NOT_FOUND = 'Tarefa não foi configurado';

{ TTaskService }

function TTaskService.Add(ATask: TTaskAddInputDTO): string;
var
  lResponse: IHTTPResponse;
  lBody: TStringStream;
  lJson: TJSONObject;
begin
  ValidateAuthentication;

  ResetStatemant;
  try
    lBody := RequestBody(TAppUtils.ConvertRecordToJSON<TTaskAddInputDTO>(ATask));

    lResponse := Http.Post(
      PathUrl,
      lBody,
      nil,
      Headers
    );
  finally
    FreeAndNil(lBody);
  end;

  if not (lResponse.StatusCode in [200, 201]) then
    raise ExceptionApiService(lResponse);

  lJson := TJSONObject.ParseJSONValue(lResponse.ContentAsString) as TJSONObject;
  try
    lJson.TryGetValue<string>('data.id', Result);
  finally
    FreeAndNil(lJson);
  end;
end;

constructor TTaskService.Create(AAuthService: IAuthService; AParams: TParamsModel);
begin
  SetAutService(AAuthService);
  FRoute := '/tasks';

  inherited Create(AParams);
end;

function TTaskService.FindAll(AQueryParams: TStrings): TObjectList<TCustomTaskModel>;
var
  lResponse: IHTTPResponse;
  lJson: TJSONObject;
  lDataArray: TJSONArray;
begin
  ValidateAuthentication;
  ResetStatemant;
  PrepareQueryParams(AQueryParams);

  lResponse := Http.Get(
    PathUrl(GeQueryParamsAsUrl),
    nil,
    Headers
  );

  if not (lResponse.StatusCode in [200, 201]) then
    raise ExceptionApiService(lResponse);

  lJson := TJSONObject.ParseJSONValue(lResponse.ContentAsString) as TJSONObject;
  try
    lJson.TryGetValue<TJSONArray>('data', lDataArray);
    Result := TAppUtils.ConvertJSONArrayToList<TCustomTaskModel>(lDataArray);
  finally
    FreeAndNil(lJson);
  end;
end;

function TTaskService.GetAuthService: IAuthService;
begin
  if not Assigned(FAuthService) then
    Exit(nil);

  Result := FAuthService;
end;

procedure TTaskService.PrepareHeaders;
begin
  inherited PrepareHeaders;
  Headers := Headers + [
    TNameValuePair.Create('Authorization', 'Bearer ' + FAuthService.Token),
    TNameValuePair.Create('Accept', Http.ContentType)
  ];
end;

procedure TTaskService.PrepareQueryParams(AStrings: TStrings);
begin
  if Assigned(AStrings) then
    FQueryParams.AddStrings(AStrings);
end;

function TTaskService.Remove(const AId: string): Boolean;
var
  lResponse: IHTTPResponse;
begin
  ValidateAuthentication;
  if AId.Trim.IsEmpty then
    raise Exception.Create('Identificador da tarefa não foi informado');

  ResetStatemant;
  lResponse := Http.Delete(
    PathUrl(AId),
    nil,
    Headers
  );

  if lResponse.StatusCode <> 200 then
    raise ExceptionApiService(lResponse);

  Result := True;
end;

procedure TTaskService.SetAutService(const Value: IAuthService);
begin
  if not Assigned(Value) then
    raise EArgumentException.Create('Serviço de autenticação não foi configurado');

  FAuthService := Value;
end;

function TTaskService.Update(ATask: TTaskUptInputDTO): Boolean;
var
  lResponse: IHTTPResponse;
  lBody: TStringStream;
  lJson: TJSONObject;
begin
  ValidateAuthentication;

  ResetStatemant;
  try
    lBody := RequestBody(TAppUtils.ConvertRecordToJSON<TTaskUptInputDTO>(ATask));

    lResponse := Http.Put(
      PathUrl(ATask.Id),
      lBody,
      nil,
      Headers
    );
  finally
    FreeAndNil(lBody);
  end;

  if not (lResponse.StatusCode in [200, 201]) then
    raise ExceptionApiService(lResponse);

  lJson := TJSONObject.ParseJSONValue(lResponse.ContentAsString) as TJSONObject;
  try
    lJson.TryGetValue<Boolean>('success', Result);
  finally
    FreeAndNil(lJson);
  end;
end;

procedure TTaskService.ValidateAuthentication;
begin
  if not FAuthService.IsTokenValid then
    raise EValidateAuthenticationException.Create('Sessão expirada ou usuário não autenticado');
end;

end.
