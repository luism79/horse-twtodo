unit Connection.Factory;

interface

uses
  FireDAC.Comp.Client, IConnection.Factory, Connection.Model;

type
  TConnectionFactory  = class
  private
    class var FParamsConnection: TParamsConnection;
  public
    class function New: IConnectionFactory;

    class property ParamsConnection: TParamsConnection read FParamsConnection write FParamsConnection;
  end;

implementation

uses
  System.SysUtils;

type
  TAppConnection = class(TInterfacedObject, IConnectionFactory)
  private
    FConnection: TFDCustomConnection;

    procedure AssignToConnection(ADest: TFDCustomConnection; ASource: TParamsConnection);
    function GetConnection: TFDCustomConnection;
  public
    constructor Create(AParamsConnection: TParamsConnection);
    destructor Destroy; override;

    property Connection: TFDCustomConnection read GetConnection;
  end;

{ TConnectionFactory }

class function TConnectionFactory.New: IConnectionFactory;
begin
  if not Assigned(FParamsConnection) then
    raise Exception.Create('Connection parameters must be initialized before use');

  Result := TAppConnection.Create(FParamsConnection);
end;

{ TAppConnection }

procedure TAppConnection.AssignToConnection(ADest: TFDCustomConnection; ASource: TParamsConnection);
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

constructor TAppConnection.Create(AParamsConnection: TParamsConnection);
begin
  FConnection :=  TFDConnection.Create(nil);
  AssignToConnection(FConnection, AParamsConnection);
end;

destructor TAppConnection.Destroy;
begin
  FreeAndNil(FConnection);
  inherited Destroy;
end;

function TAppConnection.GetConnection: TFDCustomConnection;
begin
  Result := FConnection;
end;

end.
