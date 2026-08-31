unit Auth.DTO;

interface

uses
  System.JSON.Serializers;

type
  TAuthDTO = record
    [JsonName('id')]
    Id: string;

    [JsonName('e-mail')]
    Email: string;

    [JsonName('password')]
    Password: string;

    [JsonName('is_logged_in')]
    IsLoggedIn: Boolean;

    [JsonName('message')]
    MsgAuth: string;
  end;

implementation

end.
