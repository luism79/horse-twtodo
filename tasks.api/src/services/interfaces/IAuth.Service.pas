unit IAuth.Service;

interface

uses
  Auth.DTO;

type
  IAuthService = interface
    ['{1172D955-BBF9-4FFB-9593-976C8394D2FE}']
    function GenerateToken(const AUserMail: string): string;
    function Login(var AUser: TAuthDTO): Boolean;
    function ValidToken(const AToken: string): Boolean;
  end;

implementation

end.
