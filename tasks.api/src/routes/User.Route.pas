unit User.Route;

interface

uses
  IUser.Service;

type
  TUserRoute = class
  private
    class function GetService: IUserService; static;
  public
    class procedure Registry;

    class property Service: IUserService read GetService;
  end;

implementation

uses
  Horse, App.Console, User.Controller, User.Service, User.Repository;

var
  FService: IUserService;

{ TUsuarioRoute }

class function TUserRoute.GetService: IUserService;
begin
  Result := FService;
end;

class procedure TUserRoute.Registry;
begin
  FService := TUserService.Create(
    TUserRepository.Create(TAppConsole.Connection)
  );

  TUserController.Service := FService;

  THorse
    .Group
      .Prefix('users')
      .Post('/', TUserController.Post)
      .Get('/:e-mail', TUserController.GetByEmail);
end;

end.
