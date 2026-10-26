unit Config.JWT;

interface

uses
  System.JSON.Serializers;

type
  TConfigJWT = record
    [JsonName('jwt_key')]
    JWTKey: string;

    [JsonName('issuer')]
    Issuer: string;

    [JsonName('audience')]
    Audience: string;

    [JsonName('token_expiration')]
    TokenExpiration: integer;
  end;

implementation

end.
