unit User.Current;

interface

uses
  System.SysUtils, Horse, IUser.Current;

type
  TUserCurrent = class(TInterfacedObject, IUserCurrenct)
  private
    FRequest:  THorseRequest;

    function GetId: string;
  public
    constructor Create(ARequest: THorseRequest);

    property Id: string read GetId;
  end;


implementation

uses
  JOSE.Core.JWT;

{ TUserCurrent }

constructor TUserCurrent.Create(ARequest: THorseRequest);
begin
  FRequest := ARequest;
end;

function TUserCurrent.GetId: string;
begin
  Result := FRequest.Session<TJWTClaims>.Subject.ToLower;

  if Result.IsEmpty then
    raise EHorseException.New
      .Status(THTTPStatus.Unauthorized)
      .Error('Token inválido');
end;

end.
