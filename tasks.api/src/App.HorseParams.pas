unit App.HorseParams;

interface

uses
  Horse.Model;

type
  TAppHorseParams = class
  public
    class function Params(const ADirApp: string): THorseModel;
  end;

implementation

uses
  System.Classes, System.SysUtils, App.CustomConfig;

const
  FILE_CONFIG = 'horseParams.ini';
  SECTION = 'params';
  HOST_IDENT = 'host';
  PORT_IDENT = 'port';
  JWTKEY_IDENT = 'jwt key';
  ISSUER_IDENT = 'issuer';
  TOKEN_EXPIRATION_IDENT = 'token expiration';
  HOST_DEFAULT = 'localhost';
  PORT_DEFAULT = 9025;
  TOKEN_EXPIRATION_DEFAULT = 180;

type
  THorseParams = class(TCustomConfig)
  private
    FHorseParams: THorseModel;
  protected
    procedure LoadData; override;
    procedure SaveData; override;
  public
    destructor Destroy; override;
    constructor Create(const AFileName: string); override;

    procedure Assign(ASource: TObject); override;
  end;

{ THorseParams }

procedure THorseParams.Assign(ASource: TObject);
begin
  if ASource is THorseModel then
  begin
    THorseModel(ASource).Host := FHorseParams.Host;
    THorseModel(ASource).Issuer := FHorseParams.Issuer;
    THorseModel(ASource).JWTKey := FHorseParams.JWTKey;
    THorseModel(ASource).Port := FHorseParams.Port;
    THorseModel(ASource).TokenExpiration := FHorseParams.TokenExpiration;
  end else inherited Assign(ASource);
end;

constructor THorseParams.Create(const AFileName: string);
begin
  FHorseParams := THorseModel.Create;
  inherited Create(AFileName);
end;

destructor THorseParams.Destroy;
begin
  SaveData;
  FreeAndNil(FHorseParams);
  inherited Destroy;
end;

procedure THorseParams.LoadData;
begin
  FHorseParams.Host := ReadString(SECTION, HOST_IDENT, HOST_DEFAULT);
  FHorseParams.Issuer := ReadString(SECTION, ISSUER_IDENT, EmptyStr);
  FHorseParams.JWTKey := ReadString(SECTION, JWTKEY_IDENT, EmptyStr);
  FHorseParams.Port := ReadInteger(SECTION, PORT_IDENT, PORT_DEFAULT);
  FHorseParams.TokenExpiration := ReadInteger(SECTION, TOKEN_EXPIRATION_IDENT, TOKEN_EXPIRATION_DEFAULT);
end;

procedure THorseParams.SaveData;
begin
  WriteString(SECTION, HOST_IDENT, FHorseParams.Host);
  WriteString(SECTION, ISSUER_IDENT, FHorseParams.Issuer);
  WriteString(SECTION, JWTKEY_IDENT, FHorseParams.JWTKey);
  WriteInteger(SECTION, PORT_IDENT, FHorseParams.Port);
  WriteInteger(SECTION, TOKEN_EXPIRATION_IDENT, FHorseParams.TokenExpiration);
end;

{ TAppHorseParams }

class function TAppHorseParams.Params(const ADirApp: string): THorseModel;
var
  lParams: THorseParams;
begin
  Result := THorseModel.Create;

  lParams := THorseParams.Create(ADirApp + '\' + FILE_CONFIG);
  try
    lParams.Assign(Result);
  finally
    FreeAndNil(lParams);
  end;  // try
end;

end.
