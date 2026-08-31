unit Horse.Model;

interface

uses
  System.JSON.Serializers;

type
  THorseModel = class
  private
    FHost: string;
    FPort: integer;

    [JsonName('jwt-key')]
    FJWTKey: string;

    [JsonName('issuer')]
    FIssuer: string;

    [JsonName('token-expiration')]
    FTokenExpiration: integer;
  public
    /// <summary>
    /// Endereço IP ou hostname onde o servidor Horse irá escutar (Ex: 'localhost', '127.0.0.1' ou '0.0.0.0').
    /// </summary>
    property Host: string read FHost write FHost;

    /// <summary>
    /// Emissor (Issuer) do token JWT. Identifica a aplicação/servidor que gerou a credencial.
    /// </summary>
    property Issuer: string read FIssuer write FIssuer;

    /// <summary>
    /// Chave secreta (Secret Key) utilizada para assinar e validar o hash dos tokens JWT (JSON Web Token).
    /// </summary>
    property JWTKey: string read FJWTKey write FJWTKey;

    /// <summary>
    /// Porta TCP/IP em que a aplicação Horse ficará disponível para receber requisições HTTP (Ex: 8080, 9000).
    /// </summary>
    property Port: integer read FPort write FPort;

    /// <summary>
    /// Tempo de expiração do token JWT (expresso em minutos).
    /// </summary>
    property TokenExpiration: integer read FTokenExpiration write FTokenExpiration;
  end;

implementation

end.
