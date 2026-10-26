unit User.DTO;

interface

uses
  System.JSON.Serializers;

type
  TUserDTO = record
    [JsonName('e_mail')]
    Email: string;

    [JsonName('id')]
    Id: string;

    [JsonName('password')]
    Password: string;
  end;

  TUserViewDTO = record
    [JsonName('e_mail')]
    Email: string;

    [JsonName('id')]
    Id: string;
  end;

implementation

end.
