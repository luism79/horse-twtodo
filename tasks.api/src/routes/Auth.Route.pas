unit Auth.Route;

interface

uses
  IUser.Service;

type
  TAuthRoute = class
  private
    class var FUserService: IUserService;
  public
    class procedure Registry(AUserService: IUserService);

    class property UserService: IUserService read FUserService;
  end;

implementation

uses
  Horse, Auth.Controller, Auth.Service, App.Console, App.Utils, Config.JWT;

{ TAuthRoute }

class procedure TAuthRoute.Registry(AUserService: IUserService);
begin
  TAuthController.Service := TAuthService.Create(
    TAppUtils.ConvertObjectToRecord<TConfigJWT>(TAppConsole.HorseParams),
    AUserService
  );

  THorse
    .Group
    .Prefix('/auth')
    .Post('/', TAuthController.Post);
end;

end.
