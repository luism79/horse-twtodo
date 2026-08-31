unit Task.Controller;

interface

uses
  Horse, ITask.Service;

type
  TTaskController = class
  private
    class var FService: ITaskService;
  public
    class procedure Get(AReq: THorseRequest; ARes: THorseResponse);
    class procedure GetById(AReq: THorseRequest; ARes: THorseResponse);
    class procedure Post(AReq: THorseRequest; ARes: THorseResponse);
    class procedure Put(AReq: THorseRequest; ARes: THorseResponse);
    class procedure Delete(AReq: THorseRequest; ARes: THorseResponse);

    class property Service: ITaskService read FService write FService;
  end;

implementation

uses
  System.SysUtils, System.Classes, System.JSON, System.JSON.Serializers, Task.DTO, App.Response, App.Utils;

{ TTaskController }

class procedure TTaskController.Get(AReq: THorseRequest; ARes: THorseResponse);
var
  lTasks: TArray<TTaskDTO>;
  lJsonArray: TJSONArray;
  lQueryParams: TTaskQueryParamsDTO;
begin
  try
    lQueryParams.UserId := AReq.Query.Field('user-id').AsString;
    lQueryParams.Priority := StrToIntDef(AReq.Query.Field('priority').AsString, -1);
    lQueryParams.Status := StrToIntDef(AReq.Query.Field('status').AsString, -1);

    lTasks := FService.FindAll(lQueryParams);

    lJsonArray := TAppUtils.ConvertArrayToJSONArray<TArray<TTaskDTO>>(lTasks);

    ARes
      .Send<TJSONObject>(
        TAppResponse.Success('Registros listados com sucesso', lJsonArray)
      )
      .Status(THTTPStatus.OK);
  except
    on E: Exception do
    begin
      ARes.Send<TJSONObject>(
        TAppResponse.Error(E.Message)
      )
      .Status(THTTPStatus.BadRequest);
    end;
  end;
end;

class procedure TTaskController.GetById(AReq: THorseRequest;
  ARes: THorseResponse);
const
  HTTPStatusError: array[Boolean] of THTTPStatus = (THTTPStatus.BadRequest, THTTPStatus.NotFound);
var
  lTask: TTaskDTO;
  lId: string;
  lFound: Boolean;
begin
  lFound := False;
  lId := AReq.Params['id'];
  try
    lTask := FService.FindById(lId);

    lFound := not lTask.Id.IsEmpty;

    if not lFound then
      raise Exception.Create('Registro não encontrado');

    ARes.Send<TJSONObject>(
      TAppResponse.Success('Registro localizado com sucesso',
        TAppUtils.ConvertRecordToJSON<TTaskDTO>(lTask)
      )
    )
    .Status(THTTPStatus.Found);

  except
    on E: Exception do
      ARes.Send<TJSONObject>(
        TAppResponse.Error('Falha ao localizar o registro', TJSONPair.Create('error', E.Message)
      ))
      .Status(HTTPStatusError[lFound]);
  end;
end;

class procedure TTaskController.Post(AReq: THorseRequest; ARes: THorseResponse);
var
  lInput: TTaskInputDTO;
  lResponse: TJSONObject;
  lId: string;
begin
  try
    lInput := TJsonSerializer.Create
      .Deserialize<TTaskInputDTO>(AReq.Body);

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
        TAppResponse.Error('Falha na criação do registro',
          TJSONPair.Create('error', E.Message)
      ))
      .Status(THTTPStatus.BadRequest);
  end;
end;

class procedure TTaskController.Put(AReq: THorseRequest; ARes: THorseResponse);
var
  lInput: TTaskInputDTO;
  lId: string;
begin
  try
    lId := AReq.Params['id'];
    lInput := TJsonSerializer.Create
      .Deserialize<TTaskInputDTO>(AReq.Body);

    FService.Update(lId, lInput);

    ARes.Send<TJSONObject>(
      TAppResponse.Success('Registro atualizado com sucesso',
        TJSONObject.Create
          .AddPair('id', lId)
    ))
    .Status(THTTPStatus.OK);
  except
    on E: Exception do
      ARes.Send<TJSONObject>(
        TAppResponse.Error(
          'Falha na atualização',
          TJSONPair.Create('error', E.Message)
      ))
      .Status(THTTPStatus.BadRequest);
  end;
end;

class procedure TTaskController.Delete(AReq: THorseRequest; ARes: THorseResponse);
var
  lId: string;
begin
  try
    lId := AReq.Params['id'];
    FService.Remove(lId);

    ARes.Send<TJSONObject>(
      TAppResponse.Success(
        'Registro deletado com sucesso',
        TJSONObject.Create
          .AddPair('id', lId
    )))
    .Status(THTTPStatus.OK);
  except
    on E: Exception do
      ARes.Send<TJSONObject>(
        TAppResponse.Error('Falha na exclusão',
          TJSONPair.Create('error', E.Message)
      ))
      .Status(THTTPStatus.BadRequest);
  end;
end;

end.
