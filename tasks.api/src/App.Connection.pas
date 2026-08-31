unit App.Connection;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Intf, Connection.Model;

type
  TAppConn = class
  public
    class function New(const ADirApp: string): TFDCustomConnection;
    class function ParamsConnection(const ADirApp: string): TParamsConnection;
    class procedure AssignToConnection(ADest: TFDCustomConnection; ASource: TParamsConnection);
  end;

implementation

uses
  App.CustomConfig;

const
  FILE_CONFIG = 'configDB.ini';
  SECTION = 'params';
  HOST_IDENT = 'host';
  DATABASE_IDENT = 'database';
  USERNAME_IDENT = 'user_name';
  PASSWORD_IDENT = 'password';
  PORT_IDENT = 'port';
  DRIVERNAME_IDENT = 'drive_name';
  USERNAME_DEFAULT = 'postgres';
  DRIVERNAME_DEFAULT = 'PG';

type
  TConnectionPG = class(TCustomConfig)
  private
    FParam: TParamsConnection;
  protected
    procedure LoadData; override;
    procedure SaveData; override;
  public
    constructor Create(const AFileName: string); override;
    destructor Destroy; override;

    procedure Assign(ASource: TObject); override;
  end;

  { TConnectionPG }

procedure TConnectionPG.Assign(ASource: TObject);
begin
  if ASource is TParamsConnection then
  begin
    TParamsConnection(ASource).Database := FParam.Database;
    TParamsConnection(ASource).DriverName := FParam.DriverName;
    TParamsConnection(ASource).Host := FParam.Host;
    TParamsConnection(ASource).Password := FParam.Password;
    TParamsConnection(ASource).Port := FParam.Port;
    TParamsConnection(ASource).UserName := FParam.UserName;
  end
  else inherited Assign(ASource);

end;

constructor TConnectionPG.Create(const AFileName: string);
begin
  FParam := TParamsConnection.Create(DRIVERNAME_DEFAULT);
  inherited Create(AFileName);
end;

destructor TConnectionPG.Destroy;
begin
  SaveData;
  FreeAndNil(FParam);
  inherited Destroy;
end;

procedure TConnectionPG.LoadData;
begin
  FParam.Database := ReadString(SECTION, DATABASE_IDENT, EmptyStr);
  FParam.DriverName := ReadString(SECTION, DRIVERNAME_IDENT, DRIVERNAME_DEFAULT);
  FParam.Host := ReadString(SECTION, HOST_IDENT, FParam.Host);
  FParam.Password := ReadString(SECTION, PASSWORD_IDENT, EmptyStr);
  FParam.Port := ReadInteger(SECTION, PORT_IDENT, FParam.Port);
  FParam.UserName := ReadString(SECTION, USERNAME_IDENT, USERNAME_DEFAULT);
end;

procedure TConnectionPG.SaveData;
begin
  WriteString(SECTION, DATABASE_IDENT, FParam.Database);
  WriteString(SECTION, DRIVERNAME_IDENT, FParam.DriverName);
  WriteString(SECTION, HOST_IDENT, FParam.Host);
  WriteString(SECTION, PASSWORD_IDENT, FParam.Password);
  WriteInteger(SECTION, PORT_IDENT, FParam.Port);
  WriteString(SECTION, USERNAME_IDENT, FParam.UserName);
end;

{ TAppConn }

class procedure TAppConn.AssignToConnection(ADest: TFDCustomConnection;
  ASource: TParamsConnection);
begin
  ADest.Params.Clear;

  ADest.LoginPrompt := False;

  ADest.Params.DriverID :=  ASource.DriverName;
  ADest.Params.Add('Server=' + ASource.Host);
  ADest.Params.Add('Port=' + ASource.Port.ToString);
  ADest.Params.Add('Database=' + ASource.Database);
  ADest.Params.Add('User_Name=' + ASource.UserName);
  ADest.Params.Add('Password=' + ASource.Password);
end;

class function TAppConn.New(const ADirApp: string): TFDCustomConnection;
var
  lParam: TParamsConnection;
begin
  Result := TFDCustomConnection.Create(nil);

  lParam := ParamsConnection(ADirApp);
  try
    AssignToConnection(Result, lParam);
  finally
    FreeAndNil(lParam);
  end;  // try
end;

class function TAppConn.ParamsConnection(
  const ADirApp: string): TParamsConnection;
var
  lFile: TConnectionPG;
begin
  lFile := TConnectionPG.Create(ADirApp + '\' + FILE_CONFIG);
  try
    Result := TParamsConnection.Create(DRIVERNAME_DEFAULT);
    lFile.Assign(Result);
  finally
    FreeAndNil(lFile);
  end;  // try
end;

end.
