unit App.Console;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Comp.Client, Horse.Model;

type
  TAppConsole = class
  private
    class function GetConnection: TFDCustomConnection; static;
    class function GetDir: string; static;
    class function GetHorseParams: THorseModel; static;
  public
    class procedure Init;

    class property Connection: TFDCustomConnection read GetConnection;
    class property Dir: string read GetDir;
    class property HorseParams: THorseModel read GetHorseParams;
  end;

implementation

uses
  Horse, Horse.Commons, Horse.Jhonson, Horse.JWT, Horse.Logger, Horse.Logger.Provider.Console, Horse.HandleException,
  App.Connection, App.HorseParams, AppRoutes, Middleware.ErrorHandler;

var
  FConnection: TFDCustomConnection;
  FHorseParams: THorseModel;

{ TAppHorse }

class function TAppConsole.GetConnection: TFDCustomConnection;
begin
  Result := FConnection;
end;

class function TAppConsole.GetDir: string;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

class function TAppConsole.GetHorseParams: THorseModel;
begin
  Result := FHorseParams;
end;

class procedure TAppConsole.Init;
begin
  try
    FConnection := TAppConn.New(GetDir);
    FHorseParams := TAppHorseParams.Params(GetDir);

    // 1. Registra o provedor que enviar? as mensagens para o console
    THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());
    // 2. Adiciona o middleware de log ao Horse
    THorse
      .Use(Jhonson)
      .Use(
        HorseJWT(
          FHorseParams.JWTKey,
          THorseJWTConfig.New
            .SkipRoutes(['/', '/auth'])
            .OnResponse(
              TErrorHandler.ErrorHandlerJwt
            )
        )
      )
      .Use(THorseLoggerManager.HorseCallback);

    TRegistryRoutes.Registry;

    THorse.Listen(
      FHorseParams.Port,
      procedure
      begin
        Writeln(Format('Horse version %s', [THorse.Version]));
        Writeln(Format('http://%s:%d'#13#10, [FHorseParams.Host, FHorseParams.Port]));
      end
    );
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
