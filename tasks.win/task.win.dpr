program task.win;

uses
  Vcl.Forms,
  System.SysUtils,
  Vcl.Controls,
  Custom.View in 'src\views\Custom.View.pas' {frmCustomView},
  Login.View in 'src\views\Login.View.pas' {frmLogin},
  Task.View in 'src\views\Task.View.pas' {frmTaskView},
  Custom.Service in 'src\services\Custom.Service.pas',
  Custom.Exceptions in 'src\services\exceptions\Custom.Exceptions.pas',
  App.APIParams in 'src\App.APIParams.pas',
  Params.Model in 'src\models\Params.Model.pas',
  App.CustomConfig in '..\prj.shares\App.CustomConfig.pas',
  App.Win in 'src\App.Win.pas',
  Auth.Service in 'src\services\Auth.Service.pas',
  ICustom.Service in 'src\services\interfaces\ICustom.Service.pas',
  IAuth.Service in 'src\services\interfaces\IAuth.Service.pas',
  Login.DTO in 'src\models\Login.DTO.pas',
  App.Utils in '..\prj.shares\App.Utils.pas',
  App.Enums in 'src\enums\App.Enums.pas',
  App.Consts in 'src\shared\App.Consts.pas',
  Task.Model in 'src\models\Task.Model.pas',
  Task.Service in 'src\services\Task.Service.pas',
  ITask.Service in 'src\services\interfaces\ITask.Service.pas',
  Task.Card in 'src\views\Task.Card.pas',
  Lib.Images in 'src\images\Lib.Images.pas' {frmLibImages},
  Task.Management in 'src\views\Task.Management.pas' {frmTaskManagement};

{$R *.res}

begin
  Application.Initialize;
  TAppWin.Init;
  TAppWin.AuthService := TAuthService.Create(TAppWin.Params);
  Application.CreateForm(TfrmTaskView, frmTaskView);

  frmLogin := TfrmLogin.Create(nil);
  try
    if frmLogin.ShowModal <> mrOk then
    begin
      FreeAndNil(frmTaskView);
      Application.Terminate;
    end;
  finally
    FreeAndNil(frmLogin);
  end;

  Application.Run;
end.
