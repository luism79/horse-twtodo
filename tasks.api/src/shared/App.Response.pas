unit App.Response;

interface

uses
  System.JSON;

type
  TAppResponse = class
  public
    class function Error(const AMessage: string; AData: TJSONPair = nil): TJSONObject;
    class function Success(const AMessage: string; AData: TJSONObject = nil): TJSONObject; overload;
    class function Success(const AMessage: string; AData: TJSONArray = nil): TJSONObject; overload;
  end;

implementation


{ TAppResponse }

class function TAppResponse.Error(const AMessage: string;
  AData: TJSONPair): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('success', TJSONBool.Create(False));
  Result.AddPair('message', AMessage);

  if Assigned(AData) then
    Result.AddPair(AData);
end;

class function TAppResponse.Success(const AMessage: string;
  AData: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('success', TJSONBool.Create(True));
  Result.AddPair('message', AMessage);

  if Assigned(AData) then
    Result.AddPair('data', AData);
end;

class function TAppResponse.Success(const AMessage: string; AData: TJSONArray): TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair(
      'success', TJSONBool.Create(True)
    )
    .AddPair(
      'message', AMessage
    )
    .AddPair(
      'data', AData
    );
end;

end.
