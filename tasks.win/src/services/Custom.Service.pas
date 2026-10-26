unit Custom.Service;

interface

uses
  System.StrUtils, System.Classes, System.JSON, System.Net.HttpClient, System.Net.URLClient, Custom.Exceptions,
  ICustom.Service, Params.Model;

type
  TCustomService = class(TInterfacedObject, ICustomService)
  private
    FParams: TParamsModel;
    FHttp: THTTPClient;
    FHeaders: TNetHeaders;

    procedure LoadHttp;
    function GetBaseUrl: string;
    function GetHost: string;
    function GetHttp: THTTPClient;
    function GetPort: Integer;
  protected
    FRoute: string;
    FQueryParams: TStrings;

    function ExceptionApiService(AResponse: IHTTPResponse): EAPIException; virtual;
    function PathUrl(const APath: string = ''): string;
    procedure PrepareHeaders; virtual;
    procedure PrepareQueryParams(AStrings: TStrings = nil); virtual;
    procedure ResetStatemant; virtual;
    function RequestBody(AJson: TJSONObject): TStringStream;

    property Headers: TNetHeaders read FHeaders write FHeaders;
    property Http: THTTPClient read GetHttp;
  public
    constructor Create(AParams: TParamsModel); virtual;
    destructor Destroy; override;

    function GeQueryParamsAsUrl: string;

    property BaseUrl: string read GetBaseUrl;
    property Host: string read GetHost;
    property Port: Integer read GetPort;
  end;

implementation

uses
  System.SysUtils, System.NetConsts, System.NetEncoding;

{ TCustomService }

function TCustomService.ExceptionApiService(AResponse: IHTTPResponse): EAPIException;
var
  sMenssage: string;
  lJson: TJSONValue;
begin
  sMenssage := Format('Erro ao comunicar com a API (HTTP %d).', [AResponse.StatusCode]);
  try
    lJson := TJSONObject.ParseJSONValue(AResponse.ContentAsString(TEncoding.UTF8));
    try
      if Assigned(lJson) and (lJson is TJSONObject) then
      begin
        if not TJSONObject(lJson).TryGetValue<string>('error', sMenssage) then
          TJSONObject(lJson).TryGetValue<string>('message', sMenssage);
      end;
    finally
      lJson.Free;
    end;
  except
    // ignora falha ao interpretar corpo do erro e mantém mensagem padrão
  end;
  Result := EAPIException.Create(sMenssage, AResponse.StatusCode);
end;

constructor TCustomService.Create(AParams: TParamsModel);
begin
  FParams := AParams;
  FQueryParams := TStringList.Create;
  LoadHttp;
end;

destructor TCustomService.Destroy;
begin
  FreeAndNil(FHttp);
  FreeAndNil(FQueryParams);
  inherited Destroy;
end;

function TCustomService.GetBaseUrl: string;
begin
  Result := Format('http://%s:%d', [FParams.Host, FParams.Port]);
end;

function TCustomService.GetHost: string;
begin
  Result := FParams.Host;
end;

function TCustomService.GetHttp: THTTPClient;
begin
  Result := FHttp;
end;

function TCustomService.GeQueryParamsAsUrl: string;

  function _convertInfoToNetEncoding(const Value: string): string;
  begin
    Result := TNetEncoding.URL.Encode(Value);
  end;

var
  I: Integer;
begin
  if not Assigned(FQueryParams) then
    Exit('');

  for I := 0 to Pred(FQueryParams.Count) do
    Result := Result +
      IfThen(I > 0, '&') +
      Format('%s=%s', [
        _convertInfoToNetEncoding(FQueryParams.Names[I]),
        _convertInfoToNetEncoding(FQueryParams.ValueFromIndex[I])
      ]);

  if not Result.Trim.IsEmpty then
    Result := '?' + Result;
end;

function TCustomService.GetPort: Integer;
begin
  Result := FParams.Port;
end;

procedure TCustomService.LoadHttp;
begin
  if not Assigned(FParams) then
    raise Exception.Create('Não foi possível carregar informações de configuração');

  FHttp := THTTPClient.Create;
  FHttp.ContentType := 'application/json';
  FHttp.ConnectionTimeout := FParams.ConnectionTimeout;
  FHttp.ResponseTimeout := FParams.ResponseTimeout;
end;

function TCustomService.PathUrl(const APath: string): string;
begin
  Result := GetBaseUrl + FRoute;

  if not Trim(APath).IsEmpty then
    Result := Result + '/' + APath;
end;

procedure TCustomService.PrepareHeaders;
begin
  FHeaders := [
    TNameValuePair.Create('Content-Type', FHttp.ContentType)
  ];
end;

procedure TCustomService.PrepareQueryParams(AStrings: TStrings);
begin

end;

function TCustomService.RequestBody(AJson: TJSONObject): TStringStream;
begin
  if not Assigned(AJson) then
    Exit(nil);

  Result := TStringStream.Create(AJson.ToJSON, TEncoding.UTF8);
end;

procedure TCustomService.ResetStatemant;
begin
  FQueryParams.Clear;
  PrepareHeaders;
end;

end.
