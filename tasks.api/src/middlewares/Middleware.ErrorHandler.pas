unit Middleware.ErrorHandler;
interface
uses
  Horse,
  System.SysUtils,
  System.JSON; // remova se sua versão do horse-jwt não tiver esta unit
type
  TErrorHandler = class
  public
    class procedure ErrorHandlerJwt(const AHorseResponse: THorseResponse; const AMessage: string; const AHTTPStatus: THTTPStatus; const APathInfo: string);
  end;

implementation
uses
  App.Response;

class procedure TErrorHandler.ErrorHandlerJwt(const AHorseResponse: THorseResponse; const AMessage: string; const AHTTPStatus: THTTPStatus;
  const APathInfo: string);
begin
  AHorseResponse
    .Send<TJSONObject>(
      TAppResponse.Error(AMessage)
    )
    .Status(AHTTPStatus);
end;

end.
