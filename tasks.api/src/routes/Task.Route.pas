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
  Horse, App.Console, Task.Controller, Task.Service, Task.Repository;

{ TTaskRoute }

class procedure TTaskRoute.Registry;
begin
  TTaskController.Service := TTaskService.Create(
    TTaskRepository.Create(TAppConsole.Connection),
    AUserService
  );

  THorse.Group
    .Prefix('/tasks')
    .Post('/', TTaskController.Post)
    .Get('/', TTaskController.Get)
    .Get('/:id', TTaskController.GetById)
    .Put('/:id', TTaskController.Put)
    .Delete('/:id', TTaskController.Delete);

end;

end.
