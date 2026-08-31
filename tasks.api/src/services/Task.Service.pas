unit Task.Service;

interface

uses
  System.Classes, ITask.Service, ITask.Repository, Task.DTO, Task.Model, IUser.Service;

type
  TTaskService = class(TInterfacedObject, ITaskService)
  private
    FRepository: ITaskRepository;
    FUserService: IUserService;

    procedure AssignedToModel(var ADest: TTaskModel; const ASrcTask: TTaskInputDTO);
    function ExistsUser(const AId: string): Boolean;
    procedure ValidateTask(AInput: TTaskInputDTO);
  public
    constructor Create(ARepository: ITaskRepository; AUserService: IUserService);
    destructor Destroy; override;

    function Add(const AInput: TTaskInputDTO): string;
    function FindById(const AId: string): TTaskDTO;
    function FindAll(const AQueryParams: TTaskQueryParamsDTO): TArray<TTaskDTO>;
    function Remove(const AId: string): Boolean;
    function Update(const AId: string; const AInput: TTaskInputDTO): Boolean;
  end;

implementation

uses
  System.SysUtils, System.Generics.Collections, App.Utils, App.Enums;

{ TTaskService }

function TTaskService.Add(const AInput: TTaskInputDTO): string;
var
  lTask: TTaskModel;
begin
  ValidateTask(AInput);

  lTask := TAppUtils.ConvertRecordToObject<TTaskModel, TTaskInputDTO>(AInput);
  try
    Result := FRepository.Add(lTask);
  finally
    FreeAndNil(lTask);
  end;
end;

procedure TTaskService.AssignedToModel(var ADest: TTaskModel; const ASrcTask: TTaskInputDTO);
begin
  ADest.Title := ASrcTask.Title;
  ADest.Description := ASrcTask.Description;
  ADest.Priority := TTaskPriority(ASrcTask.Priority);
  ADest.Status := TTaskStatus(ASrcTask.Status);
end;

constructor TTaskService.Create(ARepository: ITaskRepository; AUserService: IUserService);
begin
  FRepository := ARepository;
  FUserService := AUserService;
end;

destructor TTaskService.Destroy;
begin
  inherited Destroy;
end;

function TTaskService.ExistsUser(const AId: string): Boolean;
begin
  Result := not FUserService.FindById(AId).Id.IsEmpty;
end;

function TTaskService.FindById(const AId: string): TTaskDTO;
var
  lTask: TTaskModel;
begin
  lTask := FRepository.FindById(AId);
  try
    Result := TAppUtils.ConvertObjectToRecord<TTaskDTO>(lTask);
  finally
    FreeAndNil(lTask);
  end;
end;

procedure TTaskService.ValidateTask(AInput: TTaskInputDTO);
begin
  if AInput.Title.IsEmpty then
    raise Exception.Create('O título deve ser informado');

  if AInput.Description.IsEmpty then
    raise Exception.Create('A decrição deve ser informada');

  if not ExistsUser(AInput.UserId) then
    raise Exception.Create('Usuário não foi encontrado');

  if not (AInput.Priority in [0..2]) then
    raise Exception.Create('Prioridade não encontrada');

  if not (AInput.Status in [0..3]) then
    raise Exception.Create('Status não encontrado');
end;

function TTaskService.FindAll(const AQueryParams: TTaskQueryParamsDTO): TArray<TTaskDTO>;
var
  lTasks: TObjectList<TTaskModel>;
  lItem: TTaskModel;
  lIndex: Integer;
begin
  lTasks := FRepository.FindAll(AQueryParams);
  try
    SetLength(Result, lTasks.Count);
    lIndex := 0;
    for lItem in lTasks do
    begin
      Result[lIndex] := TAppUtils.ConvertObjectToRecord<TTaskDTO>(lItem);
      Inc(lIndex);
    end;
  finally
    FreeAndNil(lTasks);
  end;
end;

function TTaskService.Remove(const AId: string): Boolean;
begin
  Result := FRepository.Remove(AId);
  if not Result then
    raise Exception.Create('Tarefa não foi encontrada ou não pôde ser deletada');
end;

function TTaskService.Update(const AId: string; const AInput: TTaskInputDTO): Boolean;
var
  lTask: TTaskModel;
begin
  lTask := FRepository.FindById(AId);
  if not Assigned(lTask) then
    raise Exception.Create('Tarefa não foi encontrada');

  AssignedToModel(lTask, AInput);
  ValidateTask(TAppUtils.ConvertObjectToRecord<TTaskInputDTO>(lTask));
  try
    Result := FRepository.Update(lTask);
    if not Result then
      raise Exception.Create('Falha ao atualizar a tarefa');
  finally
    FreeAndNil(lTask);
  end;
end;
end.
