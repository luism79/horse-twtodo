unit App.AuthUser;

interface

uses
  Horse, JOSE.Core.JWT, System.SysUtils;

type
  TAppAuthUser = class
  public
    class function UserId(AReq: THorseRequest): string;
  end;

implementation

{ TAppAuthUser }

class function TAppAuthUser.UserId(AReq: THorseRequest): string;
begin
  Result := AReq.Session<TJWTClaims>.Subject;
  if Result.IsEmpty then
    raise EHorseException.New
      .Status(THTTPStatus.Unauthorized)
      .Error('Token inválido');
end;

end.
