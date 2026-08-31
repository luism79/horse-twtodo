unit Login.DTO;

interface

uses
  System.JSON.Serializers;

type
  TLoginInputDTO = record
    [JsonName('e-mail')]
    Email: string;

    [JsonName('password')]
    Password: string;
  end;

  TLoginDTO = record
    [JsonName('user_id')]
    user_id: string;

    [JsonName('e-mail')]
    Email: string;

    [JsonName('is_logged_in')]
    IsLoggedIn: Boolean;

    [JsonName('expires_in_minutes')]
    ExpiresInMinutes: Integer;

    [JsonName('access_token')]
    TokenAcess: string;

    // Campo de controle interno (não vem do JSON)
    LoggedAt: TDateTime;
 end;

implementation

end.
