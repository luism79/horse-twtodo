unit Task.Repository;

interface

uses
  System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB, System.Generics.Collections, Custom.Repository,
  Task.Model, ITask.Repository, Task.DTO, IUser.Current, IConnection.Factory;

type
  TTaskRepository = class(TCustomRepository, ITaskRepository)
  private
    FUserCurrenct: IUserCurrenct;

    procedure ApplyDateTimeToField(AField: TFDParam; AClear: Boolean);
    function ConvertDataSetToModel(ADataSet: TDataSet): TTaskModel;
    function InternalAdd(const AObj: TTaskModel): string;
    function InternalFindById(const AId: string): TTaskModel;
    function InternalFindAll(const AQueryParams: TTaskQueryParamsDTO): TObjectList<TTaskModel>;
    function InternalRemove(const AId: string): Boolean;
    function InternalUpdate(const AObj: TTaskModel): Boolean;
  public
    constructor Create(AConnectionFactory: IConnectionFactory; AUserCurrent: IUserCurrenct); reintroduce;

    function Add(const AObj: TTaskModel): string;
    function FindAll: TObjectList<TTaskModel>; overload;
    function FindAll(const AQueryParams: TTaskQueryParamsDTO): TObjectList<TTaskModel>; overload;
    function FindById(const Id: string): TTaskModel;
    function Remove(const Id: string): Boolean;
    function Update(const AObj: TTaskModel): Boolean;
  end;

implementation

uses
  System.SysUtils, App.Enums;

const
  TASK_SQL_DEFAULT = 'select'#13#10 +
                     '	t.id::varchar id, t.id_usuario::varchar id_usuario,'#13#10 +
                     '  t.titulo, t.descricao, t.prioridade, t.status,'#13#10 +
                     '  t.data_hora_incluido, t.data_hora_alterado,'#13#10 +
                     '  t.data_hora_completado, t.data_hora_cancelado, u.e_mail'#13#10 +
                     'from tarefas t'#13#10 +
                     '  join usuarios u on t.id_usuario = u.id'#13#10 +
                     '--<where>'#13#10 +
                     '--<orderBy>';

{ TTaskRepository }

function TTaskRepository.Add(const AObj: TTaskModel): string;
begin
  Result := InternalAdd(AObj);
end;

procedure TTaskRepository.ApplyDateTimeToField(AField: TFDParam; AClear: Boolean);
begin
  AField.DataType := ftDateTime;
  if AClear then
      AField.Clear
    else AField.AsDateTime := Now;
end;

function TTaskRepository.ConvertDataSetToModel(ADataSet: TDataSet): TTaskModel;
begin
  if ADataSet.IsEmpty then
    Exit(nil);

  Result := TTaskModel.Create;
  Result.Id := ADataSet.FieldByName('id').AsString.ToLower;
  Result.UserId := ADataSet.FieldByName('id_usuario').AsString.ToLower;
  Result.Title := ADataSet.FieldByName('titulo').AsString;
  Result.Description := ADataSet.FieldByName('descricao').AsString;
  Result.Priority := TTaskPriority(ADataSet.FieldByName('prioridade').AsInteger);
  Result.Status := TTaskStatus(ADataSet.FieldByName('status').AsInteger);
  Result.CreatedAt := ADataSet.FieldByName('data_hora_incluido').AsDateTime;
  Result.CompletedAt := ADataSet.FieldByName('data_hora_completado').AsDateTime;
  Result.UpdatedAt := ADataSet.FieldByName('data_hora_alterado').AsDateTime;
  Result.CancelledAt := ADataSet.FieldByName('data_hora_cancelado').AsDateTime;
  Result.UserEmail := ADataSet.FieldByName('e_mail').AsString;
end;

constructor TTaskRepository.Create(AConnectionFactory: IConnectionFactory; AUserCurrent: IUserCurrenct);
begin
  inherited Create(AConnectionFactory);

  FUserCurrenct := AUserCurrent;
  FSQLDefault := TASK_SQL_DEFAULT;
end;

function TTaskRepository.FindAll(const AQueryParams: TTaskQueryParamsDTO): TObjectList<TTaskModel>;
begin
  Result := InternalFindAll(AQueryParams);
end;

function TTaskRepository.FindAll: TObjectList<TTaskModel>;
begin
  raise Exception.Create('Método não deve ser utilizado');
end;

function TTaskRepository.FindById(const Id: string): TTaskModel;
begin
  Result := InternalFindById(Id);
end;

function TTaskRepository.InternalAdd(const AObj: TTaskModel): string;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := 'insert into tarefas'#13#10 +
                        '  (id_usuario, titulo, descricao, prioridade, status,'#13#10 +
                        '   data_hora_completado, data_hora_cancelado)'#13#10 +
                        'values'#13#10 +
                        '  (cast(:id_usuario as uuid), :titulo, :descricao, :prioridade,'#13#10 +
                        '   :status, :data_hora_completado, :data_hora_cancelado)'#13#10 +
                        'returning id::varchar;'#13#10;

    lQuery.ParamByName('id_usuario').DataType := ftString;
    lQuery.ParamByName('id_usuario').AsString := AObj.UserId;
    lQuery.ParamByName('titulo').AsString := AObj.Title;
    lQuery.ParamByName('descricao').AsString := AObj.Description;
    lQuery.ParamByName('prioridade').AsInteger := AObj.Priority.ToInteger;
    lQuery.ParamByName('status').AsInteger := AObj.Status.ToInteger;

    ApplyDateTimeToField(lQuery.ParamByName('data_hora_completado'), AObj.Status <> tsCompleted);
    ApplyDateTimeToField(lQuery.ParamByName('data_hora_cancelado'), AObj.Status <> tsCancelled);

    lQuery.Open;

    Result := lQuery.Fields[0].AsString.ToLower;
  finally
    FreeAndNil(lQuery);
  end;  // try
