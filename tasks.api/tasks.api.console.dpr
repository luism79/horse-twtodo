program tasks.api.console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Intf,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  App.Console in 'src\App.Console.pas',
  Connection.Model in 'src\models\Connection.Model.pas',
  App.Connection in 'src\App.Connection.pas',
  App.CustomConfig in '..\prj.shares\App.CustomConfig.pas',
  App.HorseParams in 'src\App.HorseParams.pas',
  Horse.Model in 'src\models\Horse.Model.pas',
  User.Model in 'src\models\User.Model.pas',
  Custom.Repository in 'src\repositories\Custom.Repository.pas',
  User.Repository in 'src\repositories\User.Repository.pas',
  ICrud.Repository in 'src\repositories\interfaces\ICrud.Repository.pas',
  IUser.Repository in 'src\repositories\interfaces\IUser.Repository.pas',
  User.Controller in 'src\controllers\User.Controller.pas',
  User.Route in 'src\routes\User.Route.pas',
  User.DTO in 'src\models\User.DTO.pas',
  IUser.Service in 'src\services\interfaces\IUser.Service.pas',
  User.Service in 'src\services\User.Service.pas',
  App.Response in 'src\shared\App.Response.pas',
  Task.Route in 'src\routes\Task.Route.pas',
  ITask.Service in 'src\services\interfaces\ITask.Service.pas',
  Task.DTO in 'src\models\Task.DTO.pas',
  Task.Repository in 'src\repositories\Task.Repository.pas',
  ITask.Repository in 'src\repositories\interfaces\ITask.Repository.pas',
  Task.Model in 'src\models\Task.Model.pas',
  Task.Service in 'src\services\Task.Service.pas',
  Task.Controller in 'src\controllers\Task.Controller.pas',
  App.Enums in 'src\enums\App.Enums.pas',
  IAuth.Service in 'src\services\interfaces\IAuth.Service.pas',
  Auth.Service in 'src\services\Auth.Service.pas',
  Config.JWT in 'src\models\Config.JWT.pas',
  Auth.Route in 'src\routes\Auth.Route.pas',
  Auth.Controller in 'src\controllers\Auth.Controller.pas',
  Auth.DTO in 'src\models\Auth.DTO.pas',
  AppRoutes in 'src\AppRoutes.pas',
  App.Utils in '..\prj.shares\App.Utils.pas',
  Middleware.ErrorHandler in 'src\middlewares\Middleware.ErrorHandler.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    TAppConsole.Init;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
