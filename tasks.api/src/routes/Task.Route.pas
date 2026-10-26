unit Task.Route;

interface

uses
  IUser.Service;

type
  TTaskRoute = class
  private
  public
    class procedure Registry(AUserService: IUserService);
  end;

implementation

uses
  Horse, App.Console, Task.Controller, ITask.Service, Task.Service, Task.Repository, User.Current,
  Connection.Factory;

{ TTaskRoute }

class procedure TTaskRoute.Registry;
begin
  TTaskController.ServiceFactory :=
    function(AReq: THorseRequest): ITaskService
    begin
      Result :=  TTaskService.Create(
        TTaskRepository.Create(
          TConnectionFactory.New,
          TUserCurrent.Create(AReq)
        ),
        AUserService
      );
    end;

  THorse.Group
    .Prefix('/tasks')
    .Post('/', TTaskController.Post)
    .Get('/', TTaskController.Get)
    .Get('/:id', TTaskController.GetById)
    .Put('/:id', TTaskController.Put)
    .Delete('/:id', TTaskController.Delete);

end;

end.
