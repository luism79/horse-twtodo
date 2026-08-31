unit App.Utils;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON, Horse.Core.Param;

type
  TAppUtils = class
  public
    class function ConvertArrayToJSONArray<T>(const AArray: T): TJSONArray;
    class function ConvertJSONArrayToList<T: class, constructor>(const AJSONArray: TJSONArray): TObjectList<T>;
    class function ConvertJSONToObject<T>(const AJson: TJSONObject): T;
    class function ConvertObjectToJSON(AObject: TObject): TJSONObject;
    class function ConvertObjectToRecord<T>(AObject: TObject): T;
    class function ConvertQueryRequestToStirngs(AQuery: THorseCoreParam): TStrings;
    class function ConvertRecordToJSON<T>(ARecord: T): TJSONObject;
    class function ConvertRecordToObject<TClass: class, constructor; T>(const ARecord: T): TClass;
    class function ConvertTextToHash(const AValue: string): string;
    class procedure GetPriorityToStringList(AStrings: TStrings);
    class procedure GetStatusToStringList(AStrings: TStrings);
    class function RemoveInvalidDatesFromJSON(const AJsonStr: string): string;
  end;

implementation

uses
  System.SysUtils, System.Hash, System.JSON.Serializers, System.RegularExpressions,
  App.Enums;

{ TAppUtils }

class function TAppUtils.ConvertArrayToJSONArray<T>(const AArray: T): TJSONArray;
var
  lJson: TJsonSerializer;
  lJsonStr: string;
begin
  lJson := TJsonSerializer.Create;
  try
    lJsonStr := lJson.Serialize(AArray);
    lJsonStr := RemoveInvalidDatesFromJSON(lJsonStr);
    Result := TJSONObject.ParseJSONValue(lJsonStr) as TJSONArray;
  finally
    lJson.Free;
  end;
end;

class function TAppUtils.ConvertJSONArrayToList<T>(const AJSONArray: TJSONArray): TObjectList<T>;
var
  lValue: TJSONValue;
begin
  if not Assigned(AJSONArray) then
    Exit(Default(TObjectList<T>));

  Result := TObjectList<T>.Create(True); // OwnsObjects := True
  try
    for lValue in AJSONArray do
      Result.Add(ConvertJSONToObject<T>(TJSONObject(lValue)));
  except
    Result.Free;
    raise;
  end;
end;

class function TAppUtils.ConvertJSONToObject<T>(const AJson: TJSONObject): T;
var
  lJson: TJsonSerializer;
begin
  if not Assigned(AJson) then
    Exit(Default(T));

  lJson := TJsonSerializer.Create;
  try
    Result := lJson.Deserialize<T>(AJson.ToString);
  finally
    FreeAndNil(lJson);
  end;  // try
end;

class function TAppUtils.ConvertObjectToJSON(AObject: TObject): TJSONObject;
var
  lJson: TJsonSerializer;
  lJsonStr: string;
begin
  if not Assigned(AObject) then
    Exit(nil);

  lJson := TJsonSerializer.Create;
  try
    lJsonStr := lJson.Serialize(AObject);
    lJsonStr := RemoveInvalidDatesFromJSON(lJsonStr);
    Result := TJSONObject.ParseJSONValue(lJsonStr) as TJSONObject;
  finally
    FreeAndNil(lJson);
  end;  // try
end;

class function TAppUtils.ConvertObjectToRecord<T>(AObject: TObject): T;
var
  lJson: TJsonSerializer;
  lJsonStr: string;
begin
  if not Assigned(AObject) then
    Exit(Default(T));

  lJson := TJsonSerializer.Create;
  try
    lJsonStr := lJson.Serialize<TObject>(AObject);
    Result := lJson.Deserialize<T>(lJsonStr);
  finally
    FreeAndNil(lJson);
  end;  // try
end;

class function TAppUtils.ConvertQueryRequestToStirngs(AQuery: THorseCoreParam): TStrings;
var
  I: Integer;
begin
  if not Assigned(AQuery) then
    Exit(nil);

  Result := TStringList.Create;
  for I := 0 to Pred(AQuery.Count) do
    Result.Values[AQuery.Content.Names[I]] := AQuery.Content.ValueFromIndex[I];

end;

class function TAppUtils.ConvertRecordToJSON<T>(ARecord: T): TJSONObject;
var
  lJson: TJsonSerializer;
  lJsonStr: string;
begin
  lJson := TJsonSerializer.Create;
  try
    lJsonStr := lJson.Serialize(ARecord);
    lJsonStr := RemoveInvalidDatesFromJSON(lJsonStr);
    Result := TJSONObject.ParseJSONValue(lJsonStr) as TJSONObject;
  finally
    FreeAndNil(lJson);
  end;
end;

class function TAppUtils.ConvertRecordToObject<TClass, T>(
  const ARecord: T): TClass;
var
  lJson: TJsonSerializer;
  lJsonStr: string;
begin
  lJson := TJsonSerializer.Create;
  try
    lJsonStr := lJson.Serialize<T>(ARecord);
    Result := lJson.Deserialize<TClass>(lJsonStr);
  finally
    FreeAndNil(lJson)
  end;
end;

class function TAppUtils.ConvertTextToHash(const AValue: string): string;
begin
  Result := THashSHA2.GetHashString(AValue, THashSHA2.TSHA2Version.SHA256);
end;

class procedure TAppUtils.GetPriorityToStringList(AStrings: TStrings);
var
  item: TTaskPriority;
  lList: TStrings;
begin
  AStrings.Clear;
  lList := TStringList.Create;
  try
    for item := Low(TTaskPriority) to High(TTaskPriority) do
      lList.Add(item.ToString);

    AStrings.Assign(lList);
  finally
    FreeAndNil(lList);
  end;
end;

class procedure TAppUtils.GetStatusToStringList(AStrings: TStrings);
var
  item: TTaskStatus;
begin
  AStrings.Clear;
  for item := Low(TTaskStatus) to High(TTaskStatus) do
    AStrings.Add(item.ToString);
end;

class function TAppUtils.RemoveInvalidDatesFromJSON(const AJsonStr: string): string;
var
  LRegex: string;
begin
  LRegex := '"1899-12-30T[0-9:.-]+"';
  Result := TRegEx.Replace(AJsonStr, LRegex, 'null');
end;

end.
