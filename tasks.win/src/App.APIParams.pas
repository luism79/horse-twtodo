unit App.APIParams;

interface

uses
  Params.Model;

type
  TAppAPIParams = class
  public
    class function Params(const ADirApp: string): TParamsModel;
  end;

implementation

uses
  System.Classes, System.SysUtils, App.CustomConfig;

const
  FILE_CONFIG = 'ParamsWin.ini';
  SECTION = 'params';
  HOST_IDENT = 'host';
  PORT_IDENT = 'port';
  CONNECTION_TIMEOUT_IDENT = 'ConnectionTimeout';
  RESPONSE_TIMEOUT_IDENT = 'ResponseTimeout';
  HOST_DEFAULT = 'localhost';
  PORT_DEFAULT = 9025;
  CONNECTION_TIMEOUT_DEAFAULT = 8000;
  RESPONSE_TIMEOUT_DEAFAULT = 15000;

type
  TAPIParams = class(TCustomConfig)
  private
    FParams: TParamsModel;
  protected
    procedure LoadData; override;
    procedure SaveData; override;
  public
    destructor Destroy; override;
    constructor Create(const AFileName: string); override;

    procedure Assign(ASource: TObject); override;
  end;

{ TAPIParams }

procedure TAPIParams.Assign(ASource: TObject);
begin
  if ASource is TParamsModel then
  begin
    TParamsModel(ASource).Host := FParams.Host;
    TParamsModel(ASource).Port := FParams.Port;
    TParamsModel(ASource).ConnectionTimeout := FParams.ConnectionTimeout;
    TParamsModel(ASource).ResponseTimeout := FParams.ResponseTimeout;
  end else inherited Assign(ASource);
end;

constructor TAPIParams.Create(const AFileName: string);
begin
  FParams := TParamsModel.Create;
  inherited Create(AFileName);
end;

destructor TAPIParams.Destroy;
begin
  SaveData;
  FreeAndNil(FParams);
  inherited Destroy;
end;

procedure TAPIParams.LoadData;
begin
  FParams.Host := ReadString(SECTION, HOST_IDENT, HOST_DEFAULT);
  FParams.Port := ReadInteger(SECTION, PORT_IDENT, PORT_DEFAULT);
  FParams.ConnectionTimeout := ReadInteger(SECTION, CONNECTION_TIMEOUT_IDENT, CONNECTION_TIMEOUT_DEAFAULT);
  FParams.ResponseTimeout := ReadInteger(SECTION, RESPONSE_TIMEOUT_IDENT, RESPONSE_TIMEOUT_DEAFAULT);
end;

procedure TAPIParams.SaveData;
begin
  WriteString(SECTION, HOST_IDENT, FParams.Host);
  WriteInteger(SECTION, PORT_IDENT, FParams.Port);
  WriteInteger(SECTION, CONNECTION_TIMEOUT_IDENT, FParams.ConnectionTimeout);
  WriteInteger(SECTION, RESPONSE_TIMEOUT_IDENT, FParams.ResponseTimeout);
end;

{ TAppHorseParams }

class function TAppAPIParams.Params(const ADirApp: string): TParamsModel;
var
  lParams: TAPIParams;
begin
  Result := TParamsModel.Create;

  lParams := TAPIParams.Create(ADirApp + '\' + FILE_CONFIG);
  try
    lParams.Assign(Result);
  finally
    FreeAndNil(lParams);
  end;  // try
end;

end.
