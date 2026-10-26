unit App.Console;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Comp.Client, Horse.Model, Connection.Model;

type
  TAppConsole = class
  private
    class function GetDir: string; static;
    class function GetHorseParams: THorseModel; static;
  public
    class procedure Init;

    class property Dir: string read GetDir;
    class property HorseParams: THorseModel read GetHorseParams;
  end;

implementation

uses
  Horse, Horse.Commons, Horse.Jhonson, Horse.JWT, Horse.Logger, Horse.Logger.Provider.Console, Horse.HandleException,
  App.ParamsConnection, App.HorseParams, AppRoutes, Middleware.ErrorHandler, JOSE.Core.JWT, System.StrUtils,
  Connection.Factory;

var
  FParamsConnextion: TParamsConnection;
  FHorseParams: THorseModel;

{ TAppHorse }

procedure FinalizationAppConsole;
begin
  FreeAndNil(FParamsConnextion);
  FreeAndNil(FHorseParams);
end;

procedure ValidateAudience(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
var
  lClaims: TJWTClaims;
begin
  // rotas públicas: não há sessão
  if IndexText(AReq.RawWebRequest.PathInfo, ['/', '/auth']) <> -1 then
  begin
    ANext;
    Exit;
  end;
  lClaims := AReq.Session<TJWTClaims>;
  if lClaims.Audience <> FHorseParams.Audience then
  begin
    ARes.Status(401).Send('{"success":false,"message":"Invalid audience"}');
    raise EHorseCallbackInterrupted.Create;
  end;
  ANext;
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
    FParamsConnextion := TAppParamsConnection.Params(GetDir);
    FHorseParams := TAppHorseParams.Params(GetDir);

    TConnectionFactory.ParamsConnection := FParamsConnextion;

    // 1. Registra o provedor que enviar? as mensagens para o console
    THorseLoggerManager.RegisterProvider(
      THorseLoggerProviderConsole.New(
        THorseLoggerConsoleConfig
          .New
          .SetLogFormat('[${time}] ${request_method} ${request_path_info} ${response_status} - ${execution_time}ms')
      )
    );
    // 2. Adiciona o middleware de log ao Horse
    THorse
      .Use(Jhonson)
      .Use(
        HorseJWT(
          FHorseParams.JWTKey,
          THorseJWTConfig.New
            .SessionClass(TJWTClaims)
            .IsRequiredSubject(True)
            .IsRequiredExpirationTime(True)
            .IsRequireAudience(True)
            .ExpectedAudience([FHorseParams.Audience])
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


initialization

finalization
  FinalizationAppConsole;

end.
