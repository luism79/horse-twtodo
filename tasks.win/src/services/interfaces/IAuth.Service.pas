unit IAuth.Service;

interface

uses
  ICustom.Service, Login.DTO;

type
  IAuthService = interface(ICustomService)
    ['{75637B64-3538-421E-9B40-BB0DADF001BD}']
    function GetUserId: string;
    function GetLoggedIn: Boolean;
    function GetLoggedEmail: string;
    function GetToken: string;
    function GetTokenValid: Boolean;
    function Login(const ALogin: TLoginInputDTO): Boolean;
    procedure Logout;

    property UserId: string read GetUserId;
    property IsLoggedIn: Boolean read GetLoggedIn;
    property IsTokenValid: Boolean read GetTokenValid;
    property LoggedEmail: string read GetLoggedEmail;
    property Token: string read GetToken;
  end;

implementation

end.
