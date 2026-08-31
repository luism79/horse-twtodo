unit Config.JWT;

interface

uses
  System.JSON.Serializers;

type
  TConfigJWT = record
    [JsonName('jwt-key')]
    JWTKey: string;

    [JsonName('issuer')]
    Issuer: string;

    [JsonName('token-expiration')]
    TokenExpiration: integer;
  end;

implementation

end.