end;

function TTaskRepository.InternalFindById(const AId: string): TTaskModel;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := StringReplace(
      FSQLDefault,
      '--<where>',
      'where t.id::varchar = :id'#13#10 +
      '  and t.id_usuario::varchar = :id_usuario',
      [rfIgnoreCase]
    );

    lQuery.SQL.Text := lQuery.SQL.Text + #13#10 +
      'limit 1;';

    lQuery.ParamByName('id').AsString := AId;
    lQuery.ParamByName('id_usuario').AsString := FUserCurrenct.Id;
    lQuery.Open;

    Result := ConvertDataSetToModel(lQuery);
  finally
    FreeAndNil(lQuery);
  end;  // try
end;

function TTaskRepository.Remove(const Id: string): Boolean;
begin
  Result := InternalRemove(Id);
end;

function TTaskRepository.Update(const AObj: TTaskModel): Boolean;
begin
  Result := InternalUpdate(AObj);
end;

function TTaskRepository.InternalFindAll(const AQueryParams: TTaskQueryParamsDTO): TObjectList<TTaskModel>;

  procedure _internalAddParam(const AValue: Integer; AParam: TFDParam);
  begin
    AParam.DataType := ftInteger;
    if AValue <> -1 then
      AParam.AsInteger := AValue
    else AParam.Clear;
  end;

var
  lQuery: TFDQuery;
  lModel: TTaskModel;
  lSQL: string;
begin
  Result := TObjectList<TTaskModel>.Create;

  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;

    lSQL := StringReplace(
      FSQLDefault,
      '--<where>',
      'where t.id_usuario::varchar = :id_usuario'#13#10 +
      '  and (t.prioridade = :prioridade or :prioridade is null)'#13#10 +
      '  and (t.status = :status or :status is null)',
      [rfIgnoreCase]
    );

    lSQL := StringReplace(lSQL,
      '--<orderBy>',
      'order by t.data_hora_incluido desc, t.prioridade desc',
      [rfIgnoreCase]
    );

    lQuery.SQL.Text := lSQL;

    lQuery.ParamByName('id_usuario').AsString := FUserCurrenct.Id;
    _internalAddParam(AQueryParams.Priority, lQuery.ParamByName('prioridade'));
    _internalAddParam(AQueryParams.Status, lQuery.ParamByName('status'));

    lQuery.Open;

    while not lQuery.Eof do
    begin
      lModel := ConvertDataSetToModel(lQuery);
      if Assigned(lModel) then
        Result.Add(lModel);
      lQuery.Next;
    end;
  finally
    FreeAndNil(lQuery);
  end;  // try
end;

function TTaskRepository.InternalRemove(const AId: string): Boolean;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := 'delete from tarefas'#13#10 +
                       'where id::varchar = :id'#13#10 +
                       '  and id_usuario::varchar = :id_usuario;';

    lQuery.ParamByName('id').AsString := AId;
    lQuery.ParamByName('id_usuario').AsString := FUserCurrenct.Id;

    lQuery.ExecSQL;

    Result := lQuery.RowsAffected > 0;
  finally
    FreeAndNil(lQuery);
  end;  // try
end;

function TTaskRepository.InternalUpdate(const AObj: TTaskModel): Boolean;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Connection;
    lQuery.SQL.Text := 'update tarefas'#13#10 +
                       'set'#13#10 +
                       '  titulo = :titulo,'#13#10 +
                       '  descricao = :descricao,'#13#10 +
                       '  prioridade = :prioridade,'#13#10 +
                       '  status = :status,'#13#10 +
                       '  data_hora_alterado = now(),'#13#10 +
                       '  data_hora_completado = :data_hora_completado,'#13#10 +
                       '  data_hora_cancelado = :data_hora_cancelado'#13#10 +
                       'where id::varchar = :id'#13#10 +
                       '  and id_usuario::varchar = :id_usuario;';

    lQuery.ParamByName('id').AsString := AObj.Id;
    lQuery.ParamByName('id_usuario').AsString := FUserCurrenct.Id;
    lQuery.ParamByName('titulo').AsString := AObj.Title;
    lQuery.ParamByName('descricao').AsString := AObj.Description;
    lQuery.ParamByName('prioridade').AsInteger := AObj.Priority.ToInteger;
    lQuery.ParamByName('status').AsInteger := AObj.Status.ToInteger;

    ApplyDateTimeToField(lQuery.ParamByName('data_hora_completado'), AObj.Status <> tsCompleted);
    ApplyDateTimeToField(lQuery.ParamByName('data_hora_cancelado'), AObj.Status <> tsCancelled);

    lQuery.ExecSQL;

    Result := lQuery.RowsAffected > 0;
  finally
    FreeAndNil(lQuery);
  end;  // try
end;

end.
